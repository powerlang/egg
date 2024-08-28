#include "GCSpace.h"

#include <algorithm>

using namespace Egg;

Egg::GCSpace::GCSpace(int size)
{
        _base = Egg::ReserveMemory(0, size);
        if (!_base)
            error("Failed to reserve memory.");

        _next = _softLimit = _committedLimit = _base;
        _reservedLimit = _base + size;

}

Egg::GCSpace::~GCSpace()
{
    if (_base)
      Egg::FreeMemory(_base, _reservedLimit - _base);
}

uintptr_t GCSpace::reservedSize()
{
    return _reservedLimit - _base;
}

void GCSpace::commitMemory(uint32_t delta)
{
    auto newLimit = std::min(_committedLimit + delta, _reservedLimit);
    Egg::CommitMemory(_base, newLimit - _base);
    _softLimit = _committedLimit = _reservedLimit;
}

uintptr_t GCSpace::allocate(uint32_t size) {
    auto result = _next;
    auto end = _next + size;
    if (end < _softLimit)
    {
        _next = end;
        return result;
    }

    return 0;
}

bool Egg::GCSpace::increaseSoftLimit_(uint32_t delta)
{ 
    int32_t available = _committedLimit - _softLimit;
    if (available < 0) return false;
    
	_softLimit = _softLimit + std::min(delta, (uint32_t)available);
	return true;
}
