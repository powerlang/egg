#ifndef _SDYNAMICBINDING_H_
#define _SDYNAMICBINDING_H_

#include "SBinding.h"
#include "EvaluationContext.h"

namespace Egg {

class SDynamicBinding : public SBinding {
public:
    SDynamicBinding(Object *name) : _name(name), _cache(nullptr) {}

    void assign_within_(Object* value, EvaluationContext* anEvaluationContext) override {
        if (_cache == nullptr) {
            this->lookupWithin_(anEvaluationContext);
        }
        _cache->assign_within_(value, anEvaluationContext);
    }

    bool isDynamic() const override {
        return true;
    }

    virtual void lookupWithin_(EvaluationContext* anEvaluationContext) {
        _cache = anEvaluationContext->staticBindingFor_(this->_name.get());
    }

    const Object* name() const override {
        return this->_name.get();
    }

    SDynamicBinding* name_(Object *aSymbol) {
        _name.set_(aSymbol);
        return this;
    }

    Object* valueWithin_(EvaluationContext* anEvaluationContext) override {
        if (_cache == nullptr) {
            this->lookupWithin_(anEvaluationContext);
        }
        return _cache->valueWithin_(anEvaluationContext);
    }

protected:
    GCedRef _name;
    SBinding *_cache;
};

} // namespace Egg

#endif // ~ _SDYNAMICBINDING_H_ ~