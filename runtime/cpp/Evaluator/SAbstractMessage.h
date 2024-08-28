#ifndef _SABSTRACTMESSAGE_H_
#define _SABSTRACTMESSAGE_H_

#include <vector>
#include "SExpression.h"
#include "SExpressionVisitor.h"
#include "../HeapObject.h"

namespace Egg {

class SAbstractMessage : public SExpression {
    HeapObject* _selector;
    std::vector<SExpression*> _arguments;
    std::vector<HeapObject*> _cache;

public:
    SAbstractMessage(HeapObject *selector, const std::vector<SExpression*>& arguments) :
        _selector(selector), _arguments(arguments)
        { }

    int argumentCount() const {
        return _arguments.size();
    }

    const std::vector<SExpression*>& arguments() const {
        return _arguments;
    }

    void arguments_(const std::vector<SExpression*>& aCollection) {
        _arguments = aCollection;
    }

    void cache_when_(HeapObject* anSCompiledMethod, HeapObject* type) {        
        _cache.push_back(type);
        _cache.push_back(anSCompiledMethod);
    }

    using UndermessagePointer = Object* (Evaluator::*)(Object *, std::vector<Object*> &args);
    void cacheUndermessage_(UndermessagePointer *anUndermessage) {
        _cache.push_back(reinterpret_cast<HeapObject*>(anUndermessage));
    }

    HeapObject* cachedUndermessage() const {
        if (_cache.size() == 1)
            return _cache[0];
        else
            return nullptr;
    }

    void flushCache() {
        _cache.clear();
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

    void registerCacheWith(Runtime* runtime) {
        if (_cache.empty()) {
            runtime->registerCache_for_(this, _selector);
        }
    }

    HeapObject* selector() const {
        return _selector;
    }

    void selector(HeapObject* aSymbol) {
        _selector = aSymbol;
    }

};

} // namespace Egg

#endif // ~ _SABSTRACTMESSAGE_H_ ~
