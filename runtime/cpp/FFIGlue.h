/*
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
 */

#ifndef _FFIGLUE_H_
#define _FFIGLUE_H_

#include <cstdint>
#include <ffi.h>

namespace Egg
{
struct FFIDescriptorImpl {
    ffi_cif *cif;
    ffi_type **argTypes;
    void(*fnAddr)();
};

uintptr_t FindSymbol(uintptr_t libHandle, char *symbol);
uintptr_t LoaderHandle();
uintptr_t SymbolFinder();

const char* PlatformName();

} // namespace Egg

#endif // _FFIGLUE_H_
