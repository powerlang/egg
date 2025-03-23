#ifndef _GARBAGECOLLECTOR_H_
#define _GARBAGECOLLECTOR_H_

#include "GCSpace.h"
#include "GCHeap.h"
#include "Memory.h"
#include <vector>

namespace Egg {

class Runtime;
class AllocationZone;

class GarbageCollector {
protected:
    Runtime *_runtime;
    AllocationZone *_oldZone;

    std::vector<HeapObject*> *_weakContainers;
    std::vector<HeapObject*> *_uncheckedEphemerons, *_unreachedEphemerons, *_rescuedEphemerons;
    HeapObject *_tombstone;
    
    GCHeap *_heap;
    std::vector<HeapObject*> *_stacks;
    uintptr_t _currentSP;

    const int LargeThreshold = 64 * KB;
    
public:
    GarbageCollector(Runtime *runtime, AllocationZone *oldZone, GCHeap *heap);

    virtual ~GarbageCollector() = default;

    bool checkEphemerons();
    virtual void checkEphemeron_(HeapObject *ephemeron) {}
    virtual bool checkReachablePropertyOf_(HeapObject *ephemeron) = 0;

    void collect();
    virtual void doCollect();
    virtual void followClosure() = 0;
    void followEphemerons();
    void followEphemeronWeaks_(HeapObject *ephemeron);
    void followLiveEphemerons();
    void followRoots();
    virtual uintptr_t initialContainerCapacity() = 0;
    virtual void initializeLocals();
    void heap_(GCHeap *aGCHeap);
    virtual void postInitialize();
    virtual void releaseLocals();
    void rememberSpecial_(HeapObject *anObject);
    void rescueEphemeron_(HeapObject *ephemeron);
    bool rescueUnreachableEphemerons();
    virtual void scan_from_to_(HeapObject *current, uintptr_t start, uintptr_t limit) = 0;
    void scanNativeStackFrame_sized_(uintptr_t *framePointer, uintptr_t size);
    void scanStackFrameObjects_sized_(uintptr_t *framePointer, uintptr_t size);
    void scanSpecialSlots_(HeapObject *special);

    void nativeFramesStartingAt_bp_do_(uintptr_t **stack, uintptr_t sp, uintptr_t bp, std::function<void(uintptr_t*, uintptr_t)> block);
    void scanFirstStackChunk_(HeapObject * aProcessVMStack);
    void scanCurrentContext();
    void scanStack_(HeapObject *aProcessVMStack);
    void scanStacks();
    virtual void scanThreadLocalStorage_(HeapObject *tread) = 0;
    void scanWeakContainers();
    void strengthenAndMigrateEphemerons();
    void swapUncheckedWithUnreached();
    virtual void updateWeak_at_(HeapObject *weakContainer, uintptr_t index) = 0;
    void updateWeakReferencesOf_(HeapObject *weakContainer);

};

} // namespace Egg

#endif // ~ _GARBAGECOLLECTOR_H_ ~
