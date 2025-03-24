
#ifndef _STACKGCEDREF_H_
#define _STACKGCEDREF_H_

#include "Egg.h"

namespace Egg {

class EvaluationContext;

class StackGCedRef {
  EvaluationContext* _context;
  uintptr_t _index;

  public:
     StackGCedRef(EvaluationContext* context, Object* object);
     ~StackGCedRef();

     Object* asObject() const;
     HeapObject* asHeapObject();
};

}

#endif // ~ _STACKGCEDREF_H_ ~
