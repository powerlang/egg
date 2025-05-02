#ifndef _STRUEBINDING_H_
#define _STRUEBINDING_H_

#include "SLiteralBinding.h"
#include "EvaluationContext.h"

namespace Egg {

class STrueBinding : public SLiteralBinding {

    Object* valueWithin_(EvaluationContext* anEvaluationContext) override {
        return (Object*)anEvaluationContext->_true();
    }
};
} // namespace Egg

#endif // ~ _STRUEBINDING_H_ ~
