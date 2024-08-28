
/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#include <sys/mman.h>
#include <unistd.h>
#include <cstring>

#include "../Memory.h"
#include "../Egg.h"

using namespace Egg;

uintptr_t Egg::ReserveMemory(uintptr_t base, uintptr_t size)
{
    return (uintptr_t)mmap(reinterpret_cast<void*>(base),
                    pagealign(size),
                    PROT_NONE,
                    MAP_PRIVATE | MAP_ANONYMOUS,
                    -1,
                    0);
}

void Egg::CommitMemory(uintptr_t base, uintptr_t size)
{
    if (mprotect((void*)base, size, PROT_READ | PROT_WRITE) != 0) {
        error("Failed to commit memory.");
    }
    std::memset((char*)base, 0, size);
}

void Egg::FreeMemory(uintptr_t base, uintptr_t size)
{
    munmap((void*)base, size);
}
