#ifndef _SOPASSIGN_H_
#define _SOPASSIGN_H_

#include "SOperation.h"

namespace Egg {

class SOpAssign : public SOperation {
    public:

    SOpAssign(auto assignees) : _assignees(assignees) {}

};

} // namespace Egg

#endif // ~ _SOPASSIGN_H_ ~
