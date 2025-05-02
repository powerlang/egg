#ifndef _GCHEAP_H
#define _GCHEAP_H

#include <vector>
#include <Evaluator/Runtime.h>

#include "GCGuard.h"
#include "Egg.h"

namespace Egg {

class GCSpace;
class AllocationZone;
class G1GC;
class Runtime;

class GCHeap {
    GCSpace *_eden, *_from, *_to;
    uintptr_t _youngBase, _youngLimit;

    Runtime *_runtime;
    AllocationZone *_oldZone;
    G1GC *_fullGC;

    bool _atGCUnsafepoint; // when true, moving objects is explicitly forbiden
    bool _atGCSafepoint; // when true, it is allowed to start GC (specially, to move objects)
    bool _gcNeeded; // set when fast-path allocation fails, will be done later at GC safepoints

public:
    static const int LargeThreshold = 64 * Egg::KB;
    
    std::vector<GCSpace*> _spaces;
    std::vector<GCSpace*> _largeSpaces;

    GCHeap(Runtime *runtime);
    ~GCHeap();

    AllocationZone* oldZone() { return _oldZone; }

    GCSpace* eden() { return _eden; }
    GCSpace* from() { return _from; }
    GCSpace* to()   { return _to; }

    uintptr_t youngBase() { return _youngBase; }
    uintptr_t youngLimit() { return _youngLimit; }

    GCSpace* addSpace_(GCSpace *space);
    GCSpace* addNewSpaceSized_(int size);

    GCSpace* createLargeSpace_(uintptr_t size);

    uintptr_t allocate_(uint32_t size);
    uintptr_t allocateLarge_(uint32_t size);
    uintptr_t allocateCommitting_(uint32_t size);

    bool isGCAllowed() { return _atGCSafepoint && !_atGCUnsafepoint; }
    bool isAtGCSafepoint() { return _atGCSafepoint; }
    bool isAtGCUnsafepoint() { return _atGCUnsafepoint; }

    GCGuard atGCSafepoint() { return GCGuard(_atGCSafepoint, true); }
    GCGuard atGCUnsafepoint() { return GCGuard(_atGCUnsafepoint, true); }


    void requestGC() { _gcNeeded = true; }
    void finishedGC() { _gcNeeded = false; }

    void collectIfTime();
    void collectYoung();
    void collectOld();

    HeapObject* allocateSlots_(uint32_t size);
    HeapObject* allocateBytes_(uint32_t size);

};

class GCHeapVector {
    
};

} // namespace Egg

#endif // ~ _GCHEAP_H ~
