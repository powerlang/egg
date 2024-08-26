#ifndef _SOPLOADRWITHNIL_H_
#define _SOPLOADRWITHNIL_H_

#include "SOperation.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SOpLoadRwithNil : public SOperation {

public:
    void acceptVisitor_(SExpressionVisitor *visitor) override {
        visitor->visitOpLoadRwithNil(this);
    }

};

} // namespace Egg

#endif // ~ _SOPLOADRWITHNIL_H_ ~
