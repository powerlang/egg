#ifndef _SOPDROPTOS_H_
#define _SOPDROPTOS_H_

#include "SOperation.h"

namespace Egg {

class SOpDropToS : public SOperation {
    public:

    SOpDropToS(auto assignees) : _assignees(assignees) {}

};

} // namespace Egg

#endif // ~ _SOPDROPTOS_H_ ~
