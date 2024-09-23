
/*
    Copyright (c) 2024-2024 Javier Pimás. 
    See (MIT) license in root directory.
 */

#include <windows.h>
#include <cstring>

#include "../Memory.h"
#include "../Egg.h"

using namespace Egg;

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
    if (base == 0) base = 0x100000;

    while (true) {
        // Attempt to allocate at the aligned base
        allocated = VirtualAlloc((void*)base, pagealign(size), MEM_RESERVE, PAGE_READWRITE);
        
        if (allocated != 0) {
            if ((uintptr_t)allocated == base) {
                return (uintptr_t)allocated;
            }

            // Free the memory and try next address
            VirtualFree((void*)allocated);
            base += 0x10000;

        } else {
            base += 0x10000;
        }

        if (base >=  0x100000000) { // We are limiting to the first 4gb for now
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
