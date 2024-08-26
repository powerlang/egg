#ifndef _SOPDISPATCHMESSAGE_H_
#define _SOPDISPATCHMESSAGE_H_

#include "SMessage.h"

namespace Egg {

class SOpDispatchMessage : public SExpression {
    SAbstractMessage *_message;
    public:

    SOpDispatchMessage(auto message) : _message(message) {}
	void acceptVisitor_(SExpressionVisitor *visitor) override {
		visitor->visitOpDispatchMessage(this);
	}

};

} // namespace Egg

#endif // ~ _SOPDISPATCHMESSAGE_H_ ~
