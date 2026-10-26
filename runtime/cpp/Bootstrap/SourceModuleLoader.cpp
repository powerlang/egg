/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "SourceModuleLoader.h"
#include "TonelReader.h"
#include "../Compiler/SSmalltalkCompiler.h"
#include "../Compiler/LiteralValue.h"
#include "../Compiler/Backend/SCompiledMethod.h"
#include "../Compiler/CompilationResult.h"
#include "../Evaluator/Runtime.h"
#include "../KnownConstants.h"
#include "../GCedRef.h"
#include <algorithm>
#include <cstring>
#include <set>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <stdexcept>

namespace Egg {

SourceModuleLoader::SourceModuleLoader(Runtime* runtime)
    : _runtime(runtime) {
    _compiler = std::make_unique<SSmalltalkCompiler>();
}

SourceModuleLoader::~SourceModuleLoader() {
}

Object* SourceModuleLoader::kernelNamespace_() {
    auto kernelModule = (Object*)_runtime->_kernel->_exports["__module__"];
    auto ns = _runtime->sendLocal_to_("namespace", kernelModule);
    return ns;
}

Object* SourceModuleLoader::lookupClass_(const Egg::string& name) {
    auto namespace_ = kernelNamespace_();
    auto symbol = (Object*)_runtime->addSymbol_(name.toUtf8());
    return _runtime->sendLocal_to_with_("at:", namespace_, symbol);
}

HeapObject* SourceModuleLoader::loadModuleFromSource(const std::string& modulePath) {
    namespace fs = std::filesystem;
    TonelReader reader;

    // Phase 1: Parse all .st files in the module directory
    std::vector<Egg::string> newClassNames;
    std::vector<Egg::string> extensionNames;
    for (const auto& entry : fs::directory_iterator(modulePath)) {
        if (entry.path().extension() == ".st") {
            std::string filename = entry.path().filename().string();
            std::string className = filename.substr(0, filename.length() - 3);
            if (className == "package") continue;

            std::ifstream file(entry.path());
            if (!file.is_open()) continue;
            std::string source((std::istreambuf_iterator<char>(file)),
                               std::istreambuf_iterator<char>());

            ClassSpec* spec = reader.parseFile(source, entry.path().string());
            _moduleSpec.addClass(spec);
            if (spec->isExtension()) {
                extensionNames.push_back(spec->name());
            } else {
                newClassNames.push_back(spec->name());
            }
        }
    }

    // Phase 2: Find module class (subclass of Module)
    Egg::string moduleClassName;
    for (const auto& name : newClassNames) {
        ClassSpec* spec = _moduleSpec.resolveClass(name);
        Egg::string sup = spec->supername();
        while (!sup.empty() && sup != "nil") {
            if (sup == "Module") {
                moduleClassName = name;
                break;
            }
            ClassSpec* superSpec = _moduleSpec.resolveClass(sup);
            if (!superSpec) break;
            sup = superSpec->supername();
        }
        if (!moduleClassName.empty()) break;
    }

    if (moduleClassName.empty()) {
        std::cerr << "ERROR: No Module subclass found in " << modulePath << std::endl;
        std::exit(1);
    }

    // Phase 3: Create module class and instance
    auto moduleSpec = _moduleSpec.resolveClass(moduleClassName);
    auto moduleClass = createNewClassFrom_(moduleSpec, nullptr);

    GCedRef moduleClassRef(moduleClass);
    createMethodsOf_(moduleClassRef.get(), moduleSpec);

    // Set module class comment if the .st file had a header comment
    if (!moduleSpec->comment().empty()) {
        auto commentObj = (Object*)_runtime->newString_(moduleSpec->comment().toUtf8());
        _runtime->sendLocal_to_with_("comment:", moduleClassRef.get(), commentObj);
    }

    auto moduleInstance = _runtime->sendLocal_to_("new", moduleClassRef.get());
    GCedRef moduleRef(moduleInstance);
    std::string modName = fs::path(modulePath).filename().string();
    auto nameObj = (Object*)_runtime->newString_(modName);
    _runtime->sendLocal_to_with_("name:", moduleRef.get(), nameObj);

    // Now set the module class's module to the new instance
    _runtime->sendLocal_to_with_("module:", moduleClassRef.get(), moduleRef.get());
    _runtime->sendLocal_to_with_("addClass:", moduleRef.get(), moduleClassRef.get());

    // Populate namespace with kernel classes so superclass lookups work in Phase 4
    _runtime->sendLocal_to_("bindKernelExports", moduleRef.get());

    // Phase 4: Import required modules so their classes are available as superclasses
    _runtime->sendLocal_to_("importRequiredModules", moduleRef.get());

    // Phase 5: Create remaining classes (sorted so superclasses come first)
    // Simple topological sort: process classes whose superclass is already available
    std::vector<Egg::string> remaining;
    // Collect module-defined class names for dependency checking
    std::set<Egg::string> moduleClassNames;
    for (const auto& name : newClassNames) {
        moduleClassNames.insert(name);
        if (name != moduleClassName)
            remaining.push_back(name);
    }

    std::vector<Egg::string> sorted;
    std::set<Egg::string> created;
    created.insert(moduleClassName); // Module class already created

    while (!remaining.empty()) {
        bool progress = false;
        for (auto it = remaining.begin(); it != remaining.end(); ) {
            auto spec = _moduleSpec.resolveClass(*it);
            auto sup = spec->supername();
            // Superclass is available if it's already created or is not a module class
            // (i.e., it's a kernel class, which is always available)
            bool available = !moduleClassNames.count(sup) || created.count(sup);
            if (available) {
                sorted.push_back(*it);
                created.insert(*it);
                it = remaining.erase(it);
                progress = true;
            } else {
                ++it;
            }
        }
        if (!progress) {
            // Remaining classes have unresolved superclasses, add them anyway
            for (const auto& name : remaining)
                sorted.push_back(name);
            break;
        }
    }

    for (const auto& name : sorted) {
        ClassSpec* spec = _moduleSpec.resolveClass(name);
        auto cls = createNewClassFrom_(spec, moduleRef.get());
        GCedRef clsRef(cls);
        createMethodsOf_(clsRef.get(), spec);

        // Set class comment if the .st file had a header comment
        if (!spec->comment().empty()) {
            auto commentObj = (Object*)_runtime->newString_(spec->comment().toUtf8());
            _runtime->sendLocal_to_with_("comment:", clsRef.get(), commentObj);
        }
    }

    // Phase 6: Finalize module
    // (importRequiredModules was already called in Phase 4)

    // Phase 7: Compile extension methods and register them via addExtension:
    // so that justLoaded -> bind properly creates extension method copies
    // with the MethodIsExtension flag and module association literal.
    for (const auto& extName : extensionNames) {
        ClassSpec* spec = _moduleSpec.resolveClass(extName);
        auto namespace_ = _runtime->sendLocal_to_("namespace", moduleRef.get());

        // Strip " class" suffix from extension name to get base class name.
        // The TonelReader already classifies methods as instance/class side
        // based on the method header (ClassName class >> vs ClassName >>),
        // so we only need the base name for namespace lookup.
        bool hasClassSuffix = extName.length() > 6 &&
            extName.substr(extName.length() - 6) == " class";
        Egg::string baseName = hasClassSuffix
            ? extName.substr(0, extName.length() - 6)
            : extName;

        auto symbol = (Object*)_runtime->addSymbol_(baseName.toUtf8());
        auto hasKey = _runtime->sendLocal_to_with_("includesKey:", namespace_, symbol);
        if (hasKey != (Object*)_runtime->_trueObj)
            continue;

        auto baseClass = _runtime->sendLocal_to_with_("at:", namespace_, symbol);
        GCedRef baseRef(baseClass);

        // Compile instance-side methods (spec->methods()) and register as extensions.
        // These always target the base class itself.
        for (const auto& method : spec->methods()) {
            auto cm = createExtensionMethod_(method.source(), baseRef.get());
            if (cm) {
                GCedRef cmRef(cm);
                _runtime->sendLocal_to_with_("addExtension:", moduleRef.get(), cmRef.get());
            }
        }

        // Compile class-side methods (spec->metaclass()->methods()) and register.
        // These always target the metaclass of the base class.
        if (spec->metaclass()) {
            auto metaclass = _runtime->sendLocal_to_("class", baseRef.get());
            GCedRef metaRef(metaclass);
            for (const auto& method : spec->metaclass()->methods()) {
                auto cm = createExtensionMethod_(method.source(), metaRef.get());
                if (cm) {
                    GCedRef cmRef(cm);
                    _runtime->sendLocal_to_with_("addExtension:", moduleRef.get(), cmRef.get());
                }
            }
        }
    }

    // Don't call justLoaded here — HostSystem>>load: calls it after the primitive returns
    return moduleRef.get()->asHeapObject();
}

Object* SourceModuleLoader::createNewClassFrom_(ClassSpec* spec, Object* module) {
    // Look up superclass
    auto supername = spec->supername();
    Object* superclass;
    if (module) {
        auto namespace_ = _runtime->sendLocal_to_("namespace", module);
        auto superSymbol = (Object*)_runtime->addSymbol_(supername.toUtf8());
        superclass = _runtime->sendLocal_to_with_("at:", namespace_, superSymbol);
    } else {
        superclass = lookupClass_(supername);
    }

    // Create class: Class newSubclassOf: superclass
    auto classClass = lookupClass_("Class");
    auto newClass = _runtime->sendLocal_to_with_("newSubclassOf:", classClass, superclass);
    GCedRef classRef(newClass);

    // Set name
    auto nameStr = (Object*)_runtime->newString_(spec->name().toUtf8());
    _runtime->sendLocal_to_with_("name:", classRef.get(), nameStr);

    // Set instance variables directly at the heap level (bypasses Smalltalk instVarNames:
    // which causes stack overflow when called from within SourceModuleLoader)
    const auto& ivarNames = spec->instVarNames();
    if (!ivarNames.empty()) {
        std::vector<Object*> ivars;
        for (const auto& ivar : ivarNames) {
            ivars.push_back((Object*)_runtime->addSymbol_(ivar.toUtf8()));
        }
        auto ivarArray = _runtime->newArray_(ivars);
        classRef.get()->asHeapObject()->slot(Offsets::SpeciesInstanceVariables) = (Object*)ivarArray;

        // Update format to include inst var count (same as updateInstSize)
        auto formatObj = classRef.get()->asHeapObject()->slot(Offsets::SpeciesFormat);
        int32_t format = formatObj->asSmallInteger()->asNative();
        int32_t oldInstSize = format & 0x7F;
        auto superFormatObj = superclass->asHeapObject()->slot(Offsets::SpeciesFormat);
        int32_t superInstSize = superFormatObj->asSmallInteger()->asNative() & 0x7F;
        int32_t newFormat = format - oldInstSize + superInstSize + (int32_t)ivarNames.size();
        classRef.get()->asHeapObject()->slot(Offsets::SpeciesFormat) = (Object*)SmallInteger::from(newFormat);
    }

    // Set bytes flag if needed
    if (!spec->isPointers()) {
        _runtime->sendLocal_to_("beBytes", classRef.get());
    }

    // Set class variables
    const auto& classVarNames = spec->classVarNames();
    if (!classVarNames.empty()) {
        auto namespaceClass = lookupClass_("Namespace");
        auto ns = _runtime->sendLocal_to_("new", namespaceClass);
        GCedRef nsRef(ns);
        for (const auto& cvar : classVarNames) {
            auto key = (Object*)_runtime->addSymbol_(cvar.toUtf8());
            _runtime->sendLocal_to_with_with_("at:put:", nsRef.get(), key, (Object*)_runtime->_nilObj);
        }
        _runtime->sendLocal_to_with_("classVariables:", classRef.get(), nsRef.get());
    }

    // Add class to module
    if (module) {
        _runtime->sendLocal_to_with_("addClass:", module, classRef.get());
        _runtime->sendLocal_to_with_("module:", classRef.get(), module);
    }

    return classRef.get();
}

void SourceModuleLoader::createMethodsOf_(Object* cls, ClassSpec* spec) {
    GCedRef clsRef(cls);

    auto runMethod = [&](const MethodSpec& method, Object* receiver, const std::string& side) {
        try {
            createNewMethod_(method.source(), receiver, method.category());
        } catch (const std::exception& e) {
            rethrowWithContext_(e, spec->name(), side, method.source());
        }
    };

    for (const auto& method : spec->methods())
        runMethod(method, clsRef.get(), "");

    auto metaclass = _runtime->sendLocal_to_("class", clsRef.get());
    GCedRef metaRef(metaclass);
    for (const auto& method : spec->metaclass()->methods())
        runMethod(method, metaRef.get(), " class");
}

[[noreturn]] void SourceModuleLoader::rethrowWithContext_(const std::exception& e,
                                                          const Egg::string& className,
                                                          const std::string& side,
                                                          const Egg::string& source) {
    size_t nl = source.find(U'\n');
    Egg::string sig = nl == Egg::string::npos ? source : source.substr(0, nl);
    std::stringstream ss;
    ss << e.what()
       << "\n  while compiling " << className.toUtf8() << side
       << " >> " << sig.toUtf8();
    throw std::runtime_error(ss.str());
}

void SourceModuleLoader::createNewMethod_(const Egg::string& source, Object* species, const Egg::string& category) {
    CompilationResult* result = _compiler->compileMethod_(source);
    SCompiledMethod* smethod = static_cast<SCompiledMethod*>(result->method());
    if (!smethod) {
        std::cerr << "ERROR: Failed to compile method from source: '"
                  << source.substr(0, std::min(source.length(), size_t(60))) << "...'" << std::endl;
        return;
    }

    GCedRef speciesRef(species);

    const auto& treecodes = smethod->treecodes();
    const auto& literals = smethod->literals();
    uint32_t literalCount = literals.size();

    Egg::string methodClassname = smethod->methodClassname();
    uint32_t instBase = Offsets::MethodInstSize + (methodClassname == "CallbackMethod" ? 2 : 0);

    auto cmClass = lookupClass_(methodClassname);
    auto size = (Object*)_runtime->newInteger_(literalCount);
    auto method = _runtime->sendLocal_to_with_("new:", cmClass, size);
    GCedRef methodRef(method);

    // Set method fields
    auto format = (Object*)_runtime->newInteger_(smethod->format());
    _runtime->sendLocal_to_with_("format:", methodRef.get(), format);

    auto selector = (Object*)_runtime->addSymbol_(smethod->selector().toUtf8());
    _runtime->sendLocal_to_with_("selector:", methodRef.get(), selector);

    // Create treecodes ByteArray
    auto baClass = _runtime->_kernel->_exports["ByteArray"];
    auto ba = _runtime->newBytes_size_(baClass, treecodes.size());
    std::memcpy((void*)ba, treecodes.data(), treecodes.size());
    _runtime->sendLocal_to_with_("treecodes:", methodRef.get(), (Object*)ba);

    _runtime->sendLocal_to_with_("classBinding:", methodRef.get(), speciesRef.get());

    auto sourceObj = (Object*)_runtime->newString_(source.toUtf8());
    _runtime->sendLocal_to_with_("sourceObject:", methodRef.get(), sourceObj);

    // Transfer literals
    for (uint32_t i = 0; i < literalCount; i++) {
        auto literal = transferLiteral_(literals[i], methodRef.get());
        methodRef.get()->asHeapObject()->slot(instBase + i) = literal;
    }

    // Install method via Smalltalk protocol (all method dicts are proper
    // MethodDictionary objects after bootstrap conversion)
    _runtime->sendLocal_to_with_with_("addSelector:withMethod:", speciesRef.get(), selector, methodRef.get());

    // Set method category if provided
    if (!category.empty()) {
        auto catObj = (Object*)_runtime->addSymbol_(category.toUtf8());
        _runtime->sendLocal_to_with_("category:", methodRef.get(), catObj);
    }
}

Object* SourceModuleLoader::createExtensionMethod_(const Egg::string& source, Object* species) {
    CompilationResult* result = _compiler->compileMethod_(source);
    SCompiledMethod* smethod = static_cast<SCompiledMethod*>(result->method());
    if (!smethod) {
        std::cerr << "ERROR: Failed to compile extension method from source: '"
                  << source.substr(0, std::min(source.length(), size_t(60))) << "...'" << std::endl;
        return nullptr;
    }

    GCedRef speciesRef(species);

    const auto& treecodes = smethod->treecodes();
    const auto& literals = smethod->literals();
    uint32_t literalCount = literals.size();

    Egg::string methodClassname = smethod->methodClassname();
    uint32_t instBase = Offsets::MethodInstSize + (methodClassname == "CallbackMethod" ? 2 : 0);

    auto cmClass = lookupClass_(methodClassname);
    auto size = (Object*)_runtime->newInteger_(literalCount);
    auto method = _runtime->sendLocal_to_with_("new:", cmClass, size);
    GCedRef methodRef(method);

    auto format = (Object*)_runtime->newInteger_(smethod->format());
    _runtime->sendLocal_to_with_("format:", methodRef.get(), format);

    auto selector = (Object*)_runtime->addSymbol_(smethod->selector().toUtf8());
    _runtime->sendLocal_to_with_("selector:", methodRef.get(), selector);

    auto baClass = _runtime->_kernel->_exports["ByteArray"];
    auto ba = _runtime->newBytes_size_(baClass, treecodes.size());
    std::memcpy((void*)ba, treecodes.data(), treecodes.size());
    _runtime->sendLocal_to_with_("treecodes:", methodRef.get(), (Object*)ba);

    _runtime->sendLocal_to_with_("classBinding:", methodRef.get(), speciesRef.get());

    auto sourceObj = (Object*)_runtime->newString_(source.toUtf8());
    _runtime->sendLocal_to_with_("sourceObject:", methodRef.get(), sourceObj);

    for (uint32_t i = 0; i < literalCount; i++) {
        auto literal = transferLiteral_(literals[i], methodRef.get());
        methodRef.get()->asHeapObject()->slot(instBase + i) = literal;
    }

    return methodRef.get();
}

Object* SourceModuleLoader::transferLiteral_(const LiteralValue& lit, Object* method) {
    switch (lit.tag) {
        case LiteralValue::Symbol:
            return (Object*)_runtime->addSymbol_(lit.asString().toUtf8());
        case LiteralValue::String:
            return (Object*)_runtime->newString_(lit.asString().toUtf8());
        case LiteralValue::Integer:
            return (Object*)_runtime->newInteger_((intptr_t)lit.asInteger());
        case LiteralValue::LargeInteger:
            return newLargeInteger_(lit.asLargeIntegerBytes(), lit.isLargeIntegerNegative());
        case LiteralValue::Float:
            return (Object*)_runtime->newDouble_(lit.asFloat());
        case LiteralValue::Character:
            return transferCharacter_(lit.asCharacter());
        case LiteralValue::Boolean:
            return (Object*)(lit.asBoolean() ? _runtime->_trueObj : _runtime->_falseObj);
        case LiteralValue::Nil:
            return (Object*)_runtime->_nilObj;
        case LiteralValue::Array:
            return (Object*)transferArray_(lit.asArray());
        case LiteralValue::ByteArray: {
            auto& bytes = lit.asByteArray();
            auto baClass = _runtime->_kernel->_exports["ByteArray"];
            auto ba = _runtime->newBytes_size_(baClass, bytes.size());
            std::memcpy((void*)ba, bytes.data(), bytes.size());
            return (Object*)ba;
        }
        case LiteralValue::Block:
            return transferBlock_(lit.asBlock(), method);
        default:
            error("transferLiteral_: unimplemented literal tag");
            return (Object*)_runtime->_nilObj;
    }
}

Object* SourceModuleLoader::transferArray_(const std::vector<LiteralValue>& elements) {
    auto arr = _runtime->newArraySized_(elements.size());
    GCedRef arrRef((Object*)arr);
    auto arrayBehavior = _runtime->speciesInstanceBehavior_(_runtime->_kernel->_exports["Array"]);
    arrRef.get()->asHeapObject()->behavior(arrayBehavior);
    for (size_t i = 0; i < elements.size(); i++) {
        arrRef.get()->asHeapObject()->slot(i) = transferLiteral_(elements[i], nullptr);
    }
    return arrRef.get();
}

// Canonicalize the Character via Character class>>value:, which consults
// ByteCharacters for code points 0..255. The kernel is fully alive at
// runtime when SourceModuleLoader is used, so this is always safe.
Object* SourceModuleLoader::transferCharacter_(uint32_t codePoint) {
    auto cp = (Object*)_runtime->newInteger_((intptr_t)codePoint);
    return _runtime->sendLocal_to_with_("value:", (Object*)_runtime->_characterClass, cp);
}

Object* SourceModuleLoader::newLargeInteger_(const std::vector<uint8_t>& leBytes, bool negative) {
    const char* className = negative ? "LargeNegativeInteger" : "LargePositiveInteger";
    auto largeClass = _runtime->_kernel->_exports[className];
    auto obj = _runtime->newBytes_size_(largeClass, (uint32_t)leBytes.size());
    auto behavior = _runtime->speciesInstanceBehavior_(largeClass);
    obj->behavior(behavior);
    std::memcpy((void*)obj, leBytes.data(), leBytes.size());
    return (Object*)obj;
}

Object* SourceModuleLoader::transferBlock_(const LiteralValue::BlockInfo& info, Object* method) {
    auto blockClass = _runtime->_kernel->_exports["CompiledBlock"];
    auto block = _runtime->newSlotsOf_(blockClass);
    GCedRef blockRef((Object*)block);

    uint32_t format = (info.argCount & 0x3F)
                    | ((info.tempCount & 0xFF) << 6)
                    | ((info.id & 0xFF) << 14)
                    | (info.capturesSelf ? 0x400000 : 0)
                    | (info.capturesHome ? 0x800000 : 0)
                    | ((info.envCount & 0x7F) << 24);

    blockRef.get()->asHeapObject()->slot(Offsets::BlockFormat) = (Object*)_runtime->newInteger_(format);
    blockRef.get()->asHeapObject()->slot(Offsets::BlockExecutableCode) = (Object*)_runtime->_nilObj;
    blockRef.get()->asHeapObject()->slot(Offsets::BlockMethod) = method;

    return blockRef.get();
}

} // namespace Egg
