#include <catch2/catch.hpp>

#include "Launcher.h"
#include "SegmentPath.h"
#include "FileImageSegment.h"

TEST_CASE("a launched segment loads the segments it imports", "[link]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.Bootstrapper.ems"));
    REQUIRE(launcher.loaded());
    REQUIRE(launcher.segmentNamed("Kernel") != nullptr);
    REQUIRE(launcher.segmentNamed("LMR") != nullptr);
    REQUIRE(launcher.segmentNamed("LMR.Nativizer") != nullptr);
}

static size_t referencesTo(Egg::Object* object, uintptr_t start, uintptr_t limit)
{
    size_t count = 0;
    auto current = ((Egg::HeapObject::ObjectHeader*)start)->object();
    while (current < (Egg::HeapObject*)limit) {
        if ((Egg::Object*)current->behavior() == object)
            count++;
        for (uintptr_t i = 0; i < current->pointersSize(); i++)
            if (current->slot(i) == object)
                count++;
        current = current->nextObject();
    }
    return count;
}

static size_t referencesTo(Egg::Object* object, Egg::FileImageSegment* segment)
{
    auto count = referencesTo(object, segment->spaceStart(), segment->spaceEnd());
    if (segment->header.codeSize != 0)
        count += referencesTo(object, segment->codeStart(), segment->codeEnd());
    return count;
}

TEST_CASE("relocating binds the imports of the runtime core by name", "[link]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.relocate();

    for (auto module : {"Kernel", "Kernel.LMR", "LMR"}) {
        INFO("module: " << module);
        auto segment = launcher.segmentNamed(module);
        auto imports = launcher.importsOf(module);
        REQUIRE(imports.size() == segment->_importDescriptors.size());
        REQUIRE(!imports.empty());
        auto sentinel = reinterpret_cast<Egg::Object*>(segment->spaceStart());
        REQUIRE(referencesTo(sentinel, segment) == 0);
    }
}

TEST_CASE("relocating binds the imports of the modules bound by name", "[link]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto segment = launcher.segmentNamed("LMR.LauncherTests");
    REQUIRE(!segment->_importDescriptors.empty());
    auto sentinel = reinterpret_cast<Egg::Object*>(segment->spaceStart());
    REQUIRE(referencesTo(sentinel, segment) == 0);
}
