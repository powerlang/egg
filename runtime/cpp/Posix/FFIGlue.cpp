
/*
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
 */

#include <dlfcn.h>


#include "../FFIGlue.h"
#include "../Egg.h"

using namespace Egg;


uintptr_t Egg::FindSymbol(uintptr_t libHandle, char *symbol)
{
    return (uintptr_t)dlsym((void*)libHandle, symbol);
}
