
#ifndef _SEXPRESSION_H_
#define _SEXPRESSION_H_

#include <iostream>

#include "Runtime.h"

namespace Egg {

class SExpressionVisitor;

class SExpression {
public:
    virtual void acceptVisitor_(SExpressionVisitor* visitor) = 0;

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

    virtual bool isSelf() const {
        return false;
    }

    virtual bool isSelfOrSuper() const {
        return false;
    }

    virtual bool isSuper() const {
        return false;
    }

protected:
    void subclassResponsibility() {
       error("Subclass responsibility");
    }
};

} // namespace Egg

#endif // ~ _SEXPRESSION_H_ ~
