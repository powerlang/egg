#ifndef _SNILBINDING_H_
#define _SNILBINDING_H_

#include "SLiteralBinding.h"
#include "EvaluationContext.h"

namespace Egg {

class SNilBinding : public SLiteralBinding {
public:

    Object* valueWithin_(EvaluationContext* anEvaluationContext) override {
        return (Object*)anEvaluationContext->nil();
    }
};

} // namespace Egg

#endif // ~ _SNILBINDING_H_ ~
