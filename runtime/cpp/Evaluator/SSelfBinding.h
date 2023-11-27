#ifndef _SSELFBINDING_H_
#define _SSELFBINDING_H_

#include "SBinding.h"
#include "KnownObjects.h"
#include "EvaluationContext.h"

namespace Egg {

class SSelfBinding : public SBinding {
public:
    bool isSelf() const override {
        return true;
    }

    HeapObject* valueWithin(EvaluationContext* anEvaluationContext) const override {
        return anEvaluationContext->receiver();
    }
};


} // namespace Egg

#endif // ~ _SSELFBINDING_H_ ~
