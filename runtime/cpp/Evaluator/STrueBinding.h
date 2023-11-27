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

    HeapObject* valueWithin(EvaluationContext* anEvaluationContext) const override {
        return anEvaluationContext->_true();
    }
};
} // namespace Egg

#endif // ~ _STRUEBINDING_H_ ~
