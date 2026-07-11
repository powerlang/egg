/*
    Step 1: load a produced .ems segment via the reused FileImageSegment and
    check its header is sane (signature, size, that memory was reserved).

    This validates the launcher can read a segment the bootstrapper wrote,
    before we attempt relocation / executing native code.
*/
#include <catch2/catch.hpp>

#include <cstring>
#include <string>

#include "Launcher.h"
#include "ImageSegment.h"

namespace
{
std::string segPath(const char* name)
{
    return std::string(LMR_SEG_DIR) + "/" + name;
}
} // namespace

TEST_CASE("a produced .ems segment loads with a valid header", "[load]")
{
    const auto path = segPath("LMR.ems");
    INFO("segment path: " << path);

    lmr::Launcher launcher(path);
    REQUIRE(launcher.loaded());

    auto* seg = launcher.segment();
    REQUIRE(seg != nullptr);

    REQUIRE(std::strncmp(reinterpret_cast<const char*>(seg->header.signature),
                         "EGG_IS\n", 7) == 0);
    REQUIRE(seg->header.size > sizeof(Egg::ImageSegmentHeader));
    REQUIRE(seg->_currentBase != 0);
}
