/*
    Step 4: run the nativized __start__ entry. Locate its NativeCode via the
    #__start__ export, mark the machine code executable, set up a frame and
    jump in. __start__ is `^42`, so the result is the tagged SmallInteger 42
    (42 * 2 + 1 = 85). This is the first nativized code executed by the
    launcher, with no C++ evaluator involved.
*/
#include <catch2/catch.hpp>

#include <cstdint>

#include "Launcher.h"
#include "SegmentPath.h"

TEST_CASE("running the nativized __start__ returns 42", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.Bootstrapper.ems"));
    REQUIRE(launcher.loaded());

    launcher.relocate();

    auto result = launcher.run("__start__");
    REQUIRE(result == 85);
    REQUIRE((result >> 1) == 42);
}

TEST_CASE("the launcher tests module exports its entries", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.relocate();

    auto result = launcher.run("start");
    REQUIRE((result >> 1) == 42);
}

TEST_CASE("a native send runs once its segment is bound", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("send");
    REQUIRE((result >> 1) == 42);
}

TEST_CASE("a static send runs a Kernel.LMR replacement", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("sendsToReplacement");
    REQUIRE((result >> 1) == 1);
}

TEST_CASE("native code allocates in the Kernel space before startUp", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("allocation");
    REQUIRE((result >> 1) == 3);
}

TEST_CASE("a closure captures the method argument it names", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("capture");
    REQUIRE((result >> 1) == 3);
}
