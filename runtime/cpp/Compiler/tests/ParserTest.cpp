/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "catch2/catch.hpp"
#include "../SCompiler.h"
#include "../SSmalltalkCompiler.h"
#include "../Parser/SSmalltalkParser.h"
#include "../Parser/SSmalltalkScanner.h"
#include "../AST/SParseNode.h"

using namespace Egg;

class SSmalltalkParserTestFixture {
protected:
    SSmalltalkCompiler compiler;
    
    void setUp() {
    }
    
    void tearDown() {
    }
    
    SMethodNode* parse(const std::string& source) {
        compiler.scanner()->on_(source);
        return compiler.parser()->parseMethod();
    }
    
    SMethodNode* parseExpression(const std::string& source) {
        compiler.scanner()->on_(source);
        return compiler.parser()->parseExpression();
    }
};

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Unary method signature", "[parser]") {
    setUp();
    
    SMethodNode* method = parse("unary ^true");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->isMethod());
    REQUIRE(method->selector() != nullptr);
    // Selector should be 'unary'
    REQUIRE(method->arguments().empty());
    REQUIRE(method->statements().size() == 1);
    REQUIRE(method->statements()[0]->isReturn());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Binary method signature", "[parser]") {
    setUp();
    
    SMethodNode* method = parse("+ arg ^self basicAdd: arg");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->isMethod());
    REQUIRE(method->selector() != nullptr);
    // Selector should be '+'
    REQUIRE(method->arguments().size() == 1);
    REQUIRE(method->arguments()[0]->name() == "arg");
    REQUIRE(method->statements().size() == 1);
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Keyword method signature", "[parser]") {
    setUp();
    
    SMethodNode* method = parse("at: index put: value ^self basicAt: index put: value");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->isMethod());
    REQUIRE(method->selector() != nullptr);
    // Selector should be 'at:put:'
    REQUIRE(method->arguments().size() == 2);
    REQUIRE(method->arguments()[0]->name() == "index");
    REQUIRE(method->arguments()[1]->name() == "value");
    REQUIRE(method->statements().size() == 1);
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Simple assignment", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("a := 3");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isAssignment());
    
    SAssignmentNode* assignment = static_cast<SAssignmentNode*>(stmt);
    REQUIRE(assignment->assignees().size() == 1);
    REQUIRE(assignment->assignees()[0]->name() == "a");
    REQUIRE(assignment->expression() != nullptr);
    REQUIRE(assignment->expression()->isLiteral());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Unary message", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("obj message");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isMessage());
    
    SMessageNode* msg = static_cast<SMessageNode*>(stmt);
    REQUIRE(msg->receiver() != nullptr);
    REQUIRE(msg->receiver()->isIdentifier());
    REQUIRE(msg->selector() != nullptr);
    REQUIRE(msg->arguments().empty());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Binary message", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("3 + 4");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isMessage());
    
    SMessageNode* msg = static_cast<SMessageNode*>(stmt);
    REQUIRE(msg->receiver() != nullptr);
    REQUIRE(msg->receiver()->isLiteral());
    REQUIRE(msg->selector() != nullptr);
    REQUIRE(msg->arguments().size() == 1);
    REQUIRE(msg->arguments()[0]->isLiteral());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Keyword message", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("dict at: key put: value");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isMessage());
    
    SMessageNode* msg = static_cast<SMessageNode*>(stmt);
    REQUIRE(msg->receiver() != nullptr);
    REQUIRE(msg->receiver()->isIdentifier());
    REQUIRE(msg->selector() != nullptr);
    REQUIRE(msg->arguments().size() == 2);
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Message precedence", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("a unary + b keyword: c");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isMessage());
    
    // Top level should be keyword message
    SMessageNode* keyword = static_cast<SMessageNode*>(stmt);
    REQUIRE(keyword->arguments().size() == 1);
    
    // Receiver should be binary message
    REQUIRE(keyword->receiver()->isMessage());
    SMessageNode* binary = static_cast<SMessageNode*>(keyword->receiver());
    
    // Binary receiver should be unary message
    REQUIRE(binary->receiver()->isMessage());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Simple block", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("[123]");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isBlock());
    
    SBlockNode* block = static_cast<SBlockNode*>(stmt);
    REQUIRE(block->arguments().empty());
    REQUIRE(block->temporaries().empty());
    REQUIRE(block->statements().size() == 1);
    REQUIRE(block->statements()[0]->isLiteral());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Block with arguments", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("[:a :b | a + b]");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isBlock());
    
    SBlockNode* block = static_cast<SBlockNode*>(stmt);
    REQUIRE(block->arguments().size() == 2);
    REQUIRE(block->arguments()[0]->name() == "a");
    REQUIRE(block->arguments()[1]->name() == "b");
    REQUIRE(block->statements().size() == 1);
    REQUIRE(block->statements()[0]->isMessage());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Block with temporaries", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("[:i | | a b | a := i. b := i. a + b]");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isBlock());
    
    SBlockNode* block = static_cast<SBlockNode*>(stmt);
    REQUIRE(block->arguments().size() == 1);
    REQUIRE(block->temporaries().size() == 2);
    REQUIRE(block->temporaries()[0]->name() == "a");
    REQUIRE(block->temporaries()[1]->name() == "b");
    REQUIRE(block->statements().size() == 3);
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Return statement", "[parser]") {
    setUp();
    
    SMethodNode* method = parse("m ^42");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isReturn());
    
    SReturnNode* ret = static_cast<SReturnNode*>(stmt);
    REQUIRE(ret->expression() != nullptr);
    REQUIRE(ret->expression()->isLiteral());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Cascade", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("obj msg1; msg2");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isCascade());
    
    SCascadeNode* cascade = static_cast<SCascadeNode*>(stmt);
    REQUIRE(cascade->receiver() != nullptr);
    REQUIRE(cascade->receiver()->isIdentifier());
    REQUIRE(cascade->messages().size() == 2);
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Cascade with different message types", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("obj unary; + 2; keyword: 3");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isCascade());
    
    SCascadeNode* cascade = static_cast<SCascadeNode*>(stmt);
    REQUIRE(cascade->messages().size() == 3);
    
    // First message is unary
    REQUIRE(cascade->messages()[0]->arguments().empty());
    
    // Second message is binary
    REQUIRE(cascade->messages()[1]->arguments().size() == 1);
    
    // Third message is keyword
    REQUIRE(cascade->messages()[2]->arguments().size() == 1);
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Method with temporaries", "[parser]") {
    setUp();
    
    SMethodNode* method = parse("m | a b c | a := 1. b := 2. c := 3. ^a + b + c");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->temporaries().size() == 3);
    REQUIRE(method->temporaries()[0]->name() == "a");
    REQUIRE(method->temporaries()[1]->name() == "b");
    REQUIRE(method->temporaries()[2]->name() == "c");
    REQUIRE(method->statements().size() == 4);
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Empty temporaries", "[parser]") {
    setUp();
    
    SMethodNode* method = parse("m || ^42");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->temporaries().empty());
    REQUIRE(method->statements().size() == 1);
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Parenthesized expression", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("(3 + 4) * 5");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isMessage());
    
    SMessageNode* mult = static_cast<SMessageNode*>(stmt);
    // Receiver should be the addition (3 + 4)
    REQUIRE(mult->receiver()->isMessage());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Multiple statements", "[parser]") {
    setUp();
    
    SMethodNode* method = parse("m a := 1. b := 2. c := 3");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 3);
    REQUIRE(method->statements()[0]->isAssignment());
    REQUIRE(method->statements()[1]->isAssignment());
    REQUIRE(method->statements()[2]->isAssignment());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Identifier", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("variable");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isIdentifier());
    
    SIdentifierNode* id = static_cast<SIdentifierNode*>(stmt);
    REQUIRE(id->name() == "variable");
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Literal number", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("42");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isLiteral());
    
    SLiteralNode* lit = static_cast<SLiteralNode*>(stmt);
    REQUIRE(lit->value() == "42");
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Literal string", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("'hello world'");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isLiteral());
    
    SLiteralNode* lit = static_cast<SLiteralNode*>(stmt);
    REQUIRE(lit->value() == "hello world");
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Literal array", "[parser]") {
    setUp();

    SMethodNode* method = parseExpression("#(16rFE $a 'hello' #s #(1 2))");

    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);

    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isLiteral());

    SLiteralNode* lit = static_cast<SLiteralNode*>(stmt);
    const LiteralValue& array = lit->literalValue();
    REQUIRE(array.isArray());
    REQUIRE(array.asArray().size() == 5);

    REQUIRE(array.asArray()[0].isInteger());
    REQUIRE(array.asArray()[0].asInteger() == 0xFE);
    REQUIRE(array.asArray()[1].isCharacter());
    REQUIRE(array.asArray()[1].asCharacter() == 'a');
    REQUIRE(array.asArray()[2].isString());
    REQUIRE(array.asArray()[2].asString() == "hello");
    REQUIRE(array.asArray()[3].isSymbol());
    REQUIRE(array.asArray()[3].asString() == "s");
    REQUIRE(array.asArray()[4].isArray());
    REQUIRE(array.asArray()[4].asArray().size() == 2);
    REQUIRE(array.asArray()[4].asArray()[0].asInteger() == 1);
    REQUIRE(array.asArray()[4].asArray()[1].asInteger() == 2);

    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Literal keyword array symbols", "[parser]") {
    setUp();

    SMethodNode* method = parseExpression("#(a:b: c: d:)");

    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);

    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isLiteral());

    SLiteralNode* lit = static_cast<SLiteralNode*>(stmt);
    const LiteralValue& array = lit->literalValue();
    REQUIRE(array.isArray());
    REQUIRE(array.asArray().size() == 3);

    REQUIRE(array.asArray()[0].isSymbol());
    REQUIRE(array.asArray()[0].asString() == "a:b:");
    REQUIRE(array.asArray()[1].isSymbol());
    REQUIRE(array.asArray()[1].asString() == "c:");
    REQUIRE(array.asArray()[2].isSymbol());
    REQUIRE(array.asArray()[2].asString() == "d:");

    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Negative elements in literal array", "[parser]") {
    setUp();

    SMethodNode* method = parseExpression("#(-21 1 -5 4)");

    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);

    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isLiteral());

    SLiteralNode* lit = static_cast<SLiteralNode*>(stmt);
    const LiteralValue& array = lit->literalValue();
    REQUIRE(array.isArray());
    REQUIRE(array.asArray().size() == 4);
    REQUIRE(array.asArray()[0].asInteger() == -21);
    REQUIRE(array.asArray()[1].asInteger() == 1);
    REQUIRE(array.asArray()[2].asInteger() == -5);
    REQUIRE(array.asArray()[3].asInteger() == 4);

    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Dash-starting symbols in literal array", "[parser]") {
    setUp();

    SMethodNode* method = parseExpression("#(#++ #--)");

    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);

    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isLiteral());

    SLiteralNode* lit = static_cast<SLiteralNode*>(stmt);
    const LiteralValue& array = lit->literalValue();
    REQUIRE(array.isArray());
    REQUIRE(array.asArray().size() == 2);
    REQUIRE(array.asArray()[0].isSymbol());
    REQUIRE(array.asArray()[0].asString() == "++");
    REQUIRE(array.asArray()[1].isSymbol());
    REQUIRE(array.asArray()[1].asString() == "--");

    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Complex expression", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("dict at: (index + 1) put: (value * 2)");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isMessage());
    
    SMessageNode* msg = static_cast<SMessageNode*>(stmt);
    REQUIRE(msg->arguments().size() == 2);
    
    // Both arguments should be binary messages (from parentheses)
    REQUIRE(msg->arguments()[0]->isMessage());
    REQUIRE(msg->arguments()[1]->isMessage());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Binary power operator", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("2 ^ 3");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isMessage());
    
    SMessageNode* msg = static_cast<SMessageNode*>(stmt);
    REQUIRE(msg->receiver()->isLiteral());
    REQUIRE(msg->arguments().size() == 1);
    REQUIRE(msg->arguments()[0]->isLiteral());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Binary colon operator", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("3 : 4");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isMessage());
    
    SMessageNode* msg = static_cast<SMessageNode*>(stmt);
    REQUIRE(msg->receiver()->isLiteral());
    REQUIRE(msg->arguments().size() == 1);
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Chained unary messages", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("obj first second third");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isMessage());
    
    // Should be nested messages: ((obj first) second) third
    SMessageNode* third = static_cast<SMessageNode*>(stmt);
    REQUIRE(third->receiver()->isMessage());
    
    SMessageNode* second = static_cast<SMessageNode*>(third->receiver());
    REQUIRE(second->receiver()->isMessage());
    
    SMessageNode* first = static_cast<SMessageNode*>(second->receiver());
    REQUIRE(first->receiver()->isIdentifier());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Chained binary messages", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("1 + 2 + 3 + 4");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isMessage());
    
    // Should be nested: ((1 + 2) + 3) + 4
    SMessageNode* plus4 = static_cast<SMessageNode*>(stmt);
    REQUIRE(plus4->receiver()->isMessage());
    
    SMessageNode* plus3 = static_cast<SMessageNode*>(plus4->receiver());
    REQUIRE(plus3->receiver()->isMessage());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Empty block", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("[]");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isBlock());
    
    SBlockNode* block = static_cast<SBlockNode*>(stmt);
    REQUIRE(block->arguments().empty());
    REQUIRE(block->temporaries().empty());
    REQUIRE(block->statements().empty());
    
    tearDown();
}

TEST_CASE_METHOD(SSmalltalkParserTestFixture, "Parser: Empty block temporaries", "[parser]") {
    setUp();
    
    SMethodNode* method = parseExpression("[:i || i + 1]");
    
    REQUIRE(method != nullptr);
    REQUIRE(method->statements().size() == 1);
    
    SParseNode* stmt = method->statements()[0];
    REQUIRE(stmt->isBlock());
    
    SBlockNode* block = static_cast<SBlockNode*>(stmt);
    REQUIRE(block->arguments().size() == 1);
    REQUIRE(block->temporaries().empty());
    REQUIRE(block->statements().size() == 1);
    
    tearDown();
}
