
#include "Egg.h"
#include "Memory.h"
#include "GCSpace.h"
#include "HeapObject.h"

#include <algorithm>

using namespace Egg;

GCSpace::GCSpace(int size)
{
        _base = ReserveMemory(0, size);
        if (!_base)
            error_("Failed to reserve memory.");

        _next = _softLimit = _committedLimit = _base;
        _reservedLimit = _base + size;

}

GCSpace* GCSpace::allocatedAt_limit_(uintptr_t base, uintptr_t limit, bool empty)
{
    GCSpace *result = new GCSpace();
    result->_base = base;
    auto end = empty ? base : limit;
    result->_next = result->_softLimit = result->_committedLimit = end;
    result->_reservedLimit = limit;

    return result;
}

GCSpace* GCSpace::allocatedAt_size_(uintptr_t base, uintptr_t size, bool empty)
{
    return allocatedAt_limit_(base, base + size, empty);
}

GCSpace::~GCSpace()
{
    if (_base)
      FreeMemory(_base, _reservedLimit - _base);
}

uintptr_t GCSpace::committedSize()
{
    return _committedLimit - _base;
}

uintptr_t GCSpace::usedSize()
{
    return _next - _base;
}

uintptr_t GCSpace::softAvailable()
{
    return _softLimit - _next;
}

uintptr_t GCSpace::reservedSize()
{
    return _reservedLimit - _base;
}

bool GCSpace::commitMemoryUpTo_(uintptr_t address)
{
    auto newLimit = std::min(pagealign(address), _reservedLimit);
    if (newLimit < address)
        return false;

    CommitMemory(_committedLimit, newLimit - _base);
    _committedLimit = newLimit;
    return true;
}

bool GCSpace::commitMemory_(uint32_t delta)
{
    return this->commitMemoryUpTo_(_committedLimit + delta);
}

uintptr_t GCSpace::allocateIfPossible_(uint32_t size) {
    auto result = _next;
    auto end = _next + size;
    if (end < _softLimit)
    {
        _next = end;
        return result;
    }

    return 0;
}

uintptr_t GCSpace::allocateCommittingIfNeeded_(uint32_t size)
{
	auto answer = _next;
	auto next = answer + size;
	if (next <= _softLimit || this->commitMemoryUpTo_(next))
    {
        _next = next;
        return answer;
    }
    else return 0;
}

bool GCSpace::increaseSoftLimit_(uint32_t delta)
{ 
    int32_t available = _committedLimit - _softLimit;
    if (available < 0) return false;
    
	_softLimit = _softLimit + std::min(delta, (uint32_t)available);
	return true;
}

HeapObject *GCSpace::firstObject()
{
    return HeapObject::ObjectHeader::at((void*)_base)->object();
}

bool GCSpace::includes_(HeapObject *object)
{
    return _base < (uintptr_t)object && (uintptr_t)object < _next;
}

HeapObject *GCSpace::shallowCopy_(HeapObject *object)
{
    auto size = object->bodySizeInBytes();
    auto extra = object->headerSizeInBytes();
    auto allocation = this->allocateIfPossible_(extra + size);
    if (!allocation)
        return nullptr;
    
    auto copy = (HeapObject*)(allocation + extra);
    copy->copyFrom_headerSize_bodySize_(object, (uintptr_t)extra, (uintptr_t)size);
    copy->beNotRemembered();
    return copy;

}

HeapObject *GCSpace::shallowCopyCommitting_(HeapObject *object)
{
    auto size = object->bodySizeInBytes();
    auto extra = object->headerSizeInBytes();
    auto allocation = this->allocateCommittingIfNeeded_(extra + size);
    if (!allocation)
        return nullptr;
    
    auto copy = (HeapObject*)(allocation + extra);
    copy->copyFrom_headerSize_bodySize_(object, extra, size);
    copy->beNotRemembered();
    return copy;
}

void GCSpace::unmarkAll() {
    this->objectsDo_(
        [](HeapObject *object) { object->beUnseen();}
        );
}

void GCSpace::objectsDo_(const std::function<void(HeapObject *)> &aBlock)
{
    auto header = HeapObject::ObjectHeader::at((void*)_base);
	while ((uintptr_t)header < _next)
    {
		auto object = header->object();
		header = object->nextHeader();
		aBlock(object);
    }
}
