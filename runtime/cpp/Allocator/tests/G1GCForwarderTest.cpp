/*
    Unit tests for G1GC::forwarderOf_ — the per-object forwarder cell address.

    Region layout in the old AllocationZone (regionSize == 256KB):

        [ base ............ base+regionSize )   data area
        [ base+regionSize .. base+2*regionSize ) forwarder area (mirrors data)

    A HeapObject* points at the object *body*; its header occupies the 8 bytes
    immediately before the body. The forwarder cell is keyed off the header
    position, so:

        forwarderOf_(body) == (body - sizeof(SmallHeader)) + regionSize

    Regression guarded here: a zero-body object at the very top of the data
    area has its body at exactly base+regionSize (the data/forwarder boundary).
    The old computation (body + regionSize) put its forwarder at
    base+2*regionSize — i.e. the *next* region's data area — corrupting it.
    The fix steps back by the header size first, keeping the forwarder inside
    this region's own forwarder area.
*/

#include <catch2/catch.hpp>

#include "../../Egg.h"
#include "../GCHeap.h"
#include "../AllocationZone.h"
#include "../G1GC.h"
#include "../../HeapObject.h"

using namespace Egg;

namespace {
// Reserve the address space the allocator relies on. Egg::Initialize() is not
// idempotent (it reserves a 4GB region), so run it exactly once for the suite.
static const bool egg_initialized = [] { Egg::Initialize(); return true; }();

// A G1GC only dereferences oldZone()->regionSize() in its constructor and
// forwarderOf_ only reads _forwarderOffset, so a heap with a null runtime is
// enough to exercise the address arithmetic.
struct ForwarderFixture {
    GCHeap heap{nullptr};
    AllocationZone *zone = heap.oldZone();
    G1GC gc{nullptr, zone, &heap};
    uintptr_t base = zone->base();
    uintptr_t regionSize = zone->regionSize();
};
}

TEST_CASE("G1GC forwarder of the first object lands at the region's forwarder base", "[gc][forwarder]") {
    ForwarderFixture f;
    // First small object: header at base, body 8 bytes in.
    auto *firstBody = (HeapObject *)(f.base + sizeof(HeapObject::SmallHeader));
    auto fw = (uintptr_t)f.gc.forwarderOf_(firstBody);

    // header (base) mirrored into the forwarder area => exactly base+regionSize.
    REQUIRE(fw == f.base + f.regionSize);
}

TEST_CASE("G1GC forwarder of a boundary object stays inside its own forwarder area", "[gc][forwarder]") {
    ForwarderFixture f;
    // Zero-body object at the top of the data area: header at
    // base+regionSize-8, body at exactly base+regionSize (the boundary).
    auto *boundaryBody = (HeapObject *)(f.base + f.regionSize);
    auto fw = (uintptr_t)f.gc.forwarderOf_(boundaryBody);

    // Must stay strictly within this region's forwarder area.
    REQUIRE(fw >= f.base + f.regionSize);
    REQUIRE(fw <  f.base + 2 * f.regionSize);

    // Exact cell: last 8-byte slot of the forwarder area.
    REQUIRE(fw == f.base + 2 * f.regionSize - sizeof(HeapObject::SmallHeader));

    // Regression guard: the old (buggy) formula `body + regionSize` produced
    // base+2*regionSize, the next region's data area.
    REQUIRE(fw != f.base + 2 * f.regionSize);
}
