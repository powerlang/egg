#include "SExpressionLinearizer.h"
#include "SOpAssign.h"
#include "SOpJump.h"
#include "SOpJumpFalse.h"
#include "SOpJumpTrue.h"
#include "SOpDispatchMessage.h"
#include "SOpDropToS.h"
#include "SOpLoadRfromFrame.h"
#include "SOpLoadRfromStack.h"
#include "SOpLoadRwithNil.h"
#include "SOpLoadRwithSelf.h"
#include "SOpNonLocalReturn.h"
#include "SOpPrimitive.h"
#include "SOpPopR.h"
#include "SOpPushR.h"
#include "SOpReturn.h"
#include "SAssignment.h"
#include "SBlock.h"
#include "SCascade.h"
#include "SCascadeMessage.h"
#include "SIdentifier.h"
#include "SLiteral.h"
#include "SMessage.h"
#include "SMethod.h"
#include "SReturn.h"

using namespace Egg;

void SExpressionLinearizer::assign_(auto aCollection) {
    auto op = new SOpAssign(aCollection);
    this->_operations->push_back(op);
}

/*
auto SExpressionLinearizer::branchIf_(bool aBoolean) {
    auto op = aBoolean ? new SOpJumpTrue : new SOpJumpFalse;
    this->_operations->push_back(op);
    return op;
}
*/

void SExpressionLinearizer::branchTargetOf_(SOpJump *branch) {
    branch->target_(this->currentPC());
}

size_t SExpressionLinearizer::currentPC() {
    return this->_operations->size();
}

void SExpressionLinearizer::dispatch_(SAbstractMessage *message) {
    
    auto op = new SOpDispatchMessage(message);
    this->_operations->push_back(op);
    if (this->_dropsArguments) return;

    auto count = message->arguments().size();
    if (count > 0) {
        count = (count+1);
    }
    this->_stackTop = (this->_stackTop-count);
    

}

void SExpressionLinearizer::dropCascadeMessageArgs_(size_t argsize) {
    if (argsize == 0 || !this->_dropsArguments)
        return;
        
    this->dropToS_(argsize);
}

void SExpressionLinearizer::dropMessageArgs_(size_t argsize) {
    if (argsize == 0 || !this->_dropsArguments)
        return;
    
    this->dropToS_((argsize+1));
}

void SExpressionLinearizer::dropToS() {
    this->dropToS_(1);
}

void SExpressionLinearizer::dropToS_(size_t anInteger) {
    auto op = new SOpDropToS(anInteger);
    this->_operations->push_back(op);
    this->_stackTop = this->_stackTop-anInteger;

}

void SExpressionLinearizer::dropsArguments() {
    this->_dropsArguments = true;
}

/*
void SExpressionLinearizer::jump() {
    auto op = new SOpJump();
    this->_operations->push_back(op);
}
*/

void SExpressionLinearizer::jumpTo_(size_t anInteger) {
    auto op = new SOpJump(anInteger);
    this->_operations->push_back(op);
}

void SExpressionLinearizer::loadRfromStack_(size_t anInteger) {
    auto op = new SOpLoadRfromStack(anInteger);
    this->_operations->push_back(op);
}

void SExpressionLinearizer::loadRwithNil() {
    this->_operations->push_back(new SOpLoadRwithNil);
}

void SExpressionLinearizer::loadRwithSelf() {
    this->_operations->push_back(new SOpLoadRwithSelf);
}

void SExpressionLinearizer::popR() {
    this->_operations->push_back(new SOpPopR);
    this->_stackTop = (this->_stackTop-1);
}

void SExpressionLinearizer::primitive_(PrimitivePointer aPrimitive) {
    this->_operations->push_back(new SOpPrimitive(aPrimitive));
}

void SExpressionLinearizer::pushR() {
    this->_operations->push_back(new SOpPushR);
    this->_stackTop = (this->_stackTop+1);
}

void SExpressionLinearizer::reset() {
    this->_operations = new std::vector<SExpression*>;
    this->_inBlock = false;
}

void SExpressionLinearizer::returnOp() {
    this->_operations->push_back(new SOpReturn);
}

