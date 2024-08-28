
#include "Evaluator.h"
#include "Runtime.h"
#include "SExpressionLinearizer.h"
#include "SOpAssign.h"
#include "SOpDispatchMessage.h"
#include "SOpDropToS.h"
#include "SOpJumpFalse.h"
#include "SOpJumpTrue.h"
#include "SOpLoadRfromFrame.h"
#include "SOpLoadRfromStack.h"
#include "SOpLoadRwithNil.h"
#include "SOpLoadRwithSelf.h"
#include "SOpNonLocalReturn.h"
#include "SOpPopR.h"
#include "SOpPrimitive.h"
#include "SOpPushR.h"
#include "SOpReturn.h"

#include "TreecodeDecoder.h"
#include <cmath>
#include <bit>

using namespace Egg;

Evaluator::Evaluator(Runtime *runtime, HeapObject *falseObj, HeapObject *trueObj, HeapObject *nilObj) : 
        _runtime(runtime),
        _nilObj(nilObj),
        _trueObj(trueObj),
        _falseObj(falseObj)
    {
        _linearizer = new SExpressionLinearizer();
        _linearizer->runtime_(_runtime);
    }


void Evaluator::_halt()
{
	perror("_halt encountered");
}

void Evaluator::addPrimitive(const std::string &name, Evaluator::PrimitivePointer primitive)
{
    HeapObject *symbol = _runtime->existingSymbolFrom_(name);
    _primitives[symbol] = primitive;
}

void Evaluator::addUndermessage(const std::string &name, UndermessagePointer primitive) {
    HeapObject *symbol = _runtime->existingSymbolFrom_(name);
    _undermessages[symbol] = primitive;
}


