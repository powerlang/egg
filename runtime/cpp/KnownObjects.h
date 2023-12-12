#ifndef _KNOWNOBJECTS_H_
#define _KNOWNOBJECTS_H_

#include "HeapObject.h"

namespace Egg {

class KnownObjects {
public:
    static HeapObject *nil;
    static HeapObject *_true;
    static HeapObject *_false;
};

} // namespace Egg

#endif // ~ _KNOWNOBJECTS_H_ ~
