
/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#include <sys/mman.h>
#include <unistd.h>
#include <cstring>
#include <cerrno>

#include <iostream>

#include "Allocator/Memory.h"
#include "Egg.h"
#include "KnownConstants.h"

using namespace Egg;

uintptr_t HEAP_ADDRESS_BLOCK;

namespace Egg {
    static uintptr_t nextFree = 0;
    static uintptr_t limit = 0;
}

uintptr_t Egg::ReserveHeapBlock() {

    uintptr_t size = HeapBlockSize;
    uintptr_t alignment = HeapBlockSize;
    uintptr_t total_size = size + alignment;
    void* addr = NULL;

    // Reserve memory with an over-allocation to ensure alignment
    void* allocated = mmap(NULL, total_size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (allocated == MAP_FAILED) {
        error("Couldn't reserve memory for future allocations");
        return (uintptr_t)NULL;
    }

    uintptr_t aligned_addr = align((uintptr_t)allocated, size);

    // Unmap the pre and post zones before and after the aligned region
    if (aligned_addr != (uintptr_t)allocated) {
        munmap(allocated, aligned_addr - (uintptr_t)allocated); // Before the aligned address
    }
    uintptr_t limit = aligned_addr + size;
    munmap((void*)limit, (uintptr_t)allocated + alignment + size - limit); // After the aligned region

    return aligned_addr;
}

void Egg::InitializeMemory()
{
    HEAP_ADDRESS_BLOCK = ReserveHeapBlock();

    // the bitmap's first 1/64 would mark the bitmap itself
    auto marks = HEAP_ADDRESS_BLOCK + MarkBitmapSize / 64;
    auto mapped = mmap((void*)marks, MarkBitmapSize - MarkBitmapSize / 64, PROT_READ | PROT_WRITE,
                       MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE | MAP_FIXED, -1, 0);
    if (mapped != (void*)marks)
        error("Couldn't reserve the GC mark bitmap");

    Egg::nextFree = HEAP_BASE;
    Egg::limit = HEAP_ADDRESS_BLOCK + HeapBlockSize;

}

void Egg::aligned_free(void* mem)
{
    std::free(mem);
}

uintptr_t Egg::pagealign(uintptr_t addr)
{
    static int pagesize = -1;
    if (pagesize == -1) {
        pagesize = (int)sysconf(_SC_PAGESIZE);
        ASSERT(pagesize != -1);
    }
    return align(addr, pagesize);
}

uintptr_t Egg::ReserveMemory(uintptr_t baseHint, uintptr_t size)
{
    auto base = (baseHint < Egg::nextFree || baseHint >= Egg::limit) ? Egg::nextFree : baseHint;
    auto end = pagealign(base + size);
    if (end > Egg::limit) {
        error("Memory allocation failed");
        return 0;
    }
    Egg::nextFree = end;
    return base;
}

void Egg::CommitMemory(uintptr_t base, uintptr_t size)
{
    if (mprotect((void*)base, pagealign(size), PROT_READ | PROT_WRITE) != 0) {
        error("Failed to commit memory.");
    }
    std::memset((char*)base, 0, size);
}

void Egg::DecommitMemory(uintptr_t base, uintptr_t size)
{
    // just to guarantee memory is wiped out
    std::memset((char*)base, 0, size);

    // if (madvise((void*)base, size, MADV_DONTNEED) != 0) {
    if (mprotect((void*)base, size, PROT_NONE) != 0) {
        error("Failed to decommit memory.");
    }
}

void Egg::FreeMemory(uintptr_t base, uintptr_t size)
{
    munmap((void*)base, size);
}
