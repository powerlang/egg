#ifndef _EVALUATIONCONTEXT_H_
#define _EVALUATIONCONTEXT_H_

#include <iostream>
#include <vector>

#include "Runtime.h"
#include "../HeapObject.h"
#include "../KnownObjects.h"

namespace Egg {

#define CURRENT_ENVIRONMENT 0
#define INLINED_ENVIRONMENT -1
#define INSTACK_ENVIRONMENT -2

class Runtime;
class SBinding;
class SBlock;
class SExpression;

class EvaluationContext {
    HeapObject *_regM, *_regE;
    uintptr_t  _regSP, _regBP, _regPC;
    Object *_regS, **_stack;
    Runtime *_runtime;

    const int FRAME_TO_RECEIVER_DELTA = 1;
    const int FRAME_TO_CODE_DELTA = 2;
    const int FRAME_TO_PREV_ENVIRONMENT_DELTA = 3;
    const int FRAME_TO_ENVIRONMENT_DELTA = 4;
    const int FRAME_TO_FIRST_TEMP_DELTA = 5;
    const int FRAME_TO_FIRST_ARG_DELTA = 2;

public:
    const int STACK_SIZE = 64 * 1024;
    EvaluationContext(Runtime *runtime) : 
        _runtime(runtime)
    {
        _regM = _regE = nullptr;
        _regSP = STACK_SIZE + 1;
        _regBP = _regPC = 0;
        _regS = 0;

        _stack = new Object*[STACK_SIZE];
    
    }

    Object* receiver() { return _regS; }
    Object* self() { return _regS; }
    
    HeapObject* environment() { return _regE; }
    HeapObject* compiledCode() { return _regM; }

    HeapObject* classBinding();

    int tempOffset() { return 4; }

    Object* argumentAt_(int anInteger);
    Object* argumentAt_frame_(int anInteger, uintptr_t bp);
    Object* argumentAt_frameIndex_(int anInteger, int anotherInteger);

    Object* argumentAt_in_(int index, int environmentIndex) {
        if (environmentIndex == INSTACK_ENVIRONMENT) {
            return this->argumentAt_(index);
        } else {
            return this->environment_at_(environmentIndex, index);
        }
    }

    Object* firstArgument(){
	    return this->argumentAt_(1);
    }

    Object* secondArgument(){
	    return this->argumentAt_(2);
    }

    Object* thirdArgument(){
	    return this->argumentAt_(3);
    }

    Object* fourthArgument(){
	    return this->argumentAt_(4);
    }

    Object** lastArgumentAddress(){
	    return &_stack[_regBP - 1 + 2];
    }

    std::vector<Object*> methodArguments();

	void buildFrameFor_code_environment_temps_(Object *receiver, HeapObject *compiledCode, HeapObject *environment, uint32_t temps);
    std::vector<SExpression*>* buildLaunchFrame(HeapObject *symbol, int argCount);
    void buildClosureFrameFor_code_environment_(Object *receiver, HeapObject *compiledCode, HeapObject *environment);
    void buildMethodFrameFor_code_environment_(Object *receiver, HeapObject *compiledCode, HeapObject *environment);
    void popLaunchFrame(HeapObject *prevRegE);

    Object* environment_at_(int environmentIndex, int index) {
	if (environmentIndex == INLINED_ENVIRONMENT)
	    return this->stackTemporaryAt_(index);
		
        HeapObject *env = environmentIndex == CURRENT_ENVIRONMENT ? 
            this->_regE :
            this->_regE->slotAt_(environmentIndex + _runtime->_closureInstSize)->asHeapObject();
        auto position = _runtime->speciesOf_((Object*)env) == _runtime->_arrayClass ? index : index + _runtime->_closureInstSize;
        return env->slotAt_(position);
	}
    
    /*
	    -1: inlined argument.
	     0: current env.
 	    >0: index of env in current env. "
    */
    void environment_at_put_(int environmentIndex, int index, Object *object)
    {
        if (environmentIndex == INLINED_ENVIRONMENT)
		    return this->stackTemporaryAt_put_(index, object);
	
        auto env = environmentIndex == CURRENT_ENVIRONMENT ? _regE : _regE->slotAt_(environmentIndex + _runtime->_closureInstSize)->asHeapObject();
        auto position = _runtime->speciesOf_((Object*)env) == _runtime->_arrayClass ? index : index + _runtime->_closureInstSize;

        env->slotAt_(position) = object;
    }

    Object* pop() {
    	auto result = this->stackAt_(_regSP);
	    _regSP = _regSP + 1;
	    return result;
    }


	void push_(Object *object) {
		//ASSERT(object != nullptr);
		
        this->_regSP = this->_regSP - 1;
		this->stackAt_put_(this->_regSP, object);
	}

