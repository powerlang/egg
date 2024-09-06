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

    void acceptVisitor_(SExpressionVisitor* visitor) override {
        visitor->visitMethod(this);
    }

    bool isMethod() const override {
        return true;
    }

    int offsetOfCurrentEnvironment() const {
        return 0;
    }

    int offsetOfEnvironment(int anInteger) const {
        return 0;
    }

    SPragma* pragma() const {
        return _pragma;
    }

    void pragma_(SPragma* anSPragma) {
        _pragma = anSPragma;
    }

    HeapObject* primitive() const;

};

} // namespace Egg

#endif // ~ _SMETHOD_H_ ~
