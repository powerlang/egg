#ifndef _SOPASSIGN_H_
#define _SOPASSIGN_H_

#include <vector>
#include "SOperation.h"

namespace Egg {

class SOpAssign : public SOperation {
    std::vector<SIdentifier*> _assignees;
    public:

    SOpAssign(auto assignees) : _assignees(assignees) {}

    void acceptVisitor_(SExpressionVisitor* visitor) override {
        visitor->visitOpAssign(this);
    }
    std::vector<SIdentifier*>& assignees() { return _assignees; }

};

} // namespace Egg

#endif // ~ _SOPASSIGN_H_ ~
