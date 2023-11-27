#ifndef _SCASCADE_H_
#define _SCASCADE_H_

#include "SExpression.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SCascadeMessage;

class SCascade : public SExpression {
    SExpression* _receiver;
    std::vector<SCascadeMessage*> _messages;

public:
    SCascade() {
        _receiver = nullptr;
        _messages = {};
    }

    void acceptVisitor(SExpressionVisitor* visitor) override {
        visitor->visitCascade(this);
    }

    bool isCascade() const override {
        return true;
    }

    const std::vector<SCascadeMessage*>& messages() const {
        return _messages;
    }

    SCascade* messages(const std::vector<SCascadeMessage*>& aCollection) {
        _messages = aCollection;
        return this;
    }

    SExpression* receiver() const {
        return _receiver;
    }

    SCascade* receiver(SExpression* anSExpression) {
        _receiver = anSExpression;
        return this;
    }

};

} // namespace Egg

#endif // ~ _SCASCADE_H_ ~
