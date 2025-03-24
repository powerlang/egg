#ifndef _PLATFORM_CODE_H_
#define _PLATFORM_CODE_H_

#include <vector>
#include <cstdlib>

/**
* A simple typedef for wrapping a buffer that can be used as a heap object,
* by encoding it as a tagged small integer.
*/

namespace Egg {
    class SExpression;

    typedef std::vector<SExpression*> PlatformCode;
    PlatformCode *newPlatformCode();
    void deletePlatformCode(PlatformCode *platformCode);

} // namespace Egg

#endif // ~ _PLATFORM_CODE ~
