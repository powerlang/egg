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
#include "SOpStoreRintoFrame.h"
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


auto SExpressionLinearizer::branchIf_(bool aBoolean) {
    SOpJump *op = aBoolean ? (SOpJump*)new SOpJumpTrue : (SOpJump*)new SOpJumpFalse;
    this->_operations->push_back(op);
    return op;
}

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

void SExpressionLinearizer::inline_if_(SMessage *anSMessage, bool aBoolean) {
    anSMessage->receiver()->acceptVisitor_(this);
    auto branch = this->branchIf_(!aBoolean);
    auto script = (SScript *)anSMessage->arguments()[0];
    this->visitStatements(script->statements());
    auto end = this->jump();

    this->branchTargetOf_(branch);
    this->loadRwithNil();
    this->branchTargetOf_(end);
}

void SExpressionLinearizer::inline_ifNil_(SMessage *anSMessage, bool aBoolean)
{
    anSMessage->receiver()->acceptVisitor_(this);
    auto arg = anSMessage->arguments()[0];
    if (arg->isBlock() && ((SBlock*)arg)->inlinedArgs().size() == 1) {
	auto index = ((SBlock*)arg)->inlinedArgs()[0];
	this->storeRintoFrameAt_(index);
    }

    this->pushR();
    auto nilObj = new SLiteral(0xFFFFFFFF, (Object*)_runtime->_nilObj);
    auto message = new SMessage(new SOpLoadRfromStack(0), _equalsEquals, {nilObj}, false);
    this->visitMessage(message);
    auto branch = this->branchIf_(!aBoolean);

    if (arg->isBlock())
	this->visitStatements(((SBlock*)arg)->statements());
    else
	arg->acceptVisitor_(this);

    this->dropToS();

    auto end = this->jump();

    this->branchTargetOf_(branch);
    this->popR();
    this->branchTargetOf_(end);
}
void SExpressionLinearizer::inline_ifNilIfNotNil_(SMessage *anSMessage, bool aBoolean)
{
    anSMessage->receiver()->acceptVisitor_(this);
    auto arguments = anSMessage->arguments();
    auto arg = aBoolean ? arguments[1] : arguments[0];
    if (arg->isBlock() && ((SBlock*)arg)->inlinedArgs().size() == 1)
    {
        auto index = ((SBlock*)arg)->inlinedArgs()[0];
        this->storeRintoFrameAt_(index);
    }
    this->pushR();

    auto nilObj = new SLiteral(0xFFFFFFFF, (Object*)_runtime->_nilObj);
    auto message = new SMessage(new SOpLoadRfromStack(0), _equalsEquals, {nilObj}, false);
    this->visitMessage(message);
    auto branch = this->branchIf_(!aBoolean);
    this->visitStatements(((SBlock*)arguments[0])->statements());
    auto end = this->jump();
    this->branchTargetOf_(branch);
    this->visitStatements(((SBlock*)arguments[1])->statements());
    this->branchTargetOf_(end);
    this->dropToS();
}

void SExpressionLinearizer::inline_ifTrueIfFalse_(SMessage *anSMessage, bool aBoolean)
{
    anSMessage->receiver()->acceptVisitor_(this);

    auto branch = this->branchIf_(!aBoolean);
    auto firstBlockStatements = ((SBlock*)anSMessage->arguments()[0])->statements();
    this->visitStatements(firstBlockStatements);
    auto end = this->jump();

    this->branchTargetOf_(branch);
    auto secondBlockStatements = ((SBlock*)anSMessage->arguments()[1])->statements();
    this->visitStatements(secondBlockStatements);
    this->branchTargetOf_(end);
}

void SExpressionLinearizer::inline_unitaryWhile_(SMessage *anSMessage, bool aBoolean)
{
    auto start = this->currentPC();
    this->visitStatements(((SBlock*)anSMessage->receiver())->statements());
    auto branch =  this->branchIf_(aBoolean);
    branch->target_(start);
}

