
/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#include <sys/mman.h>
#include <unistd.h>
#include <cstring>
#include <cerrno>

#include <iostream>

#include "../Memory.h"
#include "../Egg.h"
#include "../KnownConstants.h"

using namespace Egg;

#ifdef __APPLE__
uintptr_t BEHAVIOR_ADDRESS_SPACE; // in mac OS, this address can vary. Elsewhere it is a constant optimized away
#define EGG_NOREPLACE 0
#else
#define EGG_NOREPLACE MAP_FIXED_NOREPLACE
#endif

namespace Egg {
    static uintptr_t nextFree = 0;
    static uintptr_t limit = 0;
}

uintptr_t Egg::ReserveAligned4GB() {
    uintptr_t size = 4L * 1024 * 1024 * 1024; // 4GB
    uintptr_t alignment = 4L * 1024 * 1024 * 1024; // 4GB alignment
    uintptr_t total_size = size + alignment;
    void* addr = NULL;

    // Reserve memory with an over-allocation to ensure alignment
    void* allocated = mmap(NULL, total_size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (allocated == MAP_FAILED) {
        error("Couldn't reserve memory for future allocations");
        return (uintptr_t)NULL;
    }

    uintptr_t aligned_addr = align((uintptr_t)allocated, size);

    // Unmap the pre and post zones before and after the aligned region
    if (aligned_addr != (uintptr_t)allocated) {
        munmap(allocated, aligned_addr - (uintptr_t)allocated); // Before the aligned address
    }
    uintptr_t limit = aligned_addr + size;
    munmap((void*)limit, (uintptr_t)allocated + alignment + size - limit); // After the aligned region

    return aligned_addr;
}

void Egg::InitializeMemory()
{
#ifdef __APPLE__
    BEHAVIOR_ADDRESS_SPACE = ReserveAligned4GB();
#endif

    Egg::nextFree = BEHAVIOR_ADDRESS_SPACE;

    // avoid the zero address as mmap would confuse it with "allocate anywhere"
    if (Egg::nextFree == 0)
        Egg::nextFree = 0x100000;

    Egg::limit = BEHAVIOR_ADDRESS_SPACE + (4L * 1024 * 1024 * 1024); // We are limiting to reserve up to 4gb for now

}

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
    if (base == 0) base = Egg::nextFree;

    while (true) {
        // Attempt to allocate at the aligned base
        allocated = mmap(reinterpret_cast<void*>(base), pagealign(size), PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | EGG_NOREPLACE, -1, 0);
        if (allocated != MAP_FAILED) {
            // Check if the allocated memory is at the desired base address
            if ((uintptr_t)allocated == base) {
               Egg::nextFree = pagealign((uintptr_t)allocated + size);
                return (uintptr_t)allocated;
            }

            // Free the memory and try next address
            munmap((void*)allocated, size);
            base += 0x10000;

        } else {
            base += 0x10000;
        }

        if (base >= Egg::limit) {
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