    void pushOperand_(Object *anObject) {
        _regSP = _regSP - 1;
        this->stackAt_put_(_regSP, anObject);
    }

    void dropOperands_(intptr_t anInteger)
    {
    	_regSP = _regSP + anInteger;
    }

    std::vector<Object*> popOperands_(intptr_t anInteger)
    {
        if (anInteger == 0) return std::vector<Object*>();
    	std::vector<Object*> result;
        result.resize(anInteger);
    	for (int i = anInteger; i > 0; i--)
        {
            result[i-1] = this->pop();
        }
    	return result;
    }

    Object* operandAt_(intptr_t anInteger)
    {
    	return _stack[_regSP - 1 + anInteger];
    }

    uintptr_t regPC() { return _regPC; }
    void regPC_(uintptr_t pc) { _regPC = pc; }

    uintptr_t incRegPC() { return _regPC = _regPC + 1; }

    Object* instanceVarAt_(int index);
    void instanceVarAt_put_(int index, Object *value);

	HeapObject* method();

    uintptr_t bpForFrameAt_(int index)
    {
        uintptr_t bp = _regBP;
        for (int i = 0; i < index - 1; ++i) {
            if (bp == 0) {
                error("reached the begining of the stack");
            }
            bp = (uintptr_t)_stack[bp - 1];
        }
        return bp;
    }

    Object* stackAt_(int index) {
        return _stack[index - 1];
    }

    Object* stackAt_put_(int index, Object *object) {
        return _stack[index - 1] = object;
    }
    Object* stackAt_frameIndex_(int index, int anotherIndex);
    Object* stackAt_frameIndex_put_(int index, int anotherIndex, Object *value);

    Object* stackTemporaryAt_(int index);
    Object* stackTemporaryAt_frame_(int index, uintptr_t bp);
    Object* stackTemporaryAt_frameIndex_(int index, int anotherIndex);

    void stackTemporaryAt_put_(int index, Object *value);
    void stackTemporaryAt_frameIndex_put_(int index, int anotherIndex, Object *value);

    void popFrame()
    {
        _regSP = _regBP;
    	_regBP = (uintptr_t)this->pop();
        _regPC = (uintptr_t)this->pop();
        _regE  = _stack[_regBP - 4 - 1]->asHeapObject();
        _regM  = _stack[_regBP - 2 - 1]->asHeapObject();
        _regS  = _stack[_regBP - 1 - 1];
    }

    void reserveStackSlots_(int anInteger)
    {
        _regSP = _regSP - anInteger;
    }

    void unwind();

    Object* temporaryAt_in_(int index, int environmentIndex){
        if (environmentIndex == INSTACK_ENVIRONMENT) { 
            return this->stackTemporaryAt_(index);
        }
	    return this->environment_at_(environmentIndex, index);
    }

    void temporaryAt_in_put(int index, int environmentIndex, Object *value){
        if (environmentIndex == INSTACK_ENVIRONMENT) { 
            return this->stackTemporaryAt_put_(index, value);
        }
	    this->environment_at_put_(environmentIndex, index, value);
    }

    Object* loadAssociationValue_(HeapObject *anObject);

	void storeAssociation_value_(HeapObject *association, Object *anObject);

    HeapObject* captureClosure_(SBlock *anSBlock);

    uint16_t ivarIndex_in_(HeapObject *symbol, Object *receiver);

    SBinding* staticBindingFor_(HeapObject *aSymbol);
    SBinding* staticBindingFor_inModule_(HeapObject *symbol, HeapObject *module);
    SBinding* staticBindingForCvar_(HeapObject *aSymbol);
    SBinding* staticBindingForCvar_in_(HeapObject *aSymbol, HeapObject *species);
    SBinding* staticBindingForIvar_(HeapObject *aSymbol);
    SBinding* staticBindingForMvar_(HeapObject *symbol);
    SBinding* staticBindingForNested_(HeapObject *name);

    HeapObject*  nil()   { return KnownObjects::nil; }
    HeapObject* _true()  { return KnownObjects::_true; }
    HeapObject* _false() { return KnownObjects::_false; }

    HeapObject* codeOfFrameAt_(uintptr_t frame);
    Object* receiverOfFrameAt_(uintptr_t frame);
    Object* argumentOfFrameAt_subscript_(uintptr_t frame, uintptr_t subscript);
    Object* temporaryOfFrameAt_subscript_(uintptr_t frame, uintptr_t subscript);
    HeapObject* environmentOfFrameAt_(uintptr_t frame);
    void printFrame_into_(uintptr_t frame, std::ostringstream &s);
    std::string backtrace();
    std::string printStackContents();

};

} // namespace Egg

#endif // ~ _EVALUATIONCONTEXT_H_ ~
