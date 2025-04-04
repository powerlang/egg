
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

    static uintptr_t allocation_alignment = 0;
    static uintptr_t page_alignment = 0;

    uintptr_t allocalign(uintptr_t addr);
}

void Egg::InitializeMemory()
{
    SYSTEM_INFO si;
    GetSystemInfo(&si);
    Egg::page_alignment = si.dwPageSize;
    Egg::allocation_alignment = si.dwAllocationGranularity;
    
    Egg::nextFree = BEHAVIOR_ADDRESS_SPACE;

    // avoid the zero address as mmap would confuse it with "allocate anywhere"
    if (Egg::nextFree == 0)
        Egg::nextFree = 0x100000;

    Egg::limit = BEHAVIOR_ADDRESS_SPACE + (4LL * 1024 * 1024 * 1024);  // We are limiting to reserve up to 4gb for now
}


void Egg::aligned_free(void* mem)
{
    _aligned_free(mem);
}

uintptr_t Egg::pagealign(uintptr_t addr)
{
    return align(addr, Egg::page_alignment);
}

uintptr_t Egg::allocalign(uintptr_t addr)
{
    return align(addr, Egg::allocation_alignment);
}

uintptr_t Egg::ReserveMemory(uintptr_t base, uintptr_t size)
{
    void* allocated = nullptr;
    if (base == 0) base = Egg::nextFree;

    while (base < Egg::limit) {
        // Attempt to allocate at the aligned base
        allocated = VirtualAlloc((void*)base, pagealign(size), MEM_RESERVE, PAGE_READWRITE);
        
        if (allocated != 0) {
            if ((uintptr_t)allocated == base) {
                Egg::nextFree = allocalign((uintptr_t)allocated + size);
                return (uintptr_t)allocated;
            }

            // Free the memory and try next address
            VirtualFree((void*)allocated, 0, MEM_RELEASE);
        }
        
        base += Egg::allocation_alignment;
    }

    error("Memory allocation failed");
    return 0;
}

void Egg::CommitMemory(uintptr_t base, uintptr_t size)
{
    if (VirtualAlloc((void*)base, pagealign(size), MEM_COMMIT, PAGE_READWRITE) == 0) {
        error("Failed to commit memory.");
    }
    std::memset((char*)base, 0, size);
}

void Egg::DecommitMemory(uintptr_t base, uintptr_t size)
{
    if (!VirtualFree((void*)base, size, MEM_DECOMMIT)) {
        error("Failed to decommit memory.");
    }
}

void Egg::FreeMemory(uintptr_t base, uintptr_t size)
{
    VirtualFree((void*)base, 0, MEM_RELEASE);
}
