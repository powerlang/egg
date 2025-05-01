#ifndef _SLITERAL_H_
#define _SLITERAL_H_

#include "SLiteralVar.h"
#include "SExpressionVisitor.h"
#include "../HeapObject.h"

namespace Egg {

class SLiteral : public SLiteralVar {
    GCedRef _value;
public:
    SLiteral(int64_t index, Object *value) : SLiteralVar(index), _value(value) {}

    void acceptVisitor_(SExpressionVisitor* visitor) {
        return visitor->visitLiteral(this);
    }

    bool isLiteral() const {
        return true;
    }

    Object* value() {
        return _value.get();
    }

    void value_(Object* anObject) {
        _value.set_(anObject);
    }

};

} // namespace Egg

#endif // ~ _SLITERAL_H_ ~
