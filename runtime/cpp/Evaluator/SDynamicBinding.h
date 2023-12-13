#ifndef _SDYNAMICBINDING_H_
#define _SDYNAMICBINDING_H_

#include "SBinding.h"
#include "EvaluationContext.h"

namespace Egg {

class SDynamicBinding : public SBinding {
public:
    SDynamicBinding(HeapObject *name) : _name(name), _cache(nullptr) {}

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
        _cache = anEvaluationContext->staticBindingFor_(this->_name);
    }

    HeapObject* name() const override {
        return this->_name;
    }

    SDynamicBinding* name_(HeapObject *aSymbol) {
        _name = aSymbol;
        return this;
    }

    Object* valueWithin_(EvaluationContext* anEvaluationContext) {
        if (_cache == nullptr) {
            this->lookupWithin_(anEvaluationContext);
        }
        return _cache->valueWithin_(anEvaluationContext);
    }

protected:
    HeapObject *_name;
    SBinding *_cache;
};

} // namespace Egg

#endif // ~ _SDYNAMICBINDING_H_ ~