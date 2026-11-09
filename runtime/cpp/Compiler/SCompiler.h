/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#ifndef _SCOMPILER_H_
#define _SCOMPILER_H_

#include <cstdint>

namespace Egg {

class HeapObject;
class Stream;

/**
 * Corresponds to SCompiler in Smalltalk.
 * Frontend compiler that provides class binding and character classification.
 */
class SCompiler {
private:
    HeapObject* _classBinding;

public:
    SCompiler();

    void classBinding_(HeapObject* classObj) { _classBinding = classObj; }
    HeapObject* classBinding() const { return _classBinding; }

    bool canStartIdentifier_(uint32_t ch) const;
    bool canBeInIdentifier_(uint32_t ch) const;
    bool peekForIdentifier_(Stream& stream) const;
};

} // namespace Egg

#endif // _SCOMPILER_H_
