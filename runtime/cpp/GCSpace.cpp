#include "GCSpace.h"
#include "KnownObjects.h"

#include <cstring>

using namespace Egg;

Egg::GCSpace::GCSpace(int size)
{
        _base = Egg::ReserveMemory(0, size);
        if (!_base)
            error("Failed to reserve memory.");

        _next = _softLimit = _committedLimit = _base;
        _reservedLimit = _base + size;

}

Egg::GCSpace::~GCSpace()
{
    if (_base)
      Egg::FreeMemory(_base, _reservedLimit - _base);
}

uintptr_t GCSpace::reservedSize()
{
    return _reservedLimit - _base;
}

void GCSpace::commitMemory()
{
    Egg::CommitMemory(_base, this->reservedSize());
    _softLimit = _committedLimit = _reservedLimit;
}

uintptr_t GCSpace::allocate(uint32_t size) {
    auto result = _next;
    auto end = _next + size;
    if (end < _softLimit)
    {
        _next = end;
        return result;
    }

    error("out of space");
    return 0;
}

HeapObject* GCSpace::allocateSlots_(uint32_t size) {
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
    HeapObject *end = ((HeapObject*)result) + size;

    std::fill((HeapObject**)result, (HeapObject**)end, KnownObjects::nil);

    return result;
}

HeapObject* GCSpace::allocateBytes_(uint32_t size)
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
