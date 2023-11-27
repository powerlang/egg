#ifndef _SMETHOD_H_
#define _SMETHOD_H_

#include "SScript.h"
#include "SExpressionVisitor.h"

namespace Egg {


class SMethod : public SScript {
    SPragma* _pragma;
public:
    SMethod() {
        _pragma = nullptr;
    }

    void acceptVisitor(SExpressionVisitor* visitor) override {
        visitor->visitMethod(this);
    }

    bool isMethod() const override {
        return true;
    }

    int offsetOfCurrentEnvironment() const override {
        return 0;
    }

    int offsetOfEnvironment(int anInteger) const override {
        return 0;
    }

    SPragma* pragma() const {
        return _pragma;
    }

    SMethod* pragma(SPragma* anSPragma) {
        _pragma = anSPragma;
        return this;
    }

    SSymbol* primitive() const {
        return _pragma ? _pragma->name() : nullptr;
    }

};

} // namespace Egg

#endif // ~ _SMETHOD_H_ ~
