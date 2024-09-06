
#include "KnownObjects.h"
#include "Evaluator/Runtime.h"

namespace Egg {

HeapObject* KnownObjects::nil = 0;
HeapObject* KnownObjects::_true = 0;
HeapObject* KnownObjects::_false = 0;

void KnownObjects::initializeFrom(Runtime *runtime)
{
    nil = runtime->_nilObj;
    _true = runtime->_trueObj;
    _false = runtime->_falseObj;
}

} // namespace Egg
