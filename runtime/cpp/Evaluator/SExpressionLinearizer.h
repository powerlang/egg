#ifndef _SEXPRESSIONLINEARIZER_H_
#define _SEXPRESSIONLINEARIZER_H_

#include <vector>
#include <map>
#include "../HeapObject.h"
#include "SExpressionVisitor.h"
#include "Runtime.h"
#include "PlatformCode.h"

namespace Egg {

class Evaluator;

class SExpressionLinearizer : public SExpressionVisitor {
	HeapObject *_greaterThan, *_plus, *_not, *_equalsEquals, *_ifTrue, *_ifFalse, *_ifTrueIfFalse, *_ifFalseIfTrue, *_ifNil, *_ifNotNil, *_ifNilIfNotNil, *_ifNotNilIfNil, *_whileTrue, *_whileFalse, *_whileTrue_, *_whileFalse_, *_toDo, *_toByDo, *_repeat, *_timesRepeat, *_andNot, *_orNot;
	SLiteral *_one;
	bool _inBlock;
	bool _dropsArguments;
	size_t _stackTop;
	PlatformCode *_operations;
	
	using PrimitivePointer = Object* (Evaluator::*)();
	std::map<HeapObject*, PrimitivePointer> _primitives;
	Runtime *_runtime;

public: 
	SExpressionLinearizer() {
		
		this->_operations = nullptr;
		this->_runtime = nullptr;
		this->_stackTop = 0;
		this->_inBlock = false;
		this->_dropsArguments = true;

		this->_one = nullptr;

		this->_greaterThan = nullptr;
		this->_plus = nullptr;
		this->_not = nullptr;
		this->_equalsEquals = nullptr;
		this->_ifTrue = nullptr;
		this->_ifFalse = nullptr;
		this->_ifTrueIfFalse = nullptr;
		this->_ifFalseIfTrue = nullptr;
		this->_ifNil = nullptr;
		this->_ifNotNil = nullptr;
		this->_ifNilIfNotNil = nullptr;
		this->_ifNotNilIfNil = nullptr;
		this->_whileTrue = nullptr;
		this->_whileFalse = nullptr;
		this->_whileTrue_ = nullptr;
		this->_whileFalse_ = nullptr;
		this->_toDo = nullptr;
		this->_toByDo = nullptr;
		this->_repeat = nullptr;
		this->_timesRepeat = nullptr;
		this->_andNot = nullptr;
		this->_orNot = nullptr;
	}

	PlatformCode* operations() {
		return this->_operations;
	}

	void assign_(auto aCollection);
	auto branchIf_(bool aBoolean);
	void branchTargetOf_(SOpJump *branch);
	size_t currentPC();
	void dispatch_(SAbstractMessage *message);
	void dropCascadeMessageArgs_(size_t argsize);
	void dropMessageArgs_(size_t argsize);
	void dropToS();
	void dropToS_(size_t anInteger);
	void dropsArguments();

    void inline_if_(SMessage *anSMessage, bool aBoolean);
    void inline_ifNil_(SMessage *anSMessage, bool aBoolean);
    void inline_ifNilIfNotNil_(SMessage *anSMessage, bool aBoolean);
    void inline_ifTrueIfFalse_(SMessage *anSMessage, bool aBoolean);
    void inline_unitaryWhile_(SMessage *anSMessage, bool aBoolean);
    void inline_binaryWhile_(SMessage *anSMessage, bool aBoolean);
    void inlineRepeat_(SMessage *anSMessage);
    void inlineToDo_(SMessage *anSMessage);
    void inlineToByDo_(SMessage *anSMessage);
    void inlineTimesRepeat_(SMessage *anSMessage);
    void inlineAndNot_(SMessage *anSMessage);
    void inlineOrNot_(SMessage *anSMessage);
    void inlineOr_(SMessage *anSMessage);
    void inlineAnd_(SMessage *anSMessage);

	SOpJump *jump();
	void jumpTo_(size_t anInteger);
	void loadRfromStack_(size_t anInteger);
	void loadRwithNil();
	void loadRwithSelf();
	void popR();
	void primitive_(PrimitivePointer aClosure);
	void primitives_(std::map<HeapObject*, PrimitivePointer> &primitives) { _primitives = primitives; }
	void pushR();
	void reset();
	void returnOp();
	void return_(bool isLocal);
	void runtime_(Runtime *aRuntime);
	void storeRintoFrameAt_(size_t anInteger);

	void visitStatements(std::vector<SExpression *> &statements);

	void visitAssignment(SAssignment *anSAssignment) override;
	void visitBlock(SBlock *anSBlock) override;
	void visitCascade(SCascade *anSCascade) override;
	void visitIdentifier(SIdentifier *anSIdentifier) override;
	void visitInlinedMessage(SMessage *anSMessage);
	void visitLiteral(SLiteral *anSLiteral) override;
	void visitMessage(SMessage *anSMessage) override;
	void visitMethod(SMethod *anSMethod) override;
	void visitMethod(SMethod *anSMethod, HeapObject *method);
	void visitOpLoadRfromFrame(SOpLoadRfromFrame *anSOpLoadRfromFrame) override;
	void visitOpLoadRfromStack(SOpLoadRfromStack *anSOpLoadRfromStack) override;
	void visitReturn(SReturn *anSReturn) override;

};

}

#endif /// ~ _SEXPRESSIONLINEARIZER_H_
