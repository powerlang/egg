#include <catch2/catch.hpp>

#include <cstdint>
#include <cstring>
#include <vector>

#include "CodeInstaller.h"
#include "Allocator/Memory.h"

namespace {
// code answering a small integer n in the result register, then returning
#if defined(__aarch64__)
std::vector<uint8_t> answering(uint8_t n)
{
    uint32_t mov = 0xD2800000 | (uint32_t(n) << 5);
    uint32_t ret = 0xD65F03C0;
    std::vector<uint8_t> bytes(8);
    std::memcpy(bytes.data(), &mov, 4);
    std::memcpy(bytes.data() + 4, &ret, 4);
    return bytes;
}
#elif defined(__x86_64__)
std::vector<uint8_t> answering(uint8_t n) { return {0xB8, n, 0, 0, 0, 0xC3}; }
#endif

using Entry = uint64_t (*)();
}

TEST_CASE("code installed in a read-execute space runs, also when replaced", "[install]")
{
    auto pageSize = Egg::pagealign(1);
    auto space = Egg::ReserveMemory(0, pageSize);
    Egg::CommitMemory(space, pageSize);
    Egg::MakeExecutable(space, pageSize);

    auto first = answering(7);
    lmrInstallCode((void*)space, first.data(), first.size());
    REQUIRE(((Entry)space)() == 7);

    auto second = answering(9);
    lmrInstallCode((void*)space, second.data(), second.size());
    REQUIRE(((Entry)space)() == 9);

    Egg::FreeMemory(space, pageSize);
}
