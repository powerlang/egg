/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
*/
#include "ScriptScope.h"
#include "ArgumentBinding.h"
#include "TemporaryBinding.h"
#include "../AST/SScriptNode.h"
#include "../SSmalltalkCompiler.h"
#include "../CompilationError.h"
#include "../LiteralValue.h"

namespace Egg {

ScriptScope::ScriptScope() 
    : Scope(), _script(nullptr), _stackSize(0), _envSize(0), _captureSelf(false) {
}

Binding* ScriptScope::defineArgument_(const Egg::string& identifier) {
    if (resolves_(identifier)) {
        redefinitionError_(identifier);
    }
    auto binding = new ArgumentBinding(identifier, 0);
    _arguments[identifier] = binding;
    addBinding_(binding);
    return binding;
}

Binding* ScriptScope::defineTemporary_(const Egg::string& identifier) {
    if (_temporaries.find(identifier) != _temporaries.end()) {
        redefinitionError_(identifier);
    }
    auto binding = new TemporaryBinding(identifier, 0);
    _temporaries[identifier] = binding;
    addBinding_(binding);
    return binding;
}

bool ScriptScope::defines_(const Egg::string& aString) {
    return _temporaries.find(aString) != _temporaries.end() ||
           _arguments.find(aString) != _arguments.end();
}

Binding* ScriptScope::resolveLocal_(const Egg::string& aString) {
    auto it = _temporaries.find(aString);
    if (it != _temporaries.end()) {
        return it->second;
    }
    auto ait = _arguments.find(aString);
    if (ait != _arguments.end()) {
        return ait->second;
    }
    return nullptr;
}

bool ScriptScope::resolves_(const Egg::string& aString) {
    auto binding = resolve_(aString);
    return binding && !binding->isDynamic();
}

std::vector<Binding*> ScriptScope::localBindings_() {
    std::vector<Binding*> result;
    for (auto& pair : _arguments) {
        result.push_back(pair.second);
    }
    for (auto& pair : _temporaries) {
        result.push_back(pair.second);
    }
    return result;
}

void ScriptScope::positionLocals_() {
    positionDefinedLocals_();
}

void ScriptScope::positionDefinedLocals_() {
    positionDefinedTemporariesIn_(this);
    positionDefinedArguments_();
}

void ScriptScope::positionDefinedTemporariesIn_(ScriptScope* aScriptScope) {
    for (auto& pair : _temporaries) {
        auto binding = pair.second;
        if (auto localBinding = dynamic_cast<LocalBinding*>(binding)) {
            bool inStack = localBinding->isInStack();
            int position = inStack ? 
                aScriptScope->growStack_() : 
                aScriptScope->growEnvironment_();
            localBinding->index_(position);
        }
    }
}

void ScriptScope::positionDefinedArguments_() {
    int index = 1;
    for (auto& pair : _arguments) {
        if (auto localBinding = dynamic_cast<LocalBinding*>(pair.second)) {
            localBinding->index_(index++);
        }
    }
}

void ScriptScope::captureEnvironment_(SParseNode* aScriptNode) {
}

Binding* ScriptScope::captureLocal_(Binding* aLocalBinding) {
    return aLocalBinding;
}

void ScriptScope::captureSelf_() {
    _captureSelf = true;
}

int* ScriptScope::environmentIndexOf_(SScriptNode* aScriptNode) {
    return nullptr;
}

Binding* ScriptScope::transferLocal_(const Egg::string& name) {
    return resolveLocal_(name);
}

ScriptScope* ScriptScope::realScope_() {
    if (!_script) return nullptr;
    auto realScript = _script->realScript();
    return realScript ? realScript->scope() : nullptr;
}

void ScriptScope::redefinitionError_(const Egg::string& name) {
    if (_script && _script->compiler()) {
        _script->compiler()->warning_at_(
            name.toUtf8() + " already declared",
            nullptr
        );
    }
}

} // namespace Egg
