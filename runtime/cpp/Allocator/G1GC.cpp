#include <algorithm>

#include "G1GC.h"

#include <Evaluator/Evaluator.h>

#include "AllocationZone.h"
#include "KnownObjects.h" 
#include "KnownConstants.h"

using namespace Egg;

G1GC::G1GC(Runtime *runtime, AllocationZone *oldZone, GCHeap *heap) :
	GarbageCollector(runtime, oldZone, heap)
{
    _countdown = 1 * MB;
	_forwarderOffset = _oldZone->regionSize();

}

HeapObject *G1GC::copyOf_(HeapObject *anObject)
{
    auto forwarder = ((uintptr_t)anObject) + _forwarderOffset;
	//printf("fetching forwarder of %#" PRIxPTR " -> %#" PRIxPTR "(orig: %s, copy: %s)\n", anObject, *(HeapObject**)forwarder, anObject->printString().c_str(), (*(HeapObject**)forwarder)->printString().c_str());
	return (*(HeapObject**)forwarder);
}

void G1GC::determineEvacuatedSpaces() {
	auto threshold = uintptr_t(_forwarderOffset * 0.8); // if space uses less than this, it is a candidate for evacuation
	auto occupancy = _oldZone->occupancy(); // the occupancy was computed in marking stage of prev GC pass
	auto max = _oldZone->regionCount();
	auto headroom = _oldZone->availableBytes() * 9 / 10; // avail space for evacuating

	_evacuated.resize(occupancy->size(), false); // initialize the list with all false elements

	auto current = _oldZone->currentSpace();
	for (uint32_t i = 1; i <= max; i++)
	{
		auto spaceOccup = (*occupancy)[i-1];
		auto space = _oldZone->spaces()[i-1];
		//if (space) printf("space size: %" PRIdPTR ", used: %" PRIdPTR "\n", space->reservedSize(), spaceOccup);
		if (0 < spaceOccup && spaceOccup < threshold)
		{
			//auto space = _oldZone->spaces()[i-1];
			auto used = space->usedSize();
			if (space != current && headroom > used)
			{
				headroom = headroom - used;
				auto size = space->reservedSize();
				CommitMemory(space->_base + size, size);
				_evacuated[i-1] = true;
				/*
				printf("evacuating space: %u (%.1f%% used) - zone: 0x%" PRIxPTR " - 0x%" PRIxPTR "\n",
					i - 1,
					100.0 * (float)spaceOccup / (float)_forwarderOffset,
					space->base(),
					space->reservedLimit());
					*/
			}
		}
	}

	_heap->oldZone()->resetOccupancy(); // will be recomputed in this GC pass, for next pass
}

HeapObject *G1GC::evacuate_(HeapObject *anObject)
{
    auto copy = _oldZone->shallowCopyCommiting_(anObject);
	if (anObject->isRemembered())
        copy->beRemembered();
	
    auto forwarder = ((uintptr_t)anObject) + _forwarderOffset;
	(*(HeapObject**)forwarder)= copy;
	//printf("object %#" PRIxPTR " was forwarded to %#" PRIxPTR "(orig: %s, copy: %s)\n", anObject, copy, anObject->printString().c_str(), copy->printString().c_str());

	return copy;
}

bool G1GC::hasToEvacuate_(HeapObject *anObject)
{
    auto index = _oldZone->regionIndexOf_(anObject);
	return index > 0 && _evacuated[index-1];
}

void G1GC::initializeLocals()
{
	this->determineEvacuatedSpaces();
	auto current = 0;
	auto evac = 0;

	for (auto space : _oldZone->spaces())
	{
		current += space->usedSize();
	}

	for (auto i = 0; i < _evacuated.size(); i++)
	{
		if (_evacuated[i])
			evac+= _oldZone->spaces()[i]->reservedSize();
	}

	//printf("going to do GC - current old heap size: %d kb, going to free aprox %x\n", current / 1024, evac);

    _stack.reserve(64 * KB);
	_largeSize = _heap->_largeSpaces.size();
    GarbageCollector::initializeLocals();
}

void G1GC::releaseLocals()
{
    _oldZone->releaseEvacuated_(&_evacuated);
    _evacuated.clear();
	this->resetCountdown();
	this->sweepLargeSpaces();
	_stack.clear();
	_scanned = nullptr;
	GarbageCollector::releaseLocals();
}

