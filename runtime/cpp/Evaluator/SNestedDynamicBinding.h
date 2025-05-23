#ifndef _SNESTEDDYNAMICBINDING_H_
#define _SNESTEDDYNAMICBINDING_H_

#include "SDynamicBinding.h"
#include "EvaluationContext.h"

namespace Egg {

class SNestedDynamicBinding : public SDynamicBinding {
public:
    SNestedDynamicBinding(Object *name) : SDynamicBinding(name) {}

    void lookupWithin_ (EvaluationContext* anEvaluationContext) override {
        _cache = anEvaluationContext->staticBindingForNested_(this->_name.get());
    }
};

} // namespace Egg

#endif // ~ _SNESTEDDYNAMICBINDING_H_ ~