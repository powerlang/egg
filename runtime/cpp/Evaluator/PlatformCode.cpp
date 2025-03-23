
#include "PlatformCode.h"

Egg::PlatformCode* Egg::newPlatformCode()
{
    void* rawmem = static_cast<PlatformCode*>(std::aligned_alloc(alignof(void*), sizeof(PlatformCode)));
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
    std::free(platformCode);
}