void G1GC::resetCountdown()
{
	/*
	 * Try to set an amount that is not too large, not too small. Full GC
	 * allocation countdown has to be relative to heap size (bigger heaps
	 * result in bigger countdowns).
	 * Rules:
	 * - aims for 25% of used size minus what is known to be garbage
	 * - if near exhaustion of mem (available is small), then make countdown smaller
	 */

	intptr_t garbage = _oldZone->committedBytes() - _oldZone->occupiedBytes();
	intptr_t desired = intptr_t(_oldZone->usedBytes() * 0.25) - garbage;
	intptr_t available = _oldZone->availableBytes() * 9 / 10;

	// set countdown to not less that 3*region size, not more than old zone remaining free space
	_countdown = std::max((intptr_t)_oldZone->regionSize()*3, std::min(desired, available));

    /*
	 GenGC unimplemented
    intptr_t garbage = _oldZone->committedBytes() - _oldZone->occupiedBytes();
	intptr_t bytes = intptr_t(_oldZone->usedBytes() * 0.25) - garbage;
	auto available = _oldZone->availableBytes() * 9 / 10;
	auto young = _heap->eden()->reservedSize() + _heap->from()->reservedSize();
	_countdown = std::min(std::max(25 * MB, bytes), available - young);
	*/
}


void G1GC::updateWeak_at_(HeapObject *weakContainer, uintptr_t anInteger)
{
    auto object = weakContainer->slotAt_(anInteger);
	if (object->isSmallInteger())
        return;

    auto hobject = object->asHeapObject();

	if (!hobject->hasBeenSeen())
	{
        weakContainer->slotAt_(anInteger) = (Object*)_tombstone;
    }
	if (!this->hasToEvacuate_(hobject))
        return;
    
	auto updated = this->copyOf_(hobject);
	weakContainer->slotAt_(anInteger) = (Object*)updated;
}

bool G1GC::checkReachablePropertyOf_(HeapObject *ephemeron)
{
    auto key = ephemeron->slotAt_(1);
	return key->isSmallInteger() || key->asHeapObject()->hasBeenSeen();
}


void G1GC::doCollect()
{
    GarbageCollector::doCollect();
	// unimplemented GenGC
	// this->purgeRememberedSet(); // RE-ENABLE AFTER PLUGGING BACK GENGC
}

void G1GC::followClosure()
{
	this->followGCedRefs();
    while (!_stack.empty() || !_stacks->empty())
	{
        this->followObjects();
        this->scanStacks();
    }
}

void G1GC::followGCedRefs()
{
	_runtime->gcedRefsDo_([this](GCedRef *ref) {
			this->queue_from_to_((HeapObject*)ref->getRaw(), 1, 1);
		});
}


template <typename T>
T pop_and_return(std::vector<T>& vec) {
    T value = std::move(vec.back());
    vec.pop_back();
    return value;
}

void G1GC::followObjects()
{
    while (!_stack.empty())
    {
		_limit = (uint32_t)pop_and_return(_stack);
		_index = (uint32_t)pop_and_return(_stack);
		_scanned = (HeapObject*)pop_and_return(_stack);
		while (_index <= _limit)
		{
            if (_index == 0)
				this->scanBehavior();
			else
                this->scanSlot();
        }
    }
}

uintptr_t G1GC::initialContainerCapacity()
{
    return this->workSpaceSize() / 1000;
}

/*
void G1GC::purgeRememberedSet()
{
    auto rs = _memory->rememberedSet();
	auto kept = 0;
	for (uint32_t i = 1; i <= rs->size(); i++)
    { 
		auto object = rs[i-1];
		if (object->hasBeenSeen())
        {
			if (this->hasToEvacuate_(object))
                object = this->copyOf_(object);
			kept = kept + 1;
			rs[kept] = object;
        }
    }
	rs->size_(kept);

}
*/

void G1GC::queue_from_to_(HeapObject *anObject, uintptr_t start, uintptr_t end)
{
   	_stack.push_back((uintptr_t)anObject);
    _stack.push_back(start);
	_stack.push_back(end);
}

void G1GC::queueCurrent()
{
    _stack.push_back((uintptr_t)_scanned);
	_stack.push_back(_index + 1);
	_stack.push_back(_limit);
}

void G1GC::scan_from_to_(HeapObject *anObject, uintptr_t start, uintptr_t end)
{
    _stack.push_back((uintptr_t)anObject);
	_stack.push_back(start);
	_stack.push_back(end);
}

