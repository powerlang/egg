/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#ifndef _MEMORY_H_
#define _MEMORY_H_

#include <cstdint>
#include "Util.h"

namespace Egg
{

void     InitializeMemory();
uintptr_t ReserveMemory(uintptr_t base, uintptr_t size);
void     CommitMemory(uintptr_t base, uintptr_t size);
void     FreeMemory(uintptr_t base, uintptr_t size);


uintptr_t ReserveAligned4GB();
uintptr_t pagealign(uintptr_t addr);

class HeapObject;

} // namespace Egg

#endif // _MEMORY_H_
