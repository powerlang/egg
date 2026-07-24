/*
    Step 3: relocating a segment rebases its in-segment pointers. After
    fixPointerSlots the module reference in the header must land inside the
    reserved region. Imports are left unresolved (a sentinel) here, which is
    fine for checking in-segment relocation and for running code that never
    touches imported objects.
*/
#include <catch2/catch.hpp>

#include <cstdint>

#include "Launcher.h"
#include "FileImageSegment.h"
#include "SegmentPath.h"

TEST_CASE("relocating a segment rebases its module pointer in range", "[relocate]")
{
    lmr::Launcher launcher(lmr_test::segPath("Bootstrapper.ems"));
    REQUIRE(launcher.loaded());

    launcher.relocate();

    auto* seg = launcher.segment();
    auto module = reinterpret_cast<uintptr_t>(seg->header.module);
    REQUIRE(module >= seg->spaceStart());
    REQUIRE(module < seg->spaceEnd());
}
