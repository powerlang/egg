/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#include "SMethodNode.h"
#include "SParseNodeVisitor.h"
#include "SPragmaNode.h"
#include "SBlockNode.h"
#include "SLiteralNode.h"
#include "SMessageNode.h"
#include "SBraceNode.h"
#include "SIdentifierNode.h"
#include "SSelectorNode.h"
#include "../Backend/SCompiledMethod.h"
#include "../Backend/SCompiledBlock.h"
#include "../TreecodeEncoder.h"
#include "../Binding/BlockScope.h"
#include "../SSmalltalkCompiler.h"
#include "../Binding/MethodScope.h"
#include <set>

namespace Egg {

SMethodNode::SMethodNode(SSmalltalkCompiler* compiler) 
    : SScriptNode(compiler), _selector(nullptr), _pragma(nullptr) {
    // Matching Smalltalk's SMethodNode >> compiler: which does:
    //   scope := MethodScope new script: self
    auto scope = new MethodScope();
    scope->script_(this);
    _scope = scope;
}

void SMethodNode::acceptVisitor_(SParseNodeVisitor* visitor) {
    visitor->visitMethod_(this);
}

void SMethodNode::nodesDo_(std::function<void(SParseNode*)> block, bool includeDeclarations) {
    SScriptNode::nodesDo_(block, includeDeclarations);
    if (includeDeclarations && _selector) {
        _selector->nodesDo_(block, includeDeclarations);
    }
    if (_pragma) {
        _pragma->nodesDo_(block, includeDeclarations);
    }
}

SCompiledMethod* SMethodNode::buildMethod() {
    auto lits = literals();
    auto cm = SCompiledMethod::withAll(lits);
    
    cm->blockCount_(_compiler->blockCount());
    cm->tempCount_(_scope->stackSize());
    cm->argumentCount_(_arguments.size());
    cm->environmentCount_(_scope->environmentSize());
    cm->capturesSelf_(_scope->capturesSelf());
    cm->hasEnvironment_(needsEnvironment());
    cm->hasFrame_(needsFrame());
    cm->selector_(selectorString());
    cm->source_(_compiler->sourceCode());
    cm->classBinding_(_compiler->frontend() ? _compiler->frontend()->classBinding() : nullptr);
    
    cm->pragma_(_pragma);
    cm->methodClassname_(methodClassname());

    auto blocks = cm->blocks();
    for (auto block : blocks) {
        block->method_(cm);
    }
    
    // Encode treecodes (matching Smalltalk: encoder := TreecodeEncoder new method: cm)
    TreecodeEncoder encoder;
    encoder.method_(cm);
    auto treecodes = encoder.encodeMethod(this);
    cm->treecodes_(treecodes);
    
    return cm;
}

std::vector<LiteralValue> SMethodNode::literals() {
    std::vector<LiteralValue> lits;
    
    auto addUnique = [&](const LiteralValue& lv) {
        for (const auto& existing : lits) {
            if (existing == lv) return;
        }
        lits.push_back(lv);
    };
    
    // Add pragma name if used
    if (_pragma && _pragma->isUsed()) {
        const Egg::string& pragmaName = _pragma->name();
        if (!pragmaName.empty()) {
            addUnique(LiteralValue::fromSymbol(pragmaName));
        }
    }
    
    nodesDo_([&](SParseNode* n) {
        if (n->isLiteral()) {
            auto litNode = static_cast<SLiteralNode*>(n);
            const auto& lv = litNode->literalValue();
            if (!lv.isNone()) {
                // Skip small integers (encoded directly in treecode)
                if (lv.tag == LiteralValue::Integer && 
                    lv.intVal >= -16384 && lv.intVal <= 16383) {
                    // Don't add small integers to literal pool
                } else {
                    addUnique(lv);
                }
            }
        }
        if (n->isMessage()) {
            auto msg = static_cast<SMessageNode*>(n);
            auto sel = msg->selector();
            if (sel && sel->hasSymbol()) {
                addUnique(LiteralValue::fromSymbol(sel->symbol()));
            }
        }
        if (n->isBrace()) {
            auto brace = static_cast<SBraceNode*>(n);
            if (!brace->isLiteral()) {
                addUnique(LiteralValue::fromSymbol("Array"));
                addUnique(LiteralValue::fromSymbol("new:"));
                addUnique(LiteralValue::fromSymbol("at:put:"));
                addUnique(LiteralValue::fromSymbol("yourself"));
            }
        }
        if (n->isIdentifier()) {
            auto id = static_cast<SIdentifierNode*>(n);
            if (id->binding()) {
                auto bindingLit = id->binding()->literal();
                if (bindingLit) {
                    addUnique(*bindingLit);
                }
            }
        }
        if (n->isBlock()) {
            auto block = static_cast<SBlockNode*>(n);
            if (!block->isInlined()) {
                // Build block metadata matching Smalltalk's SBlockNode>>buildBlock
                int id = block->index();
                int argCount = block->arguments().size();
                int tempCount = 0;
                int envCount = 0;
                bool capturesSelf = false;
                bool capturesHome = false;
                
                auto scope = block->scope();
                if (scope) {
                    tempCount = scope->stackSize();
                    envCount = scope->environmentSize();
                    capturesSelf = scope->capturesSelf();
                    auto blockScope = dynamic_cast<BlockScope*>(scope);
                    if (blockScope) {
                        capturesHome = blockScope->capturesHome_();
                    }
                }
                
                addUnique(LiteralValue::fromBlock(id, argCount, tempCount,
                                                   envCount, capturesSelf, capturesHome));
            }
        }
    }, false);
    
    return lits;
}

Egg::string SMethodNode::methodClassname() {
    if (_pragma && _pragma->isFFI()) return "CallbackMethod";
    return "CompiledMethod";
}

bool SMethodNode::needsEnvironment() const {
    if (_scope->environmentSize() > 0) {
        return true;
    }
    for (auto child : _children) {
        auto block = static_cast<SBlockNode*>(child);
        if (block->usesHome()) {
            return true;
        }
    }
    return false;
}

bool SMethodNode::needsFrame() const {
    if (_scope->stackSize() > 0) return true;
    if (_arguments.size() > 16) return true;
    if (_compiler->hasSends()) return true;
    if (_compiler->hasBlocks()) return true;
    return false;
}

Egg::string SMethodNode::selectorString() const {
    return _selector ? _selector->symbol() : "";
}

} // namespace Egg
