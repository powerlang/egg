#ifndef _SOPNONLOCALRETURN_H_
#define _SOPNONLOCALRETURN_H_

#include "SOpReturn.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SOpNonLocalReturn : public SOpReturn {

public:
    void acceptVisitor_(SExpressionVisitor *visitor) override {
        visitor->visitOpNonLocalReturn(this);
    }

};

} // namespace Egg

#endif // ~ _SOPNONLOCALRETURN_H_ ~
