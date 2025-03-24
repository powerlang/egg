
#include "Egg.h"
#include "Memory.h"
#include "AllocationZone.h"
#include "GCSpace.h"
#include "GCHeap.h"
#include "HeapObject.h"

using namespace Egg;

AllocationZone::AllocationZone(GCHeap* heap, uintptr_t base, uintptr_t limit) :
    _heap(heap),
    _base(base),
    _nextFree(base),
    _limit(limit)
{
    this->build();
}

uintptr_t AllocationZone::allocate_(uintptr_t size)
{
	auto oop = this->allocateIfPossibleBumping_(size);
	if (!oop)
    	error_("Out of memory in old space");

    return oop;
}

uintptr_t AllocationZone::allocateIfPossibleCurrent_(uintptr_t size) {
    //printf("allocing: %d bytes in current\n", size);
    return _current->allocateIfPossible_(size);
}

uintptr_t AllocationZone::allocateIfPossibleBumping_(uintptr_t size)
{
    //printf("allocing: %zu bytes bumping\n", size);

    auto oop = _current->allocateIfPossible_(size);
	if (oop)
        return oop;
	this->bumpSpace();
	return _current->allocateIfPossible_(size);
}

void AllocationZone::assureFree_(uintptr_t size)
{
	if (_current->softAvailable() < size) this->bumpSpace();
}

uintptr_t AllocationZone::availableBytes()
{
	return this->usableBytes() - this->committedBytes();
}

void AllocationZone::build()
{
    auto max = this->indexOfPointer_(_limit - 1);
	_occupancy.resize(max, 0);
	this->bumpSpace();
    this->bumpSpace();
}

GCSpace* AllocationZone::bumpSpace()
{
	_current = _next;
    //if (_current) // uninitialized on first bump
    //    printf("bumped space - new limits: 0x%p - 0x%p\n", (void*)_current->base(), (void*)_current->reservedLimit());
	if (_emptySpaces.empty()) this->createEmptySpace();
	
    _next = _emptySpaces.back();
    _emptySpaces.pop_back();
	_next->commitMemory_(_next->reservedSize());
    _next->_softLimit = _next->_committedLimit;
	this->markAsFull_(_next);
	return _next;
}

uintptr_t AllocationZone::committedBytes()
{
    auto sum = 0;
    for (auto space : _spaces)
        sum = sum + space->committedSize();
	return sum;
}

GCSpace *AllocationZone::createEmptySpace()
{
    if (_nextFree == _limit) {
        printf("_nextFree: %" PRIxPTR ". _limit: %" PRIxPTR "\n", _nextFree, _limit);
        error_("Out of space in old zone");
    }
	auto start = _nextFree;
	auto end = _nextFree + SPACE_SIZE;
	_nextFree = end + SPACE_SIZE;
	auto s = GCSpace::allocatedAt_limit_(start, end);
	s->_name ="Old";
    //printf("adding old space nº %" PRIdPTR "\n", _spaces.size());
	_spaces.push_back(s);
	_emptySpaces.push_back(s);
	_heap->addSpace_(s);

    //printf("bumping old zone limit: _nextFree: %" PRIxPTR ". _limit: %" PRIxPTR "\n", _nextFree, _limit);

	return s;
}

GCSpace *AllocationZone::currentSpace()
{
    return _current;
}

uintptr_t AllocationZone::indexOfPointer_(uintptr_t address)
{
	return ((address - _base) >> SPACE_SIZE_SHIFT) / 2 + 1; // half of the space are forwarders
}

uintptr_t AllocationZone::indexOfSpace_(GCSpace *space)
{
    return this->indexOfPointer_(space->base());
}

void AllocationZone::markAsFull_(GCSpace *space)
{
	/*
	We mark spaces as fully occupied so that
	the GC doesn't see them as ready to be freed.
	*/
	auto index = this->indexOfSpace_(space);
	_occupancy[index - 1] = SPACE_SIZE;
}

uintptr_t AllocationZone::occupiedBytes()
{
    auto sum = 0;
    for (size_t i = 0; i < _spaces.size(); i++)
        if (!_spaces[i]->isFree())
            sum = sum + _occupancy[i];
    return sum;
}

void AllocationZone::recycleSpace_(GCSpace *space)
{
    _emptySpaces.push_back(space);
}

uintptr_t AllocationZone::regionCount()
{
    return this->indexOfPointer_(_nextFree - 1);
}

intptr_t AllocationZone::regionIndexOf_(HeapObject *object)
{
    auto pointer = (uintptr_t)object;
    if (pointer < _base) return -1;
    if (pointer >= _limit) return -1;
    return this->indexOfPointer_(pointer);
}

void AllocationZone::releaseEvacuated_(std::vector<bool> *evacuated)
{
    for (uint32_t i = 1; i < _spaces.size(); i++)
    {
        auto space = _spaces[i-1];
		auto used = _occupancy[i-1];
		bool recycle = (*evacuated)[i-1] || (used == 0 && space->committedSize() > 0);
		if (recycle)
        {
			auto base = space->_base;
			auto size = space->reservedSize();
			space->_next = base;
			space->_committedLimit = base;
			space->_softLimit = base;
			DecommitMemory(base, size * 2);
			this->recycleSpace_(space);
        }
    }
}

void AllocationZone::relocate_(intptr_t anInteger)
{
    _base = _base + anInteger;
    _nextFree = _nextFree + anInteger;
    _limit = _limit + anInteger;
}

uintptr_t AllocationZone::reservedBytes()
{
    return _limit - _base;
}

void AllocationZone::resetOccupancy()
{
	std::fill(_occupancy.begin(), _occupancy.end(), 0);
	this->markAsFull_(_current);
    this->markAsFull_(_next);
}

HeapObject *AllocationZone::shallowCopyCommiting_(HeapObject *object)
{
    auto copy = _current->shallowCopyCommitting_(object);
    if (copy)
        return copy;

    auto size = object->bodySizeInBytes();
    if (size > GCHeap::LargeThreshold)
    {
        auto space = _heap->createLargeSpace_(size);
        return space->shallowCopyCommitting_(object);
    }
    this->bumpSpace();
    return _current->shallowCopyCommitting_(object);
}

uintptr_t AllocationZone::size()
{
    return _limit - _base;
}

void AllocationZone::updateRegionOccupancy_(HeapObject *object)
{
    auto index = this->regionIndexOf_(object);
    if (index < 0) return;

    auto bytes = _occupancy[index - 1];
    _occupancy[index-1] = bytes + object->bodySizeInBytes();
}

uintptr_t AllocationZone::usableBytes()
{
    // Half of each reserved area is held for evacuation purposes only and not directly usable.
    return this->reservedBytes() / 2;
}

uintptr_t AllocationZone::usedBytes()
{
    auto count = 0;
    for (auto s : _spaces)
        count = count + s->usedSize();
    return count;
}
