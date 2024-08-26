#ifndef _SOPPRIMITIVE_H_
#define _SOPPRIMITIVE_H_

#include "SOperation.h"
#include "SExpressionVisitor.h"

namespace Egg {

class Evaluator;

class SOpPrimitive : public SOperation {
    using PrimitivePointer = Object* (Evaluator::*)();
    PrimitivePointer _primitive;

    public:
    SOpPrimitive(PrimitivePointer primitive) : _primitive(primitive) {}

    void acceptVisitor_(SExpressionVisitor *visitor) {
        visitor->visitOpPrimitive(this);
    }
};

} // namespace Egg

#endif // ~ _SOPPRIMITIVE_H_ ~
