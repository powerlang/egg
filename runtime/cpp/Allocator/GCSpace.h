#ifndef _GCSPACE_H_
#define _GCSPACE_H_

#include <cstdint>
#include <string>
#include <functional>

namespace Egg {

class HeapObject;

class GCSpace {
    GCSpace() {};
public:
    uintptr_t _base, _next, _softLimit, _committedLimit, _reservedLimit;
    std::string _name;
    GCSpace(int size);
    GCSpace(GCSpace *copy);

    static GCSpace* allocatedAt_limit_(uintptr_t base, uintptr_t limit, bool empty = true);
    static GCSpace* allocatedAt_size_(uintptr_t base, uintptr_t size, bool empty = true);

    ~GCSpace();

    uintptr_t base() { return _base; }
    uintptr_t next() { return _next; }
    uintptr_t nextFree() { return _next; }
    uintptr_t softLimit() { return _softLimit; }
    uintptr_t commitedLimit() { return _committedLimit; }
    uintptr_t reservedLimit() { return _reservedLimit; }
    std::string& name() { return _name; }

    uintptr_t committedSize();
    uintptr_t reservedSize();
    uintptr_t usedSize(); // the amount actually used in the committed chunk
    uintptr_t isFree() { return committedSize() == 0; }

    uintptr_t softAvailable();

    bool commitMemoryUpTo_(uintptr_t address);
    bool commitMemory_(uint32_t delta);
    uintptr_t allocateIfPossible_(uint32_t size);
    uintptr_t allocateCommittingIfNeeded_(uint32_t size);
    bool increaseSoftLimit_(uint32_t delta);

    HeapObject* firstObject();

    bool includes_(HeapObject *object);

    HeapObject* shallowCopy_(HeapObject *object);
    HeapObject* shallowCopyCommitting_(HeapObject *object);

    void unmarkAll();
    void f();

    void objectsDo_(const std::function<void(HeapObject*)>& aBlock);

};

} // namespace Egg

#endif // ~ _GCSPACE_H_ ~
