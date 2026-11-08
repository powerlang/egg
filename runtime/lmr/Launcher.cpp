#include "Launcher.h"

#include "Egg.h"
#include "Allocator/Memory.h"
#include "KnownConstants.h"
#include "FFIGlue.h"

#include <algorithm>
#include <cstring>
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

void Launcher::bind(const std::string& module)
{
    if (!this->isBound(module))
        _bound.push_back(module);
}

bool Launcher::isBound(const std::string& module) const
{
    return std::find(_bound.begin(), _bound.end(), module) != _bound.end();
}

void Launcher::relocate()
{
    for (auto& [name, segment] : _segments)
        segment->relocate();
    this->collectSymbols();
    for (auto& name : _bound)
        if (auto segment = this->segmentNamed(name))
            segment->bindImports(this->importsOf(name));
    for (auto& [name, segment] : _segments) {
        if (this->isBound(name))
            continue;
        auto sentinel = reinterpret_cast<Egg::Object*>(segment->spaceStart());
        segment->bindImports(std::vector<Egg::Object*>(segment->_importDescriptors.size(), sentinel));
    }
    this->initializeKernelSpace();
    this->initializeHostLinkage();
    this->makeExecutable();
}

uint32_t Launcher::instVarIndex(Egg::HeapObject* species, const std::string& name)
{
    auto nil = this->kernelExport("nil");
    std::vector<Egg::HeapObject*> chain;
    for (auto current = (Egg::Object*)species; current != nil; current = current->asHeapObject()->slot(Egg::Offsets::SpeciesSuperclass))
        chain.insert(chain.begin(), current->asHeapObject());
    uint32_t index = 0;
    for (auto each : chain) {
        auto names = each->slot(Egg::Offsets::SpeciesInstanceVariables);
        if (names == nil)
            continue;
        auto array = names->asHeapObject();
        for (uint32_t i = 0; i < array->size(); i++, index++) {
            auto string = array->slot(i)->asHeapObject();
            if (std::string((const char*)&string->byte(0), strnlen((const char*)&string->byte(0), string->size())) == name)
                return index;
        }
    }
    throw std::runtime_error("instances have no variable named " + name);
}

void Launcher::initializeHostLinkage()
{
    auto linkage = this->segmentNamed("Kernel.LMR")->_exports.at("HostLinkage");
    linkage->slot(0) = reinterpret_cast<Egg::Object*>(Egg::SymbolFinder() << 1 | 1);
    linkage->slot(1) = reinterpret_cast<Egg::Object*>(Egg::LoaderHandle() << 1 | 1);
    linkage->slot(3) = reinterpret_cast<Egg::Object*>(Egg::HeapNextFree() << 1 | 1);
    linkage->slot(4) = reinterpret_cast<Egg::Object*>(Egg::HeapLimit() << 1 | 1);
    auto platform = linkage->slot(2)->asHeapObject();
    std::strncpy(reinterpret_cast<char*>(&platform->byte(0)), Egg::PlatformName(), platform->size() - 1);
}

void Launcher::initializeKernelSpace()
{
    auto& exports = this->segmentNamed("LMR")->_exports;
    auto space = exports.at("KernelSpace");
    auto species = exports.at("GCSpace");
    auto kernel = this->segmentNamed("Kernel");
    auto free = kernel->header.codeSize == 0 ? kernel->spaceEnd() : Egg::pagealign(kernel->codeEnd());
    auto limit = kernel->reservedEnd();
    for (auto& [name, address] : std::map<std::string, uintptr_t>{
             {"base", kernel->spaceStart()}, {"nextFree", free}, {"softLimit", limit},
             {"commitedLimit", limit}, {"reservedLimit", limit}})
        space->slot(this->instVarIndex(species, name)) = reinterpret_cast<Egg::Object*>(address | 1);
}

void Launcher::collectSymbols()
{
    auto kernel = this->segmentNamed("Kernel");
    auto symbol = this->kernelExport("Symbol")->asHeapObject();
    auto behavior = symbol->slot(Egg::Offsets::SpeciesInstanceBehavior)->asHeapObject();
    auto current = ((Egg::HeapObject::ObjectHeader*)kernel->spaceStart())->object();
    auto end = (Egg::HeapObject*)kernel->spaceEnd();
    for (; current < end; current = current->nextObject())
        if (current->behavior() == behavior) {
            auto bytes = reinterpret_cast<const char*>(&current->byte(0));
            _symbols[std::string(bytes, strnlen(bytes, current->size()))] = (Egg::Object*)current;
        }
}

