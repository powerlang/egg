/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#ifndef _MEMORY_H_
#define _MEMORY_H_

#include <unistd.h>
#include <cstdint>
#include "Util.h"

namespace Egg
{

uintptr_t ReserveMemory(uintptr_t base, uintptr_t size);
void     CommitMemory(uintptr_t base, uintptr_t size);
void     FreeMemory(uintptr_t base, uintptr_t size);

static inline uintptr_t
pagealign(uintptr_t addr)
{
    static int pagesize = -1;
    if (pagesize == -1) {
        pagesize = (int)sysconf(_SC_PAGESIZE);
        ASSERT(pagesize != -1);
    }
    return align(addr, pagesize);
}

class HeapObject;

} // namespace Egg

#endif // _MEMORY_H_
