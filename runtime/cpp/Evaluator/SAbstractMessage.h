#ifndef _SABSTRACTMESSAGE_H_
#define _SABSTRACTMESSAGE_H_

#include <vector>
#include "SExpression.h"
#include "SExpressionVisitor.h"
#include "../HeapObject.h"
#include "GCedRef.h"

namespace Egg {

class SAbstractMessage : public SExpression {
    GCedRef _selector;
    std::vector<SExpression*> _arguments;
    std::vector<GCedRef*> _cache;

 public:
    using UndermessagePointer = Object* (Evaluator::*)(Object *, std::vector<Object*> &args);

    // this is a hack to make C++ type system stop crying
    struct UndermessageWrapper {
    public:
        UndermessageWrapper(UndermessagePointer ptr) :
            _undermessage(ptr) {}

        UndermessagePointer _undermessage;
    };

public:
    SAbstractMessage(Object *selector, const std::vector<SExpression*>& arguments) :
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

    void cache_when_(Object* anSCompiledMethod, Object* type) {
        _cache.push_back(new GCedRef(type));
        _cache.push_back(new GCedRef(anSCompiledMethod));
    }

    void cacheUndermessage_(UndermessagePointer anUndermessage) {
        _cache.push_back(reinterpret_cast<GCedRef*>(new UndermessageWrapper(anUndermessage)));
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

    Object* methodFor_(Object *behavior) const {
        for (size_t i = 0; i < _cache.size(); i += 2) {
            GCedRef *cached = _cache[i];
            if (cached->get() == behavior) {
                return _cache[i + 1]->get();
            }
        }

        return nullptr;
    }

    virtual SExpression* receiver() = 0;

    void registerCacheWith_(Runtime* runtime) {
        if (_cache.empty()) {
            runtime->registerCache_for_(this, _selector.get());
        }
    }

    Object* selector() {
        return _selector.get();
    }

};

} // namespace Egg

#endif // ~ _SABSTRACTMESSAGE_H_ ~
