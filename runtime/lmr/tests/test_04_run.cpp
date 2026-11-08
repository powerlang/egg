/*
    Step 4: run the nativized __start__ entry. Locate its NativeCode via the
    #__start__ export, mark the machine code executable, set up a frame and
    jump in. __start__ is `^42`, answered to C as the slong 42. This is the
    first nativized code executed by the launcher, with no C++ evaluator
    involved.
*/
#include <catch2/catch.hpp>

#include <cstdint>

#include "Launcher.h"
#include "SegmentPath.h"
#include "FFIGlue.h"

#include <cmath>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <fstream>

TEST_CASE("running the nativized __start__ returns 42", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.Bootstrapper.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.Bootstrapper");
    launcher.relocate();

    auto result = launcher.run("__start__");
    REQUIRE(result == 42);
}

TEST_CASE("the launcher tests module exports its entries", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("start");
    REQUIRE(result == 42);
}

TEST_CASE("a native send runs once its segment is bound", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("send");
    REQUIRE(result == 42);
}

TEST_CASE("a static send runs a Kernel.LMR replacement", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("sendsToReplacement");
    REQUIRE(result == 1);
}

TEST_CASE("native code allocates in the Kernel space before startUp", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("allocation");
    REQUIRE(result == 3);
}

TEST_CASE("a closure captures the method argument it names", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("capture");
    REQUIRE(result == 3);
}

TEST_CASE("perform: runs the method it finds", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("performAnswer");
    REQUIRE(result == 42);
}

TEST_CASE("inlined andNot: and orNot: negate their last condition", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("negations");
    REQUIRE(result == 3);
}

TEST_CASE("a non-local return returns from the closure's home method", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("nonLocalReturn");
    REQUIRE(result == 12);
}

TEST_CASE("a block in a launcher entry runs and returns to it", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("sumInBlock") == 6);
}

TEST_CASE("a nested block captures a method temporary through its outer block", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("captureThroughBlocks") == 7);
}

TEST_CASE("the native host knows the platform it runs on", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("platformNameSize");
    REQUIRE(result == (int64_t)std::strlen(Egg::PlatformName()));
}

TEST_CASE("SmallInteger arithmetic and nil tests run natively", "[run]")
{
    const std::pair<const char*, int64_t> expected[] = {
        {"add", 7},
        {"times", 42},
        {"smiTimes", 42},
        {"largeProduct", 503096068},
        {"modulo", 4},
        {"floatTimesInteger", 10},
        {"answerIfNotNil", 6},
        {"answerIfNilIfNotNil", 7}};
    for (auto& [entry, value] : expected) {
        INFO("entry: " << entry);
        lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
        launcher.bind("LMR.LauncherTests");
        launcher.relocate();
        REQUIRE(launcher.run(entry) == value);
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
        REQUIRE(launcher.run(entry) == value);
    }
}

TEST_CASE("globals defined at run time are bound at first use", "[run]")
{
    const std::pair<const char*, int64_t> expected[] = {
        {"readsLateGlobal", 42},
        {"writesLateGlobal", 7}};
    for (auto& [entry, value] : expected) {
        INFO("entry: " << entry);
        lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
        launcher.bind("LMR.LauncherTests");
        launcher.relocate();
        REQUIRE(launcher.run(entry) == value);
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
        {"atIfAbsent", 1},
        {"findFirst", 9}};
    for (auto& [entry, value] : expected) {
        INFO("entry: " << entry);
        lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
        launcher.bind("LMR.LauncherTests");
        launcher.relocate();
        REQUIRE(launcher.run(entry) == value);
    }
}

TEST_CASE("an inlined to:by:do: counts up and down by its step", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    REQUIRE(launcher.loaded());
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();

    auto result = launcher.run("toByDo");
    REQUIRE(result == 1040710 + 100602);
}

TEST_CASE("FFI initializes natively and calls C functions", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("callsC") == 1);
}

TEST_CASE("the native host reads the program arguments", "[run]")
{
    const char* argv[] = {"lmr", "egg"};
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.arguments(2, argv);
    launcher.relocate();
    REQUIRE(launcher.run("readsArguments") == 42);
}

TEST_CASE("the start entry loads a module natively and runs its main", "[run]")
{
    const char* argv[] = {"lmr", LMR_SEG_DIR, "Examples.HelloWorld"};
    lmr::Launcher launcher(lmr_test::segPath("LMR.Start.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.Start");
    launcher.arguments(3, argv);
    launcher.relocate();
    REQUIRE(launcher.run("start") == 0);
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
    REQUIRE(result == (int64_t)contents.size());
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
    REQUIRE(result == 42);
}

TEST_CASE("the native host reserves commits and releases memory", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("reservesMemory") == 42);
}