void SExpressionLinearizer::return_(bool isLocal) {
    auto ret = (isLocal && !this->_inBlock) ? new SOpReturn : new  SOpNonLocalReturn;
    this->_operations->push_back(ret);
}

void SExpressionLinearizer::runtime_(Runtime *aRuntime) {
    this->_runtime = aRuntime;
    this->_plus = _runtime->existingSymbolFrom_("+");
    this->_greaterThan = _runtime->existingSymbolFrom_(">");
    this->_equalsEquals = _runtime->existingSymbolFrom_("==");
    this->_not = _runtime->existingSymbolFrom_("not");
    this->_ifTrue = _runtime->existingSymbolFrom_("ifTrue:");
    this->_ifFalse = _runtime->existingSymbolFrom_("ifFalse:");
    this->_ifTrueIfFalse = _runtime->existingSymbolFrom_("ifTrue:ifFalse:");
    this->_ifFalseIfTrue = _runtime->existingSymbolFrom_("ifFalse:ifTrue:");
    this->_ifNil = _runtime->existingSymbolFrom_("ifNil:");
    this->_ifNotNil = _runtime->existingSymbolFrom_("ifNotNil:");
    this->_ifNilIfNotNil = _runtime->existingSymbolFrom_("ifNil:ifNotNil:");
    this->_ifNotNilIfNil = _runtime->existingSymbolFrom_("ifNotNil:ifNil:");
    this->_repeat = _runtime->existingSymbolFrom_("repeat");
    this->_whileTrue = _runtime->existingSymbolFrom_("whileTrue");
    this->_whileFalse = _runtime->existingSymbolFrom_("whileFalse");
    this->_whileTrue_ = _runtime->existingSymbolFrom_("whileTrue:");
    this->_whileFalse_ = _runtime->existingSymbolFrom_("whileFalse:");
    this->_timesRepeat = _runtime->existingSymbolFrom_("timesRepeat:");
    this->_toDo = _runtime->existingSymbolFrom_("to:do:");
    this->_toByDo = _runtime->existingSymbolFrom_("to:by:do:");
    this->_andNot = _runtime->existingSymbolFrom_("andNot:");
    this->_orNot = _runtime->existingSymbolFrom_("orNot:");
}

/*
void SExpressionLinearizer::storeRintoFrameAt_(size_t anInteger) {
    auto op = new SOpStoreRintoFrame(anInteger);
    this->_operations->push_back(op);
}
*/

void SExpressionLinearizer::visitAssignment(SAssignment *anSAssignment) {
    anSAssignment->expression()->acceptVisitor_(this);
    this->assign_(anSAssignment->assignees());
}

void SExpressionLinearizer::visitBlock(SBlock *anSBlock) {
    this->_operations->push_back(anSBlock);
    auto prevInBlock = this->_inBlock;
    auto prevOperations = this->_operations;
    this->_inBlock = true;
    this->_operations = new std::vector<SExpression*>;
    auto statements = anSBlock->statements();
    for (auto node : statements) {
        node->acceptVisitor_(this);
    }

    if (statements.empty()) {
        this->loadRwithNil();
    } else {
        if (!statements.back()->isReturn())
            this->returnOp();
    }

    if (!anSBlock->isInlined()) {

        auto code = _runtime->newExecutableCodeFor_with_(anSBlock->_compiledCode, reinterpret_cast<HeapObject*>(this->_operations));
        _runtime->blockExecutableCode_put_(anSBlock->compiledCode(), (Object*)code);
    }

    this->_operations = prevOperations;
    this->_inBlock = prevInBlock;
}

void SExpressionLinearizer::visitCascade(SCascade *anSCascade) {
    anSCascade->receiver()->acceptVisitor_(this);
    this->pushR();
    for (auto msg : anSCascade->messages()) {
        auto args = msg->arguments();
        auto argsize = args.size();
        for (auto arg : args) {
            arg->acceptVisitor_(this);
            this->pushR();
        }
        this->loadRfromStack_(argsize);
        this->dispatch_(msg);
        this->dropCascadeMessageArgs_(argsize);
    }
    this->dropToS();
}

void SExpressionLinearizer::visitIdentifier(SIdentifier *anSIdentifier) {
    this->_operations->push_back(anSIdentifier);
}

