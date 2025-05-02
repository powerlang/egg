
#include "GCedRef.h"
#include "Evaluator/Runtime.h"
#include "HeapObject.h"

using namespace Egg;

class Runtime;

GCedRef::GCedRef(Object* object, uintptr_t index)
      : _object(object), _index(index)
{}

GCedRef::GCedRef(Object* object)
      : _object(object), _index(debugRuntime->assignGCedRefIndex())
{
    debugRuntime->registerGCedRef_(this);
}
//GCedRef::GCedRef(GCedRef &other)
//      : _runtime(other._runtime), _object(other.get()), index(_runtime->assignRef(other.get()))
//{}

/*
GCedRef::GCedRef(GCedRef&& other) : _object(other._object), _index(other._index) {
    debugRuntime->registerGCedRef_(this);
    other._object = (Object*)KnownObjects::nil;
}

GCedRef& GCedRef::operator=(GCedRef&& other) {
    if (this != &other) {
        _object = other._object;
        _index = other._index;
        other._object = nullptr;
    }
    return *this;
}
*/

GCedRef::~GCedRef() {
    //if (_object != KnownObjects::nil)
        debugRuntime->releaseGCedRef_(_index);
}

uintptr_t GCedRef::Comparator::hash(const GCedRef *obj) const {
    return debugRuntime->hashFor_((Object*)obj->get());
}

uintptr_t GCedRef::Comparator::hash(const Object *obj) const {
    return debugRuntime->hashFor_((Object*)obj);
}

Object* GCedRef::get()
{
    return _object;
}

uintptr_t GCedRef::index() {
    return _index;
}

