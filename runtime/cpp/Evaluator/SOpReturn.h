#ifndef _SOPRETURN_H_
#define _SOPRETURN_H_

#include "SOperation.h"

namespace Egg {

class SOpReturn : public SOperation {

public:
    void acceptVisitor_(SExpressionVisitor *visitor) override {
        visitor->visitOpReturn(this);
    }

};

} // namespace Egg

#endif // ~ _SOPRETURN_H_ ~
