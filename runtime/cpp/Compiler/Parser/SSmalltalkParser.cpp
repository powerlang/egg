/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "SSmalltalkParser.h"
#include "../SSmalltalkCompiler.h"
#include "../LiteralValue.h"
#include "SSmalltalkScanner.h"
#include "../../Egg.h"
#include <stdexcept>
#include <sstream>
#include <iostream>
#include <cstdlib>

namespace Egg {

SSmalltalkParser::SSmalltalkParser(SSmalltalkCompiler* compiler) 
    : _compiler(compiler), _scanner(compiler->scanner()) {
}

SSmalltalkParser::~SSmalltalkParser() {
}

SMethodNode* SSmalltalkParser::parseMethod() {
    return method();
}

SMethodNode* SSmalltalkParser::parseExpression() {
    return headlessMethod();
}

SToken* SSmalltalkParser::next() {
    if (_next) {
        _token = std::move(_next);
        _next.reset();
    } else {
        _token.reset(_scanner->nextToken().release());
    }
    return _token.get();
}

SToken* SSmalltalkParser::peek() {
    if (_next) {
        return _next.get();
    }
    
    _next.reset(_scanner->nextToken().release());
    std::vector<Egg::string> comments;
    while (_next && _next->isComment()) {
        comments.push_back(_next->value());
        _next.reset(_scanner->nextToken().release());
    }
    
    if (_next && !comments.empty()) {
        for (auto& comment : comments) {
            _next->addComment_(comment);
        }
    }
    
    return _next.get();
}

SToken* SSmalltalkParser::step() {
    SToken* save = _token.get();
    next();
    std::vector<Egg::string> comments;
    while (_token && _token->isComment()) {
        comments.push_back(_token->value());
        next();
    }
    
    if (_token && !comments.empty()) {
        for (auto& comment : comments) {
            _token->addComment_(comment);
        }
    }
    
    return save;
}

void SSmalltalkParser::skipDots() {
    while (_token && _token->is('.')) step();
}

void SSmalltalkParser::error_(const std::string& message) {
    error_(message, _token ? _token->position().start() : 0);
}

void SSmalltalkParser::error_(const std::string& message, uint32_t position) {
    std::stringstream ss;
    ss << "Parse error at position " << position << ": " << message;
    throw std::runtime_error(ss.str());
}

void SSmalltalkParser::missingToken_(const std::string& expected) {
    error_("missing " + expected);
}

void SSmalltalkParser::missingExpression() {
    error_("missing expression");
}

void SSmalltalkParser::missingArgument() {
    error_("argument missing");
}

SMethodNode* SSmalltalkParser::method() {
    step();
    SMethodNode* method = methodSignature();
    if (!method) {
        return nullptr;
    }
    addBodyTo_(method);
    return method;
}

SMethodNode* SSmalltalkParser::headlessMethod() {
    step();
    SMethodNode* method = new SMethodNode(_compiler);
    _compiler->activeScript_(method);
    addBodyTo_(method);
    return method;
}

SMethodNode* SSmalltalkParser::methodSignature() {
    SMethodNode* method = keywordSignature();
    if (method) return method;
    
    method = binarySignature();
    if (method) return method;
    
    method = unarySignature();
    if (method) return method;
    
    error_("method signature expected");
    return nullptr;
}

SMethodNode* SSmalltalkParser::unarySignature() {
    if (!hasUnarySelector()) {
        return nullptr;
    }
    
    SSelectorNode* selectorNode = new SSelectorNode(_compiler);
    selectorNode->symbol_(_token->value());
    selectorNode->position_(_token->position());
    
    step();
    
    std::vector<SIdentifierNode*> emptyArgs;
    return buildMethodNode_(selectorNode, emptyArgs);
}

SMethodNode* SSmalltalkParser::binarySignature() {
    if (!hasBinarySelector()) {
        return nullptr;
    }
    SSelectorNode* selectorNode = new SSelectorNode(_compiler);
    selectorNode->symbol_(_token->value());
    selectorNode->position_(_token->position());
    
    step();
    
    if (!_token || !_token->isName()) {
        missingArgument();
    }
    
    SIdentifierNode* arg = new SIdentifierNode(_compiler);
    arg->name_(_token->value());
    arg->position_(_token->position());
    
    step();
    
    std::vector<SIdentifierNode*> args;
    args.push_back(arg);
    
    return buildMethodNode_(selectorNode, args);
}

SMethodNode* SSmalltalkParser::keywordSignature() {
    if (!hasKeywordSelector()) {
        return nullptr;
    }
    
    Egg::string selector;
    std::vector<SIdentifierNode*> arguments;
    uint32_t start = _token->position().start();
    
    while (_token && _token->isKeyword()) {
        selector += _token->value();
        step();
        
        if (!_token || !_token->isName()) {
            missingArgument();
        }
        
        SIdentifierNode* arg = new SIdentifierNode(_compiler);
        arg->name_(_token->value());
        arg->position_(_token->position());
        arguments.push_back(arg);
        
        step();
    }
    
    if (arguments.empty()) {
        return nullptr;
    }
    SSelectorNode* selectorNode = new SSelectorNode(_compiler);
    selectorNode->symbol_(selector);
    selectorNode->position_(Stretch(start, _token->position().start() - 1));
    
    return buildMethodNode_(selectorNode, arguments);
}

void SSmalltalkParser::addBodyTo_(SMethodNode* method) {
    addTemporariesTo_(method);
    addPragmaTo_(method);
    addStatementsTo_(method);
}

void SSmalltalkParser::addTemporariesTo_(SMethodNode* method) {
    method->temporaries_(temporaries());
}

void SSmalltalkParser::addStatementsTo_(SMethodNode* method) {
    method->position_(_token->position());
    auto stmts = statements();
    for (auto stmt : stmts) method->addStatement_(stmt);
    method->position_(Stretch(method->position().start(), _token->position().start()));
    if (_token && !_token->isEnd()) {
        error_("unexpected statement", _token->position().start());
    }
}

std::vector<SIdentifierNode*> SSmalltalkParser::temporaries() {
    std::vector<SIdentifierNode*> temps;
    if (!_token) return temps;
    if (_token->is("||")) {
        step();
        return temps;
    }
    if (!_token->isBar()) {
        return temps;
    }
    while (true) {
        step();
        if (!_token || !_token->isName()) break;
        SIdentifierNode* temp = new SIdentifierNode(_compiler);
        temp->name_(_token->value());
        temp->position_(_token->position());
        temps.push_back(temp);
    }
    if (!_token || !_token->isBar()) {
        missingToken_("|");
    }
    step();
    
    return temps;
}

std::vector<SParseNode*> SSmalltalkParser::statements() {
    std::vector<SParseNode*> stmts;
    while (_token && !_token->endsExpression()) {
        stmts.push_back(statement());
        if (_token && _token->is('.')) skipDots(); else break;
    }
    return stmts;
}

SParseNode* SSmalltalkParser::statement() {
    if (_token && _token->is('^')) return return_();
    SParseNode* expr = expression();
    return expr;
}

SReturnNode* SSmalltalkParser::return_() {
    uint32_t returnPos = _token->position().start();
    step();
    auto expr = expression();
    if (!expr) missingExpression();
    uint32_t end = _token->position().start();
    skipDots();
    auto node = buildNode_<SReturnNode>(returnPos);
    node->expression_(expr);
    node->position_(Stretch(returnPos, end));
    return node;
}

SParseNode* SSmalltalkParser::expression() {
    if (_token && _token->isName() && peek() && peek()->isAssignment()) {
        return assignment();
    }
    
    SParseNode* prim = primary();
    if (!prim) {
        missingExpression();
    }
    
    SParseNode* expr = unarySequence_(prim);
    expr = binarySequence_(expr);
    expr = keywordSequence_(expr);
    if (expr != prim && expr->isMessage()) {
        expr = cascadeSequence_(static_cast<SMessageNode*>(expr));
    }
    
    if (_token && !_token->endsExpression()) {
        std::string desc = _token->isEnd()
            ? "unexpected end"
            : "unexpected token: " + _token->value().toUtf8();
        error_(desc, _token->position().start());
    }
    
    return expr;
}

SAssignmentNode* SSmalltalkParser::assignment() {
    uint32_t position = _token->position().start();
    auto variable = new SIdentifierNode(_compiler);
    variable->name_(_token->value());
    variable->position_(_token->position());
    step(); step();
    auto expr = expression();
    if (!expr) missingExpression();
    auto assignment = buildNode_<SAssignmentNode>(position);
    assignment->assign_operator_(variable, nullptr);
    assignment->expression_(expr);
    return assignment;
}

// =========================================================================
// Number parsing helpers
// =========================================================================

// Parse a number literal lexeme. Detects integer vs float and dispatches.
// Radix-prefixed numbers (0x.. or NrDDD) are always treated as integers;
// '.' / 'e' / 'E' inside their digit body are hex/radix digits, not float
// markers. Float radix notation is intentionally unsupported.
LiteralValue SSmalltalkParser::parseNumberString(const std::string& v) {
    bool isHexOrRadix = (v.size() > 2 && v[0] == '0' && (v[1] == 'x' || v[1] == 'X'))
                     || v.find('r') != std::string::npos
                     || v.find('R') != std::string::npos;
    if (isHexOrRadix)
        return parseIntegerString(v);
    bool looksFloat = v.find('.') != std::string::npos
                    || v.find('e') != std::string::npos
                    || v.find('E') != std::string::npos;
    if (looksFloat)
        return parseFloatString(v);
    return parseIntegerString(v);
}

// Parse a float literal lexeme (decimal only).
LiteralValue SSmalltalkParser::parseFloatString(const std::string& v) {
    return LiteralValue::fromFloat(std::stod(v));
}

// Parse an integer literal lexeme handling decimal, hex (0x), and radix
// (NrDDD) notation. The factory in LiteralValue decides Integer vs LargeInteger.
// Base is constrained to [2, 36] because we accept digits 0-9 and A-Z
// (case-insensitive), giving 36 distinct symbols.
LiteralValue SSmalltalkParser::parseIntegerString(const std::string& v) {
    uint32_t base = 10;
    std::string digits = v;
    if (v.size() > 2 && v[0] == '0' && (v[1] == 'x' || v[1] == 'X')) {
        base = 16;
        digits = v.substr(2);
    } else {
        auto rpos = v.find('r');
        if (rpos == std::string::npos) rpos = v.find('R');
        if (rpos != std::string::npos) {
            uint64_t parsed = std::stoull(v.substr(0, rpos));
            if (!(parsed >= 2 && parsed <= 36))
                Egg::error("integer literal radix out of range [2, 36]");
            base = (uint32_t)parsed;
            digits = v.substr(rpos + 1);
        }
    }
    return LiteralValue::fromIntegerDigits(base, digits, /*negative*/ false);
}

// Convert current literal token to a LiteralValue
LiteralValue SSmalltalkParser::parseLiteralValue() {
    auto* strTok = static_cast<SStringToken*>(_token.get());
    switch (strTok->literalKind()) {
        case SStringToken::LitNumber:
            return parseNumberString(_token->value().toUtf8());
        case SStringToken::LitCharacter:
            return LiteralValue::fromCharacter(_token->value()[0]);
        case SStringToken::LitSymbol:
            return LiteralValue::fromSymbol(_token->value());
        case SStringToken::LitString:
        default:
            return LiteralValue::fromString(_token->value());
    }
}

// Matches Smalltalk pseudoLiteralValue
LiteralValue SSmalltalkParser::pseudoLiteralValue() {
    Egg::string val = _token->value();
    if (val == "nil")   return LiteralValue::nil();
    if (val == "true")  return LiteralValue::fromBoolean(true);
    if (val == "false") return LiteralValue::fromBoolean(false);
    return LiteralValue::fromSymbol(val);
}

// Matches Smalltalk negativeNumberOrBinary
LiteralValue SSmalltalkParser::negativeNumberOrBinary() {
    auto peekToken = peek();
    if (peekToken && peekToken->isLiteral()) {
        auto* strTok = static_cast<SStringToken*>(peekToken);
        if (strTok->literalKind() == SStringToken::LitNumber) {
            step();
            LiteralValue val = parseLiteralValue();
            if (val.tag == LiteralValue::Integer)
                return LiteralValue::fromInteger(-val.intVal);
            if (val.tag == LiteralValue::LargeInteger)
                return LiteralValue::fromLargeInteger(
                    std::vector<uint8_t>(val.asLargeIntegerBytes()), true);
            if (val.tag == LiteralValue::Float)
                return LiteralValue::fromFloat(-val.floatVal);
        }
    }
    return LiteralValue(); // None — signals no negative number found
}

SParseNode* SSmalltalkParser::primary() {
    if (!_token) return nullptr;
    if (_token->isName()) {
        SIdentifierNode* id = new SIdentifierNode(_compiler);
        id->name_(_token->value());
        id->position_(_token->position());
        step();
        return id;
    }
    if (_token->isLiteral()) {
        SLiteralNode* lit = new SLiteralNode(_compiler);
        lit->literalValue_(parseLiteralValue());
        lit->position_(_token->position());
        step();
        return lit;
    }
    if (_token->is('[')) return block();
    if (_token->is('(')) return parenthesizedExpression();
    if (_token->is("#(")) return literalArray();
    if (_token->is("#[")) return literalByteArray();
    if (_token->is('{')) return bracedArray();
    if (_token->is('-')) {
        LiteralValue negVal = negativeNumberOrBinary();
        if (!negVal.isNone()) {
            SLiteralNode* lit = new SLiteralNode(_compiler);
            lit->literalValue_(std::move(negVal));
            lit->position_(Stretch(_token->position().start() - 1, _token->position().end()));
            step();
            return lit;
        }
        return nullptr;
    }
    return nullptr;
}

SBlockNode* SSmalltalkParser::block() {
    uint32_t position = _token->position().start();
    SBlockNode* block = new SBlockNode(_compiler);
    block->position_(Stretch(position, _token->position().start()));
    block->parent_(_compiler->activeScript());
    _compiler->activate_while_(block, [&]() {
        step();
        block->arguments_(blockArguments());
        block->temporaries_(temporaries());
        auto stmts = statements();
        for (auto stmt : stmts) block->addStatement_(stmt);
        if (!_token || !_token->is(']')) {
            missingToken_("]");
        }
        block->position_(Stretch(position, _token->position().end()));
        step();
    });
    return block;
}

std::vector<SIdentifierNode*> SSmalltalkParser::blockArguments() {
    std::vector<SIdentifierNode*> args;
    
    if (!_token || !_token->is(':')) {
        return args;
    }
    
    while (_token && _token->is(':')) {
        step();
        
        if (!_token || !_token->isName()) {
            missingArgument();
        }
        
        SIdentifierNode* arg = new SIdentifierNode(_compiler);
        arg->name_(_token->value());
        arg->position_(_token->position());
        args.push_back(arg);
        
        step();
    }
    if (_token && _token->isBar()) {
        step();
    } else if (_token && _token->is("||")) {
        step(); // consume || as closing | for args + empty temps
    } else {
        missingToken_("|");
    }
    
    return args;
}

SParseNode* SSmalltalkParser::parenthesizedExpression() {
    uint32_t start = _token->position().start();
    step();
    auto expr = expression();
    if (!expr) missingExpression();
    if (!_token || !_token->is(')')) missingToken_(")");
    uint32_t end = _token->position().end();
    step();
    if (!expr->isImmediate()) expr->position_(Stretch(start, end));
    return expr;
}

SParseNode* SSmalltalkParser::unarySequence_(SParseNode* receiver) {
    auto node = receiver;
    while (hasUnarySelector()) {
        auto msg = buildMessageNode_(node);
        unaryMessage_(msg);
        node = msg;
    }
    return node;
}

void SSmalltalkParser::unaryMessage_(SMessageNode* message) {
    auto selectorNode = new SSelectorNode(_compiler);
    selectorNode->symbol_(_token->value());
    selectorNode->position_(_token->position());
    step();
    message->selector_(selectorNode);
    message->position_(Stretch(message->position().start(), selectorNode->position().end()));
}

SParseNode* SSmalltalkParser::binarySequence_(SParseNode* receiver) {
    auto node = receiver;
    while (hasBinarySelector()) {
        auto msg = buildMessageNode_(node);
        binaryMessage_(msg);
        node = msg;
    }
    return node;
}

void SSmalltalkParser::binaryMessage_(SMessageNode* message) {
    auto selectorNode = new SSelectorNode(_compiler);
    selectorNode->symbol_(_token->value());
    selectorNode->position_(_token->position());
    step();
    auto prim = primary();
    if (!prim) error_("primary missing");
    auto arg = unarySequence_(prim);
    message->selector_(selectorNode);
    message->addArgument_(arg);
    message->position_(Stretch(message->position().start(), arg->position().end()));
}

SParseNode* SSmalltalkParser::keywordSequence_(SParseNode* receiver) {
    if (!hasKeywordSelector()) return receiver;
    auto message = buildMessageNode_(receiver);
    keywordMessage_(message);
    return message;
}

void SSmalltalkParser::keywordMessage_(SMessageNode* message) {
    Egg::string selector;
    std::vector<SParseNode*> arguments;
    uint32_t start = _token->position().start();
    while (_token && _token->isKeyword()) {
        selector += _token->value();
        step();
        auto prim = primary();
        if (!prim) missingArgument();
        auto arg = unarySequence_(prim);
        arg = binarySequence_(arg);
        arguments.push_back(arg);
    }
    auto selectorNode = new SSelectorNode(_compiler);
    selectorNode->symbol_(selector);
    selectorNode->position_(Stretch(start, _token->position().start() - 1));
    message->selector_(selectorNode);
    message->arguments_(arguments);
    if (!arguments.empty()) message->position_(Stretch(message->position().start(), arguments.back()->position().end()));
}

SParseNode* SSmalltalkParser::cascadeSequence_(SMessageNode* messageNode) {
    if (!_token || !_token->is(';')) return messageNode;
    auto cascade = new SCascadeNode(_compiler);
    cascade->position_(messageNode->position());
    auto receiver = messageNode->receiver();
    cascade->receiver_(receiver);
    auto firstMsg = new SCascadeMessageNode(_compiler);
    firstMsg->receiver_(receiver);
    firstMsg->selector_(messageNode->selector());
    firstMsg->arguments_(messageNode->arguments());
    firstMsg->position_(messageNode->position());
    firstMsg->cascade_(cascade);
    cascade->addMessage_(firstMsg);
    while (_token && _token->is(';')) {
        step();
        auto msg = buildCascadeMessageNode_(receiver);
        msg->cascade_(cascade);
        msg->position_(_token->position());
        cascadeMessage_(msg);
        cascade->addMessage_(msg);
    }
    const auto& messages = cascade->messages();
    if (!messages.empty()) cascade->position_(Stretch(cascade->position().start(), messages.back()->position().end()));
    return cascade;
}

void SSmalltalkParser::cascadeMessage_(SMessageNode* message) {
    if (hasUnarySelector()) unaryMessage_(message);
    else if (hasBinarySelector()) binaryMessage_(message);
    else if (hasKeywordSelector()) keywordMessage_(message);
    else error_("invalid cascade message");
}

bool SSmalltalkParser::hasUnarySelector() const {
    return _token && _token->isName();
}

bool SSmalltalkParser::hasBinarySelector() const {
    if (!_token) return false;
    // ST: (token isStringToken and: [token hasSymbol]) or: [token is: $^] or: [token is: $:]
    if (_token->isSymbolic() && _token->hasSymbol()) return true;
    if (_token->is('^')) return true;
    if (_token->is(':')) return true;
    return false;
}

bool SSmalltalkParser::hasKeywordSelector() const {
    return _token && _token->isKeyword();
}

SParseNode* SSmalltalkParser::literalArray() {
    auto* array = arrayBody();
    step();
    return array;
}

SParseNode* SSmalltalkParser::literalByteArray() {
    auto* node = byteArrayBody();
    step();
    return node;
}

SLiteralNode* SSmalltalkParser::arrayBody() {
    std::vector<LiteralValue> literals;
    uint32_t position = _token->position().start();

    while (true) {
        step();
        if (!_token || _token->is(')') || _token->isEnd()) {
            break;
        }
        literals.push_back(arrayElement());
    }

    if (!_token || _token->isEnd()) {
        missingToken_(")");
    }

    auto* node = new SLiteralNode(_compiler);
    node->literalValue_(LiteralValue::fromArray(std::move(literals)));
    node->position_(Stretch(position, _token->position().end()));
    return node;
}

LiteralValue SSmalltalkParser::arrayElement() {
    if (_token->isLiteral()) {
        return parseLiteralValue();
    }
    if (_token->isName()) {
        return pseudoLiteralValue();
    }
    if (_token->isKeyword()) {
        return literalKeyword();
    }
    if (_token->is('-')) {
        LiteralValue neg = negativeNumberOrBinary();
        return neg.isNone() ? LiteralValue::fromSymbol("-") : std::move(neg);
    }
    if (_token->hasSymbol()) {
        return LiteralValue::fromSymbol(_token->value());
    }
    if (_token->is('(') || _token->is("#(")) {
        return arrayBody()->literalValue();
    }
    if (_token->is("#[")) {
        return byteArrayBody()->literalValue();
    }
    error_("invalid literal array element");
    return LiteralValue();
}

LiteralValue SSmalltalkParser::literalKeyword() {
    Egg::string keyword = _token->value();
    uint32_t prevEnd = _token->position().end();

    while (true) {
        auto* nextToken = peek();
        if (!nextToken || !nextToken->isKeyword() || nextToken->position().start() != prevEnd) {
            break;
        }
        step();
        keyword += _token->value();
        prevEnd = _token->position().end();
    }

    return LiteralValue::fromSymbol(keyword);
}

SLiteralNode* SSmalltalkParser::byteArrayBody() {
    std::vector<uint8_t> bytes;
    uint32_t position = _token->position().start();

    while (true) {
        step();
        if (!_token || !_token->isLiteral()) {
            break;
        }

        std::string v = _token->value().toUtf8();
        int val = static_cast<int>(std::stol(v, nullptr, 0));
        bytes.push_back(static_cast<uint8_t>(val));
    }

    if (!_token || !_token->is(']')) {
        missingToken_("]");
    }

    auto* node = new SLiteralNode(_compiler);
    node->literalValue_(LiteralValue::fromByteArray(std::move(bytes)));
    node->position_(Stretch(position, _token->position().end()));
    return node;
}

SBraceNode* SSmalltalkParser::bracedArray() {
    uint32_t position = _token->position().start();
    step();
    SBraceNode* brace = new SBraceNode(_compiler);
    brace->position_(Stretch(position, _token->position().start()));
    while (_token && !_token->is('}') && !_token->isEnd()) {
        SParseNode* expr = expression();
        if (expr) {
            brace->addElement_(expr);
        }
        if (_token && _token->is('.')) {
            step();
        }
    }
    if (!_token || !_token->is('}')) {
        missingToken_("}");
    }
    brace->position_(Stretch(position, _token->position().end()));
    step();
    return brace;
}

void SSmalltalkParser::addPragmaTo_(SMethodNode* method) {
    if (attachPragmaTo_(method)) {
        step();
    }
}

bool SSmalltalkParser::attachPragmaTo_(SMethodNode* method) {
    if (method->isHeadless() || !_token || !_token->is('<')) {
        return false;
    }
    
    uint32_t start = _token->position().start();
    step();
    
    SPragmaNode* node = nullptr;
    
    if (_token && _token->isKeyword()) {
        Egg::string keyword = _token->value();
        if (keyword == "primitive:") {
            node = pragma();
        } else {
            node = symbolicPragma();
        }
    } else {
        node = symbolicPragma();
    }
    
    if (node) {
        node->position_(Stretch(start, _token->position().end()));
        method->pragma_(node);
    }
    
    if (!_token || !_token->is('>')) {
        missingToken_(">");
    }
    
    return true;
}

SPragmaNode* SSmalltalkParser::pragma() {
    step();
    
    if (!_token) {
        error_("missing pragma value");
    }
    
    if (_token->isLiteral()) {
        return numberedPrimitive();
    } else if (_token->isName()) {
        return namedPrimitive();
    }
    
    error_("invalid pragma format");
    return nullptr;
}

SPragmaNode* SSmalltalkParser::numberedPrimitive() {
    int number = 0;
    try {
        number = std::stoi(_token->value().toUtf8());
    } catch (...) {
        error_("invalid primitive number");
    }
    
    uint32_t position = _token->position().start();
    SPragmaNode* pragma = new SPragmaNode(_compiler);
    pragma->bePrimitive_(number, "");
    pragma->position_(Stretch(position, _token->position().end()));
    
    step();
    return pragma;
}

SPragmaNode* SSmalltalkParser::namedPrimitive() {
    Egg::string name = _token->value();
    uint32_t position = _token->position().start();
    
    SPragmaNode* pragma = new SPragmaNode(_compiler);
    pragma->bePrimitive_(0, name);
    pragma->position_(Stretch(position, _token->position().end()));
    
    step();
    return pragma;
}

SPragmaNode* SSmalltalkParser::symbolicPragma() {
    Egg::string symbol = _token->value();
    uint32_t position = _token->position().start();
    
    SPragmaNode* pragma = new SPragmaNode(_compiler);
    pragma->beSymbolic_(symbol);
    pragma->position_(Stretch(position, _token->position().end()));
    
    step();
    return pragma;
}

SMethodNode* SSmalltalkParser::buildMethodNode_(SSelectorNode* selector, const std::vector<SIdentifierNode*>& arguments) {
    SMethodNode* method = new SMethodNode(_compiler);
    method->selector_(selector);
    method->arguments_(arguments);
    method->position_(selector->position());
    _compiler->activeScript_(method);
    return method;
}

SMessageNode* SSmalltalkParser::buildMessageNode_(SParseNode* receiver) {
    SMessageNode* msg = new SMessageNode(_compiler);
    msg->receiver_(receiver);
    msg->position_(receiver->position());
    return msg;
}

SCascadeMessageNode* SSmalltalkParser::buildCascadeMessageNode_(SParseNode* receiver) {
    SCascadeMessageNode* msg = new SCascadeMessageNode(_compiler);
    msg->receiver_(receiver);
    msg->position_(receiver->position());
    return msg;
}

} // namespace Egg
