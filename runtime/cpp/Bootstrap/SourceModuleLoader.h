/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#ifndef _SOURCE_MODULE_LOADER_H_
#define _SOURCE_MODULE_LOADER_H_

#include <string>
#include <vector>
#include <memory>
#include "../HeapObject.h"
#include "Utils/egg_string.h"
#include "../Compiler/LiteralValue.h"
#include "CodeSpecs.h"

namespace Egg {

class Runtime;
class SSmalltalkCompiler;

class SourceModuleLoader {
    Runtime* _runtime;
    ModuleSpec _moduleSpec;
    std::unique_ptr<SSmalltalkCompiler> _compiler;

public:
    SourceModuleLoader(Runtime* runtime);
    ~SourceModuleLoader();

    HeapObject* loadModuleFromSource(const std::string& modulePath, const std::string& name);

private:
    // Class creation via runtime messages
    Object* createNewClassFrom_(ClassSpec* spec, Object* module);
    void createMethodsOf_(Object* cls, ClassSpec* spec);
    void createNewMethod_(const Egg::string& source, Object* species, const Egg::string& category = Egg::string(""));
    [[noreturn]] static void rethrowWithContext_(const std::exception& e,
                                                const Egg::string& className,
                                                const std::string& side,
                                                const Egg::string& source);
    Object* createExtensionMethod_(const Egg::string& source, Object* species);

    // Literal transfer helpers
    Object* transferLiteral_(const LiteralValue& lit, Object* method);
    Object* transferBlock_(const LiteralValue::BlockInfo& blockInfo, Object* method);
    Object* transferArray_(const std::vector<LiteralValue>& elements);
    Object* transferCharacter_(uint32_t codePoint);
    Object* newLargeInteger_(const std::vector<uint8_t>& leBytes, bool negative);

    // Lookup helpers
    Object* lookupClass_(const Egg::string& name);
    Object* kernelNamespace_();
};

} // namespace Egg

#endif // _SOURCE_MODULE_LOADER_H_
