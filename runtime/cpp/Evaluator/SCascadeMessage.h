#ifndef _SCASCADEMESSAGE_H_
#define _SCASCADEMESSAGE_H_

#include <vector>
#include "SAbstractMessage.h"
#include "SExpressionVisitor.h"
#include "../HeapObject.h"

namespace Egg {

class SCascadeMessage : public SAbstractMessage {
    SCascade* _cascade;

public:
    SCascadeMessage(HeapObject *selector, const std::vector<SExpression*>& arguments, SCascade *cascade) :
        SAbstractMessage(selector, arguments), _cascade(cascade)
        { }

    void acceptVisitor_(SExpressionVisitor* visitor) override {
        visitor->visitCascadeMessage(this);
    }

    SCascade* cascade() const {
        return _cascade;
    }

    SCascadeMessage* cascade(SCascade* anSCascade) {
        _cascade = anSCascade;
        return this;
    }

    bool isCascadeMessage() const override {
        return true;
    }

    SExpression* receiver() const {
        return _cascade ? _cascade->receiver() : nullptr;
    }

};

} // namespace Egg

#endif // ~ _SCASCADEMESSAGE_H_ ~
