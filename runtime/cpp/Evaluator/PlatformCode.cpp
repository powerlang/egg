
#include "PlatformCode.h"

#include <Allocator/Memory.h>

Egg::PlatformCode* Egg::newPlatformCode()
{
    void* rawmem = Egg::aligned_alloc<PlatformCode>();
    if (!rawmem) {
        throw std::bad_alloc();
    }

    // Construct the object in the allocated memory
    return new (rawmem) PlatformCode();
}

void Egg::deletePlatformCode(Egg::PlatformCode* platformCode)
{
    platformCode->~PlatformCode();

    // Free the raw memory
    aligned_free((void*)platformCode);
}