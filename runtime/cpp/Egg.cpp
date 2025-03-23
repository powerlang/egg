#include "Egg.h"
#include "Allocator/Memory.h"
#include "Evaluator/Runtime.h"
#include "Evaluator/Evaluator.h"
#include "Evaluator/EvaluationContext.h"

#include <iostream>
#include <cstdlib>

bool Egg::GC_CRITICAL = false;

void Egg::error(const char *message) {
    if (debugRuntime)
        std::cerr << debugRuntime->_evaluator->context()->backtrace() << std::endl << std::endl;
    std::cerr << "Error: " << message << std::endl;
    std::exit(EXIT_FAILURE);  // or std::abort();
}

void Egg::error_(const std::string &message) { 
    error(message.c_str());
}

void Egg::warning(const char *message) {
    std::cerr << "WARNING: " << message << std::endl;
}

void Egg::warning_(const std::string &message) {
    warning(message.c_str());
}
void Egg::Initialize()
{
    InitializeMemory();
}
