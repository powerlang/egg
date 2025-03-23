#ifndef _ALLOCATION_ZONE_H_
#define _ALLOCATION_ZONE_H_

#include <vector>
#include "Egg.h"

namespace Egg {

class HeapObject;
class GCSpace;
class GCHeap;

class AllocationZone {
    GCHeap *_heap;
    uintptr_t _base, _nextFree, _limit;
    GCSpace *_current, *_next;
    std::vector<GCSpace*> _spaces;
    std::vector<GCSpace*> _emptySpaces;
    std::vector<uintptr_t> _occupancy;

public:
    AllocationZone(GCHeap* heap, uintptr_t base, uintptr_t limit);

    // 256 kb spaces
    const uintptr_t SPACE_SIZE_SHIFT = 18;
    const uintptr_t SPACE_SIZE = 1 << SPACE_SIZE_SHIFT;

    uintptr_t base() { return _base; }
    uintptr_t limit() { return _limit; }
    std::vector<uintptr_t>* occupancy() { return &_occupancy; }
    uintptr_t regionSize() { return SPACE_SIZE; }
    std::vector<GCSpace*>& spaces() { return _spaces; }

    uintptr_t allocate_(uintptr_t size);
    uintptr_t allocateIfPossibleCurrent_(uintptr_t size);
    uintptr_t allocateIfPossibleBumping_(uintptr_t size);
    void assureFree_(uintptr_t size);
    uintptr_t availableBytes();
    void build();
    GCSpace* bumpSpace();
    uintptr_t committedBytes();
    GCSpace* createEmptySpace();
    GCSpace* currentSpace();
    uintptr_t indexOfPointer_(uintptr_t address);
    uintptr_t indexOfSpace_(GCSpace *space);
    void markAsFull_(GCSpace *space);
    uintptr_t occupiedBytes();
    void recycleSpace_(GCSpace *space);
    uintptr_t regionCount();
    intptr_t regionIndexOf_(HeapObject *object);
    void releaseEvacuated_(std::vector<bool> *evacuated);
    void relocate_(intptr_t anInteger);
    uintptr_t reservedBytes();
    void resetOccupancy();
    HeapObject* shallowCopyCommiting_(HeapObject *object);
    uintptr_t size();
    void updateRegionOccupancy_(HeapObject *object);
    uintptr_t usableBytes();
    uintptr_t usedBytes();
};

} // namespace Egg

#endif // ~ _ALLOCATION_ZONE_H_ ~
