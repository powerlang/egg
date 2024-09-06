#ifndef _SPRAGMA_H_
#define _SPRAGMA_H_

#include "SExpression.h"

namespace Egg {

class SPragma : public SExpression {
public:
    HeapObject * _name;

    SPragma(HeapObject *name) {
        _name = name;
    }

    void acceptVisitor_(SExpressionVisitor* visitor) override {
        visitor->visitPragma(this);
    }

    HeapObject* name() const {
        return _name;
    }

    void name(HeapObject *name) {
        _name = name;

    }

};

} // namespace Egg

#endif // ~ _SPRAGMA_H_ ~
