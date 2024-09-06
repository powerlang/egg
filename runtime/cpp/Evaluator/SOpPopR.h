#ifndef _SOPPOPR_H_
#define _SOPPOPR_H_

#include "SOperation.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SOpPopR : public SOperation {
    public:

    void acceptVisitor_(SExpressionVisitor *visitor) {
        visitor->visitOpPopR(this);
    }
};

} // namespace Egg

#endif // ~ _SOPPOPR_H_ ~
