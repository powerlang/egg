/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#ifndef _BOOTSTRAPPER_H_
#define _BOOTSTRAPPER_H_

#include <string>
#include <vector>
#include <map>
#include <memory>
#include <cstdint>
#include "../HeapObject.h"
#include "Utils/egg_string.h"
#include "../Compiler/LiteralValue.h"
#include "../Allocator/GCSpace.h"
#include "../SymbolProvider.h"
#include "CodeSpecs.h"
#include "MethodDictBuilder.h"

namespace Egg
{

    class Loader;
    class Runtime;
    class SSmalltalkCompiler;

    class Bootstrapper
    {
        friend class BootstrapperTestFixture;

    public:
        Loader *_loader;
        BootstrapSymbolProvider *_symbolProvider;
        std::string _kernelPath;
        ModuleSpec _moduleSpec;

        // Bootstrap state
        GCSpace *_space;
        std::unique_ptr<SSmalltalkCompiler> _compiler;
        HeapObject *_nilObj;
        HeapObject *_trueObj;
        HeapObject *_falseObj;
        HeapObject *_kernelModule;
        HeapObject *_compiledMethodClass;
        std::map<Egg::string, HeapObject *> _classes;
        std::map<Egg::string, HeapObject *> _metaclasses;
        std::map<Egg::string, HeapObject *> _behaviors;
        std::map<Egg::string, HeapObject *> _metaBehaviors;
        // map to keep Character identity during bootstrap
        std::map<uint32_t, HeapObject *> _characterMap;

        // Cached class pointers (kernel-specific)
        HeapObject *_undefinedObjectClass;
        HeapObject *_trueClass;
        HeapObject *_falseClass;
        HeapObject *_classClass;
        HeapObject *_metaclassClass;
        HeapObject *_symbolClass;
        HeapObject *_wideSymbolClass;
        HeapObject *_stringClass;
        HeapObject *_wideStringClass;
        HeapObject *_arrayClass;
        HeapObject *_methodDictionaryClass;
        std::unique_ptr<MethodDictBuilder> _methodDictBuilder;

    public:
        Bootstrapper(const std::string &kernelPath, Loader *loader);
        ~Bootstrapper();

        // Main bootstrapping method
        Runtime *bootstrap();

        // Phase 1: Parse class definitions from source files
        std::string readSourceFile_(const std::string &className);
        void loadKernelSpecs();

        // Phase 2: Create initial objects
        void createInitialObjects();

        // Phase 3: Allocate all species and behaviors
        void instantiateMetaobjects();

        // Phase 4: Initialize metaobjects (link them together)
        void initializeMetaobjects();

        // Phase 5: Create kernel namespace
        void createKernelNamespace();

        // Phase 6: Compile and install methods
        void loadKernelMethods();

        // Phase 7: Create Runtime with bootstrapped kernel
        void createRuntimeWithBootstrappedKernel();

        // Phase 8: Fill Smalltalk symbol table with bootstrap symbols
        void fillSymbolTable();

        // Phase 9: Convert Array method dicts to proper MethodDictionary objects
        void convertMethodDictionaries();
        void convertBehaviorMethodDict_(HeapObject *species);

        // Kernel-specific hash table helpers
        HeapObject *newOpenHashTable_(uint32_t indexedSize, HeapObject *owner);
        void insertInOpenHashTable_(HeapObject *table, uint32_t indexedSize, Object *key, HeapObject *assoc);
        HeapObject *newDictionary_(const Egg::string &behaviorName, std::vector<std::pair<Object *, HeapObject *>> &entries);

        // Metaobject creation
        void instantiateMetaobjectsOf_(const Egg::string &className);
        void initializeMetaobjectsOf_(const Egg::string &className);
        uint32_t instSizeOf_(const Egg::string &className);

        // Method compilation
        void compileAndInstallMethod_(const Egg::string &source, HeapObject *cls);
        Object *transferLiteral_(const LiteralValue &lit, HeapObject *method);
        HeapObject *transferBlock_(const LiteralValue::BlockInfo &blockInfo, HeapObject *method);
        HeapObject *transferArray_(const std::vector<LiteralValue> &elements);
        Object *transferCharacter_(uint32_t codePoint);
        HeapObject *newLargeInteger_(const std::vector<uint8_t> &leBytes, bool negative);

        // Object creation helpers
        HeapObject *newBytes_(const Egg::string &className, const void *data, uint32_t byteCount);
        HeapObject *newSlots_(const Egg::string &className);
        HeapObject *newSlots_sized_(const Egg::string &className, uint32_t slotCount);
        HeapObject *newAssociation_value_(const Egg::string &key, Object *value);
        HeapObject *newAssociation_value_(Object *key, Object *value);
        Object *internSymbol_(const Egg::string &str);
        Object *newSymbol_(const Egg::string &str);
        void computeSymbolHash_(HeapObject *symbol, bool isWide);
        HeapObject *newString_(const Egg::string &str);
        HeapObject *newArray_(uint32_t size);
        HeapObject *newByteArray_(const std::vector<uint8_t> &bytes);
        HeapObject *newMethodArray();
        void addMethodToArray_(HeapObject *array, Object *selector, Object *method);

        // SmallInteger helper
        Object *newSmallInteger_(intptr_t value)
        {
            return (Object *)((value << 1) | 1);
        }

    private:
        // Low-level memory allocation
        HeapObject *allocateSlots_(uint32_t slotCount);
        HeapObject *allocateBytesRaw_(uint32_t byteCount);
        HeapObject *initializeHeader_(void *allocation, uint32_t size, uint8_t flags);
        uintptr_t align_(uintptr_t addr);
    };

} // namespace Egg

#endif // _BOOTSTRAPPER_H_
