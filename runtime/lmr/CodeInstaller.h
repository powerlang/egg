/*
    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
 */
#ifndef LMR_CODE_INSTALLER_H
#define LMR_CODE_INSTALLER_H

#include <cstddef>

extern "C" {

/**
 * Copies size bytes of code nativized in a writable buffer to destination, in a
 * code space that is read-execute. Its pages are writable only while copying,
 * so no Smalltalk code may run from them meanwhile.
 */
void lmrInstallCode(void* destination, const void* source, size_t size);

}

#endif // LMR_CODE_INSTALLER_H
