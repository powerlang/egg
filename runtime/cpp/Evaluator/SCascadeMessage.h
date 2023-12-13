#ifndef _SCASCADEMESSAGE_H_
#define _SCASCADEMESSAGE_H_

#include <vector>
#include "SExpression.h"
#include "SExpressionVisitor.h"
#include "../HeapObject.h"

namespace Egg {

class SCascadeMessage : public SExpression {
    HeapObject* _selector;
    std::vector<SExpression*> _arguments;
    SCascade* _cascade;
    std::vector<HeapObject*> _cache;

public:
    SCascadeMessage(HeapObject *selector, const std::vector<SExpression*>& arguments, SCascade *cascade) :
        _selector(selector), _arguments(arguments), _cascade(cascade)
        { }

    void acceptVisitor_(SExpressionVisitor* visitor) override {
        visitor->visitCascadeMessage(this);
    }

    int argumentCount() const {
        return _arguments.size();
    }

    const std::vector<SExpression*>& arguments() const {
        return _arguments;
    }

    SCascadeMessage* arguments_(const std::vector<SExpression*>& aCollection) {
        _arguments = aCollection;
        return this;
    }

    void cache_when_(HeapObject* anSCompiledMethod, HeapObject* type) {        
        _cache.push_back(type);
        _cache.push_back(anSCompiledMethod);
    }

    SCascadeMessage* cacheUndermessage_(HeapObject* aBlockClosure) {
        _cache.push_back(aBlockClosure);
        return this;
    }

    HeapObject* cachedUndermessage() const {
        if (_cache.size() == 1)
            return _cache[0];
        else
            return nullptr;
    }

    SCascade* cascade() const {
        return _cascade;
    }

    SCascadeMessage* cascade(SCascade* anSCascade) {
        _cascade = anSCascade;
        return this;
    }

    SCascadeMessage* flushCache() {
        _cache.clear();
        return this;
    }

    bool isCascadeMessage() const override {
        return true;
    }

    HeapObject* methodFor(HeapObject *behavior) const {
        for (size_t i = 0; i < _cache.size(); i += 2) {
            HeapObject *cached = _cache[i];
            if (cached == behavior) {
                return _cache[i + 1];
            }
        }

        return nullptr;
    }

    SExpression* receiver() const {
        return _cascade ? _cascade->receiver() : nullptr;
    }

    SCascadeMessage* registerCacheWith(Runtime* runtime) {
        if (_cache.empty()) {
            runtime->registerCache_for_(&_cache, _selector);
        }
        return this;
    }

    HeapObject* selector() const {
        return _selector;
    }

    SCascadeMessage* selector(HeapObject* aSymbol) {
        _selector = aSymbol;
        return this;
    }

};

} // namespace Egg

#endif // ~ _SCASCADEMESSAGE_H_ ~
