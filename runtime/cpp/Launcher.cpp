/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#include <iostream>
#include <vector>
#include <cstring>

#include "Launcher.h"

#include <algorithm>
#include <Evaluator/Evaluator.h>

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
    
    start(runtime, kernel, args);
    return 0;
}

void start(Runtime *runtime, HeapObject *kernel, std::vector<Object*> &args) {
    HeapObject *name = runtime->sendLocal_to_("name", (Egg::Object*)kernel)->asHeapObject();
    std::cout << "The name of kernel module is " << name->asLocalString() << std::endl;

    std::cout << "Loading module " << args[1]->asHeapObject()->asLocalString() << std::endl;
    auto module = runtime->sendLocal_to_with_("load:", (Object*)kernel, (Object*)args[1]);

    name = runtime->sendLocal_to_("name", module)->asHeapObject();
    std::cout << "The name of loaded module is " << name->asLocalString() << std::endl;

    //runtime->sendLocal_to_with_("main:", module, args);

}

void runBareTests(Runtime *runtime, HeapObject *kernel, std::vector<Object*> &args)
{
    auto segment = runtime->_bootstrapper->bareLoadModuleFromFile("Kernel.BareTests.ems");
    segment->dumpObjects();
    auto module = segment->_exports["__module__"];
    auto methodDict = runtime->behaviorMethodDictionary_(runtime->behaviorOf_((Object*)module));
    auto table = runtime->dictionaryTable_(methodDict);
    std::vector<HeapObject*> methods;
    for (int index = 2; index < table->size(); index += 2) {
        auto symbol = table->slotAt_(index)->asHeapObject();
        if (symbol != runtime->_nilObj && symbol->asLocalString().starts_with("test"))
            methods.push_back(table->slotAt_(index + 1)->asHeapObject());
    }

    std::sort(methods.begin(), methods.end(),
        [runtime](HeapObject *a, HeapObject *b) {
            return std::strcmp((char*)runtime->methodSelector_(a), (char*)runtime->methodSelector_(b)) < 0;
    });

    for (auto method : methods) {
       // auto result = runtime->_evaluator->invoke_with_(method, (Object*)runtime->_nilObj);
        //runtime->_evaluator->evaluate();
        auto selector = runtime->methodSelector_(method)->asLocalString();
       // if (selector == "test161CreateDictionary")
        {
            auto result = runtime->sendLocal_to_(selector, (Object*)module);
            ASSERT(result == (Object*)runtime->_trueObj);
        }
    }
}