
/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#include "SmallInteger.h"
#include "Object.h"
#include "Util.h"

using namespace Egg;

bool SmallInteger::isSmallInteger()
{
    return ((Object *)this)->isSmallInteger();
}

intptr_t SmallInteger::asNative()
{
    ASSERT(this->isSmallInteger());

    return (intptr_t)this >> 1;
}
