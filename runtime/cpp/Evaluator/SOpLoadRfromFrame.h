#ifndef _SOPLOADRFROMFRAME_H_
#define _SOPLOADRFROMFRAME_H_

#include "SOperation.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SOpLoadRfromFrame : public SOperation {
    int _index;

public:
    SOpLoadRfromFrame(auto index) : _index(index) {}
    void acceptVisitor_(SExpressionVisitor *visitor) override {
        visitor->visitOpLoadRfromFrame(this);
    }

};

} // namespace Egg

#endif // ~ _SOPLOADRFROMFRAME_H_ ~
