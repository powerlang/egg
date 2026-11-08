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
#include <set>
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
     * Rebases every loaded segment and binds the imports of the runtime
     * core (Kernel, Kernel.LMR and LMR), and of the modules given to
     * bind(), by name, without running code. The imports of the other
     * segments are left unresolved (a sentinel).
     */
    void relocate();
    void bind(const std::string& module);
    std::vector<Egg::Object*> importsOf(const std::string& module);
    Egg::HeapObject* exported(const std::string& name);
    void* entry(const std::string& name);
    uint64_t run(const std::string& name);

  private:
    std::string _directory;
    std::map<std::string, std::unique_ptr<Egg::FileImageSegment>> _segments;
    Egg::FileImageSegment* _segment = nullptr;
    std::map<std::string, Egg::Object*> _symbols;
    std::vector<std::string> _bound = {"Kernel", "Kernel.LMR", "LMR"};

    Egg::FileImageSegment* load(const std::string& module, const std::string& file);
    void loadImportsOf(Egg::FileImageSegment* segment);
    void collectSymbols();
    Egg::Object* kernelExport(const std::string& name);
    Egg::Object* bindImport(const std::vector<std::string>& tokens);
    Egg::Object* methodIn(Egg::HeapObject* behavior, Egg::Object* selector);
    uint32_t instVarIndex(Egg::HeapObject* species, const std::string& name);
    void initializeKernelSpace();
    void initializeHostLinkage();
    bool isBound(const std::string& module) const;
    void makeExecutable();
};

} // namespace lmr

#endif // LMR_LAUNCHER_H
