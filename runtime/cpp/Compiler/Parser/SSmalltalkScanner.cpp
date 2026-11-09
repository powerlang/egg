/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "SSmalltalkScanner.h"
#include "../SCompiler.h"
#include "../SSmalltalkCompiler.h"
#include <sstream>
#include <stdexcept>
#include <cctype>

namespace Egg {

SSmalltalkScanner::SSmalltalkScanner(SSmalltalkCompiler* compiler) : _compiler(compiler) {}

SSmalltalkScanner::~SSmalltalkScanner() {}

void SSmalltalkScanner::compiler_(SSmalltalkCompiler* compiler) {
    _compiler = compiler;
}

void SSmalltalkScanner::on_(const Egg::string& source) {
    stream.on_(source);
}

void SSmalltalkScanner::sourceCode_(const Egg::string& source) {
    stream.on_(source);
}

std::unique_ptr<SToken> SSmalltalkScanner::next() {
    return nextToken();
}

bool SSmalltalkScanner::canBeInIdentifier_(uint32_t ch) const {
    return _compiler->frontend()->canBeInIdentifier_(ch);
}

bool SSmalltalkScanner::canStartIdentifier_(uint32_t ch) const {
    if (!_compiler->frontend()->canStartIdentifier_(ch)) return false;
    if (ch == '_') {
        uint32_t next = stream.peek();
        return next != 0 && next >= 33;
    }
    return true;
}

std::unique_ptr<SEndToken> SSmalltalkScanner::end() {
    auto token = new SEndToken(Stretch(stream.position() + 1));
    return std::unique_ptr<SEndToken>(token);
}

void SSmalltalkScanner::error_(const std::string& message) {
    error_at_(message, stream.position());
}

void SSmalltalkScanner::error_at_(const std::string& message, size_t position) {
    std::ostringstream oss;
    oss << "Scanner error at position " << position << ": " << message;
    throw std::runtime_error(oss.str());
}

bool SSmalltalkScanner::isBinary_(uint32_t ch) const {
    if (ch == 0) return false;
    if (ch < 128) {
        return ch == '+' || ch == '-' || ch == '<' || ch == '>' || ch == '=' ||
               ch == '*' || ch == '/' || ch == '\\' || ch == '|' || ch == '&' ||
               ch == '~' || ch == ',' || ch == '@' || ch == '%' || ch == '?' ||
               ch == '!' || ch == ':' || ch == '^';
    }
    return ch > 255;
}

std::unique_ptr<SDelimiterToken> SSmalltalkScanner::nextArrayPrefix() {
    Egg::string string = stream.copyFrom_to_(stream.position() - 2, stream.position());
    auto token = new SDelimiterToken(Stretch(0, 0), U"");
    return buildToken_at_with_(token, stream.position() - 2, string);
}

std::unique_ptr<SDelimiterToken> SSmalltalkScanner::nextAssignment() {
    auto token = new SDelimiterToken(Stretch(0, 0), U"");
    return buildToken_at_with_(token, stream.position(), Egg::string(U":="));
}

std::unique_ptr<SSymbolicToken> SSmalltalkScanner::nextBinarySelector() {
    stream.back();
    size_t start = stream.position();
    Egg::string value = scanBinarySymbol();
    auto token = new SSymbolicToken(Stretch(0, 0), U"", true);
    return buildToken_at_with_(token, start, value);
}

std::unique_ptr<SStringToken> SSmalltalkScanner::nextBinarySymbol() {
    size_t start = stream.position();
    Egg::string value = scanBinarySymbol();
    auto token = new SStringToken(Stretch(0, 0), U"", SStringToken::LitSymbol);
    return buildToken_at_with_(token, start, value);
}

std::unique_ptr<SToken> SSmalltalkScanner::nextColon() {
    size_t start = stream.position();
    uint32_t ch = stream.peek();
    
    if ((ch == ' ' || ch == '\t') && !stream.atEnd()) {
        stream.next(); // skip space/tab
        if (stream.peek() == '=') {
            ch = '=';
        } else {
            stream.back();
        }
    }
    
    if (ch == '=') {
        stream.next(); // skip =
        auto token = nextAssignment();
        token->position_(Stretch(start, stream.position()));
        return token;
    }
    
    if (isBinary_(stream.peek())) {
        return nextBinarySelector();
    }
    
    return nextSpecialCharacter();
}

std::unique_ptr<SToken> SSmalltalkScanner::nextComment() {
    size_t start = stream.position();
    
    while (!stream.atEnd() && stream.peek() != '"') {
        stream.next();
    }
    
    if (stream.atEnd()) {
        error_at_("unfinished comment", start);
    }
    
    stream.position_(start);
    Egg::string comment = stream.upTo_('"');
    
    return nextToken();
}

std::unique_ptr<SSymbolicToken> SSmalltalkScanner::nextIdentifierOrKeyword() {
    stream.back(); // Back to the first character
    size_t start = stream.position();
    skipIdentifier();
    
    if (stream.peekFor_(':') && stream.peekFor_('=')) {
        stream.back();
        stream.back();
    }
    
    auto token = new SSymbolicToken(Stretch(0, 0), U"");
    return buildToken_at_(token, start);
}

std::unique_ptr<SStringToken> SSmalltalkScanner::nextKeyword() {
    size_t start = stream.position();
    skipKeyword();
    Egg::string string = stream.copyFrom_to_(start, stream.position());
    auto token = new SStringToken(Stretch(0, 0), U"", SStringToken::LitSymbol);
    return buildToken_at_with_(token, start, string);
}

std::unique_ptr<SStringToken> SSmalltalkScanner::nextLiteralCharacter() {
    if (stream.atEnd()) {
        error_("character expected");
    }
    uint32_t cp = stream.next();
    Egg::string value(1, (char32_t)cp);
    auto token = new SStringToken(Stretch(0, 0), U"", SStringToken::LitCharacter);
    return buildToken_at_with_(token, stream.position(), value);
}

std::unique_ptr<SStringToken> SSmalltalkScanner::nextLiteralString() {
    size_t start = stream.position();
    Egg::string value = scanString();
    auto token = new SStringToken(Stretch(0, 0), U"");
    return buildToken_at_with_(token, start, value);
}

std::unique_ptr<SStringToken> SSmalltalkScanner::nextNumber() {
    stream.back();
    size_t start = stream.position();
    
    auto isDigit = [](uint32_t ch) { return ch < 128 && std::isdigit((int)ch); };
    auto isAlpha = [](uint32_t ch) { return ch < 128 && std::isalpha((int)ch); };
    auto isAlnum = [](uint32_t ch) { return ch < 128 && std::isalnum((int)ch); };
    auto isHexDigit = [](uint32_t ch) { return ch < 128 && std::isxdigit((int)ch); };
    
    // Read integer part
    while (!stream.atEnd() && isDigit(stream.peek())) {
        stream.next();
    }
    
    // Check for 0x hex prefix notation (e.g., 0xFF)
    if ((stream.position() - start) == 1 && !stream.atEnd() && (stream.peek() == 'x' || stream.peek() == 'X')) {
        stream.next(); // skip 'x'/'X'
        while (!stream.atEnd() && isHexDigit(stream.peek())) {
            stream.next();
        }
    }
    // Check for radix notation (e.g., 16rFF)
    else if (!stream.atEnd() && (stream.peek() == 'r' || stream.peek() == 'R')) {
        size_t savedPos = stream.position();
        stream.next(); // skip 'r'
        if (!stream.atEnd() && isAlnum(stream.peek())) {
            while (!stream.atEnd() && isAlnum(stream.peek())) {
                stream.next();
            }
        } else {
            stream.position_(savedPos);
        }
    }
    // Check for float (digits followed by '.' followed by digit)
    else if (!stream.atEnd() && stream.peek() == '.') {
        size_t savedPos = stream.position();
        stream.next(); // skip '.'
        if (!stream.atEnd() && isDigit(stream.peek())) {
            while (!stream.atEnd() && isDigit(stream.peek())) {
                stream.next();
            }
            // Check for scientific notation
            if (!stream.atEnd() && (stream.peek() == 'e' || stream.peek() == 'E')) {
                stream.next();
                if (!stream.atEnd() && (stream.peek() == '+' || stream.peek() == '-')) {
                    stream.next();
                }
                while (!stream.atEnd() && isDigit(stream.peek())) {
                    stream.next();
                }
            }
        } else {
            stream.position_(savedPos); // '.' is not part of number
        }
    }
    
    Egg::string value = stream.copyFrom_to_(start, stream.position());
    auto token = new SStringToken(Stretch(0, 0), U"", SStringToken::LitNumber);
    return buildToken_at_with_(token, start, value);
}

std::unique_ptr<SStringToken> SSmalltalkScanner::nextQuotedSymbol() {
    auto node = nextLiteralString();
    node->literalKind_(SStringToken::LitSymbol);
    node->position_(Stretch(node->position().start() - 1, node->position().end()));
    return node;
}

std::unique_ptr<SDelimiterToken> SSmalltalkScanner::nextSpecialCharacter() {
    auto token = new SDelimiterToken(Stretch(0, 0), U"");
    return buildToken_at_(token, stream.position() - 1);
}

std::unique_ptr<SToken> SSmalltalkScanner::nextSymbolOrArrayPrefix() {
    if (stream.atEnd()) {
        error_("character expected");
    }
    
    uint32_t ch = stream.peek();
    
    if (canBeInIdentifier_(ch)) {
        return nextKeyword();
    }
    
    if (isBinary_(ch)) {
        return nextBinarySymbol();
    }
    
    stream.next();
    
    if (ch == '[' || ch == '(') {
        return nextArrayPrefix();
    }
    
    if (ch == '\'') {
        return nextQuotedSymbol();
    }
    
    error_("character expected");
    return nullptr;
}

std::unique_ptr<SToken> SSmalltalkScanner::nextToken() {
    uint32_t first = scanChar();
    
    if (first == 0) {
        return end();
    }
    
    if (canStartIdentifier_(first)) {
        return nextIdentifierOrKeyword();
    }
    
    if (first == '_') {
        return nextAssignment();
    }
    
    if (first == ':') {
        return nextColon();
    }
    
    if (first == '\'') {
        return nextLiteralString();
    }
    
    if (first == '$') {
        return nextLiteralCharacter();
    }
    
    if (first == '#') {
        return nextSymbolOrArrayPrefix();
    }
    
    if (first == '"') {
        return nextComment();
    }
    
    if (first < 128 && std::isdigit((int)first)) {
        return nextNumber();
    }
    
    if (first != '^' && isBinary_(first)) {
        return nextBinarySelector();
    }
    
    return nextSpecialCharacter();
}

Egg::string SSmalltalkScanner::scanBinarySymbol() {
    size_t start = stream.position();
    skipBinary();
    Egg::string symbol = stream.copyFrom_to_(start, stream.position());
    return symbol;
}

uint32_t SSmalltalkScanner::scanChar() {
    while (!stream.atEnd()) {
        uint32_t ch = stream.peek();
        if (ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n') {
            stream.next();
        } else {
            break;
        }
    }
    
    if (stream.atEnd()) return 0;
    return stream.next();
}

Egg::string SSmalltalkScanner::scanString() {
    size_t current = stream.position();
    size_t start = current;
    Egg::string result;
    
    while (true) {
        Egg::string fragment = stream.upTo_('\'');
        result += fragment;
        
        if (current < stream.position()) {
            stream.back();
            uint32_t ch = stream.next();
            if (ch != '\'') {
                error_at_("string end expected", start);
            }
        } else {
            error_at_("string end expected", start);
        }
        
        if (!stream.peekFor_('\'')) {
            break;
        }
        
        result += U'\'';
        current = stream.position();
    }
    
    return result;
}

void SSmalltalkScanner::skipBinary() {
    while (isBinary_(stream.peek())) {
        stream.next();
    }
}

void SSmalltalkScanner::skipIdentifier() {
    while (!stream.atEnd()) {
        if (!_compiler->frontend()->peekForIdentifier_(stream)) {
            return;
        }
    }
}

void SSmalltalkScanner::skipKeyword() {
    size_t pos = 0;
    while (true) {
        skipIdentifier();
        bool continue_loop = false;
        
        if (stream.peekFor_(':')) {
            pos = stream.position();
            if (!stream.atEnd()) {
                continue_loop = canStartIdentifier_(stream.peek());
            }
        }
        
        if (!continue_loop) {
            if (pos != 0) {
                stream.position_(pos);
            }
            break;
        }
    }
}

} // namespace Egg