TEST_CASE("native code writes 32-bit integers into bytes", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("writesLongs") == 42);
}

TEST_CASE("bound modules are loaded modules natively", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("findsBoundModules") == 42);
}

TEST_CASE("Kernel os hands out and reuses memory in the heap block", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("allocatesHeap") == 42);
}

TEST_CASE("native memory starts up and allocates beyond the kernel space", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("startsMemory") == 42);
}

TEST_CASE("native memory collects garbage and keeps what survives", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("collectsGarbage") == 42);
}

TEST_CASE("the native host makes memory executable", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("makesExecutable") == 42);
}

TEST_CASE("native code handles a message not understood", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("handlesDnu") == 4);
}

extern "C" __attribute__((visibility("default"), used)) int64_t lmrTestStackArguments(
    int64_t a1, int64_t a2, int64_t a3, int64_t a4, int64_t a5, int64_t a6,
    int64_t a7, int64_t a8, int32_t a9, int8_t a10, int16_t a11, int64_t a12)
{
    return a1 + 2 * a2 + 3 * a3 + 4 * a4 + 5 * a5 + 6 * a6 + 7 * a7 + 8 * a8
        + 9 * a9 + 10 * a10 + 11 * a11 + 12 * a12;
}

extern "C" __attribute__((visibility("default"), used)) double lmrTestFloatArguments(
    double d1, double d2, double d3, double d4, double d5, double d6, double d7,
    double d8, float f9, double d10, float f11)
{
    return d1 + 2 * d2 + 3 * d3 + 4 * d4 + 5 * d5 + 6 * d6 + 7 * d7 + 8 * d8
        + 9 * f9 + 10 * d10 + 11 * f11;
}

TEST_CASE("native callouts pass integers, floats and stack arguments", "[run]")
{
    const std::pair<const char*, int64_t> expected[] = {
        {"callsOutWithIntegers", 42},
        {"callsOutWithDoubles", 6},
        {"callsOutWithFloats", 10},
        {"passesStackArguments", 450},
        {"passesFloatArguments", 539}};
    for (auto& [entry, value] : expected) {
        INFO("entry: " << entry);
        lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
        launcher.bindFFI();
        launcher.bind("LMR.LauncherTests");
        launcher.relocate();
        REQUIRE(launcher.run(entry) == value);
    }
}

TEST_CASE("bound modules' extension methods run natively", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("sendsBoundExtension") == 8);
}

TEST_CASE("native code copies a string out to C memory", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bindFFI();
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("copiesStringOut") == 'g');
}

TEST_CASE("native floats compute logarithms and trigonometry through libm", "[run]")
{
    const std::pair<const char*, int64_t> expected[] = {
        {"logarithm", (int64_t)(std::log(1000.0) * 100)},
        {"trigonometry", (int64_t)((std::sin(0.5) + std::cos(0.5) + std::tan(0.5) + std::atan(1.0) + std::exp(1.0)) * 1000)}};
    for (auto& [entry, value] : expected) {
        INFO("entry: " << entry);
        lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
        launcher.bindFFI();
        launcher.bind("LMR.LauncherTests");
        launcher.relocate();
        REQUIRE(launcher.run(entry) == value);
    }
}

TEST_CASE("a nativized callback receives its C arguments", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    auto second = reinterpret_cast<int64_t (*)(int64_t, int64_t)>(launcher.entry("second:with:"));
    REQUIRE(second(3, 4) == 4);
    REQUIRE(second(4, -5) == -5);
}

TEST_CASE("a nativized callback takes and answers 32-bit ints", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    auto negated = reinterpret_cast<int (*)(int)>(launcher.entry("negated:"));
    REQUIRE(negated(5) == -5);
    REQUIRE(negated(-7) == 7);
}

TEST_CASE("a nativized callback takes and answers doubles", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    auto identity = reinterpret_cast<double (*)(double)>(launcher.entry("identity:"));
    REQUIRE(identity(2.5) == 2.5);
}

TEST_CASE("a nativized callback answers integers beyond SmallInteger", "[run]")
{
    lmr::Launcher launcher(lmr_test::segPath("LMR.LauncherTests.ems"));
    launcher.bind("LMR.LauncherTests");
    launcher.relocate();
    REQUIRE(launcher.run("large") == 0x4000000000000000);
}
