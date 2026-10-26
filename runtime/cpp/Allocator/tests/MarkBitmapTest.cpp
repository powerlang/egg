#include <catch2/catch.hpp>

#include "../Memory.h"

using namespace Egg;

namespace {
// G1GCForwarderTest already ran Egg::Initialize(), which reserves the bitmap, and it can't run twice

uint8_t* markByte(uintptr_t address)
{
    return (uint8_t*)((address & ~(MarkChunkSize - 1)) + ((address & (MarkChunkSize - 1)) >> 6));
}

int markBit(uintptr_t address) { return (address >> 3) & 7; }

// LMRProtoObject>>_markWord, _markIndex and _markMask, from pointer, which is `self _asPointer`
intptr_t markWord(intptr_t pointer) { return (pointer & -0x80000000LL) + (((pointer & 0x7FFFFFFF) >> 8) << 2); }
int markIndex(intptr_t pointer) { return ((pointer >> 5) & 7) + 1; }
int markMask(intptr_t pointer) { return 1 << ((pointer >> 2) & 7); }
}

TEST_CASE("LMR's mark arithmetic finds the byte and bit of an address", "[marks]")
{
    // an odd multiple of 8, so that offsets go through every byte and bit
    const uintptr_t step = 8 * 100003;
    for (uintptr_t window : {uintptr_t(0), 3 * MarkChunkSize}) {
        for (uintptr_t offset = MarkBitmapSize; offset < MarkChunkSize; offset += step) {
            auto address = window + offset;
            auto pointer = (intptr_t)(address / 2);
            INFO("address " << std::hex << address);
            REQUIRE((uintptr_t)(markWord(pointer) * 2 + markIndex(pointer) - 1) == (uintptr_t)markByte(address));
            REQUIRE(markMask(pointer) == 1 << markBit(address));
        }
    }
}

TEST_CASE("heap memory goes after the mark bitmap, whose bytes are usable", "[marks]")
{
    const uintptr_t size = 64 * 1024;
    auto base = ReserveMemory(HEAP_ADDRESS_BLOCK + 16 * 1024 * 1024, size);
    REQUIRE(base >= HEAP_BASE);
    CommitMemory(base, size);

    auto mark = markByte(base + size - 8);
    REQUIRE(*mark == 0);
    *mark |= 1 << markBit(base + size - 8);
    REQUIRE(*mark == 0x80);
    *mark = 0;

    FreeMemory(base, size);
}