void Evaluator::initializePrimitives()
{
    this->addPrimitive("PrimitiveBehavior", &Evaluator::primitiveBehavior);
    this->addPrimitive("PrimitiveSetBehavior", &Evaluator::primitiveSetBehavior);
    this->addPrimitive("PrimitiveClass", &Evaluator::primitiveClass);
    this->addPrimitive("PrimitiveUnderHash", &Evaluator::primitiveUnderHash);
    this->addPrimitive("PrimitiveUnderIsBytes", &Evaluator::primitiveUnderIsBytes);
    this->addPrimitive("PrimitiveUnderPointersSize", &Evaluator::primitiveUnderPointersSize);
    this->addPrimitive("PrimitiveUnderSize", &Evaluator::primitiveUnderSize);
    this->addPrimitive("PrimitiveSize", &Evaluator::primitiveSize);
    this->addPrimitive("PrimitiveHash", &Evaluator::primitiveHash);
    this->addPrimitive("PrimitiveAt", &Evaluator::primitiveAt);
    this->addPrimitive("PrimitiveAtPut", &Evaluator::primitiveAtPut);
    this->addPrimitive("PrimitiveNew", &Evaluator::primitiveNew);
    this->addPrimitive("PrimitiveNewSized", &Evaluator::primitiveNewSized);
    this->addPrimitive("PrimitiveNewBytes", &Evaluator::primitiveNewBytes);
    this->addPrimitive("PrimitiveSMIPlus", &Evaluator::primitiveSMIPlus);
    this->addPrimitive("PrimitiveSMIMinus", &Evaluator::primitiveSMIMinus);
    this->addPrimitive("PrimitiveSMITimes", &Evaluator::primitiveSMITimes);
    this->addPrimitive("PrimitiveSMIIntDiv", &Evaluator::primitiveSMIIntDiv);
    this->addPrimitive("PrimitiveSMIIntQuot", &Evaluator::primitiveSMIIntQuot);
    this->addPrimitive("PrimitiveSMIBitAnd", &Evaluator::primitiveSMIBitAnd);
    this->addPrimitive("PrimitiveSMIBitOr", &Evaluator::primitiveSMIBitOr);
    this->addPrimitive("PrimitiveSMIBitXor", &Evaluator::primitiveSMIBitXor);
    this->addPrimitive("PrimitiveSMIBitShift", &Evaluator::primitiveSMIBitShift);
    this->addPrimitive("PrimitiveSMIHighBit", &Evaluator::primitiveSMIHighBit);
    this->addPrimitive("PrimitiveSMIGreaterThan", &Evaluator::primitiveSMIGreaterThan);
    this->addPrimitive("PrimitiveSMIGreaterEqualThan", &Evaluator::primitiveSMIGreaterEqualThan);
    this->addPrimitive("PrimitiveSMIEqual", &Evaluator::primitiveSMIEqual);
    this->addPrimitive("PrimitiveSMINotEqual", &Evaluator::primitiveSMINotEqual);
    this->addPrimitive("PrimitiveSMISize", &Evaluator::primitiveSMISize);
    this->addPrimitive("PrimitiveClosureValue", &Evaluator::primitiveClosureValue);
    this->addPrimitive("PrimitiveClosureValueWithArgs", &Evaluator::primitiveClosureValueWithArgs);
    this->addPrimitive("PrimitiveClosureArgumentCount", &Evaluator::primitiveClosureArgumentCount);
    this->addPrimitive("PrimitivePerformWithArguments", &Evaluator::primitivePerformWithArguments);
    this->addPrimitive("PrimitiveStringReplaceFromToWithStartingAt", &Evaluator::primitiveStringReplaceFromToWithStartingAt);
    this->addPrimitive("PrimitiveFloatNew", &Evaluator::primitiveFloatNew);
    this->addPrimitive("PrimitiveBootstrapDictNew", &Evaluator::primitiveBootstrapDictNew);
    this->addPrimitive("PrimitiveFlushDispatchCaches", &Evaluator::primitiveFlushDispatchCaches);
    this->addPrimitive("PrimitiveBootstrapDictBeConstant", &Evaluator::primitiveBootstrapDictBeConstant);
    this->addPrimitive("PrimitiveBootstrapDictKeys", &Evaluator::primitiveBootstrapDictKeys);
    this->addPrimitive("PrimitiveBootstrapDictAt", &Evaluator::primitiveBootstrapDictAt);
    this->addPrimitive("PrimitiveBootstrapDictAtPut", &Evaluator::primitiveBootstrapDictAtPut);
    //this->addPrimitive("PrimitiveHostSuspendedBecause", &Evaluator::primitiveHostSuspendedBecause);
    this->addPrimitive("PrimitiveHostLoadModule", &Evaluator::primitiveHostLoadModule);
    //this->addPrimitive("PrimitiveHostFixOverrides", &Evaluator::primitiveHostFixOverrides);
    this->addPrimitive("PrimitivePrimeFor", &Evaluator::primitivePrimeFor);
    this->addPrimitive("PrimitiveFlushFromCaches", &Evaluator::primitiveFlushFromCaches);
    /*this->addPrimitive("PrimitivePrepareForExecution", &Evaluator::primitivePrepareForExecution);
    this->addPrimitive("PrimitiveProcessVMStackInitialize", &Evaluator::primitiveProcessVMStackInitialize);
    this->addPrimitive("PrimitiveProcessVMStackAt", &Evaluator::primitiveProcessVMStackAt);
    this->addPrimitive("PrimitiveProcessVMStackAtPut", &Evaluator::primitiveProcessVMStackAtPut);
    this->addPrimitive("PrimitiveProcessVMStackBpAtPut", &Evaluator::primitiveProcessVMStackBpAtPut);
    this->addPrimitive("PrimitiveProcessVMStackPcAtPut", &Evaluator::primitiveProcessVMStackPcAtPut);
    this->addPrimitive("PrimitiveProcessVMStackBP", &Evaluator::primitiveProcessVMStackBP);
    this->addPrimitive("PrimitiveProcessVMStackBufferSize", &Evaluator::primitiveProcessVMStackBufferSize);
    this->addPrimitive("PrimitiveProcessVMStackContextSwitchTo", &Evaluator::primitiveProcessVMStackContextSwitchTo);
    */
}

