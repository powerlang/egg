#ifndef _SLITERAL_H_
#define _SLITERAL_H_

#include "SLiteralVar.h"
#include "SExpressionVisitor.h"
#include "../HeapObject.h"

namespace Egg {

class SLiteral : public SLiteralVar {
    HeapObject *_value;
public:
    SLiteral(int64_t index, HeapObject *value) : SLiteralVar(index), _value(value) {}

    void acceptVisitor(SExpressionVisitor* visitor) {
        return visitor->visitLiteral(this);
    }

    bool isLiteral() const {
        return true;
    }

    HeapObject* value() const {
        return _value;
    }

    void value_(HeapObject* anObject) {
        _value = anObject;
    }

};

} // namespace Egg

#endif // ~ _SLITERAL_H_ ~
