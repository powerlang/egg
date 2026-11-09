/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "catch2/catch.hpp"
#include "../Parser/SSmalltalkScanner.h"
#include "../Parser/SToken.h"
#include "../SCompiler.h"
#include "../SSmalltalkCompiler.h"
#include <memory>

using namespace Egg;

// Helper class for scanner tests
class SSmalltalkScannerTestFixture {
protected:
    std::unique_ptr<SSmalltalkCompiler> compiler;
    std::unique_ptr<SSmalltalkScanner> scanner;
    
    void setUp() {
        compiler = std::make_unique<SSmalltalkCompiler>();
        scanner = std::make_unique<SSmalltalkScanner>(compiler.get());
    }
    
    void scan(const std::string& source) {
        scanner->sourceCode_(source);
    }
    
    std::unique_ptr<SToken> next() {
        return scanner->nextToken();
    }
};

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Empty string", "[scanner]") {
    setUp();
    scan("");
    auto token = next();
    REQUIRE(token->isEnd());
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Simple identifier", "[scanner]") {
    setUp();
    scan("a");
    auto token = next();
    REQUIRE(token->isName());
    REQUIRE(token->value() == "a");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Multiple identifiers", "[scanner]") {
    setUp();
    scan(" a1");
    auto token = next();
    REQUIRE(token->isName());
    REQUIRE(token->value() == "a1");
    
    setUp();
    scan("_a");
    token = next();
    REQUIRE(token->isName());
    REQUIRE(token->value() == "_a");
    
    setUp();
    scan("a_1b");
    token = next();
    REQUIRE(token->isName());
    REQUIRE(token->value() == "a_1b");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Keywords", "[scanner]") {
    setUp();
    scan("a:");
    auto token = next();
    REQUIRE(token->isKeyword());
    REQUIRE(token->value() == "a:");
    
    setUp();
    scan("ab:cd:");
    auto token1 = next();
    auto token2 = next();
    REQUIRE(token1->isKeyword());
    REQUIRE(token1->value() == "ab:");
    REQUIRE(token2->isKeyword());
    REQUIRE(token2->value() == "cd:");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Integer numbers", "[scanner]") {
    setUp();
    scan("0 12");
    auto token = next();
    REQUIRE(token->value() == "0");
    
    token = next();
    REQUIRE(token->value() == "12");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Negative numbers with binary", "[scanner]") {
    setUp();
    scan("-35");
    auto token = next();
    REQUIRE(token->isSymbolic());
    REQUIRE(token->value() == "-");
    
    token = next();
    REQUIRE(token->value() == "35");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: String literals", "[scanner]") {
    setUp();
    scan("''");
    auto token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->isString());
    REQUIRE(token->value() == "");
    
    setUp();
    scan("'Hello World!'");
    token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "Hello World!");
    
    setUp();
    scan("''''");  // Single quote escaped
    token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "'");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Character literals", "[scanner]") {
    setUp();
    scan("$a$b");
    auto token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "a");
    
    token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "b");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Binary selectors", "[scanner]") {
    setUp();
    scan("-\n--\n---\n==>");
    
    auto token = next();
    REQUIRE(token->isSymbolic());
    REQUIRE(token->value() == "-");
    
    token = next();
    REQUIRE(token->isSymbolic());
    REQUIRE(token->value() == "--");
    
    token = next();
    REQUIRE(token->isSymbolic());
    REQUIRE(token->value() == "---");
    
    token = next();
    REQUIRE(token->isSymbolic());
    REQUIRE(token->value() == "==>");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Complex binary selector", "[scanner]") {
    setUp();
    scan("~!|\\/%&*+=><");
    auto token = next();
    REQUIRE(token->isSymbolic());
    REQUIRE(token->value() == "~!|\\/%&*+=><");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Symbols", "[scanner]") {
    setUp();
    scan("#-");
    auto token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "-");
    
    setUp();
    scan("#a:");
    token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "a:");
    
    setUp();
    scan("#-!");
    token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "-!");
    
    setUp();
    scan("#a:b:");
    token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "a:b:");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Symbol followed by identifier", "[scanner]") {
    setUp();
    scan("#a:b");
    auto token1 = next();
    REQUIRE(token1->isLiteral());
    REQUIRE(token1->value() == "a:");
    
    auto token2 = next();
    REQUIRE(token2->value() == "b");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Binary symbols", "[scanner]") {
    setUp();
    scan("#=");
    auto token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "=");
    
    setUp();
    scan("#++");
    token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "++");
    
    setUp();
    scan("#//");
    token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "//");
    
    setUp();
    scan("#--");
    token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "--");
    
    setUp();
    scan("#+-");
    token = next();
    REQUIRE(token->isLiteral());
    REQUIRE(token->value() == "+-");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Array prefixes", "[scanner]") {
    setUp();
    scan("#()");
    auto token = next();
    REQUIRE(token->is_("#("));
    REQUIRE(token->isDelimiter());
    
    setUp();
    scan("#[");
    token = next();
    REQUIRE(token->is_("#["));
    REQUIRE(token->isDelimiter());
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Quoted symbol", "[scanner]") {
    setUp();
    scan("#'hello'");
    auto token = next();
    REQUIRE(token->value() == "hello");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Colon", "[scanner]") {
    setUp();
    scan(":a");
    auto token = next();
    REQUIRE(token->is_(':'));
    REQUIRE(token->isDelimiter());
    
    token = next();
    REQUIRE(token->value() == "a");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Assignment operator", "[scanner]") {
    setUp();
    scan(":=");
    auto token = next();
    REQUIRE(token->isDelimiter());
    REQUIRE(token->value() == ":=");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Double colon", "[scanner]") {
    setUp();
    scan("::");
    auto token = next();
    REQUIRE(token->isSymbolic());
    REQUIRE(token->value() == "::");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Comments are consumed", "[scanner]") {
    setUp();
    scan("\"comment\"a");
    auto token = next();
    // Comment should be skipped, next token should be 'a'
    REQUIRE(token->value() == "a");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Binary colon for message", "[scanner]") {
    setUp();
    scan("3:4");
    auto token1 = next();
    REQUIRE(token1->value() == "3");
    
    auto token2 = next();
    REQUIRE(token2->value() == ":");
    
    auto token3 = next();
    REQUIRE(token3->value() == "4");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Return operator", "[scanner]") {
    setUp();
    scan("^");
    auto token = next();
    REQUIRE(token->is_('^'));
    REQUIRE(token->isDelimiter());
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Binary power operator", "[scanner]") {
    setUp();
    scan("2^3");
    auto token1 = next();
    REQUIRE(token1->value() == "2");
    
    auto token2 = next();
    REQUIRE(token2->value() == "^");
    
    auto token3 = next();
    REQUIRE(token3->value() == "3");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Parentheses and brackets", "[scanner]") {
    setUp();
    scan("()[]{}");
    
    auto token = next();
    REQUIRE(token->is_('('));
    REQUIRE(token->isDelimiter());
    
    token = next();
    REQUIRE(token->is_(')'));
    
    token = next();
    REQUIRE(token->is_('['));
    
    token = next();
    REQUIRE(token->is_(']'));
    
    token = next();
    REQUIRE(token->is_('{'));
    
    token = next();
    REQUIRE(token->is_('}'));
}


TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Semicolon cascade", "[scanner]") {
    setUp();
    scan("a;b");
    
    auto token = next();
    REQUIRE(token->value() == "a");
    
    token = next();
    REQUIRE(token->is_(';'));
    
    token = next();
    REQUIRE(token->value() == "b");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Assignment variants", "[scanner]") {
    setUp();
    scan("a := 1");
    
    auto token = next();
    REQUIRE(token->value() == "a");
    
    token = next();
    REQUIRE(token->value() == ":=");
    REQUIRE(token->isDelimiter());
    
    token = next();
    REQUIRE(token->value() == "1");
    
    // Test underscore assignment
    setUp();
    scan("a _ 1");
    
    token = next();
    REQUIRE(token->value() == "a");
    
    token = next();
    REQUIRE(token->value() == ":=");
    
    token = next();
    REQUIRE(token->value() == "1");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Complex expression", "[scanner]") {
    setUp();
    scan("self factorial: n - 1");
    
    auto token = next();
    REQUIRE(token->value() == "self");
    
    token = next();
    REQUIRE(token->value() == "factorial:");
    REQUIRE(token->isKeyword());
    
    token = next();
    REQUIRE(token->value() == "n");
    
    token = next();
    REQUIRE(token->value() == "-");
    REQUIRE(token->isSymbolic());
    
    token = next();
    REQUIRE(token->value() == "1");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Dotted identifier", "[scanner]") {
    setUp();
    scan("Kernel.Object size");
    auto token = next();
    REQUIRE(token->isName());
    REQUIRE(token->value() == "Kernel.Object");
    token = next();
    REQUIRE(token->value() == "size");
}

TEST_CASE_METHOD(SSmalltalkScannerTestFixture, "Scanner: Periods that end statements", "[scanner]") {
    setUp();
    scan("a. b");
    REQUIRE(next()->value() == "a");
    REQUIRE(next()->is('.'));
    REQUIRE(next()->value() == "b");

    setUp();
    scan("a1.b");
    REQUIRE(next()->value() == "a1");
    REQUIRE(next()->is('.'));
    REQUIRE(next()->value() == "b");

    setUp();
    scan("a.1");
    REQUIRE(next()->value() == "a");
    REQUIRE(next()->is('.'));
    REQUIRE(next()->value() == "1");

    setUp();
    scan("a.");
    REQUIRE(next()->value() == "a");
    REQUIRE(next()->is('.'));
    REQUIRE(next()->isEnd());
}
