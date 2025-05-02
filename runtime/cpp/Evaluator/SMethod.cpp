
#include "SMethod.h"
#include "SPragma.h"

using namespace Egg;

const Object* SMethod::primitive() const {
    return _pragma ? _pragma->name() : nullptr;
}
