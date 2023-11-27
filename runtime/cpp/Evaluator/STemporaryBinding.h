
#ifndef _STEMPORARYBINDING_H_
#define _STEMPORARYBINDING_H_

#include "EvaluationContext.h"
#include "SLocalBinding.h" 

namespace Egg {

class STemporaryBinding : public SLocalBinding {
public:
    STemporaryBinding(int pos, int env) : SLocalBinding(pos, env) {}

    void assign_within(int value, EvaluationContext* anEvaluationContext) {
        anEvaluationContext->temporaryAt_in_put(this->_position, this->_environment, value);
    }

    bool isInCurrentEnvironment() const {
        return this->_environment == 1;
    }

    bool isTemporary() const {
        return true;
    }

    HeapObject* valueWithin(EvaluationContext* anEvaluationContext) const {
        return anEvaluationContext->temporaryAt_in(this->_position, this->_environment);
    }
};

} // namespace Egg

#endif // _STEMPORARYBINDING_H_
