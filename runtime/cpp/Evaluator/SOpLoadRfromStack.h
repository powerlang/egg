#ifndef _SOPLOADRFROMSTACK_H_
#define _SOPLOADRFROMSTACK_H_

#include "SOperation.h"

namespace Egg {

class SOpLoadRfromStack : public SOperation {
    int _index;
    public:

    SOpLoadRfromStack(auto index) : _index(index) {}

};

} // namespace Egg

#endif // ~ _SOPLOADRFROMSTACK_H_ ~
