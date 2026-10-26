/*
    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "catch2/catch.hpp"
#include "../SSmalltalkCompiler.h"
#include "../Parser/SSmalltalkParser.h"
#include "../Parser/SSmalltalkScanner.h"
#include "../AST/SMethodNode.h"
#include "../Binding/ScriptScope.h"
#include "../Binding/LocalBinding.h"

using namespace Egg;

TEST_CASE("ScriptScope: temporaries are positioned in declaration order", "[scope]") {
    SSmalltalkCompiler compiler;
    compiler.scanner()->on_("foo | z a | a := 1. z := 2. ^z");
    auto method = compiler.parser()->parseMethod();
    REQUIRE(method != nullptr);

    method->bindLocals();
    method->positionLocals();

    auto scope = method->scope();
    auto z = dynamic_cast<LocalBinding*>(scope->resolveLocal_("z"));
    auto a = dynamic_cast<LocalBinding*>(scope->resolveLocal_("a"));
    REQUIRE(z);
    REQUIRE(a);
    REQUIRE(z->index() == 1);
    REQUIRE(a->index() == 2);
}
