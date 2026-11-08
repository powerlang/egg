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
#include "FFIGlue.h"

#include <cstdio>
#include <cstring>
#include <filesystem>
#include <fstream>

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

TEST_CASE("perform: runs the method it finds", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("performAnswer");
    REQUIRE((result >> 1) == 42);
}

TEST_CASE("inlined andNot: and orNot: negate their last condition", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("negations");
    REQUIRE((result >> 1) == 3);
}

TEST_CASE("a non-local return returns from the closure's home method", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("nonLocalReturn");
    REQUIRE((result >> 1) == 12);
}

TEST_CASE("a block in a launcher entry runs and returns to it", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE((launcher.run("sumInBlock") >> 1) == 6);
}

TEST_CASE("a nested block captures a method temporary through its outer block", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE((launcher.run("captureThroughBlocks") >> 1) == 7);
}

TEST_CASE("the native host knows the platform it runs on", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("platformNameSize");
    REQUIRE((result >> 1) == (int64_t)std::strlen(Egg::PlatformName()));
}

TEST_CASE("SmallInteger arithmetic and nil tests run natively", "[run]")
{
    const std::pair<const char*, int64_t> expected[] = {
        {"add", 7},
        {"times", 42},
        {"smiTimes", 42},
        {"largeProduct", 503096068},
        {"modulo", 4},
        {"answerIfNotNil", 6},
        {"answerIfNilIfNotNil", 7}};
    for (auto& [entry, value] : expected) {
        INFO("entry: " << entry);
        lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
        launcher.bind("LMR.LauncherTests");
        launcher.relocate();
        REQUIRE((launcher.run(entry) >> 1) == value);
    }
}

TEST_CASE("native code allocates arrays and byte arrays", "[run]")
{
    const std::pair<const char*, int64_t> expected[] = {
        {"newArray", 3},
        {"newBytes", 5}};
    for (auto& [entry, value] : expected) {
        INFO("entry: " << entry);
        lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
        launcher.bind("LMR.LauncherTests");
        launcher.relocate();
        REQUIRE((launcher.run(entry) >> 1) == value);
    }
}

TEST_CASE("native code looks up method dictionaries and symbol hashes", "[run]")
{
    const std::pair<const char*, int64_t> expected[] = {
        {"symbolHash", 30916},
        {"methodAt", 1},
        {"methodScan", 9},
        {"tableSize", 64},
        {"tableIndex", 9},
        {"equates", 1},
        {"emptySlot", 1},
        {"valueAt", 1},
        {"lookupKey", 1},
        {"hashFor", 30916},
        {"atIfAbsent", 1}};
    for (auto& [entry, value] : expected) {
        INFO("entry: " << entry);
        lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
        launcher.bind("LMR.LauncherTests");
        launcher.relocate();
        REQUIRE((launcher.run(entry) >> 1) == value);
    }
}

TEST_CASE("an inlined to:by:do: counts up and down by its step", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("toByDo");
    REQUIRE((result >> 1) == 1040710 + 100602);
}

TEST_CASE("FFI initializes natively and calls C functions", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE((launcher.run("callsC") >> 1) == 1);
}

TEST_CASE("the native host reads the program arguments", "[run]")
{
    const char* argv[] = {"lmr", "egg"};
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.arguments(2, argv);
    launcher.relocate();
    REQUIRE((launcher.run("readsArguments") >> 1) == 42);
}

TEST_CASE("the start entry loads a module natively and runs its main", "[run]")
{
    const char* argv[] = {"lmr", LMR_SEG_DIR, "Examples.HelloWorld"};
    lmr::Launcher launcher(lmr_test::segPath("LMR.Start.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.Start");
    launcher.arguments(3, argv);
    launcher.relocate();
    REQUIRE((launcher.run("start") >> 1) == 0);
}

TEST_CASE("the native host reads a whole file", "[run]")
{
    const std::string contents = "egg reads files";
    std::ofstream("launcher-tests-file.txt", std::ios::binary) << contents;
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    auto result = launcher.run("readsFile");
    std::remove("launcher-tests-file.txt");
    REQUIRE((result >> 1) == (int64_t)contents.size());
}

TEST_CASE("an image segment loads natively", "[run]")
{
    std::filesystem::copy_file(lmr_test::segPath("Examples.HelloWorld.ems"), "launcher-tests-segment.ems",
                               std::filesystem::copy_options::overwrite_existing);
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    auto result = launcher.run("loadsSegment");
    std::remove("launcher-tests-segment.ems");
    REQUIRE((result >> 1) == 42);
}

TEST_CASE("the native host reserves commits and releases memory", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE((launcher.run("reservesMemory") >> 1) == 42);
}

TEST_CASE("native code writes 32-bit integers into bytes", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE((launcher.run("writesLongs") >> 1) == 42);
}

TEST_CASE("bound modules are loaded modules natively", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE((launcher.run("findsBoundModules") >> 1) == 42);
}

TEST_CASE("Kernel os hands out and reuses memory in the heap block", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE((launcher.run("allocatesHeap") >> 1) == 42);
}

TEST_CASE("native memory starts up and allocates beyond the kernel space", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE((launcher.run("startsMemory") >> 1) == 42);
}

TEST_CASE("the native host makes memory executable", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE((launcher.run("makesExecutable") >> 1) == 42);
}
