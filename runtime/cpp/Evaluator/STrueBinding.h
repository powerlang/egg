#ifndef _STRUEBINDING_H_
#define _STRUEBINDING_H_

#include "SLiteralBinding.h"
#include "KnownObjects.h"
#include "EvaluationContext.h"

namespace Egg {

class STrueBinding : public SLiteralBinding {
public:
    HeapObject* value() const override {
        return KnownObjects::_true;
    }

    Object* valueWithin_(EvaluationContext* anEvaluationContext) override {
        return (Object*)anEvaluationContext->_true();
    }
};
} // namespace Egg

#endif // ~ _STRUEBINDING_H_ ~
