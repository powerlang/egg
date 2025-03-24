
#ifndef _GCSAFEPOINT_H_
#define _GCSAFEPOINT_H_

#include "GCHeap.h"

namespace Egg {

/**
 * My instances, on construction, allow the heap to be collected (i.e. to move objects).
 * When destructed, we restore the previous state.
 *
 * Creating an instance does not automatically cause GC. Users should be aware of potentially
 * GCing calls (basically, calls to methods that potentially allocate objects). At that point,
 * all on-the-fly references to heap objects (raw pointers not known by GC) must be wrapped by
 * GCedRefs or dead.
 */

class GCSafepoint {
  GCHeap* _heap;
  bool _prevState;

  public:
    GCSafepoint(GCHeap *heap) : _heap(heap) {
      _prevState = _heap->isAtGCSafepoint();
      _heap->beAtGCSafepoint(true);
    }

    ~GCSafepoint() {
      _heap->beAtGCSafepoint(_prevState);
    }
};

}

#endif // ~ _GCSAFEPOINT_H_
