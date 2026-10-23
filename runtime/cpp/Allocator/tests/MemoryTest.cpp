#include <catch2/catch.hpp>

#include "../Memory.h"

#ifndef _WIN32
#include <sys/wait.h>
#include <unistd.h>

using namespace Egg;

TEST_CASE("ReserveMemory fails instead of reserving past the end of the heap block", "[memory]")
{
    auto pid = fork();
    if (pid == 0) {
        ReserveMemory(HEAP_ADDRESS_BLOCK + HeapBlockSize - 64 * 1024, 128 * 1024);
        _exit(0);
    }
    int status;
    waitpid(pid, &status, 0);
    REQUIRE(WIFEXITED(status));
    REQUIRE(WEXITSTATUS(status) == EXIT_FAILURE);
}
#endif