void SExpressionLinearizer::inline_binaryWhile_(SMessage *anSMessage, bool aBoolean)
{
    auto start = this->currentPC();
    this->visitStatements(((SBlock*)anSMessage->receiver())->statements());
    auto end = this->branchIf_(!aBoolean);

    this->visitStatements(((SBlock*)anSMessage->arguments()[0])->statements());
    this->jumpTo_(start);
    this->branchTargetOf_(end);
}

void SExpressionLinearizer::inlineRepeat_(SMessage *anSMessage)
{
    auto start = this->currentPC();
    this->visitStatements(((SBlock*)anSMessage->receiver())->statements());
    this->jumpTo_(start);
}

void SExpressionLinearizer::inlineToDo_(SMessage *anSMessage)
{
    // TODO: cleanup block locals to nil after each cycle

    anSMessage->receiver()->acceptVisitor_(this);

    auto index = ((SBlock*)anSMessage->arguments()[1])->inlinedArgs()[0];
    auto current = new SOpLoadRfromFrame(index);
    this->storeRintoFrameAt_(index);
    anSMessage->arguments()[0]->acceptVisitor_(this);
    this->pushR();

    auto limit = new SOpLoadRfromFrame(_stackTop);
    auto start = this->currentPC();

    auto compare = new SMessage(current, _greaterThan, {limit}, false);
    this->visitMessage(compare);

    auto end = this->branchIf_(true);
    this->visitStatements(((SBlock*)anSMessage->arguments()[1])->statements());

    auto increment = new SMessage(current, _plus, {_one}, false);

    this->visitMessage(increment);
    this->storeRintoFrameAt_(index);
    this->jumpTo_(start);
    this->branchTargetOf_(end);
    this->dropToS();
}

void SExpressionLinearizer::inlineToByDo_(SMessage *anSMessage)
{
    error("not yet implemented");
}

void SExpressionLinearizer::inlineTimesRepeat_(SMessage *anSMessage)
{
    // TODO: cleanup block locals to nil after each cycle

    _operations->push_back(_one);
    this->pushR();

    auto current = new SOpLoadRfromFrame(_stackTop);
    anSMessage->receiver()->acceptVisitor_(this);
    this->pushR();

    auto limit = new SOpLoadRfromFrame(_stackTop);
    auto start = this->currentPC();

    auto compare = new SMessage(current,_greaterThan, {limit}, false);
    this->visitMessage(compare);

    auto end = this->branchIf_(true);
    this->visitStatements(((SBlock*)anSMessage->arguments()[0])->statements());

    auto increment = new SMessage(current, _plus, {_one}, false);

    this->visitMessage(increment);
    this->storeRintoFrameAt_(current->index());
    this->jumpTo_(start);
    this->branchTargetOf_(end);
    this->dropToS_(2);


}

void SExpressionLinearizer::inlineAndNot_(SMessage *anSMessage)
{
    anSMessage->receiver()->acceptVisitor_(this);

    auto branch = this->branchIf_(false);

    // the receiver is added just to have an object that knows to respond isSuper
    auto message = new SMessage(new SLiteral(0xFFFFFFFF, (Object*)_runtime->_nilObj), _not, {}, false);

    this->visitStatements(((SBlock*)anSMessage->arguments()[0])->statements());
    this->dispatch_(message);
    this->branchTargetOf_(branch);

}

void SExpressionLinearizer::inlineOrNot_(SMessage *anSMessage)
{
    anSMessage->receiver()->acceptVisitor_(this);

    auto branch = this->branchIf_(true);

    // the receiver is added just to have an object that knows to respond isSuper
    auto message =  new SMessage(new SLiteral(0xFFFFFFFF, (Object*)_runtime->_nilObj), _not, {}, false);

    // Visit statements and dispatch
    this->visitStatements(((SBlock*)anSMessage->arguments()[0])->statements());
    this->dispatch_(message);
    this->branchTargetOf_(branch);
}

