/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#include <iostream>
#include <vector>

#include "Launcher.h"
#include "ImageSegment.h"
#include "Util.h"
#include "Bootstrapper.h"

#include "Evaluator/Runtime.h"

using namespace Egg;

void start(Runtime *runtime, HeapObject *kernel, std::vector<Object*> &args);

int
Launcher::main(const int argc, const char** argv)
{
    if (argc != 2) {
        printf("Usage: %s <module name>\n", argv[0]);
        return 1;
    }
    std::ifstream kernelFile("Kernel.ems", std::ifstream::binary);
    if (!kernelFile) {
        printf("No Kernel.ems file\n");
        return 1;
    }

    auto kernelSegment = new ImageSegment(&kernelFile);
    auto bootstrapper = new Bootstrapper(kernelSegment);
    auto runtime = bootstrapper->_runtime;
    HeapObject *kernel = bootstrapper->_kernel->_exports["Kernel"];


    std::vector<Object*> args;
    for (int i = 0; i < argc; i++)
        args.push_back((Object*)runtime->newString_(argv[i]));
    
     return 0;
}

void start(Runtime *runtime, HeapObject *kernel, std::vector<Object*> &args)
{
    HeapObject *name = runtime->sendLocal_to_("name", (Egg::Object*)kernel)->asHeapObject();
    std::cout << "The name of kernel module is " << name->asLocalString() << std::endl;

    auto module = runtime->sendLocal_to_with_("loadModule:", (Object*)kernel, (Object*)args[1]);

    runtime->sendLocal_to_with_("main:", module, args);
}