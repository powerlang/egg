
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

uintptr_t Egg::LoaderHandle() {
    return (uintptr_t)dlopen("libdl.so.2", RTLD_LAZY);
}

const char* Egg::PlatformName() {
#if defined(__x86_64__)
    #if defined(__linux__)
        return "x86_64-linux-gnu";
    #elif defined(__APPLE__)
        return "x86_64-darwin";
    #elif defined(_WIN32)
        return "x86_64-win32";
    #else
        return "x86_64-unknown";
    #endif
#elif defined(__aarch64__) || defined(_M_ARM64)
    #if defined(__linux__)
    return "aarch64-linux-gnu";
    #elif defined(__APPLE__)
    return "aarch64-darwin";
    #elif defined(_WIN32)
    return "aarch64-win32";
    #else
    return "aarch64-unknown";
    #endif
#elif defined(__riscv) && __riscv_xlen == 64
    return "riscv64-linux-gnu";
#else
    return "unknown-platform";
#endif
}

uintptr_t Egg::SymbolFinder() {
    return (uintptr_t)dlsym;
}
