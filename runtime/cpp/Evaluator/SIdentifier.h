#ifndef _SIDENTIFIER_H_
#define _SIDENTIFIER_H_

#include "SExpression.h"
#include "SExpressionVisitor.h"
#include "SBinding.h"

namespace Egg {

class SIdentifier : public SExpression {
public:
    SBinding* _binding;

    SIdentifier(SBinding* aBinding) : _binding(aBinding) { }

    void acceptVisitor_(SExpressionVisitor* visitor) override {
        visitor->visitIdentifier(this);
    }

    SBinding* binding() const {
        return _binding;
    }

    SIdentifier* binding(SBinding* aBinding) {
        _binding = aBinding;
        return this;
    }

    bool isArgument() const {
        return _binding->isArgument();
    }

    bool isAssociation() const {
        return _binding->isAssociation();
    }

    bool isIdentifier() const override {
        return true;
    }

    bool isInstVar() const override {
        return _binding->isInstVar();
    }

    bool isLiteral() const override {
        return _binding->isLiteral();
    }

    bool isSelf() const override {
        return _binding->isSelf();
    }

    bool isSelfOrSuper() const override {
        return _binding->isSelf() || _binding->isSuper();
    }

    bool isSuper() const override {
        return _binding->isSuper();
    }

    bool isTemporary() const {
        return _binding->isTemporary();
    }

};

} // namespace Egg

#endif // ~ _SIDENTIFIER_H_ ~
