#include <catch2/catch.hpp>

#include <cstdint>

#include "Launcher.h"
#include "FileImageSegment.h"
#include "Allocator/Memory.h"
#include "SegmentPath.h"

TEST_CASE("nativized code is in a page-aligned space of its own", "[code]")
{
    lmr::Launcher launcher(lmr_test::segPath("Bootstrapper.ems"));
    REQUIRE(launcher.loaded());
    launcher.relocate();

    auto* segment = launcher.segment();
    REQUIRE(segment->header.codeSize > 0);
    REQUIRE(Egg::pagealign(segment->codeStart()) == segment->codeStart());
    REQUIRE(segment->codeStart() >= segment->spaceEnd());

    auto nativeCode = launcher.exported("__start__");
    REQUIRE(nativeCode != nullptr);
    REQUIRE(segment->spaceStart() <= (uintptr_t)nativeCode);
    REQUIRE((uintptr_t)nativeCode < segment->spaceEnd());

    auto machineCode = (uintptr_t)nativeCode->slot(0);
    REQUIRE(segment->codeStart() <= machineCode);
    REQUIRE(machineCode < segment->codeEnd());
}