void Evaluator::evaluatePerform_in_withArgs_(HeapObject *aSymbol, Object *receiver, Object *arguments) {
    HeapObject *behavior = this->_runtime->behaviorOf_(receiver);
    HeapObject *method = this->_runtime->lookup_startingAt_(aSymbol, behavior);
    auto heapargs = arguments->asHeapObject();
    for (int i = 1; i <= heapargs->size(); i++) {
        this->_context->pushOperand_(heapargs->slotAt_(i));
    }
    this->invoke_with_(method, receiver);
}

Object* Evaluator::invoke_with_(HeapObject* method, Object *receiver) {
        int size = _runtime->methodEnvironmentSize_(method);
        HeapObject *environment = _runtime->newEnvironmentSized_(size);
        HeapObject *executable = this->prepareForExecution_(method);

        this->_context->buildMethodFrameFor_code_environment_(receiver, executable, environment);

        return _regR;
}

HeapObject* Evaluator::prepareForExecution_(HeapObject *method) {

	auto executableCode = _runtime->methodExecutableCode_(method);
	if (executableCode != _nilObj) return executableCode;

    HeapObject *treecodes = this->_runtime->methodTreecodes_(method);
    TreecodeDecoder decoder;
    decoder.bytes_(treecodes->stringVal());
    decoder.method_(method);
    decoder.runtime_(_runtime);
    auto sexpressions = decoder.decodeMethod();

    this->_linearizer->visitMethod(sexpressions);
    executableCode = this->_runtime->newExecutableCodeFor_with_(method, reinterpret_cast<HeapObject*>(this->_linearizer->operations()));
    this->_runtime->methodExecutableCode_put_(method, (Object*)executableCode);

	return executableCode;
}

SmallInteger* Evaluator::evaluatePrimitiveHash_(HeapObject *receiver) {
    uint16_t hash = receiver->hash();
    if (hash == 0) {
        hash = this->_runtime->nextHash();
        receiver->hash(hash);
    }
    return this->_runtime->newInteger_(hash);
}

void Egg::Evaluator::evaluateUndermessage_with_(SAbstractMessage * message, UndermessagePointer undermessage)
{
    auto argcount = message->argumentCount();
    auto arguments = _context->popOperands_(argcount);
    _regR = (this->*undermessage)(_regR, arguments);
    _context->reserveStackSlots_(argcount);
}

Object* Evaluator::send_to_with_(HeapObject *symbol, Object *receiver, std::vector<Object*> &args) {
    auto literal = new SLiteral(0, (Object*)this->_nilObj);
    std::vector<SExpression*> dummy(args.size(), literal);
    auto message = new SMessage(literal, symbol, dummy, false);
    auto dispatch = new SOpDispatchMessage(message);

    this->_context->buildLaunchFrame();
    this->_regR = receiver;
    if (!args.empty())
        this->_context->pushOperand_(receiver);
    
    for (auto arg : args) {
        this->_context->pushOperand_(arg);
    }
    auto bytecodes = new std::vector<SExpression*>();
    bytecodes->push_back(dispatch);
    this->_work = bytecodes;
    this->_context->regPC_(0);
    this->evaluate();
    this->_context->popLaunchFrame();
    return this->_regR;
}

void Evaluator::doesNotKnow(HeapObject *symbol)
{
    ASSERT(false);
}

void Evaluator::visitIdentifier(SIdentifier *identifier)
{
    SBinding* binding = identifier->binding();
    auto value = binding->valueWithin_(_context);
    if (!value)
        return this->doesNotKnow(binding->name());
    
    this->_regR = value;
}

void Egg::Evaluator::visitLiteral(SLiteral *anSLiteral)
{
    this->_regR = anSLiteral->value();
}

void Egg::Evaluator::visitBlock(SBlock *anSBlock)
{
    this->_regR = (Object*)_context->captureClosure_(anSBlock);
}

void Evaluator::visitOpAssign(SOpAssign *anSOpAssign)
{
	auto assignees = anSOpAssign->assignees();
	for (auto &identifier : assignees)
	{
        auto binding = identifier->binding();
		binding->assign_within_(_regR, _context);

        // ifUnbound: [ self unboundAssignment: binding with: assignees ] ]
    }
}

