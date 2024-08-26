#ifndef _SEXPRESSIONLINEARIZER_H_
#define _SEXPRESSIONLINEARIZER_H_

#include <vector>
#include <map>
#include "../HeapObject.h"
#include "SExpressionVisitor.h"

namespace Egg {

class Runtime;
class Evaluator;
class SExpression;
class SOpAssign;
class SOpJump;
class SOpJumpFalse;
class SOpJumpTrue;
class SOpDispatchMessage;
class SOpDropToS;
class SOpLoadRfromStack;
class SOpLoadRwithNil;
class SOpLoadRwithSelf;
class SOpPopR;
class SOpPushR;
class SAbstractMessage;
class SAssignment;
class SBlock;
class SCascade;
class SCascadeMessage;
class SIdentifier;
class SLiteral;
class SMessage;
class SMethod;
class SReturn;

class SExpressionLinearizer : public SExpressionVisitor {
	HeapObject *_greaterThan, *_one, *_plus, *_not, *_equalsEquals, *_ifTrue, *_ifFalse, *_ifTrueIfFalse, *_ifFalseIfTrue, *_ifNil, *_ifNotNil, *_ifNilIfNotNil, *_ifNotNilIfNil, *_whileTrue, *_whileFalse, *_whileTrue_, *_whileFalse_, *_toDo, *_toByDo, *_repeat, *_timesRepeat, *_andNot, *_orNot;

	bool _inBlock;
	bool _dropsArguments;
	size_t _stackTop;
	std::vector<SExpression*> *_operations;
	
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

		this->_greaterThan = nullptr;
		this->_one = nullptr;
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

	std::vector<SExpression*>* operations() {
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
	void jump();
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
	void visitAssignment(SAssignment *anSAssignment);
	void visitBlock(SBlock *anSBlock);
	void visitCascade(SCascade *anSCascade);
	void visitIdentifier(SIdentifier *anSIdentifier);
	void visitInlinedMessage(SMessage *anSMessage);
	void visitLiteral(SLiteral *anSLiteral);
	void visitMessage(SMessage *anSMessage);
	void visitMethod(SMethod *anSMethod);
	void visitOpLoadRfromFrame(SOpLoadRfromFrame *anSOpLoadRfromFrame);
	void visitOpLoadRfromStack(SOpLoadRfromStack *anSOpLoadRfromStack);
	void visitReturn(SReturn *anSReturn);

};

}

#endif /// ~ _SEXPRESSIONLINEARIZER_H_
