/*
    Minimal launcher for booting nativized LMR image segments without the
    full C++ evaluator VM.

    It loads a produced .ems segment and, from the same directory, every
    segment it imports from, reusing the cpp runtime's FileImageSegment for
    reading and memory reservation. relocate() rebases them all, and run()
    calls a nativized entry exported by the first segment.
*/
#ifndef LMR_LAUNCHER_H
#define LMR_LAUNCHER_H

#include <cstdint>
#include <map>
#include <memory>
#include <string>
#include <vector>

#include "FileImageSegment.h"

namespace lmr
{

class Launcher
{
  public:
    explicit Launcher(const std::string& path);

    bool loaded() const { return _segment != nullptr; }
    /**
     * The segment the launcher was given.
     */
    Egg::FileImageSegment* segment() const { return _segment; }
    /**
     * A loaded segment by module name ("Kernel", "LMR.Nativizer", ...), or nullptr.
     */
    Egg::FileImageSegment* segmentNamed(const std::string& module) const;

    /**
     * Rebases every loaded segment and binds Kernel's imports, which name
     * classes, behaviors and modules exported by the other segments. The
     * imports of the other segments are left unresolved (a sentinel).
     */
    void relocate();
    std::vector<Egg::Object*> kernelImports();
    Egg::HeapObject* exported(const std::string& name);
    uint64_t run(const std::string& name);

  private:
    std::string _directory;
    std::map<std::string, std::unique_ptr<Egg::FileImageSegment>> _segments;
    Egg::FileImageSegment* _segment = nullptr;

    Egg::FileImageSegment* load(const std::string& module, const std::string& file);
    void loadImportsOf(Egg::FileImageSegment* segment);
    Egg::Object* bindKernelImport(const std::vector<std::string>& tokens);
    void makeExecutable();
};

} // namespace lmr

#endif // LMR_LAUNCHER_H
