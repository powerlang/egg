#include "Egg.h"

#include <iostream>
#include <cstdlib>

bool Egg::GC_CRITICAL = false;

void Egg::error(const char *message) {
    std::cerr << "Error: " << message << std::endl;
    std::exit(EXIT_FAILURE);  // or std::abort();
}

void Egg::error_(const std::string &message) { error(message.c_str()); }
