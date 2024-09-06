
#ifndef _SBINDING_H_
#define _SBINDING_H_

#include <iostream>

#include "Runtime.h"
#include "../HeapObject.h"

namespace Egg {

class EvaluationContext;

class SBinding {
protected:
    SBinding() = default;
public:

    virtual void assign_within_(Object *value, EvaluationContext* anEvaluationContext) {
        subclassResponsibility();
    }

    virtual bool isArgument() const {
        return false;
    }

    virtual bool isAssociation() const {
        return false;
    }

    virtual bool isClassBinding() const {
        return false;
    }

    virtual bool isClassVar() const {
        return false;
    }

    virtual bool isDynamic() const {
        return false;
    }

    virtual bool isInstVar() const {
        return false;
    }

    virtual bool isLiteral() const {
        return false;
    }

    virtual bool isPoolVar() const {
        return false;
    }

    virtual bool isSelf() const {
        return false;
    }

    virtual bool isSuper() const {
        return false;
    }

    virtual bool isTemporary() const {
        return false;
    }

    virtual HeapObject* name() const {
        subclassResponsibility();
        return nullptr;
    }

    virtual Object* valueWithin_(EvaluationContext* anEvaluationContext) = 0;

private:
    static void subclassResponsibility() {
        error("Subclass must implement this method.");
    }

    virtual std::string printString() const {
        return "Subclass must implement this printString.";
    }
};

} // namespace Egg

#endif // ~ _SBINDING_H_ ~
