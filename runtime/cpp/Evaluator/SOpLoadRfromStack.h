#ifndef _SOPLOADRFROMSTACK_H_
#define _SOPLOADRFROMSTACK_H_

#include "SOperation.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SOpLoadRfromStack : public SOperation {
    int _index;

public:
    SOpLoadRfromStack(auto index) : _index(index) {}
    void acceptVisitor_(SExpressionVisitor *visitor) override {
        visitor->visitOpLoadRfromStack(this);
    }

    int index() const { return _index; }
};

} // namespace Egg

#endif // ~ _SOPLOADRFROMSTACK_H_ ~
