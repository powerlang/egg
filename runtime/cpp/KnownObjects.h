#ifndef _KNOWNOBJECTS_H_
#define _KNOWNOBJECTS_H_

#include "HeapObject.h"

namespace Egg {

class Runtime;

class KnownObjects {
public:
    static void initializeFrom(Runtime *runtime);

    static HeapObject *nil;
    static HeapObject *_true;
    static HeapObject *_false;
};

} // namespace Egg

#endif // ~ _KNOWNOBJECTS_H_ ~
