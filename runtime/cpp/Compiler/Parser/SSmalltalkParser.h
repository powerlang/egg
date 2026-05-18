/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#ifndef _SSMALLTALKPARSER_H_
#define _SSMALLTALKPARSER_H_

#include <string>
#include <memory>
#include <vector>
#include "SToken.h"
#include "../SSmalltalkCompiler.h"
#include "../LiteralValue.h"
#include "../AST/SParseNode.h"
#include "../AST/SIdentifierNode.h"
#include "../AST/SLiteralNode.h"
#include "../AST/SMessageNode.h"
#include "../AST/SAssignmentNode.h"
#include "../AST/SReturnNode.h"
#include "../AST/SMethodNode.h"
#include "../AST/SBlockNode.h"
#include "../AST/SCascadeNode.h"
#include "../AST/SBraceNode.h"
#include "../AST/SCascadeMessageNode.h"
#include "../AST/SSelectorNode.h"
#include "../AST/SNumberNode.h"
#include "../AST/SStringNode.h"
#include "../AST/SPragmaNode.h"

namespace Egg {

class SSmalltalkScanner;

/**
 * Parser for Smalltalk code
 * Implements a recursive descent parser
 * Corresponds to SmalltalkParser in Smalltalk
 */
class SSmalltalkParser {
private:
    SSmalltalkCompiler* _compiler;
    SSmalltalkScanner* _scanner;
    std::unique_ptr<SToken> _token;
    std::unique_ptr<SToken> _next;
    
public:
    SSmalltalkParser(SSmalltalkCompiler* compiler);
    ~SSmalltalkParser();
    
    SMethodNode* parseMethod();
    SMethodNode* parseExpression();
    
    SMethodNode* method();
    SMethodNode* headlessMethod();
    SMethodNode* methodSignature();
    SMethodNode* unarySignature();
    SMethodNode* binarySignature();
    SMethodNode* keywordSignature();
    
    SParseNode* expression();
    SParseNode* primary();
    SParseNode* statement();
    std::vector<SParseNode*> statements();
    
    SParseNode* unarySequence_(SParseNode* receiver);
    SParseNode* binarySequence_(SParseNode* receiver);
    SParseNode* keywordSequence_(SParseNode* receiver);
    SParseNode* cascadeSequence_(SMessageNode* message);
    
    void unaryMessage_(SMessageNode* message);
    void binaryMessage_(SMessageNode* message);
    void keywordMessage_(SMessageNode* message);
    void cascadeMessage_(SMessageNode* message);
    
    SBlockNode* block();
    std::vector<SIdentifierNode*> blockArguments();
    
    SReturnNode* return_();
    SAssignmentNode* assignment();
    
    std::vector<SIdentifierNode*> temporaries();
    
    void addBodyTo_(SMethodNode* method);
    void addTemporariesTo_(SMethodNode* method);
    void addStatementsTo_(SMethodNode* method);
    void addPragmaTo_(SMethodNode* method);
    bool attachPragmaTo_(SMethodNode* method);
    
    SParseNode* literalArray();
    SParseNode* literalByteArray();
    SLiteralNode* arrayBody();
    LiteralValue arrayElement();
    LiteralValue literalKeyword();
    SLiteralNode* byteArrayBody();
    SBraceNode* bracedArray();
    
    LiteralValue parseLiteralValue();
    LiteralValue parseNumberString(const std::string& v);
    LiteralValue parseFloatString(const std::string& v);
    LiteralValue parseIntegerString(const std::string& v);
    LiteralValue pseudoLiteralValue();
    LiteralValue negativeNumberOrBinary();
    
    SPragmaNode* pragma();
    SPragmaNode* numberedPrimitive();
    SPragmaNode* namedPrimitive();
    SPragmaNode* symbolicPragma();
    
    SParseNode* parenthesizedExpression();
    bool hasUnarySelector() const;
    bool hasBinarySelector() const;
    bool hasKeywordSelector() const;
    
    SToken* step();
    SToken* peek();
    SToken* next();
    void skipDots();
    
    void error_(const std::string& message);
    void error_(const std::string& message, uint32_t position);
    void missingToken_(const std::string& expected);
    void missingExpression();
    void missingArgument();
    
    template<typename T>
    T* buildNode_(uint32_t position) {
        T* node = new T(_compiler);
        node->position_(Stretch(position, _token->position().end()));
        return node;
    }
    
    SMethodNode* buildMethodNode_(SSelectorNode* selector, 
                                 const std::vector<SIdentifierNode*>& arguments);
    SMessageNode* buildMessageNode_(SParseNode* receiver);
    SCascadeMessageNode* buildCascadeMessageNode_(SParseNode* receiver);
};

} // namespace Egg

#endif // _SSMALLTALKPARSER_H_
