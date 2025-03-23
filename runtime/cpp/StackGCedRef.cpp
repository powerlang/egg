
#include "StackGCedRef.h"
#include "Evaluator/EvaluationContext.h"

using namespace Egg;
StackGCedRef::StackGCedRef(EvaluationContext* context, Object* object) :
 _context(context)
{
  _context->push_(object);
  _index = _context->stackPointer();
}

StackGCedRef::~StackGCedRef()
{
  ASSERT(_context->stackPointer() == _index);
  _context->pop();
}

Object* StackGCedRef::asObject() const
{
  return _context->stackAt_(_index);
}

HeapObject* StackGCedRef::asHeapObject()
{
    return asObject()->asHeapObject();
}