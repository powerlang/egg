
#include "GCedRef.h"
#include "Evaluator/Runtime.h"
#include "HeapObject.h"

using namespace Egg;

class Runtime;

GCedRef::GCedRef(HeapObject* object, uintptr_t index)
      : _object(object), _index(index)
{}

GCedRef::GCedRef(HeapObject* object)
      : _object(object), _index(debugRuntime->assignGCedRefIndex())
{
    debugRuntime->registerGCedRef_(this);
}
//GCedRef::GCedRef(GCedRef &other)
//      : _runtime(other._runtime), _object(other.get()), index(_runtime->assignRef(other.get()))
//{}

GCedRef::~GCedRef() {
    debugRuntime->releaseGCedRef_(_index);
}

uintptr_t GCedRef::Comparator::hash(const GCedRef *obj) const {
    return debugRuntime->hashFor_((Object*)obj->get());
}

uintptr_t GCedRef::Comparator::hash(const HeapObject *obj) const {
    return debugRuntime->hashFor_((Object*)obj);
}

HeapObject* GCedRef::get()
{
    return _object;
}

uintptr_t GCedRef::index() {
    return _index;
}

