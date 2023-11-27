#ifndef _SFALSEBINDING_H_
#define _SFALSEBINDING_H_

#include "SLiteralBinding.h"
#include "KnownObjects.h"
#include "EvaluationContext.h"

namespace Egg {

class SFalseBinding : public SLiteralBinding {
public:
    HeapObject* value() const override {
        return KnownObjects::_false;
    }

    HeapObject* valueWithin(EvaluationContext* anEvaluationContext) const override {
        return anEvaluationContext->_false();
    }
};
} // namespace Egg

#endif // ~ _SFALSEBINDING_H_ ~
