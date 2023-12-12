
#ifndef _UTIL_H_
#define _UTIL_H_

#include <cstdint>
#include <cassert>

#ifndef ASSERT
#define ASSERT assert
#endif

namespace Egg
{

static inline uintptr_t
align(uintptr_t value, int alignment)
{
    return ((value + (alignment - 1)) & ~(alignment - 1));
}

} // namespace Egg

#endif // _UTIL_H_