void Evaluator::visitOpDispatchMessage(SOpDispatchMessage *anSOpDispatchMessage)
{
    SAbstractMessage *message = anSOpDispatchMessage->message();
    
    UndermessagePointer cachedUndermessage = *(UndermessagePointer*)message->cachedUndermessage();
    if (cachedUndermessage != nullptr) {
        return this->evaluateUndermessage_with_(message, cachedUndermessage);
    }

}
void Evaluator::visitOpDropToS(SOpDropToS *anSOpDropToS)
{
	_context->dropOperands_(anSOpDropToS->count());
}

void Evaluator::visitOpJump(SOpJump *anSOpJump)
{
    _context->regPC_(anSOpJump->target());
}

void Evaluator::visitOpJumpFalse(SOpJumpFalse *anSOpJumpFalse)
{
	if (_regR == (Object*)_falseObj) _context->regPC_(anSOpJumpFalse->target());
}

void Evaluator::visitOpJumpTrue(SOpJumpTrue *anSOpJumpTrue)
{
	if (_regR == (Object*)_trueObj) _context->regPC_(anSOpJumpTrue->target());
}

void Evaluator::visitOpLoadRfromFrame(SOpLoadRfromFrame *anSOpLoadRfromFrame)
{
	_regR = _context->stackTemporaryAt_(anSOpLoadRfromFrame->index());
}

void Evaluator::visitOpLoadRfromStack(SOpLoadRfromStack *anSOpLoadRfromStack)
{
	_regR = _context->operandAt_(anSOpLoadRfromStack->index());
}

void Evaluator::visitOpLoadRwithNil(SOpLoadRwithNil *anSOpLoadRwithNil)
{
	_regR = (Object*)_nilObj;
}

void Evaluator::visitOpLoadRwithSelf(SOpLoadRwithSelf *anSOpLoadRwithSelf)
{
    _regR = _context->self();
}

void Evaluator::visitOpPrimitive(SOpPrimitive *anSOpPrimitive)
{
    PrimitivePointer p = anSOpPrimitive->primitive();
    _regR = (this->*p)(); // weird syntax, means call p passing this too (as this)
}

void Evaluator::visitOpPopR(SOpPopR *anSOpPopR)
{
    _regR = _context->pop();
}

void Evaluator::visitOpPushR(SOpPushR *anSOpPushR)
{
	_context->pushOperand_(_regR);
}

void Evaluator::popFrameAndPrepare()
{
	_context->popFrame();
	auto code = _runtime->methodExecutableCode_(_context->compiledCode());
	_work = _runtime->executableCodeWork_(code);
}

void Evaluator::visitOpReturn(SOpReturn *anSOpReturn)
{
    this->popFrameAndPrepare();
}

void Evaluator::visitOpNonLocalReturn(SOpNonLocalReturn *anSOpNonLocalReturn)
{
    _context->unwind();
	auto code = _runtime->methodExecutableCode_(_context->compiledCode());
	_work = _runtime->executableCodeWork_(code);
}

void Evaluator::evaluate() {
	while (auto operation = this->nextOperation()) {
		operation->acceptVisitor_(this);
    }
}

SExpression* Evaluator::nextOperation() {
    auto pc = _context->incRegPC();
	if (pc > _work->size())
        return nullptr;

    return _work->at(pc);
}


Object* Evaluator::newIntObject(auto anInteger){
    return (Object*)this->_runtime->newInteger_(anInteger);
}

Object* Evaluator::boolObject(bool aBoolean){
    return (Object*)this->_runtime->booleanFor_(aBoolean);
}


Object* Evaluator::primitiveAt() {
    auto receiver = this->_context->self();
    auto index = this->_context->firstArgument();

    if (receiver->isSmallInteger())
        error("primitiveAt: receiver must not be an integer");

    if (!index->isSmallInteger())
        error("primitiveAt: index must be an integer");
    
    auto index_int = index->asSmallInteger()->asNative();

    auto heapreceiver = receiver->asHeapObject();
    return heapreceiver->isBytes() ? newIntObject(heapreceiver->byteAt_(index_int)) : heapreceiver->slotAt_(index_int);
}

