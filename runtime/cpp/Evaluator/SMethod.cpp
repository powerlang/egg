
#include "SMethod.h"
#include "SPragma.h"

using namespace Egg;

HeapObject* SMethod::primitive() const {
    return _pragma ? _pragma->name() : nullptr;
}
