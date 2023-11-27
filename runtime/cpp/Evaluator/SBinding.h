
#ifndef _SBINDING_H_
#define _SBINDING_H_

#include <iostream>

#include "PowertalkRuntime.h"
#include "../HeapObject.h"

namespace Egg {

class EvaluationContext;

class SBinding {
public:

    virtual void assign_within(int value, PowertalkRuntime* aPowertalkRuntime) {
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

    virtual std::string name() const {
        return printString();
    }

    virtual HeapObject* valueWithin(EvaluationContext* anEvaluationContext) const {
        subclassResponsibility();
        return null;
    }

private:
    static void subclassResponsibility() {
        std::cerr << "Subclass must implement this method." << std::endl;
        std::terminate();
    }

    virtual std::string printString() const {
        return "Subclass must implement this method.";
    }
};

} // namespace Egg

#endif // ~ _SBINDING_H_ ~
