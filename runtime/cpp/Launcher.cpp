/*
    Copyright (c) 2019-2025 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#include <vector>
#include <filesystem>

#include "Launcher.h"
#include "Util.h"
#include "Loader.h"
#include "GCedRef.h"

#include "Evaluator/Runtime.h"

using namespace Egg;

int
Launcher::main(const int argc, const char** argv)
{
    if (argc < 2) {
        printf("Usage: %s <module name> [arguments]\n", argv[0]);
        return 1;
    }

    Egg::Initialize();

    // Determine modules directory from the module path argument
    std::filesystem::path modulePath(argv[1]);
    std::string modulesDir;
    if (modulePath.has_parent_path()) {
        modulesDir = modulePath.parent_path().string();
    } else {
        modulesDir = "modules";
    }

    auto loader = new Loader(modulesDir);
    Runtime* runtime = loader->loadKernel();
    if (!runtime) {
        return 1;
    }

    // Extract module name from path
    auto moduleName = modulePath.filename().string();

    auto kernelModule = (Object*)runtime->_kernel->_exports["__module__"];
    runtime->sendLocal_to_("useHostModuleLoader", kernelModule);
    auto moduleNameSym = (Object*)runtime->addSymbol_(moduleName);
    auto module = runtime->sendLocal_to_with_("load:", kernelModule, moduleNameSym);
    GCedRef moduleRef(module);
    auto args = std::vector<Object*>();
    for (int i = 0; i < argc; i++)
        args.push_back((Object*)runtime->newString_(argv[i]));
    auto array = runtime->newArray_(args);
    runtime->sendLocal_to_with_("main:", moduleRef.get(), (Object*)array);

    return 0;
}