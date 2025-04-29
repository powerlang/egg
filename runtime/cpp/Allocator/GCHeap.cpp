#include <cstring>

#include "GCHeap.h"

#include "Evaluator/Evaluator.h"

#include "GCSpace.h"
#include "KnownObjects.h"
#include "AllocationZone.h"
#include "G1GC.h"

using namespace Egg;

GCHeap::GCHeap(Runtime *runtime) : _runtime(runtime), _gcNeeded(false)
{
    _atGCSafepoint = false; // defaults to false, only particular points enable GC
    _eden = this->addNewSpaceSized_(16*MB);
    _eden->_name = "Eden";

    auto size = 128*MB;
    auto address = ReserveMemory(0x100000000,size);
    _oldZone = new AllocationZone(this, address, address + size);
    _fullGC = new G1GC(_runtime, _oldZone, this);
}

GCHeap::~GCHeap()
{
    for (auto &space : _spaces)
        delete space;
}

GCSpace *GCHeap::addSpace_(GCSpace *space)
{
    _spaces.push_back(space);
    return space;
}

GCSpace *GCHeap::addNewSpaceSized_(int size) {
    auto space = new GCSpace(size);
    return this->addSpace_(space);
}

GCSpace *Egg::GCHeap::createLargeSpace_(uintptr_t size)
{
	auto address = ReserveMemory(0, size);
	if (!address)
		error_(std::string("Not enough memory to allocate ") + std::to_string(size) + "bytes");

    auto limit = address + size;
	auto space = GCSpace::allocatedAt_limit_(address, limit);

	space->_name = "Large";
	space->_committedLimit = limit;
	space->_softLimit = limit;
	this->addSpace_(space);
	_largeSpaces.push_back(space);
	return space;
}

/*
uintptr_t GCHeap::allocate_(uint32_t size) {
    // GenGC unimplemented yet
    auto result = _eden->allocateIfPossible_(size);
    if (result)
        return result;

    if (size > LargeThreshold)
        return this->allocateLarge_(size);

    if (atGCSafepoint())
        this->collectIfTime();

    return this->allocateCommitting_(size);
}
*/

uintptr_t GCHeap::allocate_(uint32_t size) {
    auto result = _oldZone->allocateIfPossibleCurrent_(size);
    if (result) {
        _fullGC->tenured_(size);
        return result;
    }
    if (size > LargeThreshold)
        return this->allocateLarge_(size);

    if (this->isAtGCSafepoint() && !_runtime->_evaluator->isInCallback())
        this->collectIfTime();
    else
        requestGC();

    _fullGC->tenured_(size);

    return _oldZone->allocateIfPossibleBumping_(size);
}

uintptr_t GCHeap::allocateLarge_(uint32_t size) {
    auto space = this->addNewSpaceSized_(size);
    return space->allocateIfPossible_(size);
}


uintptr_t GCHeap::allocateCommitting_(uint32_t size)
{
    auto result = _eden->allocateIfPossible_(size);
    if (result) return result;

    // should allocate committing in old here

    error("Out of space. Fix me: add an old zone");
    return (uintptr_t)nullptr;
}

HeapObject* GCHeap::allocateSlots_(uint32_t size) {
    bool small = size <= HeapObject::MAX_SMALL_SIZE;
    auto headerSize = small ? 8 : 16;
    auto totalSize = headerSize + size * sizeof(uintptr_t);
    auto buffer = this->allocate_(totalSize);
    std::memset((void*)buffer, 0, headerSize);
    HeapObject *result;

    if (small)
    {
        result = ((HeapObject::SmallHeader*)buffer)->object();
        result->beSmall();
        result->smallSize((uint8_t)size);
    } 
    else
    {
        result = ((HeapObject::LargeHeader*)buffer)->object();
        result->beLarge(); 
        result->largeSize(size);
    }
    uintptr_t *end = ((uintptr_t*)result) + size;

    std::fill((uintptr_t*)result, (uintptr_t*)end, (uintptr_t)KnownObjects::nil);

    return result;
}

HeapObject* GCHeap::allocateBytes_(uint32_t size)
{
    bool small = size <= HeapObject::MAX_SMALL_SIZE;
    auto headerSize = small ? 8 : 16;
    auto totalSize = headerSize + align(size, sizeof(uintptr_t));
    auto buffer = this->allocate_(totalSize);
    std::memset((void*)buffer, 0, totalSize);
    HeapObject *result;

    if (small)
    {
        result = ((HeapObject::SmallHeader*)buffer)->object();
        result->beSmall();
        result->smallSize((uint8_t)size);
    } 
    else
    {
        result = ((HeapObject::LargeHeader*)buffer)->object();
        result->beLarge(); 
        result->largeSize(size);
    }

    result->beBytes();
    result->beArrayed();

    return result;
}

/* GenGC unimplemented yet
 void GCHeap::collectIfTime()
{
    _eden->commitMemory_(256*KB);
    bool success = _eden->increaseSoftLimit_(256 * KB);
    if (success) return;
	
    this->collectYoung();

	//if (fullCollector->reachedCountdown())
    //    this->collectOld();
}
*/

bool GCHeap::isAtGCSafepoint()
{
    return _atGCSafepoint;
}

void GCHeap::collectIfTime()
{
    if (_gcNeeded || _fullGC->hasReachedCountdown())
        this->collectOld();
}

void GCHeap::collectYoung()
{
    error("Fixme: Collect young hasn't been implemented yet");
}

void GCHeap::collectOld()
{
    //warning("GCHeap::collectOld()\n");
    for (auto space : _spaces) {
        space->unmarkAll();
    }

    //_runtime->checkCache();
    _fullGC->collect();
    //_runtime->checkCache();
    // this->rescueEphemerons();
    finishedGC();

    //warning("GCHeap::collectOld() done\n");

}