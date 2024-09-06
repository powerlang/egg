#ifndef _SMESSAGE_H_
#define _SMESSAGE_H_

#include <vector>

#include "SAbstractMessage.h"
#include "SExpressionVisitor.h"

namespace Egg {

class SMessage : public SAbstractMessage {
    SExpression *_receiver;
    bool _inlined;

    public:
    SMessage(SExpression *receiver, HeapObject *selector, const std::vector<SExpression*>& arguments, bool inlined) :
        SAbstractMessage(selector, arguments), _receiver(receiver), _inlined(inlined)
        { }

    void acceptVisitor_(SExpressionVisitor* visitor) override {
        visitor->visitMessage(this);
    }

    bool isInlined() const { return _inlined; }
    SExpression* receiver () { return _receiver; }
};

} // namespace Egg

#endif // ~ _SMESSAGE_H_ ~
