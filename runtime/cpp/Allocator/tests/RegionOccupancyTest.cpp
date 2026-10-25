#include <catch2/catch.hpp>

#include "../../Egg.h"
#include "../GCHeap.h"
#include "../AllocationZone.h"
#include "../../HeapObject.h"

using namespace Egg;

// G1GCForwarderTest already ran Egg::Initialize(), and it can't run twice

TEST_CASE("an empty object keeps its region occupied", "[gc][occupancy]") {
    GCHeap heap{nullptr};
    AllocationZone *zone = heap.oldZone();
    auto empty = heap.allocateSlots_(0);
    auto index = zone->regionIndexOf_(empty);
    REQUIRE(index > 0);

    // a region with occupancy 0 after marking gets decommitted
    (*zone->occupancy())[index - 1] = 0;
    zone->updateRegionOccupancy_(empty);
    REQUIRE((*zone->occupancy())[index - 1] > 0);
}