Object* Evaluator::primitiveAtPut() {
    auto receiver = this->_context->self();
    auto index = this->_context->firstArgument();

   if (receiver->isSmallInteger())
        error("primitiveAtPut: receiver must not be an integer");

    if (!index->isSmallInteger())
        error("primitiveAtPut: index must be an integer");

    auto index_int = index->asSmallInteger()->asNative();
    auto heapreceiver = receiver->asHeapObject();
    
    heapreceiver->slotAt_(index_int) = this->_context->secondArgument();
    return receiver;
}

Object* Evaluator::primitiveBehavior() {
    auto receiver = this->_context->self();
    return (Object*)this->_runtime->behaviorOf_((Object*)receiver);
}

// to-do
Object* Evaluator::primitiveBootstrapDictAt() { ASSERT(false); return nullptr; }
Object* Evaluator::primitiveBootstrapDictAtPut() { ASSERT(false); return nullptr; }
Object* Evaluator::primitiveBootstrapDictBeConstant() { ASSERT(false); return nullptr; }
Object* Evaluator::primitiveBootstrapDictKeys() { ASSERT(false); return nullptr; }
Object* Evaluator::primitiveBootstrapDictNew() { ASSERT(false); return nullptr; }

/*
Object* Evaluator::primitiveBootstrapDictAt() {
    let string;
    return () => {
        string = this->_context->firstArgument()->asString();
        return this->_context->self()->at_(string)
    };
}

Object* Evaluator::primitiveBootstrapDictAtPut() {
    let string;
    return () => {
        string = this->_context->firstArgument()->asString();
        return this->_context->self()->at_put_(string, this->_context->secondArgument())
    };
}

Object* Evaluator::primitiveBootstrapDictBeConstant() {
    return () => {
        return this->_context->self()->beConstant()
    };
}

Object* Evaluator::primitiveBootstrapDictKeys() {
    return () => {
        return this->_context->self()->keys()
    };
}

Object* Evaluator::primitiveBootstrapDictNew() {
    return () => {
        return this->_runtime->newBootstrapDictionaryOf_(this->_context->self())
    };
}
*/

Object* Evaluator::primitiveClass() {
    return (Object*)this->_runtime->speciesOf_(this->_context->self());
}

Object* Evaluator::primitiveClosureArgumentCount() {
    auto block = _runtime->closureBlock_(this->_context->self()->asHeapObject());
    auto count = _runtime->blockArgumentCount_(block);
    return newIntObject(count);
}

Object* Evaluator::primitiveClosureValue() {
    this->evaluateClosure_(this->_context->self());
    return this->_context->self();
}

Object* Evaluator::primitiveClosureValueWithArgs() {
    this->evaluateClosure_withArgs_(this->_context->self(), this->_context->methodArguments());
    return this->_context->self();
}

Object* Evaluator::primitiveEqual() {
    return boolObject(this->_context->self() == this->_context->firstArgument());
}

Object* Evaluator::primitiveFloatNew() {
    return (Object*)this->_runtime->newBytesOf_sized_(this->_context->self()->asHeapObject(), 8);
}

Object* Evaluator::primitiveFlushDispatchCaches() {
    this->_runtime->flushDispatchCache_in_(this->_context->self()->asHeapObject(), this->_context->firstArgument()->asHeapObject());
    return this->_context->self();
}

Object* Evaluator::primitiveFlushFromCaches() {
    this->_runtime->flushDispatchCache_(this->_runtime->methodSelector_(this->_context->self()->asHeapObject()));
    return this->_context->self();
}

Evaluator::PrimitivePointer Evaluator::primitiveFor_(HeapObject *aSymbol) {
    return this->_primitives[aSymbol];
}

Object* Evaluator::primitiveHash() {
    return newIntObject(this->_runtime->hashFor_(this->_context->self()));
}

Object* Evaluator::primitiveHostLoadModule() {
    return (Object*)this->_runtime->loadModule_(this->_context->firstArgument()->asHeapObject());
}

Object* Evaluator::primitiveNew() {
    return (Object*)this->_runtime->newSlotsOf_(this->_context->self()->asHeapObject());
}

