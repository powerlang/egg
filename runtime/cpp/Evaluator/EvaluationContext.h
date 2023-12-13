#ifndef _EVALUATIONCONTEXT_H_
#define _EVALUATIONCONTEXT_H_

#include <iostream>

#include "../HeapObject.h"
#include "../KnownObjects.h"

namespace Egg {

#define CURRENT_ENVIRONMENT 0
#define INLINED_ENVIRONMENT -1
#define INSTACK_ENVIRONMENT -2

class Runtime;
class SBinding;

class EvaluationContext {
    HeapObject *_regM, *_regE;
    uintptr_t  _regSP, _regBP, _regPC;
    Object *_regS, **_stack;
    Runtime *_runtime;

public:
    Object* receiver() { return _regS; }
    HeapObject* compiledCode() { return _regM; }

    Object* argumentAt_(int anInteger);

    Object* argumentAt_in_(int index, int environmentIndex) {
        if (environmentIndex == CURRENT_ENVIRONMENT) {
            return this->argumentAt_(index);
        } else {
            return this->environment_at_(environmentIndex, index);
        }
    }

    Object* firstArgument(){
	    return this->argumentAt_(1);
    }

	void buildFrameFor_code_environment_temps_(Object *receiver, HeapObject *executableCode, HeapObject *environment, uint32_t temps);
    void buildLaunchFrame();
    void buildMethodFrameFor_code_environment_(Object *receiver, HeapObject *executableCode, HeapObject *environment);
    void popLaunchFrame();

    Object*	environment_at_(int environmentIndex, int index) {
		if (environmentIndex == INLINED_ENVIRONMENT)
			return this->stackTemporaryAt_(index);
		
        HeapObject *env = environmentIndex == CURRENT_ENVIRONMENT ? 
            this->_regE :
            this->_regE->slot(environmentIndex)->asHeapObject();
        return env->slot(index);	
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
	
        auto env = environmentIndex == CURRENT_ENVIRONMENT ? _regE : _regE->slotAt_(environmentIndex)->asHeapObject();
	    env->slotAt_(index) = object;
    }

    Object* pop() {
    	auto result = this->stackAt_(_regSP);
	    _regSP = _regSP + 1;
	    return result;
    }


	void push_(Object *object) {
		ASSERT(object != nullptr);
		
        this->_regSP = this->_regSP - 1;
		this->stackAt_put_(this->_regSP, object);
	}

    void pushOperand_(Object *anObject) {
        _regSP = _regSP - 1;
        this->stackAt_put_(_regSP, anObject);
    }

    uintptr_t regPC() { return _regPC; }
    void regPC_(uintptr_t pc) { _regPC = pc; }

    uintptr_t incRegPC() { return _regPC = _regPC + 1; }

    Object* instanceVarAt_(int index);
    void instanceVarAt_put_(int index, Object *value);

	HeapObject* method();

    Object* stackAt_(int index) {
        return _stack[index - 1];
    }

    Object* stackAt_put_(int index, Object *object) {
        return _stack[index - 1] = object;
    }

    Object* stackTemporaryAt_(int);
    void stackTemporaryAt_put_(int index, Object *value);

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

    uint16_t ivarIndex_in_(HeapObject *symbol, Object *receiver);

    SBinding* staticBindingFor_(HeapObject *aSymbol);
    SBinding* staticBindingFor_inModule_(HeapObject *symbol, HeapObject *module);
    SBinding* staticBindingForCvar_(HeapObject *aSymbol);
    SBinding* staticBindingForIvar_(HeapObject *aSymbol);
    SBinding* staticBindingForMvar_(HeapObject *symbol);
    SBinding* staticBindingForNested_(HeapObject *name);

    HeapObject*  nil()   { return KnownObjects::nil; }
    HeapObject* _true()  { return KnownObjects::_true; }
    HeapObject* _false() { return KnownObjects::_false; }
};

} // namespace Egg

#endif // ~ _EVALUATIONCONTEXT_H_ ~
