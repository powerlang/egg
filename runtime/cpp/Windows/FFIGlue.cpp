
/*
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
 */

#include <windows.h>


#include "../FFIGlue.h"
#include "../Egg.h"

using namespace Egg;


uintptr_t Egg::FindSymbol(uintptr_t libHandle, char *symbol)
{
    return (uintptr_t)GetProcAddress((HMODULE)libHandle, symbol);
}

uintptr_t Egg::LoaderHandle() {
    return (uintptr_t)LoadLibrary("Kernel32.dll");
}

const char* Egg::PlatformName() {
#if defined(_M_X64)
    return "x86_64-win32";
#else
    #error unsupported platform
#endif
}

uintptr_t Egg::SymbolFinder() {
    return (uintptr_t)GetProcAddress;
}
