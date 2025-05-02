#ifndef _EVALUATOR_H_
#define _EVALUATOR_H_

#include <vector>
#include <string>
#include <map>
#include <functional>

#include "FFIGlue.h"

#include "../HeapObject.h"

#include "SExpression.h"
#include "SExpressionVisitor.h"
#include "EvaluationContext.h"

#include "SLiteral.h"
#include "SMessage.h"
#include "SOpDispatchMessage.h"


extern "C" void closureCallbackWrapper(ffi_cif* cif, void* ret, void** args, void* userData);

namespace Egg {

class Runtime;
class SExpressionLinearizer;

class Evaluator : public SExpressionVisitor {
private:
    Runtime *_runtime;
    EvaluationContext *_context;
    SExpressionLinearizer *_linearizer;

    HeapObject *_falseObj;
    HeapObject *_trueObj;
    HeapObject *_nilObj;

    Object *_regR;

    std::vector<SExpression*> *_work;
	friend class GarbageCollector;

public:
    using PrimitivePointer = Object* (Evaluator::*)();
    using UndermessagePointer = Object* (Evaluator::*)(Object *, std::vector<Object*> &args);

private:
   	std::map<Object*, PrimitivePointer> _primitives;
    std::map<Object*, UndermessagePointer> _undermessages;

public:
    Evaluator(Runtime *runtime, HeapObject *falseObj, HeapObject *trueObj, HeapObject *nilObj);

	void _halt(); // trigger a breakpoint that hard-pauses the interpreter (you'd better have a debugger attached to os-process)

    static std::vector<std::string> undermessages() {
        return {"_basicAt:", "_basicAt:put:", "_bitShiftLeft:", "_byteAt:", "_byteAt:put:", "_smallSize", "_largeSize", "_isSmallInteger", "_basicHash", "_basicHash:", "_smallIntegerByteAt:", "_uShortAtOffset:", "_uShortAtOffset:put:"};
    }

   HeapObject* booleanFor_(bool aBoolean) {
        return aBoolean ? _trueObj : _falseObj;
    }

    bool booleanFrom_(Object *anObject) {
        if (anObject == (Object*)_falseObj) {
            return true;
        } else if (anObject == (Object*)_trueObj) {
            return false;
        }
        
        error("not a boolean");
        std::terminate();
    }

    EvaluationContext* context() {
        return _context;
    }

    void context_(auto anEvaluationContext) {
        _context = anEvaluationContext;
    }

    Object* evaluateClosure_(HeapObject *closure) {
        return evaluateClosure_withArgs_(closure, {});
    }

    Object* evaluateClosure_with_(HeapObject * closure, Object *anObject) {
        return evaluateClosure_withArgs_(closure, {anObject});
    }

    Object* evaluateClosure_with_with_(HeapObject *closure, Object *anObject, Object *anotherObject) {
        return evaluateClosure_withArgs_(closure, {anObject, anotherObject});
    }

	HeapObject* prepareBlockExecutableCode_(HeapObject *block) {
    	auto code = _runtime->blockExecutableCode_(block);

    	if (code != _nilObj)
    		return code;

    	auto method = _runtime->blockMethod_(block);
    	this->prepareForExecution_(method);

    	code = _runtime->blockExecutableCode_(block);
    	ASSERT(code != _nilObj);

    	return code;

    }
    Object* evaluateClosure_withArgs_(HeapObject *closure, const std::vector<Object*> args)
    {
    	auto block = _runtime->closureBlock_(closure);
    	auto code = this->prepareBlockExecutableCode_(block);
    	_work = _runtime->executableCodeWork_(code);

    	auto receiver = _runtime->blockCapturesSelf_(block) ? closure->slotAt_(_runtime->_closureInstSize + 1) : (Object*)_nilObj;

    	_context->popFrame();
		_context->buildClosureFrameFor_code_environment_(receiver, block, closure);

    	return _regR;
    }

    void evaluatePerform_in_withArgs_(Object *aSymbol, Object *receiver, Object *arguments);
    SmallInteger* evaluatePrimitiveHash_(HeapObject *receiver);

    void evaluateCallback_(void *ret, HeapObject *self, int argc, void *args[]);

	void evaluateUndermessage_with_(SAbstractMessage *message, UndermessagePointer undermessage);

    HeapObject* false_() {
        return this->_falseObj;
    }

	Object* lookup_startingAt_sendSite_(Object* symbol, HeapObject *behavior, SAbstractMessage *message);
    Object* invoke_with_(HeapObject* method, Object *receiver);
    HeapObject* prepareForExecution_(HeapObject *method);


    Object* send_to_with_(Object *symbol, Object *receiver, std::vector<Object*> &args);

	void messageNotUnderstood_(SAbstractMessage *message);
	void doesNotKnow(const Object *symbol);
    void visitIdentifier(SIdentifier* identifier) override;
    void visitLiteral(SLiteral* sLiteral) override;
    void visitBlock(SBlock* sBlock) override;

