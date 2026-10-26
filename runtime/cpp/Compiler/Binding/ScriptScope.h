/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
*/
#ifndef _SCRIPTSCOPE_H_
#define _SCRIPTSCOPE_H_
#include "Scope.h"
#include "Utils/egg_ordered_map.h"
#include <string>
#include <vector>

namespace Egg {

class SScriptNode;
class SIdentifierNode;
class ArgumentBinding;
class TemporaryBinding;

/**
 * Scope for script nodes (methods and blocks)
 * Corresponds to ScriptScope in Smalltalk
 */
class ScriptScope : public Scope {
protected:
    SScriptNode* _script;
    ordered_map<Egg::string, Binding*> _arguments;
    ordered_map<Egg::string, Binding*> _temporaries;
    int _stackSize;
    int _envSize;
    bool _captureSelf;
    
    void redefinitionError_(const Egg::string& name);
    
public:
    ScriptScope();
    virtual ~ScriptScope() {}
    
    void script_(SScriptNode* aScriptNode) { _script = aScriptNode; }
    
    bool capturesSelf() const { return _captureSelf; }
    int environmentSize() const { return _envSize; }
    int stackSize() const { return _stackSize; }
    int growEnvironment_() { return ++_envSize; }
    int growStack_() { return ++_stackSize; }
    
    Binding* defineArgument_(const Egg::string& identifier) override;
    Binding* defineTemporary_(const Egg::string& identifier) override;
    bool defines_(const Egg::string& aString);
    Binding* resolveLocal_(const Egg::string& aString);
    bool resolves_(const Egg::string& aString);
    virtual std::vector<Binding*> localBindings_();
    
    virtual void positionLocals_();
    virtual void positionDefinedLocals_();
    void positionDefinedTemporariesIn_(ScriptScope* aScriptScope);
    void positionDefinedArguments_();
    
    void captureEnvironment_(SParseNode* aScriptNode) override;
    virtual Binding* captureLocal_(Binding* aLocalBinding);
    virtual void captureSelf_();
    virtual int* environmentIndexOf_(SScriptNode* aScriptNode);
    virtual Binding* resolve_(const Egg::string& aString) = 0;
    virtual SScriptNode* scriptDefining_(const Egg::string& aString) = 0;
    virtual Binding* transferLocal_(const Egg::string& name);
    virtual ScriptScope* realScope_();
};

} // namespace Egg

#endif // _SCRIPTSCOPE_H_
