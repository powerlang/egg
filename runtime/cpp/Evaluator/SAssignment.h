#ifndef _SASSIGNMENT_H_
#define _SASSIGNMENT_H_

#include <vector>

#include "SExpression.h"
#include "SExpressionVisitor.h"
#include "SIdentifier.h"

namespace Egg {

class SAssignment : public SExpression {
    std::vector<SIdentifier*> _assignees;
    SExpression *_expression;
public:
    SAssignment(SExpression *expression) : _expression(expression) { }

    void acceptVisitor_(SExpressionVisitor* visitor) override {
        visitor->visitAssignment(this);
    }

    SAssignment* assign(SIdentifier* anSIdentifier) {
        _assignees.push_back(anSIdentifier);
        return this;
    }

    const std::vector<SIdentifier*>& assignees() const {
        return _assignees;
    }

    SExpression* expression() const {
        return _expression;
    }

    SAssignment* expression(SExpression* anSExpression) {
        _expression = anSExpression;
        return this;
    }

    bool isAssignment() const override {
        return true;
    }

};

} // namespace Egg

#endif // ~ _SASSIGNMENT_H_ ~