Object* Evaluator::primitiveNewBytes() {
    auto size = this->_context->firstArgument()->asSmallInteger()->asNative();
    return (Object*)this->_runtime->newBytesOf_sized_(this->_context->self()->asHeapObject(), size);
}

Object* Evaluator::primitiveNewSized() {
    auto size = this->_context->firstArgument()->asSmallInteger()->asNative();
    return (Object*)this->_runtime->newOf_sized_(this->_context->self()->asHeapObject(), size);
}

Object* Evaluator::primitivePerformWithArguments() {
    this->evaluatePerform_in_withArgs_(
        this->_context->firstArgument()->asHeapObject(),
        this->_context->self(),
        this->_context->secondArgument());
    return this->_context->self();
}

Object* Evaluator::primitivePrimeFor() {
    return this->primitivePrimeFor_(this->_context->firstArgument()->asSmallInteger()->asNative());
}

Object* Evaluator::primitivePrimeFor_(auto anInteger) {
    int primes[] = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 269, 359, 479, 641, 857, 1151, 1549, 2069, 2237, 2423, 2617, 2797, 2999, 3167, 3359, 3539, 3727, 3911, 4441, 4787, 5119, 5471, 5801, 6143, 6521, 6827, 7177, 7517, 7853, 8783, 9601, 10243, 10867, 11549, 12239, 12919, 13679, 14293, 15013, 15731, 17569, 19051, 20443, 21767, 23159, 24611, 25847, 27397, 28571, 30047, 31397, 35771, 38201, 40841, 43973, 46633, 48989, 51631, 54371, 57349, 60139, 62969};

    for (int i = 0; i < sizeof(primes); i++) {
        auto prime = primes[i];
        if (prime >= anInteger)
            return newIntObject(prime);
    }
    return (Object*)this->_runtime->_nilObj;
}

