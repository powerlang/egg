
#include "EvaluationContext.h"

#include <iomanip>
#include <sstream>

#include "Runtime.h"
#include "SAssociationBinding.h"
#include "SInstVarBinding.h"
#include "SBlock.h"

#include "SLiteral.h"
#include "SMessage.h"
#include "SOpDispatchMessage.h"


using namespace Egg;

class Runtime;

HeapObject* EvaluationContext::classBinding()
{
    return _runtime->methodClassBinding_(this->method());
}

Object *EvaluationContext::argumentAt_(int anInteger) {
    return argumentAt_frame_(anInteger, this->_regBP);
}

Object * EvaluationContext::argumentAt_frame_(int anInteger, uintptr_t bp) {
    auto code = _stack[bp - 2 - 1];
    auto count = _runtime->argumentCountOf_(code->asHeapObject());
    return _stack[bp + 1 + (count - anInteger + 1) - 1];
}

Object * EvaluationContext::argumentAt_frameIndex_(int anInteger, int anotherInteger) {
    auto bp = this->bpForFrameAt_(anotherInteger);
    return this->argumentAt_frame_(anInteger, bp);
}

void EvaluationContext::buildFrameFor_code_environment_temps_(Object *receiver, HeapObject *compiledCode, HeapObject *environment, uint32_t temps) {
    this->_regS = receiver;
    this->_regM = compiledCode;
    this->push_((Object*)this->_regPC);
    this->push_((Object*)this->_regBP);
    this->_regBP = this->_regSP;
    if (this->_regBP <= 100) 
        error_("stack overflow");

    this->push_(receiver);
    this->push_((Object*)compiledCode);
    this->push_((Object*)this->_regE);
    this->push_((Object*)environment);
    this->_regE = environment;
    this->_regPC = 0;
    for (int i = 0; i < temps; i++)
        this->push_((Object*)this->_runtime->_nilObj);
}


std::vector<Object*> EvaluationContext::methodArguments() {
    int count = _runtime->methodArgumentCount_(_regM);
    std::vector<Object*> arguments;
    arguments.reserve(count);
    for (int i = count; i >= 1; --i) {
        arguments.push_back(this->argumentAt_(i));
    }
    return arguments;
}

std::vector<SExpression*>* EvaluationContext::buildLaunchFrame(HeapObject *symbol, int argCount)
{
    auto launcher = _runtime->newCompiledMethod();
    auto bytecodes = new std::vector<SExpression*>();
    auto executable = _runtime->newExecutableCodeFor_with_(launcher, reinterpret_cast<HeapObject*>(bytecodes));
    _runtime->methodExecutableCode_put_(launcher, (Object*)executable);
    this->buildMethodFrameFor_code_environment_((Object*)_runtime->_nilObj, launcher, _runtime->_nilObj);

    auto literal = new SLiteral(0, (Object*)_runtime->_nilObj);
    std::vector<SExpression*> dummy(argCount, literal);
    auto message = new SMessage(literal, symbol, dummy, false);
    auto dispatch = new SOpDispatchMessage(message);

    bytecodes->push_back(dispatch);
    return bytecodes;
}

void EvaluationContext::buildClosureFrameFor_code_environment_(Object *receiver, HeapObject *code,
    HeapObject *environment) {
    auto temps = _runtime->blockTempCount_(code);
    this->buildFrameFor_code_environment_temps_(receiver, code, environment, temps);
}

void EvaluationContext::buildMethodFrameFor_code_environment_(Object *receiver, HeapObject *method, HeapObject *environment) { 
    auto temps = this->_runtime->methodTempCount_(method);
    this->buildFrameFor_code_environment_temps_(receiver, method, environment, temps);
}


