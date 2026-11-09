/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "MessageInliner.h"
#include "AST/SMessageNode.h"
#include "AST/SBlockNode.h"
#include "AST/SIdentifierNode.h"
#include "AST/SNumberNode.h"
#include "AST/SSelectorNode.h"
#include <algorithm>

namespace Egg {

void MessageInliner::inline_(SMessageNode* aMessageNode) {
    _message = aMessageNode;
    
    if (_message->receiver()->isSuper()) {
        return;
    }
    
    if (_message->isCascadeMessage()) {
        return;
    }
    
    SSelectorNode* selectorNode = static_cast<SSelectorNode*>(_message->selector());
    Egg::string s = selectorNode->value();
    
    if (s == "ifTrue:" || s == "ifFalse:" || s == "or:" || s == "and:" || 
        s == "timesRepeat:" || s == "andNot:" || s == "orNot:" || s == "ifNil:") {
        inlineConditional();
        return;
    }
    
    if (s == "ifTrue:ifFalse:" || s == "ifFalse:ifTrue:") {
        inlineConditional();
        return;
    }
    
    if (s == "ifNotNil:") {
        inlineIfNotNil();
        return;
    }
    
    if (s == "ifNil:ifNotNil:") {
        inlineIfNilIfNotNil();
        return;
    }
    
    if (s == "ifNotNil:ifNil:") {
        inlineIfNotNilIfNil();
        return;
    }
    
    if (s == "whileTrue:" || s == "whileFalse:") {
        inlineWhile();
        return;
    }
    
    if (s == "whileTrue" || s == "whileFalse") {
        inlineUnitaryWhile();
        return;
    }
    
    if (s == "repeat") {
        inlineRepeat();
        return;
    }
    
    if (s == "to:do:") {
        inlineToDo();
        return;
    }

    if (s == "to:by:do:") {
        inlineToByDo();
        return;
    }
    
    std::vector<Egg::string> keywords;
    size_t pos = 0;
    while (pos < s.length()) {
        size_t colon = s.find(':', pos);
        if (colon == Egg::string::npos) break;
        keywords.push_back(s.substr(pos, colon - pos));
        pos = colon + 1;
    }
    
    if (!keywords.empty()) {
        if (keywords.back().empty()) {
            keywords.pop_back();
        }
        
        bool allAnd = std::all_of(keywords.begin(), keywords.end(), 
                                   [](const Egg::string& k) { return k == "and"; });
        if (allAnd) {
            inlineConditional();
            return;
        }
        
        bool allOr = std::all_of(keywords.begin(), keywords.end(), 
                                  [](const Egg::string& k) { return k == "or"; });
        if (allOr) {
            inlineConditional();
            return;
        }
        
        if (keywords.size() > 1) {
            Egg::string last = keywords.back();
            bool allButLastAnd = std::all_of(keywords.begin(), keywords.end() - 1,
                                              [](const Egg::string& k) { return k == "and"; });
            if (allButLastAnd && (last == "ifTrue" || last == "ifFalse")) {
                inlineConditional();
                return;
            }
            
            bool allButLastOr = std::all_of(keywords.begin(), keywords.end() - 1,
                                             [](const Egg::string& k) { return k == "or"; });
            if (allButLastOr && (last == "ifTrue" || last == "ifFalse")) {
                inlineConditional();
                return;
            }
        }
    }
}

void MessageInliner::inlineConditional() {
    auto& arguments = _message->arguments();
    if (arguments.size() < 1) return;
    
    for (auto arg : arguments) {
        if (!arg->isEvaluable()) return;
    }
    
    _message->beInlined_();
    
    for (auto arg : arguments) {
        if (arg->isBlock()) {
            static_cast<SBlockNode*>(arg)->beInlined_();
        }
    }
}

void MessageInliner::inlineIfNotNil() {
    auto& arguments = _message->arguments();
    if (arguments.size() != 1) return;
    
    SParseNode* arg = arguments[0];
    bool isValidArg = arg->isEvaluable() || 
                      (arg->isBlock() && static_cast<SBlockNode*>(arg)->arguments().size() == 1);
    if (!isValidArg) return;
    
    _message->beInlined_();
    if (arg->isBlock()) {
        static_cast<SBlockNode*>(arg)->beInlined_();
    }
}

void MessageInliner::inlineIfNilIfNotNil() {
    auto& arguments = _message->arguments();
    if (arguments.size() != 2) return;
    
    if (!arguments[0]->isEvaluable()) return;
    
    SParseNode* arg = arguments[1];
    bool isValidArg = arg->isEvaluable() || 
                      (arg->isBlock() && static_cast<SBlockNode*>(arg)->arguments().size() == 1);
    if (!isValidArg) return;
    
    _message->beInlined_();
    
    for (auto a : arguments) {
        if (a->isBlock()) {
            static_cast<SBlockNode*>(a)->beInlined_();
        }
    }
}

void MessageInliner::inlineIfNotNilIfNil() {
    auto& arguments = _message->arguments();
    if (arguments.size() != 2) return;
    
    if (!arguments[1]->isEvaluable()) return;
    
    SParseNode* arg = arguments[0];
    bool isValidArg = arg->isEvaluable() || 
                      (arg->isBlock() && static_cast<SBlockNode*>(arg)->arguments().size() == 1);
    if (!isValidArg) return;
    
    _message->beInlined_();
    
    for (auto a : arguments) {
        if (a->isBlock()) {
            static_cast<SBlockNode*>(a)->beInlined_();
        }
    }
}

void MessageInliner::inlineRepeat() {
    SParseNode* receiver = _message->receiver();
    if (!receiver->isEvaluable()) return;
    
    auto& arguments = _message->arguments();
    if (!arguments.empty()) return;
    
    if (!receiver->isBlock()) return;
    
    _message->beInlined_();
    static_cast<SBlockNode*>(receiver)->beInlined_();
}

void MessageInliner::inlineToDo() {
    auto& arguments = _message->arguments();
    if (arguments.size() != 2) return;
    
    SParseNode* last = arguments[1];
    if (!last->isBlock()) return;
    
    SBlockNode* block = static_cast<SBlockNode*>(last);
    if (block->arguments().size() != 1) return;
    
    _message->beInlined_();
    block->beInlined_();
}

void MessageInliner::inlineToByDo() {
    auto& arguments = _message->arguments();
    if (arguments.size() != 3) return;
    
    SParseNode* arg = arguments[2];
    if (!arg->isBlock()) return;
    
    SBlockNode* block = static_cast<SBlockNode*>(arg);
    if (block->arguments().size() != 1) return;
    
    SParseNode* step = arguments[1];
    if (!step->isLiteral()) return;
    auto& value = static_cast<SLiteralNode*>(step)->literalValue();
    if (!value.isInteger() || value.intVal == 0) return;
    
    _message->beInlined_();
    block->beInlined_();
}

void MessageInliner::inlineUnitaryWhile() {
    SParseNode* receiver = _message->receiver();
    if (!receiver->isEvaluable()) return;
    
    auto& arguments = _message->arguments();
    if (arguments.size() != 0) return;
    
    inlineConditional();
    
    if (receiver->isBlock()) {
        _message->beInlined_();
        static_cast<SBlockNode*>(receiver)->beInlined_();
    }
}

void MessageInliner::inlineWhile() {
    SParseNode* receiver = _message->receiver();
    if (!receiver->isEvaluable()) return;
    
    auto& arguments = _message->arguments();
    if (arguments.size() != 1) return;
    
    SParseNode* last = arguments[0];
    if (!last->isBlock()) return;
    
    SBlockNode* block = static_cast<SBlockNode*>(last);
    if (!block->isNullary()) return;
    
    inlineConditional();
    
    if (receiver->isBlock()) {
        static_cast<SBlockNode*>(receiver)->beInlined_();
    }
}

} // namespace Egg
