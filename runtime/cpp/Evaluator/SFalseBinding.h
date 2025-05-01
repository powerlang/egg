#ifndef _SFALSEBINDING_H_
#define _SFALSEBINDING_H_

#include "SLiteralBinding.h"
#include "EvaluationContext.h"

namespace Egg {

class SFalseBinding : public SLiteralBinding {
public:

    Object* valueWithin_(EvaluationContext* anEvaluationContext) override {
        return (Object*)anEvaluationContext->_false();
    }
};
} // namespace Egg

#endif // ~ _SFALSEBINDING_H_ ~
