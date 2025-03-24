#ifndef _G1GC_H_
#define _G1GC_H_

#include <vector>
#include "../HeapObject.h"
#include "GarbageCollector.h"

/**
 * This class implements a garbage-first inspired GC for the old heap.
 * The main idea is that the algorithm doesn't compact all old spaces
 * in the same pass, but only those which are most fragmented.
 * The old heap is managed by a allocation zone object, which splits
 * memory fixed size GCSpaces (larger objects that wouldn't fit are
 * created in another place, outside the allocation zone).
 * 
 * When the system decides it is time to reclaim space, the GC uses
 * the fragmentation stats from last G1 pass to decide which spaces
 * it will evacuate, according to an occupation threshold.
 * 
 * This allows to do forwarding during marking phase: when the tracer
 * starts, it knows all spaces that have to be evacuated. When each
 * object is reached for the first time in an evacuated space, it is
 * copyied to a different space using bump allocation and a forwarder
 * is left. This way, the GC only does one pass through the heap.
 * 
 * After GC pass finishes, some 'floating garbage' will still be left
 * because not all spaces are compacted. However, that space should be
 * a small proportion of the used memory.
*/

namespace Egg {

class HeapObject;
class AllocationZone;

class G1GC : public GarbageCollector {
public:
    std::vector<uintptr_t> _stack;
    uint32_t _limit, _index;
    HeapObject* _scanned;
    uint32_t _largeSize;
    std::vector<bool> _evacuated;
    uintptr_t _forwarderOffset;
    intptr_t _countdown;
    G1GC(Runtime *runtime, AllocationZone *oldZone, GCHeap *memory);
    virtual ~G1GC() = default;

    HeapObject* copyOf_(HeapObject *anObject);
    HeapObject* evacuate_(HeapObject *anObject);
    bool hasReachedCountdown() { return _countdown <= 0; }
    bool hasToEvacuate_(HeapObject *anObject);
    virtual void initializeLocals();
    virtual void releaseLocals();
    void resetCountdown();
    void determineEvacuatedSpaces();
    void tenured_(intptr_t anInteger) {	_countdown = _countdown - anInteger; }
    void updateWeak_at_(HeapObject *weakContainer, uintptr_t anInteger);

    bool checkReachablePropertyOf_(HeapObject *ephemeron);
    void doCollect();
    void followClosure();
    void followGCedRefs();
    void followObjects();
    uintptr_t initialContainerCapacity();
    //void purgeRememberedSet(); // RE-ENABLE AFTER PLUGGING BACK GENGC
    void queue_from_to_(HeapObject *anObject, uintptr_t start, uintptr_t end);
    void queueCurrent();
    void scan_from_to_(HeapObject *anObject, uintptr_t start, uintptr_t end);
    void scanBehavior();
    void scanSlot();
    void scanThreadLocalStorage_(HeapObject *thread);
    void scanThreadLocalStorage_at_(HeapObject *thread, uint32_t i);
    void scanTopSlot_(HeapObject *processStack);
    void sweepLargeSpaces();
    void updateRegionOccupancy_(HeapObject *object);
    uintptr_t workSpaceSize() { return 20 * MB; }

};

} // namespace Egg

#endif // ~ _G1GC_H_ ~