Egg::Object* Launcher::kernelExport(const std::string& name)
{
    auto& exports = this->segmentNamed("Kernel")->_exports;
    auto it = exports.find(name);
    if (it == exports.end())
        throw std::runtime_error("Kernel exports no " + name);
    return (Egg::Object*)it->second;
}

std::vector<Egg::Object*> Launcher::importsOf(const std::string& module)
{
    auto segment = this->segmentNamed(module);
    std::vector<Egg::Object*> imports;
    for (auto& descriptor : segment->_importDescriptors) {
        std::vector<std::string> tokens;
        for (auto index : descriptor)
            tokens.push_back(segment->importStringAt_(index));
        imports.push_back(this->bindImport(tokens));
    }
    return imports;
}

Egg::Object* Launcher::bindImport(const std::vector<std::string>& tokens)
{
    static const std::map<std::string, std::string> constants = {
        {"nil", "nil"}, {"true", "true"}, {"false", "false"},
        {"symbolTable", "SymbolTable"}, {"nilToken", "NilToken"}};
    auto& linker = tokens[0];
    auto constant = constants.find(linker);
    if (constant != constants.end() && tokens.size() == 1)
        return this->kernelExport(constant->second);
    if (linker == "asSymbol" && tokens.size() == 2) {
        auto it = _symbols.find(tokens[1]);
        if (it != _symbols.end())
            return it->second;
    }
    if (linker == "asCharacter" && tokens.size() == 2) {
        auto characters = this->kernelExport("ByteCharacters")->asHeapObject();
        auto value = std::stoul(tokens[1]);
        if (value < characters->size())
            return characters->slot(value);
    }
    auto segment = tokens.size() > 1 ? this->segmentNamed(tokens[1]) : nullptr;
    if (segment && linker == "asModule" && tokens.size() == 2)
        return (Egg::Object*)segment->header.module;
    if (segment && tokens.size() == 3) {
        auto it = segment->_exports.find(tokens[2]);
        if (it != segment->_exports.end()) {
            auto exported = it->second;
            Egg::Object* object = nullptr;
            if (linker == "asClass" || linker == "asMvar")
                object = (Egg::Object*)exported;
            if (linker == "asBehavior")
                object = exported->slot(Egg::Offsets::SpeciesInstanceBehavior);
            if (linker == "asMetaclassBehavior")
                object = (Egg::Object*)exported->behavior();
            if (linker == "asMetaclass")
                object = exported->behavior()->slot(Egg::Offsets::BehaviorClass);
            if (object && !Egg::FileImageSegment::isExternalReference(reinterpret_cast<uintptr_t>(object)))
                return object;
        }
    }
    if (segment && tokens.size() == 4 && (linker == "asMethod" || linker == "asMetaclassMethod")) {
        auto it = segment->_exports.find(tokens[2]);
        auto selector = _symbols.find(tokens[3]);
        if (it != segment->_exports.end() && selector != _symbols.end()) {
            auto species = it->second;
            auto behavior = linker == "asMethod"
                ? species->slot(Egg::Offsets::SpeciesInstanceBehavior)->asHeapObject()
                : species->behavior();
            auto method = this->methodIn(behavior, selector->second);
            if (method)
                return method;
        }
    }
    std::string import;
    for (auto& token : tokens)
        import += " " + token;
    throw std::runtime_error("the launcher cannot bind the import" + import);
}

Egg::Object* Launcher::methodIn(Egg::HeapObject* behavior, Egg::Object* selector)
{
    auto dictionary = behavior->slot(Egg::Offsets::BehaviorMethodDictionary)->asHeapObject();
    auto table = dictionary->slot(Egg::Offsets::DictionaryTable)->asHeapObject();
    for (uintptr_t i = 1; i + 1 < table->size(); i += 2)
        if (table->slot(i) == selector)
            return table->slot(i + 1);
    return nullptr;
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

void* Launcher::entry(const std::string& name)
{
    auto nativeCode = exported(name);
    auto machineCode = reinterpret_cast<Egg::HeapObject*>(nativeCode->slot(0));
    return &machineCode->byte(0);
}

uint64_t Launcher::run(const std::string& name)
{
    return reinterpret_cast<uint64_t (*)()>(this->entry(name))();
}

} // namespace lmr
