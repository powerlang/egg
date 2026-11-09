/*
    Step 2: loading a segment parses its import and export tables, and each
    export address is relocated to point inside the segment's objects or code.
    Later steps use the exports to find entry points (a module, a method) by
    name, and the imports to bind references into other segments.
*/
#include <catch2/catch.hpp>

#include <cstdint>

#include "Launcher.h"
#include "FileImageSegment.h"
#include "SegmentPath.h"

TEST_CASE("loading a segment parses its import and export tables", "[tables]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.ems"));
    REQUIRE(launcher.loaded());

    auto* seg = launcher.segment();

    REQUIRE_FALSE(seg->_importStrings.empty());
    REQUIRE_FALSE(seg->_importDescriptors.empty());
    REQUIRE_FALSE(seg->_exports.empty());

    for (const auto& [name, object] : seg->_exports)
    {
        INFO("export: " << name);
        auto address = reinterpret_cast<uintptr_t>(object);
        auto inObjects = address >= seg->spaceStart() && address < seg->spaceEnd();
        auto inCode = seg->header.codeSize != 0 && address >= seg->codeStart() && address < seg->codeEnd();
        REQUIRE((inObjects || inCode));
    }
}
