
#ifndef _SEXPRESSION_H_
#define _SEXPRESSION_H_

#include <iostream>

#include "PowertalkRuntime.h"

namespace Egg {

class SExpressionVisitor;

class SExpression {
public:
    virtual void acceptVisitor(SExpressionVisitor* visitor) {
        subclassResponsibility();
    }

    virtual bool isAssignment() const {
        return false;
    }

    virtual bool isBlock() const {
        return false;
    }

    virtual bool isCascade() const {
        return false;
    }

    virtual bool isCascadeMessage() const {
        return false;
    }

    virtual bool isIdentifier() const {
        return false;
    }

    virtual bool isInstVar() const {
        return false;
    }

    virtual bool isLiteral() const {
        return false;
    }

    virtual bool isMessage() const {
        return false;
    }

    virtual bool isMethod() const {
        return false;
    }

    virtual bool isReturn() const {
        return false;
    }

    virtual bool isSuper() const {
        return false;
    }

protected:
    void subclassResponsibility() {
        // Implement the behavior or throw an exception as needed
    }
};

} // namespace Egg

#endif // ~ _SEXPRESSION_H_ ~
