/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware.
    See (MIT) license in root directory.
 */

#ifndef _SMALL_INTEGER_H_
#define _SMALL_INTEGER_H_

#include "Util.h"

#include <string>

namespace Egg {

struct Object;
/**
 * Class `SmallInteger` represents an immediate small integer, encoded
 * in a pointer. It is signed and tagged with 1 in its least significant
 * bit. It is always held as a pointer.
 */
struct SmallInteger {
    static const intptr_t SMALLINT_MIN = INTPTR_MIN >> 1;
    static const intptr_t SMALLINT_MAX = INTPTR_MAX >> 1;

    operator Object *() /// just a cast
    {
        return (Object *)(void *)this;
    }

    static SmallInteger *
    from(intptr_t intVal) /// makes a tagged SmallInteger from a native value
    {
        ASSERT(SMALLINT_MIN <= intVal && intVal <= SMALLINT_MAX);

        return (SmallInteger *)(((uintptr_t)intVal << 1) | 1);
    }

    bool isSmallInteger();

    intptr_t asNative(); /// Assuming `this` encodes a SmallInteger, decode its
                         /// (signed) integer value

    template <typename T = void *>
    T asObject() /// Assuming `this` encodes a pointer stored as a SmallInteger,
                 /// return the address of the original pointer
    {
        // ASSERT(this->object()->isSmallInteger());

        return (T)((intptr_t)this & (intptr_t)~1);
    }

    // debugging
    std::string printString(){ return std::to_string(this->asNative()); }
};

} // namespace Egg

#endif /* _SMALL_INTEGER_H_ */
