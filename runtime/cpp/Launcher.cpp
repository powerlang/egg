/*
    Copyright (c) 2019-2023 Javier Pimás, Jan Vrany, Labware. 
    See (MIT) license in root directory.
 */

#include <iostream>

#include "Launcher.h"
#include "ImageSegment.h"
#include "Util.h"
#include "Bootstrapper.h"

#include "Evaluator/Runtime.h"

using namespace Egg;

void start(ImageSegment *kernel);

int
Launcher::main(const int argc, const char** argv)
{
    if (argc != 2) {
        printf("Usage: %s <KERNEL_SEGMENT>\n", argv[0]);
        return 1;
    }
    std::ifstream file(argv[1], std::ifstream::binary);
    if (!file) {
        printf("No such file: %s\n", argv[1]);
        return 1;
    }

    auto kernel = new ImageSegment(&file);

    start(kernel);
    return 0;
}

void start(ImageSegment *kernel)
{
    Bootstrapper bootstrapper(kernel);

    auto runtime = bootstrapper._runtime;

    HeapObject *module = bootstrapper._kernel->exports["Kernel"];
    HeapObject *name = runtime->sendLocal_to_("name", (Egg::Object*)module)->asHeapObject();

    std::cout << "The name of kernel module is " << name->asLocalString() << std::endl;

}