void SExpressionLinearizer::inlineOr_(SMessage *anSMessage)
{
    anSMessage->receiver()->acceptVisitor_(this);

    auto branches = std::vector<SOpJump*>();

    for (auto &block : anSMessage->arguments()) {
        branches.push_back(this->branchIf_(true));
        this->visitStatements(((SBlock*)block)->statements());
    }

    for (auto &branch : branches) {
        this->branchTargetOf_(branch);
    }
}

void SExpressionLinearizer::inlineAnd_(SMessage *anSMessage)
{
    anSMessage->receiver()->acceptVisitor_(this);

    auto branches = std::vector<SOpJump*>();
    for (auto &block : anSMessage->arguments()) {
        branches.push_back(this->branchIf_(false));
        this->visitStatements(((SBlock*)block)->statements());
    }

    for (auto &branch : branches) {
        this->branchTargetOf_(branch);
    }

}

SOpJump *SExpressionLinearizer::jump() {
    auto op = new SOpJump();
    this->_operations->push_back(op);
    return op;
}


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
    this->_operations = newPlatformCode();
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

    this->_one = new SLiteral(0xFFFFFFFF, (Object*)_runtime->newInteger_(1));

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

void SExpressionLinearizer::storeRintoFrameAt_(size_t anInteger) {
    auto op = new SOpStoreRintoFrame(anInteger);
    _operations->push_back(op);
}

/*
void SExpressionLinearizer::storeRintoFrameAt_(size_t anInteger) {
    auto op = new SOpStoreRintoFrame(anInteger);
    this->_operations->push_back(op);
}
*/

void SExpressionLinearizer::visitStatements(std::vector<SExpression *> &statements) {
    for (auto& sexpression : statements) {
        sexpression->acceptVisitor_(this);
    }
}

void SExpressionLinearizer::visitAssignment(SAssignment *anSAssignment) {
    anSAssignment->expression()->acceptVisitor_(this);
    this->assign_(anSAssignment->assignees());
}

void SExpressionLinearizer::visitBlock(SBlock *anSBlock) {
    this->_operations->push_back(anSBlock);
    auto prevInBlock = this->_inBlock;
    auto prevOperations = this->_operations;
    auto prevStackTop = _stackTop;
    this->_stackTop = _runtime->blockTempCount_(anSBlock->compiledCode());
    this->_inBlock = true;
    this->_operations = newPlatformCode();
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

        auto code = _runtime->newExecutableCodeFor_with_(anSBlock->_compiledCode, this->_operations);
        _runtime->blockExecutableCode_put_(anSBlock->compiledCode(), code);
    }

    this->_stackTop = prevStackTop;
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
    HeapObject *selector = anSMessage->selector();

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

    // check if selector is or:or:or:... or and:and:and:...
    if (selector->asLocalString().starts_with("or:")) return this->inlineOr_(anSMessage);
    if (selector->asLocalString().starts_with("and:")) return this->inlineAnd_(anSMessage);

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
    ASSERT(false);
}

void SExpressionLinearizer::visitMethod(SMethod *anSMethod, HeapObject *method) {
    this->reset();
    auto primitive = anSMethod->pragma();
    if (primitive != nullptr) {
        auto name = (_runtime->methodIsFFI_(method)) ? _runtime->existingSymbolFrom_("FFICall") : anSMethod->primitive();
        PrimitivePointer primitive = this->_primitives[name];
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

void SExpressionLinearizer::visitOpLoadRfromStack(
    SOpLoadRfromStack *anSOpLoadRfromStack) {
    this->loadRfromStack_(anSOpLoadRfromStack->index());
}

void SExpressionLinearizer::visitReturn(SReturn *anSReturn) {
    anSReturn->expression()->acceptVisitor_(this);
    this->return_(anSReturn->local());
}

