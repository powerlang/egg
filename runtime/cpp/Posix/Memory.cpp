
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

uintptr_t Egg::pagealign(uintptr_t addr)
{
    static int pagesize = -1;
    if (pagesize == -1) {
        pagesize = (int)sysconf(_SC_PAGESIZE);
        ASSERT(pagesize != -1);
    }
    return align(addr, pagesize);
}

uintptr_t Egg::ReserveMemory(uintptr_t base, uintptr_t size)
{
    void* allocated = nullptr;
    if (base == 0) base = BEHAVIOR_ADDRESS_SPACE | 0x100000;

    while (true) {
        // Attempt to allocate at the aligned base
        allocated = mmap(reinterpret_cast<void*>(base), pagealign(size), PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
        if (allocated != MAP_FAILED) {
            // Check if the allocated memory is at the desired base address
            if ((uintptr_t)allocated == base) {
                return (uintptr_t)allocated;
            }

            // Free the memory and try next address
            munmap((void*)allocated, size);
            base += 0x10000;

        } else {
            base += 0x10000;
        }

        if (base >= BEHAVIOR_ADDRESS_SPACE + 0x100000000) { // We are limiting to reserve up to 4gb for now
            error("Memory allocation failed");
            return 0;
        }
    }
}

void Egg::CommitMemory(uintptr_t base, uintptr_t size)
{
    if (mprotect((void*)base, pagealign(size), PROT_READ | PROT_WRITE) != 0) {
        error("Failed to commit memory.");
    }
    std::memset((char*)base, 0, size);
}

void Egg::FreeMemory(uintptr_t base, uintptr_t size)
{
    munmap((void*)base, size);
}
