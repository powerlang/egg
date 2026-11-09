/*
    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "catch2/catch.hpp"
#include "../SCompiler.h"
#include "../SSmalltalkCompiler.h"
#include "../MessageInliner.h"
#include "../Parser/SSmalltalkParser.h"
#include "../Parser/SSmalltalkScanner.h"
#include "../AST/SParseNode.h"
#include "../AST/SMethodNode.h"
#include "../AST/SMessageNode.h"
#include "../AST/SCascadeMessageNode.h"

using namespace Egg;

class SMessageInlinerTestFixture {
protected:
    SSmalltalkCompiler compiler;
    MessageInliner inliner;

    SMethodNode* parse(const std::string& source) {
        compiler.scanner()->on_(source);
        return compiler.parser()->parseMethod();
    }

    void runInlinerOver(SMethodNode* method) {
        method->nodesDo_([this](SParseNode* n) {
            if (n->isMessage()) {
                inliner.inline_(static_cast<SMessageNode*>(n));
            }
        });
    }
};

TEST_CASE_METHOD(SMessageInlinerTestFixture,
                 "Inliner: cascade ifTrue: is not inlined", "[inliner]") {
    // Regression: matches the original InternalReadStream>>peekFor: pattern
    //   ^self peek = token ifTrue: [position := position + 1]; yourself
    SMethodNode* method = parse("foo ^true ifTrue: [42]; yourself");
    REQUIRE(method != nullptr);

    runInlinerOver(method);

    bool sawCascade = false;
    method->nodesDo_([&](SParseNode* n) {
        if (n->isMessage()) {
            SMessageNode* m = static_cast<SMessageNode*>(n);
            if (m->isCascadeMessage()) {
                sawCascade = true;
                REQUIRE_FALSE(m->isInlined());
            }
        }
    });
    REQUIRE(sawCascade);
}

TEST_CASE_METHOD(SMessageInlinerTestFixture,
                 "Inliner: non-cascade ifTrue: is still inlined", "[inliner]") {
    SMethodNode* method = parse("foo ^true ifTrue: [42]");
    REQUIRE(method != nullptr);

    runInlinerOver(method);

    bool sawInlined = false;
    method->nodesDo_([&](SParseNode* n) {
        if (n->isMessage()) {
            SMessageNode* m = static_cast<SMessageNode*>(n);
            if (m->isInlined()) sawInlined = true;
        }
    });
    REQUIRE(sawInlined);
}

static bool inlinesMessage(SMethodNode* method) {
    bool inlined = false;
    method->nodesDo_([&](SParseNode* n) {
        if (n->isMessage() && static_cast<SMessageNode*>(n)->isInlined())
            inlined = true;
    });
    return inlined;
}

TEST_CASE_METHOD(SMessageInlinerTestFixture,
                 "Inliner: to:by:do: with a literal step is inlined", "[inliner]") {
    SMethodNode* method = parse("foo 1 to: 10 by: 2 do: [:i | i]");
    REQUIRE(method != nullptr);
    runInlinerOver(method);
    REQUIRE(inlinesMessage(method));
}

TEST_CASE_METHOD(SMessageInlinerTestFixture,
                 "Inliner: to:by:do: with a non-literal step is not inlined", "[inliner]") {
    SMethodNode* method = parse("foo: n 1 to: 10 by: n do: [:i | i]");
    REQUIRE(method != nullptr);
    runInlinerOver(method);
    REQUIRE_FALSE(inlinesMessage(method));
}
