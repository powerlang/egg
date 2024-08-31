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
    using UndermessagePointer = Object* (Evaluator::*)(Object *, std::vector<Object*> &args);

    // this is a hack to make C++ type system stop crying
    struct UndermessageWrapper {
    public:
        UndermessageWrapper(UndermessagePointer ptr) : _undermessage(ptr) {}

        UndermessagePointer _undermessage;
    };

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

    void cacheUndermessage_(UndermessagePointer anUndermessage) {
        _cache.push_back(reinterpret_cast<HeapObject*>(new UndermessageWrapper(anUndermessage)));
    }

    UndermessagePointer cachedUndermessage() const {
        // cache is usually added pairs of <behavior, method>. If size is 1 (odd), then the cache
        // has been used to cache an undermessage instead.
        if (_cache.size() != 1)
            return nullptr;

        UndermessageWrapper *w = (UndermessageWrapper*)_cache[0];
        return w->_undermessage;
    }

    void flushCache() {
        _cache.clear();
    }

    HeapObject* methodFor_(HeapObject *behavior) const {
        for (size_t i = 0; i < _cache.size(); i += 2) {
            HeapObject *cached = _cache[i];
            if (cached == behavior) {
                return _cache[i + 1];
            }
        }

        return nullptr;
    }

    virtual SExpression* receiver() = 0;

    void registerCacheWith_(Runtime* runtime) {
        if (_cache.empty()) {
            runtime->registerCache_for_(this, _selector);
        }
    }

    HeapObject* selector() const {
        return _selector;
    }

    void selector_(HeapObject* aSymbol) {
        _selector = aSymbol;
    }

};

} // namespace Egg

#endif // ~ _SABSTRACTMESSAGE_H_ ~
