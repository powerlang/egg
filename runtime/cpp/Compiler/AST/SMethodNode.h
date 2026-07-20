/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
 */

#ifndef _METHOD_NODE_H_
#define _METHOD_NODE_H_

#include "SScriptNode.h"
#include "../LiteralValue.h"
#include <functional>

namespace Egg {

class SPragmaNode;
class SCompiledMethod;
class SSelectorNode;

/**
 * Method node
 * Corresponds to SMethodNode in Smalltalk
 */
class SMethodNode : public SScriptNode {
private:
    SSelectorNode* _selector;
    SPragmaNode* _pragma;
    
public:
    SMethodNode(SSmalltalkCompiler* compiler);
    virtual ~SMethodNode() {}
    
    void acceptVisitor_(SParseNodeVisitor* visitor) override;
    
    SSelectorNode* selector() const { return _selector; }
    void selector_(SSelectorNode* sel) { _selector = sel; }
    
    SPragmaNode* pragma() const { return _pragma; }
    void pragma_(SPragmaNode* p) { _pragma = p; }
    
    bool isMethod() const override { return true; }
    bool isHeadless() const { return _selector == nullptr; }
    
    SScriptNode* realScript() override { return this; }
    void captureHome() override {} // Empty in method
    
    SCompiledMethod* buildMethod();
    std::vector<LiteralValue> literals();
    Egg::string methodClassname();
    bool needsEnvironment() const;
    bool needsFrame() const;
    Egg::string selectorString() const;
    
    void nodesDo_(std::function<void(SParseNode*)> block, bool includeDeclarations = false) override;
};

} // namespace Egg

#endif // _METHOD_NODE_H_
