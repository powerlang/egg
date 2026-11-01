#include "Launcher.h"

#include "Egg.h"
#include "Allocator/Memory.h"

#include <filesystem>
#include <fstream>
#include <set>
#include <stdexcept>
#include <vector>


namespace lmr
{

static const bool egg_initialized = [] { Egg::Initialize(); return true; }();

static std::string segmentFileOf(const std::string& module)
{
    return module + ".ems";
}

static std::set<std::string> importedModules(Egg::FileImageSegment* segment)
{
    static const std::set<std::string> byModule = {"asClass", "asBehavior", "asMetaclass", "asMetaclassBehavior", "asMvar", "asModule"};
    std::set<std::string> modules;
    for (auto& descriptor : segment->_importDescriptors) {
        auto& linker = segment->importStringAt_(descriptor[0]);
        if (descriptor.size() > 1 && byModule.count(linker))
            modules.insert(segment->importStringAt_(descriptor[1]));
    }
    return modules;
}

Launcher::Launcher(const std::string& path)
{
    std::filesystem::path file(path);
    _directory = file.parent_path().string();
    _segment = this->load(file.stem().string(), file.filename().string());
}

Egg::FileImageSegment* Launcher::segmentNamed(const std::string& module) const
{
    auto it = _segments.find(module);
    return it == _segments.end() ? nullptr : it->second.get();
}

Egg::FileImageSegment* Launcher::load(const std::string& module, const std::string& file)
{
    if (auto loaded = this->segmentNamed(module))
        return loaded;
    std::ifstream stream(std::filesystem::path(_directory) / file, std::ios::binary);
    if (!stream)
        return nullptr;
    auto& segment = _segments[module];
    segment = std::make_unique<Egg::FileImageSegment>(&stream);
    this->loadImportsOf(segment.get());
    return segment.get();
}

void Launcher::loadImportsOf(Egg::FileImageSegment* segment)
{
    for (auto& module : importedModules(segment))
        if (!this->load(module, segmentFileOf(module)))
            throw std::runtime_error("cannot find the segment of module " + module + " in " + _directory);
}

void Launcher::relocate()
{
    for (auto& [name, segment] : _segments) {
        auto sentinel = reinterpret_cast<Egg::Object*>(segment->spaceStart());
        std::vector<Egg::Object*> imports(segment->_importDescriptors.size(), sentinel);
        segment->fixPointerSlots(imports);
    }
    this->makeExecutable();
}

void Launcher::makeExecutable()
{
    for (auto& [name, segment] : _segments) {
        if (segment->header.codeSize == 0)
            continue;
        auto start = segment->codeStart();
        auto end = Egg::pagealign(segment->codeEnd());
        Egg::MakeExecutable(start, end - start);
    }
}

Egg::HeapObject* Launcher::exported(const std::string& name)
{
    auto it = _segment->_exports.find(name);
    return it == _segment->_exports.end() ? nullptr : it->second;
}

uint64_t Launcher::run(const std::string& name)
{
    auto nativeCode = exported(name);
    auto machineCode = reinterpret_cast<Egg::HeapObject*>(nativeCode->slot(0));
    auto code = reinterpret_cast<uint8_t*>(&machineCode->byte(0));
    auto entry = reinterpret_cast<uint64_t (*)()>(code);
    return entry();
}

} // namespace lmr
