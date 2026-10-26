/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#ifndef _MEMORY_H_
#define _MEMORY_H_

#include <cstdint>
#include "Util.h"
#include "Egg.h"

// The 4GB-aligned block the heap is allocated in. Behaviors are in it too, so headers keep only their low 32 bits
extern uintptr_t HEAP_ADDRESS_BLOCK;
#define BEHAVIOR_ADDRESS_BLOCK HEAP_ADDRESS_BLOCK

namespace Egg
{

// The size, and alignment, of HEAP_ADDRESS_BLOCK
constexpr uintptr_t HeapBlockSize = 4ULL * 1024 * 1024 * 1024;

// The GC marks of an object at address a are bits at the start of its chunk:
// bit (a >> 3) & 7 of byte (a & ~(MarkChunkSize - 1)) + ((a & (MarkChunkSize - 1)) >> 6)
constexpr uintptr_t MarkChunkSize = HeapBlockSize;
constexpr uintptr_t MarkBitmapSize = MarkChunkSize / 64;

#define HEAP_BASE (HEAP_ADDRESS_BLOCK + Egg::MarkBitmapSize)

void     InitializeMemory();
uintptr_t ReserveMemory(uintptr_t baseHint, uintptr_t size);
void     CommitMemory(uintptr_t base, uintptr_t size);
void     DecommitMemory(uintptr_t base, uintptr_t size);
void     FreeMemory(uintptr_t base, uintptr_t size);


uintptr_t ReserveHeapBlock();
uintptr_t pagealign(uintptr_t addr);

template<typename T>
T* aligned_alloc()
{
#ifdef _WIN32
    return static_cast<T*>(_aligned_malloc(sizeof(T), sizeof(void*)));
#else
    return static_cast<T*>(std::aligned_alloc(sizeof(void*), sizeof(T)));
#endif
}

void aligned_free(void* mem);


class HeapObject;

} // namespace Egg

#endif // _MEMORY_H_
