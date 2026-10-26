/*
    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "catch2/catch.hpp"
#include "../SSmalltalkCompiler.h"
#include "../TreecodeEncoder.h"
#include "../CompilerTypes.h"
#include "../AST/SMethodNode.h"
#include "../AST/SBlockNode.h"

using namespace Egg;

TEST_CASE("TreecodeEncoder: a block reads an outer environment from its parent's closure", "[encoder]") {
    SSmalltalkCompiler compiler;
    compiler.parseMethod_("foo | a | a := 1. ^[self printString. [a]]");
    auto method = compiler.ast();
    REQUIRE(method != nullptr);

    SBlockNode* inner = nullptr;
    method->nodesDo_([&](SParseNode* node) {
        if (node->isBlock() && static_cast<SBlockNode*>(node)->parent()->isBlock())
            inner = static_cast<SBlockNode*>(node);
    });
    REQUIRE(inner);

    TreecodeEncoder encoder;
    auto elements = encoder.encodeClosureElements_(inner);
    REQUIRE(elements == std::vector<uint8_t>{ClosureEnvironmentValue, 2});
}
