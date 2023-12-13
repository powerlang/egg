#ifndef _SOPDISPATCHMESSAGE_H_
#define _SOPDISPATCHMESSAGE_H_

#include "SMessage.h"

namespace Egg {

class SOpDispatchMessage : public SExpression {
    SMessage *_message;
    public:

    SOpDispatchMessage(auto message) : _message(message) {}

};

} // namespace Egg

#endif // ~ _SOPDISPATCHMESSAGE_H_ ~
