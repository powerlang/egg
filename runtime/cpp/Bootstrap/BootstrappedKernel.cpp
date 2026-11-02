/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "BootstrappedKernel.h"
#include <cstring>

namespace Egg {

BootstrappedKernel::BootstrappedKernel(uintptr_t base, uintptr_t size, uintptr_t objectsEnd)
{
    // Bootstrap objects live directly in memory with no prefixed header,
    // so we offset _currentBase so that spaceStart() returns 'base'.
    _currentBase = base - sizeof(ImageSegmentHeader);
    header.baseAddress = base;
    header.size = objectsEnd - _currentBase;
    header.reservedSize = size + sizeof(ImageSegmentHeader);
    header.module = nullptr;
    header.codeSize = 0;
}

} // namespace Egg
