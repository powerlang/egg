#ifndef _SOPLOADRWITHSELF_H_
#define _SOPLOADRWITHSELF_H_

#include "SOperation.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SOpLoadRwithSelf : public SOperation {

public:
    void acceptVisitor_(SExpressionVisitor *visitor) override {
        visitor->visitOpLoadRwithSelf(this);
    }

};

} // namespace Egg

#endif // ~ _SOPLOADRWITHSELF_H_ ~