void EvaluationContext::popLaunchFrame(HeapObject *prevRegE) {
    _regSP = _regBP;
	_regE = prevRegE;
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

HeapObject *EvaluationContext::captureClosure_(SBlock *anSBlock)
{
	auto closure = _runtime->newClosureFor_(anSBlock->compiledCode());
	auto it = anSBlock->capturedVariables().begin();
	auto i = 1;
	while(it != anSBlock->capturedVariables().end()) {
		auto type = *it++;
	    switch (type)
        {
        case BlockCapturedVariables::Self:
            _runtime->closureIndexedSlotAt_(closure, i) = this->self(); break;
		case BlockCapturedVariables::Environment:
            _runtime->closureIndexedSlotAt_(closure, i) = (Object*)this->environment(); break;
        case BlockCapturedVariables::EnvironmentValue: {
            auto j = *it++;
			auto env = _runtime->environmentIndexedSlotAt_(this->environment(), j);
			_runtime->closureIndexedSlotAt_(closure, i) = env;
            break; }
		case BlockCapturedVariables::LocalArgument: {
            auto j = *it++;
			auto arg = this->argumentAt_(j);
			_runtime->closureIndexedSlotAt_(closure, i) = arg;
            break; };
        case BlockCapturedVariables::InlinedArgument:
            auto j = *it++;
            auto arg = this->stackTemporaryAt_frame_(j, this->_regBP);
			_runtime->closureIndexedSlotAt_(closure, i) = arg;
        }
		i = i + 1;
    }
	return closure;
}

HeapObject* EvaluationContext::method()
{
		return this->_runtime->isBlock_(this->_regM) ? this->_runtime->blockMethod_(this->_regM) : this->_regM;
}

Object *EvaluationContext::stackTemporaryAt_(int anInteger)
{
    return this->stackTemporaryAt_frameIndex_(anInteger, 1);
}

Object *EvaluationContext::stackTemporaryAt_frame_(int index, uintptr_t bp)
{
    return _stack[bp - this->tempOffset() - index - 1];
}

Object *EvaluationContext::stackTemporaryAt_frameIndex_(int index, int anotherIndex)
{
    uintptr_t bp = this->bpForFrameAt_(anotherIndex);
    return this->stackTemporaryAt_frame_(index, bp);
}

Object *EvaluationContext::stackAt_frameIndex_(int index, int anotherIndex)
{
    uintptr_t bp = this->bpForFrameAt_(anotherIndex);
    return _stack[bp - 1 - (index)];
}

Object *EvaluationContext::stackAt_frameIndex_put_(int index, int anotherIndex, Object *value)
{
    uintptr_t bp = this->bpForFrameAt_(anotherIndex);
    return _stack[bp - 1 - (index)] = value;
}

void EvaluationContext::stackTemporaryAt_put_(int index, Object *value)
{
    this->stackTemporaryAt_frameIndex_put_(index, 1, value);
}

void EvaluationContext::stackTemporaryAt_frameIndex_put_(int index, int anotherIndex, Object *value)
{
    uintptr_t bp = this->bpForFrameAt_(anotherIndex);
    _stack[bp - this->tempOffset() - index - 1] = value;
}

void EvaluationContext::unwind()
{
    HeapObject* home = _runtime->closureHome_(this->environment());
    if (home == _runtime->_nilObj)
        error("cannot return because closure has no home");

    uintptr_t bp = _regBP;
    while (bp != 0) {
        HeapObject* environment = _stack[bp - FRAME_TO_ENVIRONMENT_DELTA - 1]->asHeapObject();
        if (environment == home) {
            _regBP = bp;
            this->popFrame();
            return;
        }

        bp = (uintptr_t)_stack[bp - 1];
    }

    error("cannot return from this closure");

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

SBinding* EvaluationContext::staticBindingForCvar_in_(HeapObject *aSymbol, HeapObject *species) {
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

SBinding* EvaluationContext::staticBindingForCvar_(HeapObject *aSymbol) {
    auto species = this->_runtime->methodClassBinding_(this->method());
    return staticBindingForCvar_in_(aSymbol, species);
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
    auto module_ = this->_runtime->methodModule_(this->method());
    return this->staticBindingFor_inModule_(symbol, module_);
}

SBinding* EvaluationContext::staticBindingForNested_(HeapObject *name) {
    auto binding = this->staticBindingFor_(name->slotAt_(1)->asHeapObject());
    auto module_ = binding->valueWithin_(this);
    return this->staticBindingFor_inModule_(name->slotAt_(2)->asHeapObject(), module_->asHeapObject());
}

HeapObject * EvaluationContext::codeOfFrameAt_(uintptr_t frame) {
    return (HeapObject*)_stack[frame - FRAME_TO_CODE_DELTA - 1];
}

Object * EvaluationContext::receiverOfFrameAt_(uintptr_t frame) {
    return _stack[frame - FRAME_TO_RECEIVER_DELTA - 1];
}

Object * EvaluationContext::argumentOfFrameAt_subscript_(uintptr_t frame, uintptr_t subscript) {
    return _stack[frame + FRAME_TO_FIRST_ARG_DELTA + subscript - 1];
}

Object * EvaluationContext::temporaryOfFrameAt_subscript_(uintptr_t frame, uintptr_t subscript) {
    return _stack[frame - FRAME_TO_FIRST_TEMP_DELTA - subscript - 1];
}

HeapObject * EvaluationContext::environmentOfFrameAt_(uintptr_t frame) {
    return (HeapObject*)_stack[frame - FRAME_TO_ENVIRONMENT_DELTA - 1];
}

void printObject_into_(Object* o, std::ostringstream &s) {

    if (o == nullptr)
        s << "bad obj";
    else
        s << o->printString();

    s<< " (" << std::hex << o << ")";
}

void EvaluationContext::printFrame_into_(uintptr_t frame, std::ostringstream &s) {
    auto code = this->codeOfFrameAt_(frame);
    auto receiver = this->receiverOfFrameAt_(frame);
    auto argCount = this->_runtime->argumentCountOf_(code);
    std::vector<Object*> args;
    for (int i = argCount - 1; i >= 0; i--)
        args.push_back(this->argumentOfFrameAt_subscript_(frame, i));

    auto tempCount = this->_runtime->temporaryCountOf_(code);
    std::vector<Object*> temps;
    for (int i = 0; i < tempCount; i++)
        temps.push_back(this->temporaryOfFrameAt_subscript_(frame, i));

    auto envCount = 0;
    if (!this->_runtime->isBlock_(code))
        envCount = this->_runtime->methodEnvironmentSize_(code);

    std::vector<Object*> envTemps;
    for (int i = 0; i < envCount; i++)
        envTemps.push_back(this->environmentOfFrameAt_(frame)->slot(i));


    printObject_into_((Object*)code, s);
    s << std::endl;

    s <<  "recv: ";
    printObject_into_(receiver, s);
    s << std::endl;

    for(auto &arg : args) {
        s << "arg: ";
        printObject_into_(arg, s);
        s << std::endl;
    }
    for(auto &temp : temps) {
        s << "temp: ";
        printObject_into_(temp, s);
        s << std::endl;
    }

    for(auto &envtemp : envTemps) {
        s << "envtemp: ";
        printObject_into_(envtemp, s);
        s << std::endl;
    }
}

std::string EvaluationContext::backtrace() {
    std::ostringstream s;
    std::vector<uintptr_t> frames;
    uintptr_t current = _regBP;
    while (current) {
        frames.push_back(current);
        current = (uintptr_t)_stack[current - 1];
    }
    for (int i = frames.size() - 1; i >= 0; i--) {
        this->printFrame_into_(frames[i], s);
        s << std::endl;
    }

    s << "-----------------" << std::endl;
    s << "regs:" << std::endl;
    s << "-----------------" << std::endl;
    s << "regM: ";
    printObject_into_((Object*)_regM, s);
    s << std::endl;
    s << "regS: ";
    printObject_into_(_regS, s);
    s << std::endl;

    s << "regE: ";
    printObject_into_((Object*)_regE, s);
    s << std::endl;
    //auto regR = _runtime->_evaluator->_regR;
    //s << "regR: " << regR->printString() << "(" << std::hex << regR << ")" << std::endl;
    return s.str();
}

void printStackObject_into_(Object *o, std::ostringstream &s)
{
    s << "| " << std::setw(sizeof(void*)*2) << std::setfill(' ') << std::hex << o << " | ";
    if (o == nullptr)
        s << "bad obj";
    else
        s << o->printString();
}
std::string EvaluationContext::printStackContents() {
    std::ostringstream s;
    std::vector<uintptr_t> frames;
    uintptr_t current = _regSP;
    uintptr_t next    = _regBP;
    s << "|------------------|" << std::endl;

    do {
        for (uintptr_t index = current; index < next; index++) {
            printStackObject_into_(_stack[index - 1], s);
            s << std::endl;
        }
        s << "| " << std::setw(sizeof(void*)*2) << std::setfill(' ') << std::hex << _stack[next - 1] << " | fp" << std::endl;
        s << "| " << std::setw(sizeof(void*)*2) << std::setfill(' ') << std::hex << _stack[next + 1 - 1] << " | retaddr" << std::endl;

        current = next + 2;
        next = (uintptr_t)_stack[next - 1];
    } while (next != 0);

    return s.str();
}