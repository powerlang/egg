#ifndef _GCHEAP_H
#define _GCHEAP_H

#include "GCSpace.h"
#include "Memory.h"
#include <vector>

namespace Egg {

class GCHeap {
    GCSpace *eden, *from, *to;
    const int KB = 1024;
    const int MB = 1024 * KB;
    const int LargeThreshold = 64 * KB;
public:
    std::vector<GCSpace*> spaces;
    GCHeap();
    ~GCHeap();

    GCSpace* addSpace(GCSpace *space);
    GCSpace* addNewSpaceSized(int size);

    uintptr_t allocate(uint32_t size);
    uintptr_t allocateLarge(uint32_t size);
    uintptr_t allocateCommitting(uint32_t size);

    void collectIfTime();
    void collectYoung();

    HeapObject* allocateSlots_(uint32_t size);
    HeapObject* allocateBytes_(uint32_t size);

};

class GCHeapVector {
    
};

} // namespace Egg

#endif // ~ _GCHEAP_H ~
