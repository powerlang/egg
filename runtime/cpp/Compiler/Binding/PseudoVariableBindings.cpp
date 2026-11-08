/*
    Copyright (c) 2025-2026, Javier Pimás.
    See (MIT) license in root directory.
*/
#include "PseudoVariableBindings.h"
#include "../TreecodeEncoder.h"
#include <algorithm>

namespace Egg {

void NilBinding::encodeUsing_(TreecodeEncoder* encoder) {
    encoder->encodeNil();
}

void TrueBinding::encodeUsing_(TreecodeEncoder* encoder) {
    encoder->encodeTrue();
}

void FalseBinding::encodeUsing_(TreecodeEncoder* encoder) {
    encoder->encodeFalse();
}

void SelfBinding::encodeUsing_(TreecodeEncoder* encoder) {
    encoder->encodeSelf();
}

void SelfBinding::beReferencedFrom_(SScriptNode* aScriptNode) {
    aScriptNode->useSelf_();
}

void SuperBinding::beReferencedFrom_(SScriptNode* aScriptNode) {
    aScriptNode->useSelf_();
}

void SuperBinding::encodeUsing_(TreecodeEncoder* encoder) {
    encoder->encodeSuper();
}

void DynamicBinding::encodeUsing_(TreecodeEncoder* encoder) {
    encoder->encodeDynamicVar_(name());
}

void DynamicBinding::beReferencedFrom_(SScriptNode* aScriptNode) {
    aScriptNode->useSelf_();
}

void NestedDynamicBinding::encodeUsing_(TreecodeEncoder* encoder) {
    encoder->encodeNestedDynamicVar_(*literal());
}

DynamicBinding* DynamicBinding::named_(const Egg::string& name) {
    size_t dotPos = name.find('.');
    if (dotPos == Egg::string::npos) {
        return new DynamicBinding(name);
    }
    
    Egg::string first = name.substr(0, dotPos);
    Egg::string second = name.substr(dotPos + 1);
    std::vector<Egg::string> names = {first, second};
    return new NestedDynamicBinding(names);
}

} // namespace Egg
