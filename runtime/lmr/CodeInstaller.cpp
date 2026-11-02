/*
    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
 */
#include "CodeInstaller.h"

#include <cstdint>
#include <cstring>

#include "Allocator/Memory.h"

// flipping protections is enough while LMR runs one thread; more need a doubly mapped zone
extern "C" void lmrInstallCode(void* destination, const void* source, size_t size)
{
    auto page = Egg::pagealign(1);
    auto start = Egg::pagealign((uintptr_t)destination + 1) - page;
    auto end = Egg::pagealign((uintptr_t)destination + size);
    Egg::MakeWritable(start, end - start);
    std::memcpy(destination, source, size);
    Egg::MakeExecutable(start, end - start);
}
