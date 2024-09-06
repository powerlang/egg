#ifndef _SOPPUSHR_H
#define _SOPPUSHR_H

#include "SOperation.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SOpPushR : public SOperation {
    public:

    void acceptVisitor_(SExpressionVisitor *visitor) {
        visitor->visitOpPushR(this);
    }
};

} // namespace Egg

#endif // ~ _SOPPUSHR_H ~
