/*
    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#ifndef _SYMBOL_HASH_H_
#define _SYMBOL_HASH_H_

#include <cstdint>

#include "HeapObject.h"

namespace Egg {

/**
 * The hash of a symbol, computed from its characters exactly as Symbol>>hash
 * does in Smalltalk, where it is also the symbol's identity hash. `basicSize`
 * is what the receiver answers to #basicSize: its size without the trailing
 * zero for a Symbol, its size in bytes for a WideSymbol.
 *
 * Every symbol must get this hash, however it is created: segments keep
 * hashed collections laid out by the hashes of their symbol keys, and those
 * symbols are interned again in the process that loads the segment.
 */
inline uint16_t symbolHash(const uint8_t *bytes, int64_t basicSize)
{
    int64_t pseudoindex = basicSize - 1;
    if (pseudoindex < 0)
        return 0;
    // a 16-bit signed integer at a byte offset, as CharacterArray>>shortAtOffset:
    auto shortAt = [bytes](int64_t offset) {
        return (int64_t)(int16_t)(bytes[offset] | (bytes[offset + 1] << 8));
    };
    int64_t middle = (pseudoindex & 0xFFFF) / 2;
    int64_t end = middle * 2;
    int64_t first = shortAt(0) + 256 * (pseudoindex & 0xFF);
    int64_t second = shortAt(end);
    int64_t third = shortAt(middle);
    return (uint16_t)((first + (second * 4 + third) * 4) & 0x7FFF);
}

/**
 * The hash of a byte symbol, whose bytes end with a zero.
 */
inline uint16_t symbolHash(HeapObject *symbol)
{
    return symbolHash(reinterpret_cast<const uint8_t*>(symbol), (int64_t)symbol->size() - 1);
}

/**
 * The hash of a wide symbol, which has no trailing zero.
 */
inline uint16_t wideSymbolHash(HeapObject *symbol)
{
    return symbolHash(reinterpret_cast<const uint8_t*>(symbol), (int64_t)symbol->size());
}

} // namespace Egg

#endif // _SYMBOL_HASH_H_
