
/*
    Copyright (c) 2024-2024 Javier Pimás. 
    See (MIT) license in root directory.
 */

#include <windows.h>
#include <cstring>

#include "Allocator/Memory.h"
#include "Egg.h"
#include "KnownConstants.h"

using namespace Egg;


namespace Egg {
    static uintptr_t nextFree = 0;
    static uintptr_t limit = 0;
}

void Egg::InitializeMemory()
{
    Egg::nextFree = BEHAVIOR_ADDRESS_SPACE;

    // avoid the zero address as mmap would confuse it with "allocate anywhere"
    if (Egg::nextFree == 0)
        Egg::nextFree = 0x100000;

    Egg::limit = BEHAVIOR_ADDRESS_SPACE + (4L * 1024 * 1024 * 1024);  // We are limiting to reserve up to 4gb for now
}


uintptr_t Egg::pagealign(uintptr_t addr)
{
    static int pagesize = -1;

    if (pagesize == -1)
    {
        SYSTEM_INFO si;
	    GetSystemInfo(&si);
        pagesize = si.dwPageSize;
    }
    return align(addr, pagesize);
}

uintptr_t Egg::ReserveMemory(uintptr_t base, uintptr_t size)
{
    void* allocated = nullptr;
    if (base == 0) base = Egg::nextFree;

    while (true) {
        // Attempt to allocate at the aligned base
        allocated = VirtualAlloc((void*)base, pagealign(size), MEM_RESERVE, PAGE_READWRITE);
        
        if (allocated != 0) {
            if ((uintptr_t)allocated == base) {
                Egg::nextFree = pagealign((uintptr_t)allocated + size);
                return (uintptr_t)allocated;
            }

            // Free the memory and try next address
            VirtualFree((void*)allocated, 0, MEM_RELEASE);
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
    if (VirtualAlloc((void*)base, pagealign(size), MEM_COMMIT, PAGE_READWRITE) == 0) {
        error("Failed to commit memory.");
    }
    std::memset((char*)base, 0, size);
}

void Egg::FreeMemory(uintptr_t base, uintptr_t size)
{
    VirtualFree((void*)base, 0, MEM_RELEASE);
}
