/*
    Minimal launcher for booting nativized LMR image segments without the
    full C++ evaluator VM.

    Step 1 (this file): load a produced .ems segment from disk, reusing the
    cpp runtime's FileImageSegment for reading + memory reservation. Later
    steps add pointer relocation, locating a nativized method's machine code,
    marking it executable, and calling it.
*/
#ifndef LMR_LAUNCHER_H
#define LMR_LAUNCHER_H

#include <memory>
#include <string>

#include "FileImageSegment.h"

namespace lmr
{

class Launcher
{
  public:
    explicit Launcher(const std::string& path);

    bool loaded() const { return _segment != nullptr; }
    Egg::FileImageSegment* segment() const { return _segment.get(); }

  private:
    std::unique_ptr<Egg::FileImageSegment> _segment;
};

} // namespace lmr

#endif // LMR_LAUNCHER_H