void G1GC::scanBehavior()
{
    auto slot = _scanned->behavior();
//	printf("scanning behavior of %#" PRIxPTR " (%s)", (uintptr_t)_scanned, _scanned->printString().c_str());
//	fflush(stdout);
//	printf(", which is %#" PRIxPTR "( %s)\n", (uintptr_t)slot, slot->printString().c_str());
	if (((Object*)slot)->isSmallInteger()) 
    {
        _index = _index + 1;
        return;
    }
	auto evacuate = this->hasToEvacuate_(slot);
	if (slot->hasBeenSeen())
    {
		if (evacuate)
        {
			slot = this->copyOf_(slot);
			_scanned->behavior(slot);
        }
		_index = _index + 1;
        return;
    }
	slot->beSeen();
	if (evacuate)
	{
        slot = this->evacuate_(slot);
		_scanned->behavior(slot);
    }
    else
    {
        this->updateRegionOccupancy_(slot);
    }

	if (slot->isSpecial())
        this->rememberSpecial_(slot);
    
	if (_index < _limit)
        this->queueCurrent();

	_index = 0;
	_limit = slot->strongPointersSize();
	_scanned = slot;
}

void G1GC::scanSlot()
{
	// scanned can be a heap object or a chunk of stack frame, we cannot use slotAt_
	auto slot = ((Object**)_scanned)[_index-1];
	auto stack = debugRuntime->_evaluator->context()->stack();
//	if ((uintptr_t)_scanned < (uintptr_t)&stack[0] || (uintptr_t)_scanned > (uintptr_t)&stack[0xFFFF])
//		printf("scanning slot %d of %#" PRIxPTR " (%s)", _index, (uintptr_t)_scanned, _scanned->printString().c_str());
//	else
//		printf("scanning stack slot of frame %#" PRIxPTR " at %d" , (uintptr_t)_scanned, _index);

//	fflush(stdout);
//	printf(" which is %#" PRIxPTR " (%s)\n", (uintptr_t)slot, slot->printString().c_str());

	if (slot->isSmallInteger())
    {
        _index = _index + 1;
        return;
    }

    auto hslot = slot->asHeapObject();

	auto evacuate = this->hasToEvacuate_(hslot);
	if (hslot->hasBeenSeen())
	{
        if (evacuate)
        {
			hslot = this->copyOf_(hslot);
			((Object**)_scanned)[_index-1] = (Object*)hslot;
        }
		_index = _index + 1;
        return;
    }

	hslot->beSeen();

	if (evacuate)
	{
        hslot = this->evacuate_(hslot);
		((Object**)_scanned)[_index-1] = (Object*)hslot;
    }
    else
    {
        this->updateRegionOccupancy_(hslot);
    }

    if (hslot->isSpecial())
        this->rememberSpecial_(hslot);
    
	if (_index < _limit)
        this->queueCurrent();
    
	_index = 0;
	_limit = hslot->strongPointersSize();
	_scanned = hslot;
}

void G1GC::scanThreadLocalStorage_(HeapObject *thread)
{
    // unimplemented yet
}

void G1GC::scanThreadLocalStorage_at_(HeapObject *thread, uint32_t i)
{
    // uimplemented yet
}

void G1GC::scanTopSlot_(HeapObject *processStack)
{
	error("G1GC::scanTopSlot_ not implemented");
    //this->queue_from_to_(_stackWrapper->sp->asObject(), 1, 1);
}

void G1GC::sweepLargeSpaces()
{
    auto used = 0;
	auto &large = _heap->_largeSpaces;
	auto &registered = _heap->_spaces;
	for (int i = 1; i <= _largeSize; i++)
    {
		GCSpace* s = large[i-1];
		if (s->firstObject()->hasBeenSeen())
		{
			used = used + 1;
			large[used] = s;
        }
		else
        {
			FreeMemory(s->base(), s->reservedSize());
			registered.erase(std::remove(registered.begin(), registered.end(), s), registered.end());
        }
    }

	for (uint32_t i = _largeSize + 1; i <= large.size(); i++)
    {
		auto s = large[i-1];
		used = used + 1;
		large[used-1] = s;
    }

	for (uint32_t i = used + 1; i <= large.size(); i++)
    {
        large[i-1] = nullptr;
    }

	large.resize(used);
}

void G1GC::updateRegionOccupancy_(HeapObject *object)
{
    _heap->oldZone()->updateRegionOccupancy_(object);
}
