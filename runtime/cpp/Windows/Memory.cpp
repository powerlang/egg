
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

uintptr_t HEAP_ADDRESS_BLOCK;

namespace Egg {
    static uintptr_t nextFree = 0;
    static uintptr_t limit = 0;

    static uintptr_t allocation_alignment = 0;
    static uintptr_t page_alignment = 0;

    uintptr_t allocalign(uintptr_t addr);
}

// Windows releases only whole reservations, so the probe can't be trimmed to the aligned block:
// it is released and the block reserved again, which something else may take in between
uintptr_t Egg::ReserveHeapBlock()
{
    uintptr_t size = HeapBlockSize;
    for (int attempt = 0; attempt < 8; attempt++) {
        auto probe = VirtualAlloc(nullptr, size * 2, MEM_RESERVE, PAGE_NOACCESS);
        if (probe == nullptr)
            break;
        auto aligned = align((uintptr_t)probe, size);
        if (!VirtualFree(probe, 0, MEM_RELEASE))
            break;
        if (VirtualAlloc((void*)aligned, size, MEM_RESERVE, PAGE_READWRITE) == (void*)aligned)
            return aligned;
    }
    error("Couldn't reserve a 4GB block for the heap");
    return 0;
}

void Egg::InitializeMemory()
{
    SYSTEM_INFO si;
    GetSystemInfo(&si);
    Egg::page_alignment = si.dwPageSize;
    Egg::allocation_alignment = si.dwAllocationGranularity;

    HEAP_ADDRESS_BLOCK = ReserveHeapBlock();

    Egg::nextFree = HEAP_BASE;
    Egg::limit = HEAP_ADDRESS_BLOCK + HeapBlockSize;
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

// The block is reserved as a whole, so this only hands out its addresses, which CommitMemory backs
uintptr_t Egg::ReserveMemory(uintptr_t baseHint, uintptr_t size)
{
    auto base = (baseHint < Egg::nextFree || baseHint >= Egg::limit) ? Egg::nextFree : allocalign(baseHint);
    auto end = allocalign(base + size);
    if (end > Egg::limit) {
        error("Memory allocation failed");
        return 0;
    }
    Egg::nextFree = end;
    return base;
}

void Egg::CommitMemory(uintptr_t base, uintptr_t size)
{
    if (VirtualAlloc((void*)base, pagealign(size), MEM_COMMIT, PAGE_READWRITE) == 0) {
        error("Failed to commit memory.");
    }
    std::memset((char*)base, 0, size);

    // the marks of what gets committed: Windows doesn't back reserved pages on first use as mmap does
    auto first = (HEAP_ADDRESS_BLOCK + ((base - HEAP_ADDRESS_BLOCK) >> 6)) & ~(Egg::page_alignment - 1);
    auto last = pagealign(HEAP_ADDRESS_BLOCK + ((base + size - HEAP_ADDRESS_BLOCK + 63) >> 6));
    if (VirtualAlloc((void*)first, last - first, MEM_COMMIT, PAGE_READWRITE) == 0)
        error("Failed to commit GC marks.");
}

void Egg::DecommitMemory(uintptr_t base, uintptr_t size)
{
    if (!VirtualFree((void*)base, size, MEM_DECOMMIT)) {
        error("Failed to decommit memory.");
    }
}

void Egg::FreeMemory(uintptr_t base, uintptr_t size)
{
    // a part of the block can't be released, only decommitted
    if (!VirtualFree((void*)base, size, MEM_DECOMMIT))
        error("Failed to free memory.");
}
