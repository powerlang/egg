#ifndef _EVALUATOR_H_
#define _EVALUATOR_H_

#include <vector>
#include <string>
#include <map>
#include <functional>

#include "../HeapObject.h"

#include "SExpression.h"
#include "SExpressionVisitor.h"
#include "EvaluationContext.h"

#include "SLiteral.h"
#include "SMessage.h"
#include "SOpDispatchMessage.h"

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

    using PrimitivePointer = Object* (Evaluator::*)();
    std::map<HeapObject*, PrimitivePointer> _primitives;

    using UndermessagePointer = Object* (Evaluator::*)(Object *, std::vector<Object*> &args);
    std::map<HeapObject*, UndermessagePointer> _undermessages;

public:
    Evaluator(Runtime *runtime, HeapObject *falseObj, HeapObject *trueObj, HeapObject *nilObj);

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

    auto evaluateClosure_(auto receiver) {
        return evaluateClosure_withArgs_(receiver, {});
    }

    auto evaluateClosure_with_(auto aPClosure, Object *anObject) {
        return evaluateClosure_withArgs_(aPClosure, {anObject});
    }

    auto evaluateClosure_with_with_(auto aPClosure, Object *anObject, Object *anotherObject) {
        return evaluateClosure_withArgs_(aPClosure, {anObject, anotherObject});
    }

    auto evaluateClosure_withArgs_(auto receiver, const std::vector<Object*> _arguments)
    {

    }

    void evaluatePerform_in_withArgs_(HeapObject *aSymbol, Object *receiver, std::vector<Object*> &arguments);
    SmallInteger* evaluatePrimitiveHash_(HeapObject *receiver);

    HeapObject* false_() {
        return this->_falseObj;
    }
    
    Object* invoke_with_(HeapObject* method, Object *receiver);
    HeapObject* prepareForExecution_(HeapObject *method);


    Object* send_to_with_(HeapObject *symbol, Object *receiver, std::vector<Object*> &args);

    void visitAssignment(SAssignment* assignment) override;
    void visitExpression(SExpression* expression) override;
    void visitIdentifier(SIdentifier* identifier) override;
    void visitReturn(SReturn* sReturn) override;
    void visitPragma(SPragma* sPragma) override;
    void visitCascade(SCascade* sCascade) override;
    void visitCascadeMessage(SCascadeMessage* cascadeMessage) override;
    void visitMethod(SMethod* sMethod) override;
    void visitLiteral(SLiteral* sLiteral) override;
    void visitBlock(SBlock* sBlock) override;

private:
    void evaluate();
    SExpression* nextOperation();

    void initializePrimitives();
    void convertUndermessages();
    void addPrimitive(const std::string &name, PrimitivePointer primitive);
    void addUndermessage(const std::string &name, UndermessagePointer primitive);

	PrimitivePointer primitiveFor_(HeapObject *symbol);

    Object* newIntObject(auto anInteger);
    Object* boolObject(bool aBoolean);

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
	Object* primitiveClosureValue();
	Object* primitiveClosureValueWithArgs();
	Object* primitiveEqual();
	Object* primitiveFloatNew();
	Object* primitiveFlushDispatchCaches();
	Object* primitiveFlushFromCaches();


	Object* primitiveHash();
	Object* primitiveHostFixOverrides();
	Object* primitiveHostLoadModule();
	Object* primitiveNew();
	Object* primitiveNewBytes();
	Object* primitiveNewObjectHeap();
	Object* primitiveNewSized();
	Object* primitivePerformWithArguments();
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
	Object* primitiveUnderHash();
	Object* primitiveUnderIsBytes();
	Object* primitiveUnderPointersSize();
	Object* primitiveUnderSize();

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
	Object* underprimitiveLeadingZeroBitCount_(auto anInteger);
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
	Object* underprimitiveULongAtOffset(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveULongAtOffsetPut(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveUShortAtOffset(Object *receiver, std::vector<Object*> &args);
	Object* underprimitiveUShortAtOffsetPut(Object *receiver, std::vector<Object*> &args);

};

} // namespace Egg

#endif // ~ _EVALUATOR_H_ ~