void SExpressionLinearizer::visitInlinedMessage(SMessage *anSMessage) {
    auto selector = anSMessage->selector();
/*
    if (selector == this->_ifTrue) return this->inline_if_(anSMessage, true);
    if (selector == this->_ifFalse) return this->inline_if_(anSMessage, false);
    if (selector == this->_ifNil) return this->inline_ifNil_(anSMessage, true);
    if (selector == this->_ifNotNil) return this->inline_ifNil_(anSMessage, false);
    if (selector == this->_ifNilIfNotNil) return this->inline_ifNilIfNotNil_(anSMessage, true);
    if (selector == this->_ifNotNilIfNil) return this->inline_ifNilIfNotNil_(anSMessage, false);
    if (selector == this->_ifTrueIfFalse) return this->inline_ifTrueIfFalse_(anSMessage, true);
    if (selector == this->_ifFalseIfTrue) return this->inline_ifTrueIfFalse_(anSMessage, false);
    if (selector == this->_whileTrue) return this->inline_unitaryWhile_(anSMessage, true);
    if (selector == this->_whileFalse) return this->inline_unitaryWhile_(anSMessage, false);
    if (selector == this->_whileTrue_) return this->inline_binaryWhile_(anSMessage, true);
    if (selector == this->_whileFalse_) return this->inline_binaryWhile_(anSMessage, false);
    if (selector == this->_repeat) return this->inlineRepeat_(anSMessage);
    if (selector == this->_toDo) return this->inlineToDo_(anSMessage);
    if (selector == this->_toByDo) return this->inlineToByDo_(anSMessage);
    if (selector == this->_timesRepeat) return this->inlineTimesRepeat_(anSMessage);
    if (selector == this->_andNot) return this->inlineAndNot_(anSMessage);
    if (selector == this->_orNot) return this->inlineOrNot_(anSMessage);
    selector = _runtime->existingSymbolFrom_(selector);
    if (selector->asLocalString()->begisWith("or:")) return this->inlineOr_(anSMessage);
    if (selector->asLocalString()->beginsWith_("and:")) return this->inlineAnd_(anSMessage);
*/
    ASSERT(false);
}

void SExpressionLinearizer::visitLiteral(SLiteral *anSLiteral) {
    this->_operations->push_back(anSLiteral);
}

void SExpressionLinearizer::visitMessage(SMessage *anSMessage) {
    if (anSMessage->isInlined())
        return this->visitInlinedMessage(anSMessage);
    
    anSMessage->receiver()->acceptVisitor_(this);
    auto args = anSMessage->arguments();
    auto argsize = args.size();
    if (argsize > 0)
        this->pushR();
    
    for (auto arg : args) {
        arg->acceptVisitor_(this);
        this->pushR();
    }
    if (argsize > 0)
        this->loadRfromStack_(argsize);
    
    this->dispatch_(anSMessage);
    this->dropMessageArgs_(argsize);
}

void SExpressionLinearizer::visitMethod(SMethod *anSMethod) {
    this->reset();
    auto primitive = anSMethod->pragma();
    if (primitive != nullptr) {
        PrimitivePointer primitive = this->_primitives[anSMethod->primitive()];
        this->primitive_(primitive);
        this->returnOp();
        return;
    }
    this->_stackTop = _runtime->methodTempCount_(anSMethod->compiledCode());
    auto statements = anSMethod->statements();
    for (auto node : statements) {
        node->acceptVisitor_(this);
    }
    if (statements.empty() || !statements.back()->isReturn()) {
        this->loadRwithSelf();
        this->returnOp();
    }
}

void SExpressionLinearizer::visitOpLoadRfromFrame(SOpLoadRfromFrame *anSOpLoadRfromFrame) {
    this->_operations->push_back(anSOpLoadRfromFrame);
}

void SExpressionLinearizer::visitOpLoadRfromStack(SOpLoadRfromStack *anSOpLoadRfromStack) {
    this->loadRfromStack_(anSOpLoadRfromStack->index());
}

void SExpressionLinearizer::visitReturn(SReturn *anSReturn) {
    anSReturn->expression()->acceptVisitor_(this);
    this->return_(anSReturn->local());
}

