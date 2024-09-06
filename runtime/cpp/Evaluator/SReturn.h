#ifndef _SRETURN_H_
#define _SRETURN_H_

#include "SExpression.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SReturn : public SExpression {
    bool _local;
    SExpression* _expression;

public:
    SReturn(bool local, SExpression* anSExpression) : _local(local), _expression(anSExpression) { }

    void acceptVisitor_(SExpressionVisitor* visitor) override {
        visitor->visitReturn(this);
    }

    SExpression* expression() const {
        return _expression;
    }

    SReturn* expression(SExpression* anSExpression) {
        _expression = anSExpression;
        return this;
    }

    bool isReturn() const override {
        return true;
    }

    bool local() const {
        return _local;
    }

    SReturn* local(bool aBoolean) {
        _local = aBoolean;
        return this;
    }
};

} // namespace Egg

#endif // ~ _SRETURN_H_ ~
