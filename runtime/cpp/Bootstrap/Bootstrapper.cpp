/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "Bootstrapper.h"
#include "../Loader.h"
#include "BootstrappedKernel.h"
#include "TonelReader.h"
#include "../Allocator/Memory.h"
#include "../Allocator/GCHeap.h"
#include "../Compiler/SSmalltalkCompiler.h"
#include "../Compiler/LiteralValue.h"
#include "../Compiler/Backend/SCompiledMethod.h"
#include "../Compiler/CompilationResult.h"
#include "../KnownConstants.h"
#include "../GCedRef.h"

#include <algorithm>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <sstream>
#include <iostream>

namespace Egg {

Bootstrapper::Bootstrapper(const std::string& kernelPath, Loader* loader)
    : _loader(loader), _symbolProvider(new BootstrapSymbolProvider(this)),
      _kernelPath(kernelPath),
      _space(nullptr),
      _nilObj(nullptr), _trueObj(nullptr), _falseObj(nullptr),
      _kernelModule(nullptr), _compiledMethodClass(nullptr),
      _undefinedObjectClass(nullptr), _trueClass(nullptr), _falseClass(nullptr),
      _classClass(nullptr), _metaclassClass(nullptr),
      _symbolClass(nullptr), _wideSymbolClass(nullptr),
      _stringClass(nullptr), _wideStringClass(nullptr),
      _arrayClass(nullptr), _methodDictionaryClass(nullptr) {
    _compiler = std::make_unique<SSmalltalkCompiler>();
    _methodDictBuilder = std::make_unique<ArrayMethodDictBuilder>(this);
}

Bootstrapper::~Bootstrapper() {
}

// =========================================================================
// Main bootstrap
// =========================================================================

Runtime* Bootstrapper::bootstrap() {
    // Allocate GC space for kernel objects (128MB)
    uintptr_t segmentSize = 128 * 1024 * 1024;
    _space = new GCSpace(segmentSize);
    _space->commitMemory_(segmentSize);
    _space->increaseSoftLimit_(segmentSize);
    _loader->_runtime = nullptr;

    loadKernelSpecs();
    createInitialObjects();
    instantiateMetaobjects();
    initializeMetaobjects();
    createKernelNamespace();
    loadKernelMethods();
    createRuntimeWithBootstrappedKernel();

    return _loader->_runtime;
}

// =========================================================================
// Phase 1: Parse class definitions
// =========================================================================

void Bootstrapper::createInitialObjects() {
    _nilObj = allocateSlots_(0);
    _trueObj = allocateSlots_(0);
    _falseObj = allocateSlots_(0);
}

void Bootstrapper::loadKernelSpecs() {
    namespace fs = std::filesystem;
    TonelReader reader;

    for (const auto& entry : fs::directory_iterator(_kernelPath)) {
        if (entry.path().extension() == ".st") {
            std::string filename = entry.path().filename().string();
            std::string className = filename.substr(0, filename.length() - 3);

            if (className == "package") continue;

            std::string source = readSourceFile_(className);
            ClassSpec* spec = reader.parseFile(source, entry.path().string());
            _moduleSpec.addClass(spec);
        }
    }

    // Load VM extension methods from Kernel/VM/ directory
    auto vmPath = _kernelPath + "/VM";
    if (fs::exists(vmPath) && fs::is_directory(vmPath)) {
        for (const auto& entry : fs::directory_iterator(vmPath)) {
            if (entry.path().extension() == ".st") {
                std::string filename = entry.path().filename().string();
                std::string className = filename.substr(0, filename.length() - 3);

                if (className == "package") continue;

                std::ifstream file(entry.path());
                if (!file.is_open()) continue;
                std::string source((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());

                ClassSpec* extensionSpec = reader.parseFile(source, entry.path().string());
                ClassSpec* existingSpec = _moduleSpec.resolveClass(className);
                if (!existingSpec) {
                    std::cerr << "  Warning: VM extension for unknown class " << className << std::endl;
                    delete extensionSpec->metaclass();
                    delete extensionSpec;
                    continue;
                }

                for (const auto& m : extensionSpec->methods())
                    existingSpec->addMethod(m);
                for (const auto& m : extensionSpec->metaclass()->methods())
                    existingSpec->metaclass()->addMethod(m);

                delete extensionSpec->metaclass();
                delete extensionSpec;
            }
        }
    }
}

std::string Bootstrapper::readSourceFile_(const std::string& className) {
    std::string filename = _kernelPath + "/" + className + ".st";
    std::ifstream file(filename);

    if (!file.is_open()) {
        throw std::runtime_error("Cannot open file: " + filename);
    }

    std::stringstream buffer;
    buffer << file.rdbuf();
    return buffer.str();
}

// =========================================================================
// Phase 3 & 4: Metaobject creation and initialization
// =========================================================================

void Bootstrapper::instantiateMetaobjects() {
    for (const auto& [name, spec] : _moduleSpec.classes()) {
        instantiateMetaobjectsOf_(name);
    }
}

void Bootstrapper::initializeMetaobjects() {
    // Cache pointers to frequently-used classes
    _metaclassClass = _classes["Metaclass"];
    _classClass = _classes["Class"];
    _undefinedObjectClass = _classes["UndefinedObject"];
    _trueClass = _classes["True"];
    _falseClass = _classes["False"];
    _symbolClass = _classes["Symbol"];
    _wideSymbolClass = _classes["WideSymbol"];
    _stringClass = _classes["String"];
    _wideStringClass = _classes["WideString"];
    _arrayClass = _classes["Array"];
    _methodDictionaryClass = _classes["MethodDictionary"];
    _compiledMethodClass = _classes["CompiledMethod"];

    for (const auto& [name, spec] : _moduleSpec.classes()) {
        initializeMetaobjectsOf_(name);
    }

    // Set behaviors on pre-existing objects
    _nilObj->behavior(_behaviors["UndefinedObject"]);
    _trueObj->behavior(_behaviors["True"]);
    _falseObj->behavior(_behaviors["False"]);
}

uint32_t Bootstrapper::instSizeOf_(const Egg::string& className) {
    ClassSpec* spec = _moduleSpec.resolveClass(className);
    if (spec) {
        if (spec->superclass())
            return spec->instSize();
        uint32_t count = spec->instVarNames().size();
        auto supername = spec->supername();
        if (!supername.empty() && supername != U"nil") {
            auto it = _classes.find(supername);
            if (it != _classes.end()) {
                auto format = it->second->slot(Offsets::SpeciesFormat)->asSmallInteger()->asNative();
                count += format & 0x7F;
            }
        }
        return count;
    }
    auto it = _classes.find(className);
    if (it != _classes.end()) {
        auto formatObj = it->second->slot(Offsets::SpeciesFormat);
        return formatObj->asSmallInteger()->asNative() & 0x7F;
    }
    error(("instSizeOf_: class not found: " + std::string(className.begin(), className.end())).c_str());
    return 0;
}

void Bootstrapper::instantiateMetaobjectsOf_(const Egg::string& className) {
    uint32_t classSlots = instSizeOf_("Class");
    uint32_t metaclassSlots = instSizeOf_("Metaclass");
    uint32_t behaviorSlots = instSizeOf_("Behavior");

    ClassSpec* spec = _moduleSpec.resolveClass(className);
    uint32_t classInstVarCount = spec->metaclass()->instVarNames().size();

    HeapObject* metaclass = allocateSlots_(metaclassSlots);
    metaclass->beNamed();
    for (uint32_t i = 0; i < metaclassSlots; i++)
        metaclass->untypedSlot(i) = (Object*)_nilObj;

    HeapObject* cls = allocateSlots_(classSlots + classInstVarCount);
    cls->beNamed();
    for (uint32_t i = 0; i < classSlots + classInstVarCount; i++)
        cls->untypedSlot(i) = (Object*)_nilObj;

    HeapObject* behavior = allocateSlots_(behaviorSlots);
    for (uint32_t i = 0; i < behaviorSlots; i++)
        behavior->untypedSlot(i) = (Object*)_nilObj;

    HeapObject* metaBehavior = allocateSlots_(behaviorSlots);
    for (uint32_t i = 0; i < behaviorSlots; i++)
        metaBehavior->untypedSlot(i) = (Object*)_nilObj;

    _classes[className] = cls;
    _metaclasses[className] = metaclass;
    _behaviors[className] = behavior;
    _metaBehaviors[className] = metaBehavior;
}

void Bootstrapper::initializeMetaobjectsOf_(const Egg::string& className) {
    ClassSpec* spec = _moduleSpec.resolveClass(className);

    HeapObject* cls = _classes[className];
    HeapObject* metaclass = _metaclasses[className];
    HeapObject* behavior = _behaviors[className];
    HeapObject* metaBehavior = _metaBehaviors[className];
    HeapObject* behaviorClassBehavior = _behaviors["Behavior"];

    // --- Link class header -> metaclass's instance behavior ---
    cls->behavior(metaBehavior);

    // --- Link metaclass header -> Metaclass's instance behavior ---
    metaclass->behavior(_behaviors["Metaclass"]);

    // --- Metaclass slots ---
    metaclass->slot(Offsets::MetaclassClass) = (Object*)cls;
    metaclass->slot(Offsets::SpeciesInstanceBehavior) = (Object*)metaBehavior;

    uint32_t classInstVarCount = spec->metaclass()->instVarNames().size();
    uint32_t metaclassInstSize = instSizeOf_("Class") + classInstVarCount;
    uint32_t metaFormat = (metaclassInstSize & 0x7F) | 0x4000;
    metaclass->slot(Offsets::SpeciesFormat) = newSmallInteger_(metaFormat);

    // --- Class slots ---
    uint32_t format = spec->instSize() & 0x7F;
    if (spec->isVariable())
        format |= 0x2000;
    if (spec->isPointers())
        format |= 0x4000;
    cls->slot(Offsets::SpeciesFormat) = newSmallInteger_(format);
    cls->slot(Offsets::SpeciesInstanceBehavior) = (Object*)behavior;
    cls->slot(Offsets::ClassName) = internSymbol_(spec->name());

    // Create instance variables array
    const auto& ivarNames = spec->instVarNames();
    if (!ivarNames.empty()) {
        HeapObject* ivars = newArray_(ivarNames.size());
        for (size_t i = 0; i < ivarNames.size(); i++) {
            ivars->untypedSlot(i) = internSymbol_(ivarNames[i]);
        }
        cls->slot(Offsets::SpeciesInstanceVariables) = (Object*)ivars;
    }

    // Set metaclass instance variables
    const auto& classInstVarNames = spec->metaclass()->instVarNames();
    if (!classInstVarNames.empty()) {
        HeapObject* metaIvars = newArray_(classInstVarNames.size());
        for (size_t i = 0; i < classInstVarNames.size(); i++) {
            metaIvars->untypedSlot(i) = internSymbol_(classInstVarNames[i]);
        }
        metaclass->slot(Offsets::SpeciesInstanceVariables) = (Object*)metaIvars;
    }

    // --- Instance behavior slots ---
    behavior->behavior(behaviorClassBehavior);
    behavior->slot(Offsets::BehaviorClass) = (Object*)cls;
    behavior->slot(Offsets::BehaviorMethodDictionary) = (Object*)newMethodArray();

    // --- Metaclass instance behavior slots ---
    metaBehavior->behavior(behaviorClassBehavior);
    metaBehavior->slot(Offsets::BehaviorClass) = (Object*)metaclass;
    metaBehavior->slot(Offsets::BehaviorMethodDictionary) = (Object*)newMethodArray();

    // --- Superclass and behavior chain linking ---
    const auto& supername = spec->supername();
    if (!supername.empty() && supername != "nil") {
        auto superIt = _classes.find(supername);
        if (superIt != _classes.end()) {
            cls->slot(Offsets::SpeciesSuperclass) = (Object*)superIt->second;
            _metaclasses[className]->slot(Offsets::SpeciesSuperclass) = (Object*)_metaclasses[supername];
            behavior->slot(Offsets::BehaviorNext) = (Object*)_behaviors[supername];
            metaBehavior->slot(Offsets::BehaviorNext) = (Object*)_metaBehaviors[supername];
        } else {
            std::cerr << "  Warning: Superclass " << supername
                      << " not found for " << className << std::endl;
        }
    } else {
        auto classIt = _behaviors.find("Class");
        if (classIt != _behaviors.end()) {
            _metaclasses[className]->slot(Offsets::SpeciesSuperclass) = (Object*)_classes["Class"];
            metaBehavior->slot(Offsets::BehaviorNext) = (Object*)classIt->second;
        }
    }
}

// =========================================================================
// Phase 5: Create kernel namespace
// =========================================================================

void Bootstrapper::createKernelNamespace() {
    std::vector<std::pair<Object*, HeapObject*>> entries;
    for (const auto& entry : _classes) {
        const auto& className = entry.first;
        HeapObject* cls = entry.second;

        Object* key = internSymbol_(className);
        HeapObject* assoc = newAssociation_value_(key, (Object*)cls);
        entries.push_back({key, assoc});
    }
    // Add WordSize constant
    {
        Object* key = internSymbol_("WordSize");
        HeapObject* assoc = newAssociation_value_(key, (Object*)newSmallInteger_(sizeof(void*)));
        entries.push_back({key, assoc});
    }

    HeapObject* namespace_ = newDictionary_("Namespace", entries);

    // Create kernel module and set its slots
    _kernelModule = newSlots_("KernelModule");
    _kernelModule->slot(Offsets::ModuleName) = internSymbol_("Kernel");
    _kernelModule->slot(Offsets::ModuleNamespace) = (Object*)namespace_;

    // Add Kernel module reference to namespace
    {
        Object* key = internSymbol_("Kernel");
        HeapObject* assoc = newAssociation_value_(key, (Object*)_kernelModule);
        insertInOpenHashTable_(
            namespace_->slot(Offsets::DictionaryTable)->asHeapObject(),
            namespace_->slot(Offsets::DictionaryTable)->asHeapObject()->size() - 1,
            key, assoc);
        namespace_->untypedSlot(Offsets::DictionaryTally) = newSmallInteger_(
            ((intptr_t)namespace_->untypedSlot(Offsets::DictionaryTally) >> 1) + 1);
    }

    // Create an empty namespaces array for classes without class variables
    HeapObject* emptyNamespacesArray = allocateSlots_(0);
    emptyNamespacesArray->behavior(_behaviors["Array"]);
    emptyNamespacesArray->beArrayed();

    // Set up each class: ClassNamespaces and ClassModule
    for (const auto& entry : _classes) {
        const auto& className = entry.first;
        HeapObject* cls = entry.second;

        cls->slot(Offsets::ClassModule) = (Object*)_kernelModule;

        ClassSpec* spec = _moduleSpec.resolveClass(className);
        if (spec && !spec->classVarNames().empty()) {
            auto& cvars = spec->classVarNames();

            std::vector<std::pair<Object*, HeapObject*>> cvarEntries;
            for (size_t j = 0; j < cvars.size(); j++) {
                Object* key = internSymbol_(cvars[j]);
                HeapObject* assoc = newAssociation_value_(key, (Object*)_nilObj);
                cvarEntries.push_back({key, assoc});
            }
            HeapObject* cvarNamespace = newDictionary_("Namespace", cvarEntries);

            HeapObject* namespacesArray = allocateSlots_(1);
            namespacesArray->behavior(_behaviors["Array"]);
            namespacesArray->beArrayed();
            namespacesArray->slot(0) = (Object*)cvarNamespace;
            cls->slot(Offsets::ClassNamespaces) = (Object*)namespacesArray;
        } else {
            cls->slot(Offsets::ClassNamespaces) = (Object*)emptyNamespacesArray;
        }
    }
}

// =========================================================================
// Phase 6: Compile and install methods
// =========================================================================

void Bootstrapper::loadKernelMethods() {
    for (const auto& [className, spec] : _moduleSpec.classes()) {
        auto it = _classes.find(className);
        if (it == _classes.end()) {
            std::cerr << "  Warning: Class " << className << " not found in registry" << std::endl;
            continue;
        }

        HeapObject* cls = it->second;

        for (const auto& method : spec->methods()) {
            try {
                compileAndInstallMethod_(method.source(), cls);
            } catch (const std::exception& e) {
                std::cerr << "  Warning: Failed to compile instance method" << std::endl;
                std::cerr << "    " << e.what() << std::endl;
            }
        }

        HeapObject* metaclass = _metaclasses[className];
        for (const auto& method : spec->metaclass()->methods()) {
            try {
                compileAndInstallMethod_(method.source(), metaclass);
            } catch (const std::exception& e) {
                std::cerr << "  Warning: Failed to compile class method" << std::endl;
                std::cerr << "    " << e.what() << std::endl;
            }
        }
    }
}

// =========================================================================
// Phase 7: Create Runtime
// =========================================================================

void Bootstrapper::createRuntimeWithBootstrappedKernel() {
    uintptr_t spaceBase = _space->base();
    uintptr_t spaceSize = _space->reservedSize();
    uintptr_t objectsEnd = _space->next();

    BootstrappedKernel* kernel = new BootstrappedKernel(spaceBase, spaceSize, objectsEnd);

    kernel->addExport("nil", _nilObj);
    kernel->addExport("true", _trueObj);
    kernel->addExport("false", _falseObj);
    kernel->addExport("Kernel", _kernelModule);
    kernel->addExport("__module__", _kernelModule);

    kernel->addExport("Array", _classes.at("Array"));
    kernel->addExport("Metaclass", _metaclassClass);
    kernel->addExport("CompiledMethod", _classes.at("CompiledMethod"));
    kernel->addExport("SmallInteger", _classes.at("SmallInteger"));
    kernel->addExport("LargePositiveInteger", _classes.at("LargePositiveInteger"));
    kernel->addExport("LargeNegativeInteger", _classes.at("LargeNegativeInteger"));
    kernel->addExport("Float", _classes.at("Float"));
    kernel->addExport("CompiledBlock", _classes.at("CompiledBlock"));
    kernel->addExport("ByteArray", _classes.at("ByteArray"));
    kernel->addExport("String", _stringClass);
    kernel->addExport("Closure", _classes.at("Closure"));
    kernel->addExport("Behavior", _classes.at("Behavior"));
    kernel->addExport("Ephemeron", _classes.at("Ephemeron"));
    kernel->addExport("ProcessVMStack", _classes.at("ProcessVMStack"));
    kernel->addExport("OpenHashTable", _classes.at("OpenHashTable"));
    kernel->addExport("Character", _classes.at("Character"));

    _loader->_runtime = new Runtime(_loader, kernel, _symbolProvider);
    _loader->_runtime->addSegmentSpace_(kernel);
    _loader->_runtime->initializeEvaluator();
    _loader->_runtime->initializeClosureReturnMethod();

    // Send #bootstrap to the kernel module
    auto bootstrapSymbol = _symbolProvider->symbols().at("bootstrap");
    _loader->_runtime->send_to_(bootstrapSymbol, (Object*)_kernelModule);

    // Fill symbol table
    fillSymbolTable();

    // Convert Array method dicts to proper MethodDictionary objects, then
    // switch from array-based to Smalltalk message-based method installation
    convertMethodDictionaries();
    _methodDictBuilder = std::make_unique<SmalltalkMethodDictBuilder>(_loader->_runtime);
}

// =========================================================================
// Phase 8: Fill symbol table
// =========================================================================

void Bootstrapper::fillSymbolTable() {
    auto symbolClass = (Object*)_classes.at("Symbol");

    auto table = _loader->_runtime->sendLocal_to_("symbolTable", symbolClass);
    GCedRef tableRef(table);

    for (const auto& [name, symbol] : _symbolProvider->symbols()) {
        _loader->_runtime->sendLocal_to_with_("add:", tableRef.get(), symbol);
    }

    _loader->_runtime->switchToDynamicSymbolProvider_(tableRef.get()->asHeapObject());
}

// =========================================================================
// Phase 9: Convert Array method dicts to proper MethodDictionary objects
// =========================================================================

void Bootstrapper::convertMethodDictionaries() {
    for (const auto& [className, cls] : _classes) {
        convertBehaviorMethodDict_(cls);
        convertBehaviorMethodDict_(_metaclasses.at(className));
    }
}

void Bootstrapper::convertBehaviorMethodDict_(HeapObject* species) {
    auto runtime = _loader->_runtime;
    HeapObject* behavior = species->slot(Offsets::SpeciesInstanceBehavior)->asHeapObject();
    Object* mdObj = behavior->slot(Offsets::BehaviorMethodDictionary);

    HeapObject* md = mdObj->asHeapObject();
    ASSERT (runtime->speciesOf_((Object*)md) == _arrayClass);

    // Count actual methods in the array (stops at first nil selector)
    uint32_t count = 0;
    uint32_t size = md->size();
    for (uint32_t i = 0; i + 1 < size; i += 2) {
        if (md->slot(i) == (Object*)_nilObj) break;
        count++;
    }

    // Create MethodDictionary new: count and populate via public API
    auto mdClassObj = (Object*)_classes.at("MethodDictionary");
    auto sizeArg = (Object*)runtime->newInteger_(count);
    auto newMd = runtime->sendLocal_to_with_("new:", mdClassObj, sizeArg);
    GCedRef newMdRef(newMd);

    for (uint32_t i = 0; i + 1 < size; i += 2) {
        Object* selector = md->slot(i);
        if (selector == (Object*)_nilObj) break;
        Object* method = md->slot(i + 1);
        runtime->sendLocal_to_with_with_("at:put:", newMdRef.get(), selector, method);
    }

    // Replace the behavior's method dict
    behavior->slot(Offsets::BehaviorMethodDictionary) = newMdRef.get();
}

// =========================================================================
// Kernel-specific hash table helpers
// =========================================================================

HeapObject* Bootstrapper::newOpenHashTable_(uint32_t indexedSize, HeapObject* owner) {
    uint32_t totalSlots = 1 + indexedSize;
    HeapObject* table = newSlots_sized_("OpenHashTable", totalSlots);
    table->slot(0) = (Object*)owner;
    return table;
}

void Bootstrapper::insertInOpenHashTable_(HeapObject* table, uint32_t indexedSize, Object* key, HeapObject* assoc) {
    uint32_t hash = key->asHeapObject()->hash();
    uint32_t index = (hash % indexedSize);
    uint32_t originalIndex = index;
    do {
        Object* existing = table->slot(1 + index);
        if (existing == (Object*)_nilObj) {
            table->slot(1 + index) = (Object*)assoc;
            return;
        }
        index = (index + 1) % indexedSize;
    } while (index != originalIndex);
    std::cerr << "ERROR: OpenHashTable full during bootstrap!" << std::endl;
}

HeapObject* Bootstrapper::newDictionary_(const Egg::string& behaviorName,
    std::vector<std::pair<Object*, HeapObject*>>& entries) {
    uint32_t count = entries.size();
    uint32_t targetSize = std::max(7u, count * 3 / 2);
    static const uint32_t primes[] = {7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53,
        59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139,
        149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229,
        233, 239, 241, 251, 269, 359, 479, 641, 857};
    uint32_t primeSize = targetSize;
    for (uint32_t p : primes) {
        if (p >= targetSize) { primeSize = p; break; }
    }

    HeapObject* dict = newSlots_(behaviorName);
    dict->untypedSlot(Offsets::DictionaryTally) = newSmallInteger_(count);

    HeapObject* table = newOpenHashTable_(primeSize, dict);
    dict->slot(Offsets::DictionaryTable) = (Object*)table;

    for (auto& [key, assoc] : entries) {
        insertInOpenHashTable_(table, primeSize, key, assoc);
    }
    return dict;
}

// =========================================================================
// Method compilation
// =========================================================================

void Bootstrapper::compileAndInstallMethod_(const Egg::string& source, HeapObject* cls) {
    CompilationResult* result = _compiler->compileMethod_(source);
    SCompiledMethod* smethod = static_cast<SCompiledMethod*>(result->method());
    if (!smethod) {
        std::cerr << "ERROR: Failed to compile method from source: '"
                  << source.substr(0, std::min(source.length(), size_t(60))) << "...'" << std::endl;
        std::exit(1);
    }

    Egg::string selector = smethod->selector();

    const auto& treecodes = smethod->treecodes();
    const auto& literals = smethod->literals();
    uint32_t literalCount = literals.size();

    // Transfer the compiled method to a heap object
    HeapObject* method = allocateSlots_(Offsets::MethodInstSize + literalCount);
    method->beNamed();
    method->beArrayed();

    // Set method's behavior to CompiledMethod's instance behavior
    Object* cmBehavior = _compiledMethodClass->slot(Offsets::SpeciesInstanceBehavior);
    if (cmBehavior && cmBehavior != (Object*)_nilObj) {
        method->behavior(cmBehavior->asHeapObject());
    }

    method->slot(Offsets::MethodFormat) = (Object*)newSmallInteger_(smethod->format());
    method->slot(Offsets::MethodExecutableCode) = (Object*)_nilObj;
    method->slot(Offsets::MethodTreecodes) = (Object*)newByteArray_(treecodes);
    method->slot(Offsets::MethodClassBinding) = (Object*)cls;
    method->slot(Offsets::MethodSelector) = internSymbol_(selector);
    method->slot(Offsets::MethodSourceCode) = (Object*)newString_(source);

    // Transfer literals
    for (uint32_t i = 0; i < literalCount; i++) {
        method->slot(Offsets::MethodInstSize + i) = transferLiteral_(literals[i], method);
    }

    // Install in behavior's method dictionary
    _methodDictBuilder->installMethod((Object*)cls, internSymbol_(selector), (Object*)method);
}

Object* Bootstrapper::transferLiteral_(const LiteralValue& lit, HeapObject* method) {
    switch (lit.tag) {
        case LiteralValue::Symbol:
            return internSymbol_(lit.asString());
        case LiteralValue::String:
            return (Object*)newString_(lit.asString());
        case LiteralValue::Integer:
            return (Object*)newSmallInteger_((intptr_t)lit.asInteger());
        case LiteralValue::LargeInteger:
            return (Object*)newLargeInteger_(lit.asLargeIntegerBytes(), lit.isLargeIntegerNegative());
        case LiteralValue::Float: {
            double value = lit.asFloat();
            return (Object*)newBytes_("Float", &value, sizeof(double));
        }
        case LiteralValue::Character:
            return transferCharacter_(lit.asCharacter());
        case LiteralValue::Boolean:
            return (Object*)(lit.asBoolean() ? _trueObj : _falseObj);
        case LiteralValue::Nil:
            return (Object*)_nilObj;
        case LiteralValue::Array:
            return (Object*)transferArray_(lit.asArray());
        case LiteralValue::ByteArray:
            return (Object*)newByteArray_(lit.asByteArray());
        case LiteralValue::Block:
            return (Object*)transferBlock_(lit.asBlock(), method);
        default:
            error("transferLiteral_: unimplemented literal tag");
            return (Object*)_nilObj;
    }
}

Object* Bootstrapper::transferCharacter_(uint32_t codePoint) {
    auto it = _characterMap.find(codePoint);
    if (it != _characterMap.end()) return (Object*)it->second;
    HeapObject* character = newSlots_("Character");
    character->slot(0) = (Object*)newSmallInteger_((intptr_t)codePoint);
    _characterMap[codePoint] = character;
    return (Object*)character;
}

HeapObject* Bootstrapper::newLargeInteger_(const std::vector<uint8_t>& leBytes, bool negative) {
    const char* className = negative ? "LargeNegativeInteger" : "LargePositiveInteger";
    return newBytes_(className, leBytes.data(), (uint32_t)leBytes.size());
}

HeapObject* Bootstrapper::transferArray_(const std::vector<LiteralValue>& elements) {
    HeapObject* arr = newArray_(elements.size());
    arr->behavior(_behaviors["Array"]);
    for (size_t i = 0; i < elements.size(); i++) {
        arr->slot(i) = transferLiteral_(elements[i], nullptr);
    }
    return arr;
}

HeapObject* Bootstrapper::transferBlock_(const LiteralValue::BlockInfo& info, HeapObject* method) {
    HeapObject* block = allocateSlots_(3);

    auto it = _classes.find("CompiledBlock");
    if (it != _classes.end()) {
        Object* cbBehavior = it->second->slot(Offsets::SpeciesInstanceBehavior);
        if (cbBehavior && cbBehavior != (Object*)_nilObj) {
            block->behavior(cbBehavior->asHeapObject());
        }
    }

    uint32_t format = (info.argCount & 0x3F)
                    | ((info.tempCount & 0xFF) << 6)
                    | ((info.id & 0xFF) << 14)
                    | (info.capturesSelf ? 0x400000 : 0)
                    | (info.capturesHome ? 0x800000 : 0)
                    | ((info.envCount & 0x7F) << 24);

    block->slot(Offsets::BlockFormat) = (Object*)newSmallInteger_(format);
    block->slot(Offsets::BlockExecutableCode) = (Object*)_nilObj;
    block->slot(Offsets::BlockMethod) = (Object*)method;

    return block;
}

// =========================================================================
// Object creation helpers
// =========================================================================

HeapObject* Bootstrapper::newBytes_(const Egg::string& className, const void* data, uint32_t byteCount) {
    HeapObject* obj = allocateBytesRaw_(byteCount);
    obj->behavior(_behaviors[className]);
    if (data)
        std::memcpy((void*)obj, data, byteCount);
    return obj;
}

HeapObject* Bootstrapper::newSlots_(const Egg::string& className) {
    return newSlots_sized_(className, instSizeOf_(className));
}

HeapObject* Bootstrapper::newSlots_sized_(const Egg::string& className, uint32_t slotCount) {
    HeapObject* obj = allocateSlots_(slotCount);
    obj->behavior(_behaviors[className]);
    ClassSpec* spec = _moduleSpec.resolveClass(className);
    if (spec) {
        if (spec->instSize() > 0)
            obj->beNamed();
        if (spec->isVariable())
            obj->beArrayed();
    } else {
        auto it = _classes.find(className);
        if (it != _classes.end()) {
            auto format = it->second->slot(Offsets::SpeciesFormat)->asSmallInteger()->asNative();
            if ((format & 0x7F) > 0)
                obj->beNamed();
            if (format & 0x2000)
                obj->beArrayed();
        }
    }
    for (uint32_t i = 0; i < slotCount; i++)
        obj->untypedSlot(i) = (Object*)_nilObj;
    return obj;
}

HeapObject* Bootstrapper::newAssociation_value_(const Egg::string& key, Object* value) {
    return newAssociation_value_(internSymbol_(key), value);
}

HeapObject* Bootstrapper::newAssociation_value_(Object* key, Object* value) {
    HeapObject* assoc = newSlots_("Association");
    assoc->slot(Offsets::AssociationKey) = key;
    assoc->slot(Offsets::AssociationValue) = value;
    return assoc;
}

Object* Bootstrapper::internSymbol_(const Egg::string& str) {
    return _symbolProvider->symbolFor_(str);
}

Object* Bootstrapper::newSymbol_(const Egg::string& str) {
    bool isWide = std::ranges::any_of(str, [](char32_t cp) { return cp > 0xFF; });
    HeapObject* symbol;
    if (!isWide) {
        uint32_t len = str.size();
        symbol = newBytes_("Symbol", nullptr, len + 1);
        for (uint32_t i = 0; i < len; i++)
            ((uint8_t*)symbol)[i] = (uint8_t)str[i];
        ((uint8_t*)symbol)[len] = 0;
    } else {
        uint32_t len = str.size();
        symbol = newBytes_("WideSymbol", nullptr, len * 4);
        for (uint32_t i = 0; i < len; i++)
            ((uint32_t*)symbol)[i] = (uint32_t)str[i];
    }
    computeSymbolHash_(symbol);
    return (Object*)symbol;
}

void Bootstrapper::computeSymbolHash_(HeapObject* symbol) {
    uint32_t basicSize = symbol->size();
    int32_t pseudoindex = (int32_t)basicSize - 1;
    if (pseudoindex < 0) return;

    uint32_t begin = 0;
    uint32_t middle = (pseudoindex & 0xFFFF) / 2;
    uint32_t end = middle * 2;

    uint8_t* bytes = (uint8_t*)symbol;

    // uShortAtOffset reads LE 16-bit at byte offset, with out-of-bounds bytes = 0
    auto uShortAtOffset = [&](uint32_t offset) -> uint32_t {
        uint32_t index = offset; // 0-based byte index
        uint32_t lo = (index < basicSize) ? bytes[index] : 0;
        uint32_t hi = (index + 1 < basicSize) ? bytes[index + 1] : 0;
        return (hi << 8) + lo;
    };
    auto shortAtOffset = [&](uint32_t offset) -> int32_t {
        uint32_t u = uShortAtOffset(offset);
        return (u > 0x7FFF) ? (int32_t)(u - 0x10000) : (int32_t)u;
    };

    int32_t first = shortAtOffset(begin) + 256 * (pseudoindex & 0xFF);
    int32_t second = shortAtOffset(end);
    int32_t third = shortAtOffset(middle);
    uint16_t hash = (first + second * 4 + third * 4) & 0x7FFF;

    symbol->hash(hash);
}

HeapObject* Bootstrapper::newString_(const Egg::string& str) {
    bool isWide = std::ranges::any_of(str, [](char32_t cp) { return cp > 0xFF; });

    if (!isWide) {
        uint32_t len = str.size();
        HeapObject* string = newBytes_("String", nullptr, len + 1);
        for (uint32_t i = 0; i < len; i++)
            ((uint8_t*)string)[i] = (uint8_t)str[i];
        ((uint8_t*)string)[len] = 0;
        return string;
    } else {
        uint32_t len = str.size();
        HeapObject* string = newBytes_("WideString", nullptr, len * 4);
        for (uint32_t i = 0; i < len; i++)
            ((uint32_t*)string)[i] = (uint32_t)str[i];
        return string;
    }
}

HeapObject* Bootstrapper::newArray_(uint32_t size) {
    HeapObject* array = allocateSlots_(size);
    array->behavior(_behaviors["Array"]);
    array->beArrayed();
    return array;
}

HeapObject* Bootstrapper::newByteArray_(const std::vector<uint8_t>& bytes) {
    return newBytes_("ByteArray", bytes.data(), bytes.size());
}

HeapObject* Bootstrapper::newMethodArray() {
    uint32_t capacity = 1024;
    HeapObject* array = allocateSlots_(capacity);
    array->behavior(_behaviors["Array"]);
    for (uint32_t i = 0; i < capacity; i++) {
        array->slot(i) = (Object*)_nilObj;
    }
    return array;
}

void Bootstrapper::addMethodToArray_(HeapObject* array, Object* selector, Object* method) {
    uint32_t size = array->size();
    for (uint32_t i = 0; i < size; i += 2) {
        Object* existing = array->slot(i);
        if (existing == (Object*)_nilObj) {
            array->slot(i) = selector;
            array->slot(i + 1) = method;
            return;
        }
        if (existing == selector) {
            array->slot(i + 1) = method;
            return;
        }
    }
    throw std::runtime_error("Method array is full");
}

// =========================================================================
// Low-level memory allocation
// =========================================================================

uintptr_t Bootstrapper::align_(uintptr_t addr) {
    return (addr + 7) & ~7;
}

HeapObject* Bootstrapper::initializeHeader_(void* allocation, uint32_t size, uint8_t flags) {
    bool isSmall = (size <= HeapObject::MAX_SMALL_SIZE);
    if (isSmall) {
        HeapObject::SmallHeader* header = HeapObject::SmallHeader::at(allocation);
        header->size = (uint8_t)size;
        header->hash = 0;
        header->behavior = 0;
        header->flags = HeapObject::SmallHeader::IsSmall | flags;
        return header->object();
    } else {
        HeapObject::LargeHeader* header = HeapObject::LargeHeader::at(allocation);
        header->size = size;
        header->padding = 0;
        header->smallHeader.size = 0;
        header->smallHeader.hash = 0;
        header->smallHeader.behavior = 0;
        header->smallHeader.flags = flags;
        return header->object();
    }
}

HeapObject* Bootstrapper::allocateSlots_(uint32_t slotCount) {
    if (_loader->_runtime) {
        return _loader->_runtime->_heap->allocateSlots_(slotCount);
    }

    bool isSmall = (slotCount <= HeapObject::MAX_SMALL_SIZE);
    uintptr_t headerSize = isSmall ? sizeof(HeapObject::SmallHeader) : sizeof(HeapObject::LargeHeader);
    uintptr_t totalSize = align_(headerSize + slotCount * sizeof(Object*));

    uintptr_t allocation = _space->allocateCommittingIfNeeded_(totalSize);
    if (!allocation) {
        error("Bootstrapper: Out of memory");
        return nullptr;
    }

    return initializeHeader_((void*)allocation, slotCount, 0);
}

HeapObject* Bootstrapper::allocateBytesRaw_(uint32_t byteCount) {
    if (_loader->_runtime) {
        return _loader->_runtime->_heap->allocateBytes_(byteCount);
    }

    bool isSmall = (byteCount <= HeapObject::MAX_SMALL_SIZE);
    uintptr_t headerSize = isSmall ? sizeof(HeapObject::SmallHeader) : sizeof(HeapObject::LargeHeader);
    uintptr_t totalSize = align_(headerSize + byteCount);

    uintptr_t allocation = _space->allocateCommittingIfNeeded_(totalSize);
    if (!allocation) {
        error("Bootstrapper: Out of memory");
        return nullptr;
    }

    return initializeHeader_((void*)allocation, byteCount, HeapObject::SmallHeader::IsBytes);
}

} // namespace Egg
