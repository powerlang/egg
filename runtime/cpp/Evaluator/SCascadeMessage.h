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
    std::vector<HeapObject*> *_cache;  // Assuming SObject is the common base class for Type and SCompiledMethod

public:
    SCascadeMessage(HeapObject *selector, const std::vector<SExpression*>& arguments, SCascade *cascade) :
        _selector(selector), _arguments(arguments), _cascade(cascade)
    {
        _cache = nullptr;
    }

    void acceptVisitor(SExpressionVisitor* visitor) override {
        visitor->visitCascadeMessage(this);
    }

    int argumentCount() const {
        return _arguments.size();
    }

    const std::vector<SExpression*>& arguments() const {
        return _arguments;
    }

    SCascadeMessage* arguments(const std::vector<SExpression*>& aCollection) {
        _arguments = aCollection;
        return this;
    }

    void cache_when(HeapObject* anSCompiledMethod, HeapObject* type) {
        if (!_cache)
            _cache = new std::vector<HeapObject*>();
        
        _cache->push_back(type);
        _cache->push_back(anSCompiledMethod);

    }

    SCascadeMessage* cacheUndermessage(BlockClosure* aBlockClosure) {
        _cache = aBlockClosure;
        return this;
    }

    BlockClosure* cachedUndermessage() const {
        return (_cache && _cache->isBlock()) ? dynamic_cast<BlockClosure*>(_cache) : nullptr;
    }

    SCascade* cascade() const {
        return _cascade;
    }

    SCascadeMessage* cascade(SCascade* anSCascade) {
        _cascade = anSCascade;
        return this;
    }

    SCascadeMessage* flushCache() {
        _cache = nullptr;
        return this;
    }

    bool isCascadeMessage() const override {
        return true;
    }

    SCompiledMethod* methodFor(Type* requiredType) const {
        if (!_cache) {
            return nullptr;
        }

        for (size_t i = 1; i < _cache->size(); i += 2) {
            Type* type = dynamic_cast<Type*>(_cache->at(i));
            if (type && *type == *requiredType) {
                return dynamic_cast<SCompiledMethod*>(_cache->at(i + 1));
            }
        }

        return nullptr;
    }

    SExpression* receiver() const {
        return _cascade ? _cascade->receiver() : nullptr;
    }

    SCascadeMessage* registerCacheWith(Runtime* runtime) {
        if (!_cache) {
            runtime->registerCache_for(this, _selector);
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
