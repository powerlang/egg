#include "GCHeap.h"
#include "KnownObjects.h"

#include <cstring>

using namespace Egg;

Egg::GCHeap::GCHeap()
{
    eden = this->addNewSpaceSized(16*MB);
}

Egg::GCHeap::~GCHeap()
{
    for (auto &space : spaces)
        delete space;
}

GCSpace *GCHeap::addSpace(GCSpace *space)
{
    spaces.push_back(space);
    return space;
}

GCSpace *GCHeap::addNewSpaceSized(int size) {
    auto space = new GCSpace(size);
    return this->addSpace(space);
}

uintptr_t GCHeap::allocate(uint32_t size) {
    auto result = eden->allocate(size);
    if (result)
        return result;

	if (size > LargeThreshold)
        return this->allocateLarge(size);
	
    if (!GC_CRITICAL)
        this->collectIfTime();

    return this->allocateCommitting(size);
}

uintptr_t GCHeap::allocateLarge(uint32_t size) {
    auto space = this->addNewSpaceSized(size);
    return space->allocate(size);
}

uintptr_t GCHeap::allocateCommitting(uint32_t size)
{
    auto result = eden->allocate(size);
    if (result) return result;

    // should allocate committing in old here

    error("Out of space. Fix me: add an old zone");
    return (uintptr_t)nullptr;
}

HeapObject* GCHeap::allocateSlots_(uint32_t size) {
    bool small = size <= HeapObject::MAX_SMALL_SIZE;
    auto headerSize = small ? 8 : 16;
    auto totalSize = headerSize + size * sizeof(uintptr_t);
    auto buffer = this->allocate(totalSize);
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
    auto buffer = this->allocate(totalSize);
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

void GCHeap::collectIfTime()
{
    eden->commitMemory(256*KB);
    bool success = eden->increaseSoftLimit_(256 * KB);
    if (success) return;
	
    this->collectYoung();

	//if (fullCollector->reachedCountdown())
    //    this->collectOld();
}

void GCHeap::collectYoung()
{
    error("Fixme: Collect young hasn't been implemented yet");
}
