#ifndef _SPRAGMA_H_
#define _SPRAGMA_H_

#include "SExpression.h"

namespace Egg {

class SPragma : public SExpression {
public:
    GCedRef _name;

    SPragma(Object *name) : _name(name) {}

    void acceptVisitor_(SExpressionVisitor* visitor) override {
        visitor->visitPragma(this);
    }

    const Object* name() const {
        return _name.get();
    }

    void name(Object *name) {
        _name.set_(name);

    }

};

} // namespace Egg

#endif // ~ _SPRAGMA_H_ ~
