#ifndef _SNESTEDDYNAMICBINDING_H_
#define _SNESTEDDYNAMICBINDING_H_

#include "SDynamicBinding.h"
#include "EvaluationContext.h"

namespace Egg {

class SNestedDynamicBinding : public SDynamicBinding {
public:

    SNestedDynamicBinding* lookupWithin(EvaluationContext* anEvaluationContext) {
        _cache = anEvaluationContext->staticBindingForNested(_name);
        return this;
    }
};

} // namespace Egg

#endif // ~ _SNESTEDDYNAMICBINDING_H_ ~