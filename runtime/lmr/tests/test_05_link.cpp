#include <catch2/catch.hpp>

#include "Launcher.h"
#include "SegmentPath.h"

TEST_CASE("a launched segment loads the segments it imports", "[link]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.Bootstrapper.ems"));
    REQUIRE(launcher.loaded());
    REQUIRE(launcher.segmentNamed("Kernel") != nullptr);
    REQUIRE(launcher.segmentNamed("LMR") != nullptr);
    REQUIRE(launcher.segmentNamed("LMR.Nativizer") != nullptr);
}
