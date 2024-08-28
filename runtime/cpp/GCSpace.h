#ifndef _GCSPACE_H_
#define _GCSPACE_H_

#include "HeapObject.h"
#include "Memory.h"

namespace Egg {

class GCSpace {
public:
    uintptr_t _base, _next, _softLimit, _committedLimit, _reservedLimit;
    GCSpace(int size = 4096 * 8);
    ~GCSpace();

    uintptr_t reservedSize();
    void commitMemory();
    uintptr_t allocate(uint32_t size);
    HeapObject* allocateSlots_(uint32_t size);
    HeapObject* allocateBytes_(uint32_t size);

};

class GCSpaceVector {
    
};

} // namespace Egg

#endif // ~ _GCSPACE_H_ ~
