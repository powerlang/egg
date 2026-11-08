/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "SCompiler.h"
#include "Utils/egg_string.h"
#include "Parser/Stream.h"

using namespace Egg;

SCompiler::SCompiler() : _classBinding(nullptr) {
}

bool SCompiler::canStartIdentifier_(uint32_t ch) const {
    return Egg::isLetter(static_cast<char32_t>(ch)) || ch == '_';
}

bool SCompiler::canBeInIdentifier_(uint32_t ch) const {
    return Egg::isLetter(static_cast<char32_t>(ch)) || Egg::isDigit(static_cast<char32_t>(ch)) || ch == '_';
}

bool SCompiler::peekForIdentifier_(Stream& stream) const {
    auto ch = stream.peek();
    if (canBeInIdentifier_(ch)) {
        stream.next();
        return true;
    }
    if (ch != '.' || stream.position() == 0)
        return false;
    auto dot = stream.position();
    stream.position_(dot - 1);
    auto previous = stream.peek();
    stream.position_(dot + 1);
    if (Egg::isLetter(static_cast<char32_t>(previous)) && !stream.atEnd() && Egg::isLetter(static_cast<char32_t>(stream.peek())))
        return true;
    stream.position_(dot);
    return false;
}
