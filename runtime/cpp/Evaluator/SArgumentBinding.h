#ifndef _SARGUMENTBINDING_H_
#define _SARGUMENTBINDING_H_

#include "SLocalBinding.h"
#include "EvaluationContext.h"

namespace Egg {

class SArgumentBinding : public SLocalBinding {
public:
    bool _inlined;

    SArgumentBinding(int pos, int env) : SLocalBinding(pos, env), _inlined(false) {}

    void assign_within(int value, EvaluationContext* anEvaluationContext) {
        ASSERT(false);
    }

    bool isArgument() const {
        return true;
    }

    bool isInlined() const {
        return this->_environment == -1;
    }

    HeapObject* valueWithin(EvaluationContext* anEvaluationContext) {
        return anEvaluationContext->argumentAt_in(this->_position, this->_environment);
    }
};

} // namespace Egg

#endif // ~ _SARGUMENTBINDING_H_
