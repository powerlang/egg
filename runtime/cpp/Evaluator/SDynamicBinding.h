#ifndef _SDYNAMICBINDING_H_
#define _SDYNAMICBINDING_H_

#include "SBinding.h"
#include "EvaluationContext.h"

namespace Egg {

class SDynamicBinding : public SBinding {
public:
    SDynamicBinding() : _name(nullptr), _cache(nullptr) {}

    SDynamicBinding* assign_within(Value* value, EvaluationContext* anEvaluationContext) {
        if (_cache == nullptr) {
            this->lookupWithin(anEvaluationContext);
        }
        _cache->assign_within(value, anEvaluationContext);
        return this;
    }

    bool isDynamic() const {
        return true;
    }

    SDynamicBinding* lookupWithin(EvaluationContext* anEvaluationContext) {
        _cache = anEvaluationContext->staticBindingFor(_name);
        return this;
    }

    Symbol* name() const {
        return _name;
    }

    SDynamicBinding* name_(Symbol* aSymbol) {
        _name = aSymbol;
        return this;
    }

    Value* valueWithin(EvaluationContext* anEvaluationContext) {
        if (_cache == nullptr) {
            this->lookupWithin(anEvaluationContext);
        }
        return _cache->valueWithin(anEvaluationContext);
    }

private:
    Symbol* _name;
    SDynamicBinding* _cache;
};

} // namespace Egg

#endif // ~ _SDYNAMICBINDING_H_ ~