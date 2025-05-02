
#ifndef _GCGUARD_H_
#define _GCGUARD_H_

namespace Egg {

/**
 * My instances, on construction, mantain a bool var to allow/disallow the heap to be
 * collected (i.e. to move objects).
 * When destructed, we restore the previous state.
 *
 * Creating an instance does not automatically cause GC. Users should be aware of potentially
 * GCing calls (basically, calls to methods that potentially allocate objects). At that point,
 * all on-the-fly references to heap objects (raw pointers not known by GC) must be wrapped by
 * GCedRefs or dead.
 */

class GCGuard {
    bool &_var;
    bool _prev;

  public:
    GCGuard(bool &var, bool newValue) : _var(var), _prev(var) {
      _var = newValue;
    }

    ~GCGuard() {
      _var = _prev;
    }

    GCGuard(const GCGuard&) = delete;
    GCGuard& operator=(const GCGuard&) = delete;
};

}

#endif // ~ _GCGUARD_H_