Object* Evaluator::primitiveSMIBitAnd() {
    return newIntObject((this->_context->self()->asSmallInteger()->asNative() & this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMIBitOr() {
    return newIntObject((this->_context->self()->asSmallInteger()->asNative() | this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMIBitShift() {
    auto self = this->_context->self()->asSmallInteger()->asNative();
    auto firstArg = this->_context->firstArgument()->asSmallInteger()->asNative();
    auto shifted = firstArg > 0 ? self << firstArg : self >> firstArg;
    return newIntObject(shifted);
}

Object* Evaluator::primitiveSMIBitXor() {
    return newIntObject(this->_context->self()->asSmallInteger()->asNative() ^ (this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMIEqual() {
    return boolObject(this->_context->self()->asSmallInteger()->asNative() == (this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMIGreaterEqualThan() {
    return boolObject(this->_context->self()->asSmallInteger()->asNative() >= (this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMIGreaterThan() {
    return boolObject(this->_context->self()->asSmallInteger()->asNative() > (this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMIHighBit() {
    auto number = this->_context->self()->asSmallInteger()->asNative();
    int highbit = number == 0 ? 0 : static_cast<int>(log2(number)) + 1;

    return newIntObject(highbit);
}

Object* Evaluator::primitiveSMIIntDiv() {
    return newIntObject(this->_context->self()->asSmallInteger()->asNative() / (this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMIIntQuot() {
    return newIntObject(this->_context->self()->asSmallInteger()->asNative() % (this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMIMinus() {
    return newIntObject((this->_context->self()->asSmallInteger()->asNative() - this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMINotEqual() {
    return boolObject(this->_context->self()->asSmallInteger()->asNative() != (this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMIPlus() {
    return newIntObject((this->_context->self()->asSmallInteger()->asNative() + this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMISize() {
    auto number = this->_context->self()->asSmallInteger()->asNative();

    auto size = number < 0 ? 1 : (static_cast<int>(log2(number)) >> 3) + 1;
    
    return newIntObject(size);
}

Object* Evaluator::primitiveSMITimes() {
    return newIntObject((this->_context->self()->asSmallInteger()->asNative() * this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSetBehavior() {
    auto receiver = this->_context->self()->asHeapObject();
    receiver->behavior(this->_context->firstArgument()->asHeapObject());
    return this->_context->self();
}

Object* Evaluator::primitiveSize() {
    return newIntObject(this->_runtime->arrayedSizeOf_(this->_context->self()));
}

Object* Evaluator::primitiveStringReplaceFromToWithStartingAt() {
    auto receiver = this->_context->self();
    receiver->asHeapObject()->replaceBytesFrom_to_with_startingAt_(
        this->_context->firstArgument()->asSmallInteger()->asNative(),
        this->_context->secondArgument()->asSmallInteger()->asNative(),
        this->_context->thirdArgument()->asHeapObject(),
        this->_context->fourthArgument()->asSmallInteger()->asNative());
    return receiver;
}

Object* Evaluator::primitiveUnderHash() {
    return newIntObject(this->_context->self()->asHeapObject()->hash());
}

Object* Evaluator::primitiveUnderIsBytes() {
    return boolObject(this->_context->self()->asHeapObject()->isBytes());
}

Object* Evaluator::primitiveUnderPointersSize() {
    return newIntObject(this->_context->self()->asHeapObject()->pointersSize());
}

Object* Evaluator::primitiveUnderSize() {
    return newIntObject(this->_context->self()->asHeapObject()->size());
}

Object* Evaluator::underprimitiveBasicAt(Object *receiver, std::vector<Object*> &args) {
    return receiver->asHeapObject()->slotAt_(args[0]->asSmallInteger()->asNative());
}

Object* Evaluator::underprimitiveBasicAtPut(Object *receiver, std::vector<Object*> &args) {
    receiver->asHeapObject()->slotAt_(args[0]->asSmallInteger()->asNative()) = args[1];
    return args[1];
}

Object* Evaluator::underprimitiveBasicFlags(Object *receiver, std::vector<Object*> &args) {
    return newIntObject(receiver->asHeapObject()->flags());
}

Object* Evaluator::underprimitiveBasicHash(Object *receiver, std::vector<Object*> &args) {
    return newIntObject(receiver->asHeapObject()->hash());
}

Object* Evaluator::underprimitiveBasicHashPut(Object *receiver, std::vector<Object*> &args) {
    receiver->asHeapObject()->hash(args[0]->asSmallInteger()->asNative());
    return this->_context->self();
}

Object* Evaluator::underprimitiveBitShiftLeft(Object *receiver, std::vector<Object*> &args) {
    auto result = receiver->asSmallInteger()->asNative() << args[0]->asSmallInteger()->asNative();
    return newIntObject(result);
}

Object* Evaluator::underprimitiveByteAt(Object *receiver, std::vector<Object*> &args) {
    auto result = receiver->asHeapObject()->byteAt_(args[0]->asSmallInteger()->asNative());
    return newIntObject(result);
}

Object* Evaluator::underprimitiveByteAtPut(Object *receiver, std::vector<Object*> &args) {
    receiver->asHeapObject()->byteAt_(args[0]->asSmallInteger()->asNative()) = args[1]->asSmallInteger()->asNative();
    return args[1];
}

Object* Evaluator::underprimitiveHalt(Object *receiver, std::vector<Object*> &args) {
    this->_halt();
    return receiver;
}

Object* Evaluator::underprimitiveIdentityEquals(Object *receiver, std::vector<Object*> &args) {
    return boolObject(receiver == args[0]);
}

Object* Evaluator::underprimitiveIsLarge(Object *receiver, std::vector<Object*> &args) {
    return boolObject(!receiver->asHeapObject()->isSmall());
}

Object* Evaluator::underprimitiveIsSmallInteger(Object *receiver, std::vector<Object*> &args) {
    return boolObject(receiver->isSmallInteger());
}

Object* Evaluator::underprimitiveLargeSize(Object *receiver, std::vector<Object*> &args) {
    if (receiver->asHeapObject()->isSmall())
        error("underprimitiveLargeSize: receiver must be large");
    return newIntObject(receiver->asHeapObject()->size());
}

Object* Evaluator::underprimitiveLeadingZeroBitCount(Object *receiver, std::vector<Object*> &args) {
    return newIntObject(this->underprimitiveLeadingZeroBitCount_(receiver->asSmallInteger()->asNative()));
}

intptr_t Evaluator::underprimitiveLeadingZeroBitCount_(uintptr_t anInteger) {

    return anInteger < 0 ? 0 : ( std::countl_zero(anInteger));
}

Object* Evaluator::underprimitiveSMIBitAnd(Object *receiver, std::vector<Object*> &args) {
    return newIntObject((receiver->asSmallInteger()->asNative() & args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMIBitOr(Object *receiver, std::vector<Object*> &args) {
    return newIntObject((receiver->asSmallInteger()->asNative() | args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMIBitShiftLeft(Object *receiver, std::vector<Object*> &args) {
    return newIntObject((receiver->asSmallInteger()->asNative() << args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMIBitShiftRight(Object *receiver, std::vector<Object*> &args) {
    return newIntObject((receiver->asSmallInteger()->asNative() >> args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMIEquals(Object *receiver, std::vector<Object*> &args) {
    return boolObject(receiver->asSmallInteger()->asNative() == args[0]->asSmallInteger()->asNative());
}

Object* Evaluator::underprimitiveSMIGreaterEqualThan(Object *receiver, std::vector<Object*> &args) {
    return boolObject(receiver->asSmallInteger()->asNative() >= (args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMIGreaterThan(Object *receiver, std::vector<Object*> &args) {
    return boolObject(receiver->asSmallInteger()->asNative() > (args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMILowerEqualThan(Object *receiver, std::vector<Object*> &args) {
    return boolObject(receiver->asSmallInteger()->asNative() <= (args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMILowerThan(Object *receiver, std::vector<Object*> &args) {
    return boolObject(receiver->asSmallInteger()->asNative() < (args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMIMinus(Object *receiver, std::vector<Object*> &args) {
    return newIntObject((receiver->asSmallInteger()->asNative() - args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMIPlus(Object *receiver, std::vector<Object*> &args) {
    return newIntObject((receiver->asSmallInteger()->asNative() + args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMIQuotientTowardZero(Object *receiver, std::vector<Object*> &args) {
    return newIntObject(receiver->asSmallInteger()->asNative() / (args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMIRemainderTowardZero(Object *receiver, std::vector<Object*> &args) {
    return newIntObject(receiver->asSmallInteger()->asNative() % (args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMITimes(Object *receiver, std::vector<Object*> &args) {
    return newIntObject((receiver->asSmallInteger()->asNative() * args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSmallIntegerByteAt(Object *receiver, std::vector<Object*> &args) {
    auto integer = receiver->asSmallInteger()->asNative();
    auto offset = args[0]->asSmallInteger()->asNative() - 1;
    auto result = integer > 7 ? 0 : reinterpret_cast<uint8_t*>(&integer)[offset];
    return newIntObject(result);
}

Object* Evaluator::underprimitiveSmallSize(Object *receiver, std::vector<Object*> &args) {
    if (!receiver->asHeapObject()->isSmall()) {
        error("underprimitiveSmallSize: object must be small");
    }
    return newIntObject(receiver->asHeapObject()->size());
}

Object* Evaluator::underprimitiveULongAtOffset(Object *receiver, std::vector<Object*> &args) {
    auto result = receiver->asHeapObject()->unsignedLongAt_((args[1]->asSmallInteger()->asNative()+1));
    return newIntObject(result);
}

Object* Evaluator::underprimitiveULongAtOffsetPut(Object *receiver, std::vector<Object*> &args) {
    auto value = args[1];
    receiver->asHeapObject()->unsignedLongAt_((args[0]->asSmallInteger()->asNative()+1)) = value->asSmallInteger()->asNative();
    return value;
}

Object* Evaluator::underprimitiveUShortAtOffset(Object *receiver, std::vector<Object*> &args) {
    auto result = receiver->asHeapObject()->unsignedShortAt_((args[1]->asSmallInteger()->asNative()+1));
    return newIntObject(result);
}

Object* Evaluator::underprimitiveUShortAtOffsetPut(Object *receiver, std::vector<Object*> &args) {
    auto value = args[1];
    receiver->asHeapObject()->unsignedShortAt_((args[0]->asSmallInteger()->asNative()+1)) = value->asSmallInteger()->asNative();
    return value;
}
