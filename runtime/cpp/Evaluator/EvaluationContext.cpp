
#include "EvaluationContext.h"
#include "Runtime.h"
#include "SAssociationBinding.h"
#include "SInstVarBinding.h"

using namespace Egg;

class Runtime;

Object* EvaluationContext::argumentAt_(int anInteger) {
    auto executableCode = this->_runtime->executableCodeCompiledCode_(this->_regM);
    int args = this->_runtime->isBlock_(executableCode) ?
        this->_runtime->blockArgumentCount_(executableCode) :
        this->_runtime->methodArgumentCount_(executableCode);

    return this->stackAt_((this->_regBP + 1) + (args - anInteger) + 1);
}

void EvaluationContext::buildFrameFor_code_environment_temps_(Object *receiver, HeapObject *executableCode, HeapObject *environment, uint32_t temps) {
    this->_regS = receiver;
    this->_regM = executableCode;
    this->push_((Object*)this->_regPC);
    this->push_((Object*)this->_regBP);
    this->_regBP = this->_regSP;
    if (this->_regBP <= 100) 
        error_("stack overflow");

    this->push_(receiver);
    this->push_((Object*)executableCode);
    this->push_((Object*)this->_regE);
    this->push_((Object*)environment);
    this->_regE = environment;
    this->_regPC = 0;
    for (int i = 0; i < temps; i++)
        this->push_((Object*)this->_runtime->_nilObj);
}


void EvaluationContext::buildLaunchFrame()
{
    auto launcher = _runtime->newCompiledMethod();
    auto platformCode = _runtime->newArraySized_(0);
    auto executable = _runtime->newExecutableCodeFor_with_(launcher, platformCode);
    _runtime->methodExecutableCode_put_(launcher, (Object*)executable);
    this->buildMethodFrameFor_code_environment_((Object*)_runtime->_nilObj, launcher, _runtime->_nilObj);
}

void EvaluationContext::buildMethodFrameFor_code_environment_(Object *receiver, HeapObject *executableCode, HeapObject *environment) { 
    auto method = this->_runtime->executableCodeCompiledCode_(executableCode);
    auto temps = this->_runtime->methodTempCount_(method);
    this->buildFrameFor_code_environment_temps_(receiver, executableCode, environment, temps);
}


void EvaluationContext::popLaunchFrame() {
    _regSP = _regBP;
	_regE = this->stackAt_(_regBP - 3)->asHeapObject();
	_regBP = reinterpret_cast<uintptr_t>(this->pop());
	_regPC = reinterpret_cast<uintptr_t>(this->pop());
	
    if (_regBP == 0) return;
    
	_regM = this->stackAt_(_regBP - 2)->asHeapObject();
	_regS = this->stackAt_(_regBP - 1);
}

Object* EvaluationContext::instanceVarAt_(int index) {
    return this->_runtime->instanceVarOf_at_(this->_regS->asHeapObject(), index);
}

void EvaluationContext::instanceVarAt_put_(int index, Object *value) {
    this->_runtime->instanceVarOf_at_put_(this->_regS->asHeapObject(), index, value);
}

Object* EvaluationContext::loadAssociationValue_(HeapObject *anObject) {
    return this->_runtime->associationValue_(anObject);
}

void EvaluationContext::storeAssociation_value_(HeapObject *association, Object *anObject) {
    this->_runtime->associationValue_put_(association, anObject);
}

HeapObject* EvaluationContext::method()
{
        auto code = this->_runtime->executableCodeCompiledCode_(this->_regM);
		return this->_runtime->isBlock_(code) ? this->_runtime->blockMethod_(code) : code;
}

SBinding* EvaluationContext::staticBindingFor_(HeapObject *symbol)
{
    auto b = this->staticBindingForIvar_(symbol);
    if (b != nullptr)
        return b;
    b = this->staticBindingForCvar_(symbol);
    if (b != nullptr)
        return b;
    return this->staticBindingForMvar_(symbol);
}

SBinding* EvaluationContext::staticBindingFor_inModule_(HeapObject *symbol, HeapObject *module) {
    auto namespace_ = this->_runtime->moduleNamespace_(module);
    auto assoc = this->_runtime->lookupAssociationFor_in_(symbol, namespace_);
    if (assoc == nullptr)
        error_(("unbound variable: " + symbol->asLocalString()));
    return new SAssociationBinding(assoc);
}

SBinding* EvaluationContext::staticBindingForCvar_(HeapObject *aSymbol) {
    auto species = this->_runtime->methodClassBinding_(this->method());
    auto nilObj = this->_runtime->_nilObj;
    do {
        auto namespaces = this->_runtime->speciesNamespaces_(species);
        auto size = namespaces->size();
        for (int i = 0; i < size; i++)
        {
            auto namespace_ = namespaces->slot(i)->asHeapObject();
            auto assoc = this->_runtime->lookupAssociationFor_in_(aSymbol, namespace_);
            if (assoc != nullptr)
                return new SAssociationBinding(assoc);
        }
        species = this->_runtime->speciesSuperclass_(species);
    } while(species != nilObj);

    return nullptr;
}

uint16_t EvaluationContext::ivarIndex_in_(HeapObject *symbol, Object *receiver) {
    auto species = this->_runtime->speciesOf_(receiver);
    
    while (species != this->_runtime->_nilObj)
    {
        auto slots = this->_runtime->speciesInstanceVariables_(species);
        
        if (slots != this->_runtime->_nilObj) {
            for (int i = 1; i <= slots->size(); i++){
                auto ivar = slots->slotAt_(i)->asHeapObject();
                if (ivar->sameBytesThan(symbol))
                {
                    auto superspecies = this->_runtime->speciesSuperclass_(species);
                    auto size = (superspecies != this->_runtime->_nilObj) ? this->_runtime->speciesInstanceSize_(superspecies) : 0;
                    return size + i;
                }
            }
        }    
        species = this->_runtime->speciesSuperclass_(species);
    }
    
    return 0;
}


SBinding* EvaluationContext::staticBindingForIvar_(HeapObject *aSymbol) {
    auto ivar = this->ivarIndex_in_(aSymbol, this->_regS);
    return ivar > 0 ? new SInstVarBinding(ivar) : nullptr;
}

SBinding* EvaluationContext::staticBindingForMvar_(HeapObject *symbol) {
    auto species = this->_runtime->methodClassBinding_(this->method());
    auto module_ = this->_runtime->speciesModule_(species);
    return this->staticBindingFor_inModule_(symbol, module_);
}

SBinding* EvaluationContext::staticBindingForNested_(HeapObject *name) {
    auto binding = this->staticBindingFor_(name->slotAt_(1)->asHeapObject());
    auto module_ = binding->valueWithin_(this);
    return this->staticBindingFor_inModule_(name->slotAt_(2)->asHeapObject(), module_->asHeapObject());
}