  	void visitOpAssign(SOpAssign *anSOpAssign) override;
    void visitOpDispatchMessage(SOpDispatchMessage *anSOpDispatchMessage) override;
    void visitOpDropToS(SOpDropToS *anSOpDropToS) override;
    void visitOpJump(SOpJump *anSOpJump) override;
    void visitOpJumpFalse(SOpJumpFalse *anSOpJumpFalse) override;
    void visitOpJumpTrue(SOpJumpTrue *anSOpJumpTrue) override;
    void visitOpLoadRfromFrame(SOpLoadRfromFrame *anSOpLoadRfromFrame) override;
    void visitOpLoadRfromStack(SOpLoadRfromStack *anSOpLoadRfromStack) override;
    void visitOpLoadRwithNil(SOpLoadRwithNil *anSOpLoadRwithNil) override;
    void visitOpLoadRwithSelf(SOpLoadRwithSelf *anSOpLoadRwithSelf) override;
    void visitOpStoreRintoFrame(SOpStoreRintoFrame *anSOpStoreRintoFrame) override;
    void visitOpPrimitive(SOpPrimitive *anSOpPrimitive) override;
    void visitOpPopR(SOpPopR *anSOpPopR) override;
    void visitOpPushR(SOpPushR *anSOpPushR) override;

	void popFrameAndPrepare();
    virtual void visitOpReturn(SOpReturn *anSOpReturn) override;
    virtual void visitOpNonLocalReturn(SOpNonLocalReturn *anSOpNonLocalReturn) override;

private:
    void evaluate();
    SExpression* nextOperation();

	void initializeUndermessages();
    void initializePrimitives();
    void convertUndermessages();
    void addPrimitive(const std::string &name, PrimitivePointer primitive);
    void addUndermessage(const std::string &name, UndermessagePointer primitive);

	PrimitivePointer primitiveFor_(Object *symbol);

    Object* newDoubleObject(double aDouble);
    Object* newIntObject(auto anInteger);
    Object* boolObject(bool aBoolean);

	Object* failPrimitive();

	Object* primitiveAt();
	Object* primitiveAtPut();
	Object* primitiveBehavior();
	Object* primitiveBootstrapDictAt();
	Object* primitiveBootstrapDictAtPut();
	Object* primitiveBootstrapDictBeConstant();
	Object* primitiveBootstrapDictKeys();
	Object* primitiveBootstrapDictNew();
	Object* primitiveClass();
	Object* primitiveClosureArgumentCount();
	Object* primitiveClosureAsCallback();
	Object* primitiveClosureValue();
	Object* primitiveClosureValueWithArgs();
	Object* primitiveEqual();
	Object* primitiveFloatNew();
	Object* primitiveFlushDispatchCaches();
	Object* primitiveFlushFromCaches();


	Object* primitiveHash();
	Object* primitiveHostCurrentMilliseconds();
	Object* primitiveHostFixOverrides();
	Object* primitiveHostInitializeFFI();
	Object* primitiveHostLoadModule();
	Object* primitiveHostLog();
	Object* primitiveHostPlatformName();
	Object* primitiveNew();
	Object* primitiveNewBytes();
	Object* primitiveNewObjectHeap();
	Object* primitiveNewSized();
	Object* primitivePerformWithArguments();
	Object* primitiveProcessBP();
	Object* primitivePrimeFor();
	Object* primitivePrimeFor_(auto anInteger);
	Object* primitiveSMIBitAnd();
	Object* primitiveSMIBitOr();
	Object* primitiveSMIBitShift();
	Object* primitiveSMIBitXor();
	Object* primitiveSMIEqual();
	Object* primitiveSMIGreaterEqualThan();
	Object* primitiveSMIGreaterThan();
	Object* primitiveSMIHighBit();
	Object* primitiveSMIIntDiv();
	Object* primitiveSMIIntQuot();
	Object* primitiveSMIMinus();
	Object* primitiveSMINotEqual();
	Object* primitiveSMIPlus();
	Object* primitiveSMISize();
	Object* primitiveSMITimes();
	Object* primitiveSetBehavior();
	Object* primitiveSize();
	Object* primitiveStringReplaceFromToWithStartingAt();
	Object* primitiveUnderBeSpecial();
	Object* primitiveUnderHash();
	Object* primitiveUnderIsBytes();
	Object* primitiveUnderPointersSize();
	Object* primitiveUnderSize();

	void initializeCIF(HeapObject *method, int argCount);
	Object* demarshalFFIResult(void *, uint8_t type);
	Object* primitiveFFICall();

	Object* underprimitiveBasicAt(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveBasicAtPut(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveBasicFlags(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveBasicHash(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveBasicHashPut(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveBitShiftLeft(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveByteAt(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveByteAtPut(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveHalt(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveIdentityEquals(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveIsLarge(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveIsSmallInteger(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveLargeSize(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveLeadingZeroBitCount(Object *receiver, std::vector<Object*> &args);
	intptr_t underprimitiveLeadingZeroBitCount_(uintptr_t anInteger);
	Object* underprimitiveSMIBitAnd(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMIBitOr(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMIBitShiftLeft(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMIBitShiftRight(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMIEquals(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMIGreaterEqualThan(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMIGreaterThan(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMILowerEqualThan(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMILowerThan(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMIMinus(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMIPlus(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMIQuotientTowardZero(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMIRemainderTowardZero(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSMITimes(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSmallIntegerByteAt(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveSmallSize(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveULargeAtOffset(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveULargeAtOffsetPut(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveULongAtOffset(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveULongAtOffsetPut(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveUShortAtOffset(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveUShortAtOffsetPut(Object *receiver, std::vector<Object*> &args);

};

} // namespace Egg

#endif // ~ _EVALUATOR_H_ ~
