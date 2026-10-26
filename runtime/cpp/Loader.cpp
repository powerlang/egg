/*
    Copyright (c) 2019-2025 Javier Pimás, Jan Vrany, Labware.
    See (MIT) license in root directory.
 */

#include "Loader.h"
#include "Bootstrap/Bootstrapper.h"
#include "Bootstrap/SourceModuleLoader.h"
#include "FileImageSegment.h"
#include <algorithm>
#include <iostream>
#include <stdexcept>

namespace Egg {

Loader::Loader(const std::string& modulesDir)
    : _modulesDir(modulesDir), _runtime(nullptr), _kernel(nullptr) {
}

Loader::~Loader() {
}

std::string Loader::findModulesDir_() {
    namespace fs = std::filesystem;
    if (fs::exists(_modulesDir))
        return _modulesDir;

    std::vector<std::string> prefixes = {
        "./", "../", "../../", "../../../", "../../../../"
    };
    for (const auto& prefix : prefixes) {
        auto candidate = prefix + _modulesDir;
        if (fs::exists(candidate))
            return candidate;
    }
    return "";
}

bool Loader::hasEmsFile_(const std::string& name) {
    auto searched = "image-segments/" + name + ".ems";
    for (const auto& dir : {"./", "../"}) {
        if (std::filesystem::exists(std::filesystem::path(dir) / searched))
            return true;
    }
    return false;
}

bool Loader::hasSourceDir_(const std::string& name) {
    namespace fs = std::filesystem;
    auto modulesRoot = findModulesDir_();
    if (modulesRoot.empty()) return false;
    auto moduleDir = fs::path(modulesRoot) / modulePath_(name);
    return fs::exists(moduleDir) && fs::is_directory(moduleDir);
}

Runtime* Loader::loadKernel() {
    namespace fs = std::filesystem;
    auto modulesRoot = findModulesDir_();

    auto kernelPath = (fs::path(modulesRoot) / "Kernel").string();
    if (!fs::exists(kernelPath)) {
        std::cerr << "Cannot bootstrap: Kernel module source directory not found at "
                  << kernelPath << std::endl;
        return nullptr;
    }

    Bootstrapper bootstrapper(kernelPath, this);
    _runtime = bootstrapper.bootstrap();
    _kernel = _runtime->_kernel;

    // Register the kernel module as loaded so Kernel load: #Kernel works
    _loadedModules["Kernel"] = _kernel->_exports["__module__"];

    return _runtime;
}

HeapObject* Loader::loadModule_(const std::string& name) {
    // 1. Already loaded?
    auto it = _loadedModules.find(name);
    if (it != _loadedModules.end()) {
        return it->second;
    }

    HeapObject* module = nullptr;

    // 2. .ems file available?
    if (hasEmsFile_(name)) {
        auto imageSegment = _segments.count(name) ? _segments[name] : loadModuleFromFile(name + ".ems");
        module = imageSegment->_exports["__module__"];
    }
    // 3. Source directory available?
    else if (hasSourceDir_(name)) {
        namespace fs = std::filesystem;
        auto modulesRoot = findModulesDir_();
        auto modPath = (fs::path(modulesRoot) / modulePath_(name)).string();
        SourceModuleLoader sourceLoader(_runtime);
        module = sourceLoader.loadModuleFromSource(modPath);
    }
    else {
        throw std::runtime_error("Module not found: " + name);
    }

    _loadedModules[name] = module;
    return module;
}

std::string Loader::modulePath_(const std::string& name) {
    std::string path = name;
    std::replace(path.begin(), path.end(), '.', '/');
    return path;
}

HeapObject* Loader::loadModuleFromPath_(const std::string& path) {
    namespace fs = std::filesystem;
    fs::path fsPath(path);
    HeapObject* module = nullptr;

    // Derive a stable dotted module name from the path. For .ems we use the
    // filename without extension (writer encodes dotted name in the filename).
    // For a source directory we strip the modules-root prefix and replace
    // path separators with dots, e.g. "modules/Kernel/LMR" -> "Kernel.LMR".
    std::string name;
    if (fsPath.extension() == ".ems") {
        name = fsPath.stem().string();
    } else {
        auto modulesRoot = findModulesDir_();
        std::string relative = path;
        if (!modulesRoot.empty()) {
            auto rootCanon = fs::weakly_canonical(modulesRoot).string();
            auto pathCanon = fs::weakly_canonical(fsPath).string();
            if (pathCanon.rfind(rootCanon, 0) == 0) {
                relative = pathCanon.substr(rootCanon.size());
                if (!relative.empty() && relative.front() == '/') relative.erase(0, 1);
            }
        }
        name = relative;
        std::replace(name.begin(), name.end(), '/', '.');
        if (name.empty()) name = fsPath.filename().string();
    }

    // Already loaded?
    auto it = _loadedModules.find(name);
    if (it != _loadedModules.end())
        return it->second;

    // If path ends with .ems, load as image segment
    if (fsPath.extension() == ".ems" && fs::exists(fsPath)) {
        auto stream = std::ifstream(fsPath, std::ios::binary);
        auto imageSegment = new FileImageSegment(&stream);
        _segments[name] = imageSegment;
        std::vector<Object*> imports;
        this->bindModuleImports(imageSegment, imports);
        imageSegment->fixPointerSlots(imports);
        this->_runtime->addSegmentSpace_(imageSegment);
        module = imageSegment->_exports["__module__"];
    }
    // If path is a directory, load from source
    else if (fs::is_directory(fsPath)) {
        SourceModuleLoader sourceLoader(_runtime);
        module = sourceLoader.loadModuleFromSource(path);
    }
    else {
        throw std::runtime_error("Module not found at path: " + path);
    }

    _loadedModules[name] = module;
    return module;
}

// .ems loading support methods

FileImageSegment* Loader::loadModuleFromFile(const std::string &filename) {
    auto filepath = this->findInPath(filename);
    auto stream = std::ifstream(filepath, std::ios::binary);
    auto imageSegment = new FileImageSegment(&stream);
    std::vector<Object*> imports;
    this->bindModuleImports(imageSegment, imports);
    imageSegment->fixPointerSlots(imports);
    this->_runtime->addSegmentSpace_(imageSegment);
    return imageSegment;
}

void Loader::bindModuleImports(FileImageSegment *imageSegment, std::vector<Object*> &imports) {
    for (size_t i = 0; i < imageSegment->_importDescriptors.size(); i++) {
        imports.push_back(this->bindModuleImport(imageSegment, imageSegment->_importDescriptors[i]));
    }
}

Object* Loader::bindModuleImport(FileImageSegment* imageSegment, std::vector<std::uint32_t> &descriptor) {
    auto linker = this->importStringAt_(imageSegment, descriptor[0]);
    HeapObject *token;
    if (descriptor.size() == 1)
        token = this->_kernel->_exports["nil"];
    else if (descriptor.size() == 2)
        token = this->importStringAt_(imageSegment, descriptor[1]);
    else {
        std::vector<HeapObject*> array;
        for (size_t i = 1; i < descriptor.size(); i++)
            array.push_back(this->importStringAt_(imageSegment, descriptor[i]));
        token = this->transferArray(array);
    }

    auto ref = this->_runtime->sendLocal_to_with_with_("linker:token:", (Object*)this->_kernel->_exports["SymbolicReference"], (Object*)linker, (Object*)token);
    return this->_runtime->sendLocal_to_("link", ref);
}

HeapObject* Loader::importStringAt_(FileImageSegment* imageSegment, uint32_t index) {
    return this->transferSymbol(imageSegment->importStringAt_(index));
}

HeapObject* Loader::transferSymbol(std::string &str) {
    return this->_runtime->addSymbol_(str);
}

HeapObject* Loader::transferArray(std::vector<HeapObject*> &array) {
    return this->_runtime->newArray_(array);
}

HeapObject* Loader::transferArray(std::vector<Object*> &array) {
    return this->_runtime->newArray_(array);
}

std::filesystem::path Loader::findInPath(const std::string &filename) {
    std::vector<std::string> dirs({"./", "../"});
    auto searched = "image-segments/" + filename;
    for (auto& dir : dirs) {
        auto filePath = std::filesystem::path(dir) / searched;
        if (std::filesystem::exists(filePath))
            return filePath;
    }

    auto str = std::string("could not find module snapshot file ") + filename;
    error(str.c_str());
    std::terminate();
}

// Bare testing support

FileImageSegment* Loader::bareLoadModuleFromFile(const std::string &filename) {
    auto filepath = this->findInPath(filename);
    auto stream = std::ifstream(filepath);
    auto imageSegment = new FileImageSegment(&stream);
    std::vector<Object*> imports;
    for (size_t i = 0; i < imageSegment->_importDescriptors.size(); i++) {
        std::vector<uint32_t> &descriptor = imageSegment->_importDescriptors[i];
        auto import = this->bareBindModuleImport(imageSegment, descriptor);
        std::cout << "import " << i << " is: " << import->printString() << std::endl;
        imports.push_back(import);
    }
    imageSegment->fixPointerSlots(imports);
    return imageSegment;
}

Object* Loader::bareBindModuleImport(FileImageSegment* imageSegment, std::vector<std::uint32_t> &descriptor) {
    auto linker = imageSegment->importStringAt_(descriptor[0]);
    std::vector<std::string> tokens;
    for (size_t i = 1; i < descriptor.size(); i++)
        tokens.push_back(imageSegment->importStringAt_(descriptor[i]));

    if (linker == "asSymbol") {
        auto symbol = _runtime->existingSymbolFrom_(tokens[0]);
        if (symbol == nullptr) {
            symbol = (Object*)_runtime->newString_(tokens[0]);
        }
        return (Object*)symbol;
    }
    if (linker == "nil")
        return (Object*)_runtime->_nilObj;
    if (linker == "true")
        return (Object*)_runtime->_trueObj;
    if (linker == "false")
        return (Object*)_runtime->_falseObj;
    if (linker == "asClass")
        return (Object*)_kernel->_exports[tokens[1]];
    if (linker == "asMetaclass")
        return (Object*)_runtime->speciesOf_((Object*)_kernel->_exports[tokens[1]]);
    if (linker == "asBehavior")
        return (Object*)_runtime->speciesInstanceBehavior_(_kernel->_exports[tokens[1]]);
    if (linker == "asMetaclassBehavior")
        return (Object*)_runtime->speciesInstanceBehavior_(_runtime->speciesOf_((Object*)_kernel->_exports[tokens[1]]));
    if (linker == "asModule")
        return (Object*)_kernel->_exports["__module__"];
    if (linker == "symbolTable")
        return (Object*)_kernel->_exports["SymbolTable"];
    if (linker == "nilToken") {
        auto hashTable = _kernel->_exports["HashTable"];
        auto symbol = _runtime->existingSymbolFrom_("NilToken");
        auto binding = (SAssociationBinding*)_runtime->_evaluator->context()->staticBindingForCvar_in_(symbol, hashTable);
        return binding->valueWithin_(_runtime->_evaluator->context());
    }
    ASSERT(false);
    std::terminate();
}

} // namespace Egg
