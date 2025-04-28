
#include "Evaluator.h"
#include "Runtime.h"
#include "Allocator/GCSafepoint.h"
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
#include "SOpStoreRintoFrame.h"
#include "SOpNonLocalReturn.h"
#include "SOpPopR.h"
#include "SOpPrimitive.h"
#include "SOpPushR.h"
#include "SOpReturn.h"

#include "TreecodeDecoder.h"

#include "FFIGlue.h"

#include <chrono>
#include <cmath>
#include <bit>
#include <cstring>

using namespace Egg;

// as libffi cannot directly call C++ lambdas, here is a plain C wrapper
extern "C" void closureCallbackWrapper(ffi_cif* cif, void* ret, void** args, void* userData) {
    auto lambda = *reinterpret_cast<std::function<void(void*, int, void**)>*>(userData);
    lambda(ret, cif->nargs, args);
}

Evaluator::Evaluator(Runtime *runtime, HeapObject *falseObj, HeapObject *trueObj, HeapObject *nilObj) : 
        _runtime(runtime),
        _nilObj(nilObj),
        _trueObj(trueObj),
        _falseObj(falseObj)
    {
        _linearizer = new SExpressionLinearizer();
        _linearizer->runtime_(_runtime);
        _context = new EvaluationContext(runtime);
        this->initializeUndermessages();
        this->initializePrimitives();
        debugRuntime = _runtime;
    }


void Evaluator::_halt()
{
	error("_halt encountered");
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

void Evaluator::initializeUndermessages() {
    this->addUndermessage("_isSmallInteger", &Evaluator::underprimitiveIsSmallInteger);
    this->addUndermessage("_isLarge", &Evaluator::underprimitiveIsLarge);
    this->addUndermessage("_smallSize", &Evaluator::underprimitiveSmallSize);
    this->addUndermessage("_largeSize", &Evaluator::underprimitiveLargeSize);
    this->addUndermessage("_basicFlags", &Evaluator::underprimitiveBasicFlags);
    this->addUndermessage("_basicAt:", &Evaluator::underprimitiveBasicAt);
    this->addUndermessage("_basicAt:put:", &Evaluator::underprimitiveBasicAtPut);
    this->addUndermessage("_byteAt:", &Evaluator::underprimitiveByteAt);
    this->addUndermessage("_byteAt:put:", &Evaluator::underprimitiveByteAtPut);
    this->addUndermessage("_basicHash", &Evaluator::underprimitiveBasicHash);
    this->addUndermessage("_basicHash:", &Evaluator::underprimitiveBasicHashPut);
    this->addUndermessage("_smallIntegerByteAt:", &Evaluator::underprimitiveSmallIntegerByteAt);
    this->addUndermessage("_bitShiftLeft:", &Evaluator::underprimitiveBitShiftLeft);
    this->addUndermessage("_uLargeAtOffset:", &Evaluator::underprimitiveULargeAtOffset);
    this->addUndermessage("_uLargeAtOffset:put:", &Evaluator::underprimitiveULargeAtOffsetPut);
    this->addUndermessage("_primitiveULongAtOffset:", &Evaluator::underprimitiveULongAtOffset);
    this->addUndermessage("_primitiveULongAtOffset:put:", &Evaluator::underprimitiveULongAtOffsetPut);
    this->addUndermessage("_uShortAtOffset:", &Evaluator::underprimitiveUShortAtOffset);
    this->addUndermessage("_uShortAtOffset:put:", &Evaluator::underprimitiveUShortAtOffsetPut);
    this->addUndermessage("_smiPlus:", &Evaluator::underprimitiveSMIPlus);
    this->addUndermessage("_smiMinus:", &Evaluator::underprimitiveSMIMinus);
    this->addUndermessage("_smiTimes:", &Evaluator::underprimitiveSMITimes);
    this->addUndermessage("_smiLowerThan:", &Evaluator::underprimitiveSMILowerThan);
    this->addUndermessage("_smiLowerEqualThan:", &Evaluator::underprimitiveSMILowerEqualThan);
    this->addUndermessage("_smiGreaterThan:", &Evaluator::underprimitiveSMIGreaterThan);
    this->addUndermessage("_smiGreaterEqualThan:", &Evaluator::underprimitiveSMIGreaterEqualThan);
    this->addUndermessage("_smiEquals:", &Evaluator::underprimitiveSMIEquals);
    this->addUndermessage("_identityEquals:", &Evaluator::underprimitiveIdentityEquals);
    this->addUndermessage("_leadingZeroBitCount", &Evaluator::underprimitiveLeadingZeroBitCount);
    this->addUndermessage("_quotientTowardZero:", &Evaluator::underprimitiveSMIQuotientTowardZero);
    this->addUndermessage("_remainderTowardZero:", &Evaluator::underprimitiveSMIRemainderTowardZero);
    this->addUndermessage("_bitShiftLeft:", &Evaluator::underprimitiveSMIBitShiftLeft);
    this->addUndermessage("_bitShiftRight:", &Evaluator::underprimitiveSMIBitShiftRight);
    this->addUndermessage("_smiBitAnd:", &Evaluator::underprimitiveSMIBitAnd);
    this->addUndermessage("_smiBitOr:", &Evaluator::underprimitiveSMIBitOr);
    this->addUndermessage("_halt", &Evaluator::underprimitiveHalt);
}


void Evaluator::initializePrimitives()
{
    this->addPrimitive("Behavior", &Evaluator::primitiveBehavior);
    this->addPrimitive("SetBehavior", &Evaluator::primitiveSetBehavior);
    this->addPrimitive("Class", &Evaluator::primitiveClass);
    this->addPrimitive("UnderBeSpecial", &Evaluator::primitiveUnderBeSpecial);
    this->addPrimitive("UnderHash", &Evaluator::primitiveUnderHash);
    this->addPrimitive("UnderIsBytes", &Evaluator::primitiveUnderIsBytes);
    this->addPrimitive("UnderPointersSize", &Evaluator::primitiveUnderPointersSize);
    this->addPrimitive("UnderSize", &Evaluator::primitiveUnderSize);
    this->addPrimitive("Size", &Evaluator::primitiveSize);
    this->addPrimitive("Hash", &Evaluator::primitiveHash);
    this->addPrimitive("At", &Evaluator::primitiveAt);
    this->addPrimitive("AtPut", &Evaluator::primitiveAtPut);
    this->addPrimitive("New", &Evaluator::primitiveNew);
    this->addPrimitive("NewSized", &Evaluator::primitiveNewSized);
    this->addPrimitive("NewBytes", &Evaluator::primitiveNewBytes);
    this->addPrimitive("Equal", &Evaluator::primitiveEqual);
    this->addPrimitive("SMIPlus", &Evaluator::primitiveSMIPlus);
    this->addPrimitive("SMIMinus", &Evaluator::primitiveSMIMinus);
    this->addPrimitive("SMITimes", &Evaluator::primitiveSMITimes);
    this->addPrimitive("SMIIntDiv", &Evaluator::primitiveSMIIntDiv);
    this->addPrimitive("SMIIntQuot", &Evaluator::primitiveSMIIntQuot);
    this->addPrimitive("SMIBitAnd", &Evaluator::primitiveSMIBitAnd);
    this->addPrimitive("SMIBitOr", &Evaluator::primitiveSMIBitOr);
    this->addPrimitive("SMIBitXor", &Evaluator::primitiveSMIBitXor);
    this->addPrimitive("SMIBitShift", &Evaluator::primitiveSMIBitShift);
    this->addPrimitive("SMIHighBit", &Evaluator::primitiveSMIHighBit);
    this->addPrimitive("SMIGreaterThan", &Evaluator::primitiveSMIGreaterThan);
    this->addPrimitive("SMIGreaterEqualThan", &Evaluator::primitiveSMIGreaterEqualThan);
    this->addPrimitive("SMIEqual", &Evaluator::primitiveSMIEqual);
    this->addPrimitive("SMINotEqual", &Evaluator::primitiveSMINotEqual);
    this->addPrimitive("SMISize", &Evaluator::primitiveSMISize);
    this->addPrimitive("ClosureValue", &Evaluator::primitiveClosureValue);
    this->addPrimitive("ClosureValueWithArgs", &Evaluator::primitiveClosureValueWithArgs);
    this->addPrimitive("ClosureArgumentCount", &Evaluator::primitiveClosureArgumentCount);
    this->addPrimitive("ClosureAsCallback", &Evaluator::primitiveClosureAsCallback);
    this->addPrimitive("PerformWithArguments", &Evaluator::primitivePerformWithArguments);
    this->addPrimitive("StringReplaceFromToWithStartingAt", &Evaluator::primitiveStringReplaceFromToWithStartingAt);
    this->addPrimitive("FloatNew", &Evaluator::primitiveFloatNew);
    this->addPrimitive("FlushDispatchCaches", &Evaluator::primitiveFlushDispatchCaches);
    //this->addPrimitive("BootstrapDictBeConstant", &Evaluator::primitiveBootstrapDictBeConstant);
    //this->addPrimitive("BootstrapDictKeys", &Evaluator::primitiveBootstrapDictKeys);
    //this->addPrimitive("BootstrapDictNew", &Evaluator::primitiveBootstrapDictNew);
    //this->addPrimitive("BootstrapDictAt", &Evaluator::primitiveBootstrapDictAt);
    //this->addPrimitive("BootstrapDictAtPut", &Evaluator::primitiveBootstrapDictAtPut);
    //this->addPrimitive("HostSuspendedBecause", &Evaluator::primitiveHostSuspendedBecause);
    this->addPrimitive("HostLoadModule", &Evaluator::primitiveHostLoadModule);
    //this->addPrimitive("HostFixOverrides", &Evaluator::primitiveHostFixOverrides);
    this->addPrimitive("PrimeFor", &Evaluator::primitivePrimeFor);
    this->addPrimitive("FlushFromCaches", &Evaluator::primitiveFlushFromCaches);
    this->addPrimitive("FFICall", &Evaluator::primitiveFFICall);
    this->addPrimitive("HostInitializeFFI", &Evaluator::primitiveHostInitializeFFI);
    this->addPrimitive("HostPlatformName", &Evaluator::primitiveHostPlatformName);
    this->addPrimitive("HostCurrentMilliseconds", &Evaluator::primitiveHostCurrentMilliseconds);
    this->addPrimitive("HostLog", &Evaluator::primitiveHostLog);

    /*this->addPrimitive("PrepareForExecution", &Evaluator::primitivePrepareForExecution);
    this->addPrimitive("ProcessVMStackInitialize", &Evaluator::primitiveProcessVMStackInitialize);
    this->addPrimitive("ProcessVMStackAt", &Evaluator::primitiveProcessVMStackAt);
    this->addPrimitive("ProcessVMStackAtPut", &Evaluator::primitiveProcessVMStackAtPut);
    this->addPrimitive("ProcessVMStackBpAtPut", &Evaluator::primitiveProcessVMStackBpAtPut);
    this->addPrimitive("ProcessVMStackPcAtPut", &Evaluator::primitiveProcessVMStackPcAtPut);
    this->addPrimitive("ProcessVMStackBP", &Evaluator::primitiveProcessVMStackBP);
    this->addPrimitive("ProcessVMStackBufferSize", &Evaluator::primitiveProcessVMStackBufferSize);
    this->addPrimitive("ProcessVMStackContextSwitchTo", &Evaluator::primitiveProcessVMStackContextSwitchTo);
    */
    _linearizer->primitives_(_primitives);
}

void Evaluator::evaluatePerform_in_withArgs_(HeapObject *aSymbol, Object *receiver, Object *arguments) {
    HeapObject *behavior = this->_runtime->behaviorOf_(receiver);
    if (aSymbol->printString() == "#asBehavior") {
        int a = 0;
    }
    HeapObject *method = this->_runtime->lookup_startingAt_(aSymbol, behavior);
    if (!method)
        error_(std::string("cannot perform ") + aSymbol->printString() + " on " + receiver->printString());
    auto heapargs = arguments->asHeapObject();
    for (int i = 1; i <= heapargs->size(); i++) {
        this->_context->pushOperand_(heapargs->slotAt_(i));
    }
    this->invoke_with_(method, receiver);
}

HeapObject*
Evaluator::lookup_startingAt_sendSite_(HeapObject *symbol, HeapObject *behavior, SAbstractMessage *message)
{
	auto method = _runtime->lookup_startingAt_(symbol, behavior);
	if (!method) return nullptr;

    message->registerCacheWith_(_runtime);
    message->cache_when_(method, behavior);
    
    return method;
}

Object *Evaluator::invoke_with_(HeapObject *method, Object *receiver) {
    int size = _runtime->methodEnvironmentSize_(method);

    HeapObject *environment = _runtime->methodNeedsEnviornment_(method) ? _runtime->newEnvironmentSized_(size) : _runtime-> _nilObj;
    HeapObject *executable = this->prepareForExecution_(method);
    _work = _runtime->executableCodeWork_(executable);

    this->_context->buildMethodFrameFor_code_environment_(receiver, method,
                                                          environment);

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

    this->_linearizer->visitMethod(sexpressions, method);
    executableCode = this->_runtime->newExecutableCodeFor_with_(method, this->_linearizer->operations());
    this->_runtime->methodExecutableCode_put_(method, executableCode);

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
    auto bytecodes = this->_context->buildLaunchFrame(symbol, args.size());
    auto prevRegE = this->_context->environment();
    this->_regR = receiver;
    if (!args.empty())
        this->_context->pushOperand_(receiver);
    
    for (auto arg : args) {
        this->_context->pushOperand_(arg);
    }
    this->_work = bytecodes;
    this->_context->regPC_(0);
    this->evaluate();
    this->_context->popLaunchFrame(prevRegE);
    auto executableCode = this->_runtime->methodExecutableCode_(this->_context->method());
    this->_work = _runtime->executableCodeWork_(executableCode);
    return this->_regR;
}

void Egg::Evaluator::messageNotUnderstood_(SAbstractMessage *message)
{
    std::string errmsg = std::string("Message not understood!\n") +
        this->_regR->printString() + " does not understand " + message->selector()->printString() +
        "\ndnu recovery not implemented yet";
    
    error_(errmsg);
}

void Evaluator::doesNotKnow(HeapObject *symbol) { ASSERT(false); }

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

    //std::cout << "dispatching " << message->selector()->asLocalString() << std::endl;
    
    UndermessagePointer undermessage = message->cachedUndermessage();
    if (undermessage != nullptr) {
        return this->evaluateUndermessage_with_(message, undermessage);
    }

	auto behavior =
        message->receiver()->isSuper() ? 
            _runtime->superBehaviorOf_(_context->classBinding()) :
		    _runtime->behaviorOf_(_regR);

    auto method = message->methodFor_(behavior);
	if (method)
    {
        this->invoke_with_(method, _regR);
        return;
    }
	
    auto symbol = message->selector();
    auto it = _undermessages.find(symbol);
    if (it != _undermessages.end())
    {
        UndermessagePointer undermessage = it->second;
        message->cacheUndermessage_(undermessage);
        return this->evaluateUndermessage_with_(message, undermessage);
		return;
    }

    method = this->lookup_startingAt_sendSite_(symbol, behavior, message);

	if (!method)
        return messageNotUnderstood_(message);

	this->invoke_with_(method, _regR);
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

void Evaluator::visitOpStoreRintoFrame(SOpStoreRintoFrame *anSOpStoreRintoFrame) {
    _context->stackTemporaryAt_put_(anSOpStoreRintoFrame->index(), _regR);
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

    _runtime->_heap->collectIfTime();
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

    return _work->at(pc - 1);
}
Object* Evaluator::newDoubleObject(double aDouble){
    return (Object*)this->_runtime->newDouble_(aDouble);
}

Object* Evaluator::newIntObject(auto anInteger){
    return (Object*)this->_runtime->newInteger_(anInteger);
}

Object* Evaluator::boolObject(bool aBoolean){
    return (Object*)this->_runtime->booleanFor_(aBoolean);
}

Object* Evaluator::failPrimitive()
{
    // failing a primitive implies skipping the return just after the primop bytecode
    // after that return comes the normal Smalltalk failure code of the method
    this->_context->incRegPC();
    return this->_regR;
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
    return heapreceiver->isBytes() ? newIntObject(heapreceiver->byteAt_(index_int)) : _runtime->indexedSlotAt_(heapreceiver, index_int);
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

    Object* value = this->_context->secondArgument();
    if (heapreceiver->isBytes()) {
        auto native = value->asSmallInteger()->asNative();
        ASSERT(native < 256 && native >= -128);
        heapreceiver->byteAt_(index_int) = native;
    }
    else {
        _runtime->indexedSlotAt_(heapreceiver, index_int) = value;
    }
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

void Evaluator::evaluateCallback_(void *ret, HeapObject *closure, int argc, void *args[])
{
    std::vector<Object*> arguments;

    for (size_t i = 0; i < argc; ++i) {
        uintptr_t arg = *reinterpret_cast<uintptr_t*>(args[i]);
        //arguments.push_back((Object*)this->_runtime->newInteger_(arg));
        this->_context->push_((Object*)this->_runtime->newInteger_(arg));
    }

    // push args here or fix evaluateClosure_withArgs_
    //for (int i = 0; i < arguments.size(); i++)
    //    this->_context->push_(arguments[i]);

    //this->evaluateClosure_withArgs_(closure, arguments);
    auto prevPC = this->_context->regPC();
    {
        auto block = _runtime->closureBlock_(closure);
        auto code = this->prepareBlockExecutableCode_(block);
        _work = _runtime->executableCodeWork_(code);

        auto receiver = _runtime->blockCapturesSelf_(block) ? closure->slotAt_(_runtime->_closureInstSize + 1) : (Object*)_nilObj;

        this->_context->regPC_(_work->size());
        _context->buildClosureFrameFor_code_environment_(receiver, block, closure);
    }
    this->evaluate();
    this->_context->regPC_(prevPC);
    for (size_t i = 0; i < argc; ++i) {
        this->_context->pop();
    }
    *reinterpret_cast<uintptr_t*>(ret) = this->_regR->asSmallInteger()->asNative();
}

Object* Evaluator::primitiveClosureAsCallback() {
    auto block = _runtime->closureBlock_(this->_context->self()->asHeapObject());
    auto count = _runtime->blockArgumentCount_(block);


    ffi_cif* cif = new ffi_cif();
    void* code_location = nullptr;
    ffi_closure* closure = reinterpret_cast<ffi_closure*>(ffi_closure_alloc(sizeof(ffi_closure), &code_location));

    ffi_type** argTypes = new ffi_type*[count];
    for (int i = 0; i < count; ++i) {
        argTypes[i] = &ffi_type_pointer; // for now we only support pointer args and ret-type
    }

    if (ffi_prep_cif(cif, FFI_DEFAULT_ABI, count, &ffi_type_pointer, argTypes) != FFI_OK) {
        delete cif;
        delete[] argTypes;
        ffi_closure_free(closure);
        return (Object*)_runtime->_nilObj;
    }

    auto self = this->_context->self()->asHeapObject();
    auto lambda = new std::function(
        [self, this](void *ret, int argc, void *args[]) {
            this->evaluateCallback_(ret, self, argc, args);
        }
    );

    // Bind the closure
    if (ffi_prep_closure_loc(closure, cif, closureCallbackWrapper, (void*)lambda, code_location) != FFI_OK) {
        delete cif;
        delete[] argTypes;
        ffi_closure_free(closure);
        delete lambda;
        return (Object*)_runtime->_nilObj;
    }

    return (Object*)this->_runtime->newInteger_(reinterpret_cast<intptr_t>(code_location));
}

Object* Evaluator::primitiveClosureValue() {
    this->evaluateClosure_(this->_context->self()->asHeapObject());
    return this->_context->self();
}

Object* Evaluator::primitiveClosureValueWithArgs() {
    this->evaluateClosure_withArgs_(this->_context->self()->asHeapObject(), this->_context->methodArguments());
    return this->_context->self();
}

Object* Evaluator::primitiveEqual() {
    return boolObject(this->_context->self() == this->_context->firstArgument());
}

Object* Evaluator::primitiveFloatNew() {
    return (Object*)this->_runtime->newBytes_size_(this->_context->self()->asHeapObject(), 8);
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

Object * Evaluator::primitiveHostCurrentMilliseconds() {
    intptr_t now = std::chrono::duration_cast< std::chrono::milliseconds >(
            std::chrono::system_clock::now().time_since_epoch()).count();
    return newIntObject((intptr_t)now);
}

Object* Evaluator::primitiveHostPlatformName() {
    return (Object*)this->_runtime->newString_(PlatformName());
}

Object* Evaluator::primitiveHostLog() {
    auto arg = this->_context->firstArgument();
    auto code = this->_context->secondArgument()->asSmallInteger()->asNative();

    std::string message;
    if (arg->isSmallInteger())
        message = arg->printString();
    else
    {
        auto harg = arg->asHeapObject();
        auto species = _runtime->behaviorClass_(harg->behavior());
        if (species == _runtime->_stringClass)
            message = harg->asLocalString();
        else
            message = harg->printString();
    }

    _runtime->log_code_(message, code);
    return this->_regR;
}

Object* Evaluator::primitiveHostInitializeFFI() {
    auto library = this->_context->firstArgument()->asHeapObject();
    auto handle = library->slotAt_(1);
    *((uintptr_t*)handle) = LoaderHandle();

    auto symbolFinder = this->_context->secondArgument()->asHeapObject();

    auto ffiMethodClass = this->_runtime->speciesOf_((Object*)symbolFinder);
    this->_runtime->_ffiMethodClass = ffiMethodClass;

    return (Object*)this->_context->self();
}
Object* Evaluator::primitiveHostLoadModule() {
    auto name = this->_context->firstArgument()->asHeapObject()->asLocalString();
    std::cout << "loading " << name << "..." << std::endl;
    auto module = (Object*)this->_runtime->loadModule_(this->_context->firstArgument()->asHeapObject());
    std::cout << " done loading " << name << std::endl;
    return module;
}

Object* Evaluator::primitiveNew() {
    GCSafepoint safepoint(this->_runtime->_heap);
    return (Object*)this->_runtime->newSlotsOf_(this->_context->self()->asHeapObject());
}

Object* Evaluator::primitiveNewBytes() {
    GCSafepoint safepoint(this->_runtime->_heap);
    auto size = this->_context->firstArgument()->asSmallInteger()->asNative();
    return (Object*)this->_runtime->newBytes_size_(this->_context->self()->asHeapObject(), size);
}

Object* Evaluator::primitiveNewSized() {
    GCSafepoint safepoint(this->_runtime->_heap);
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
    auto shifted = firstArg > 0 ? self << firstArg : self >> -firstArg;
    return newIntObject(shifted);
}

Object* Evaluator::primitiveSMIBitXor() {
    return newIntObject(this->_context->self()->asSmallInteger()->asNative() ^ (this->_context->firstArgument()->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMIEqual() {
    auto arg = this->_context->firstArgument();
    return arg->isSmallInteger() ?
        boolObject(this->_context->self()->asSmallInteger()->asNative() == (arg->asSmallInteger()->asNative())) :
        this->failPrimitive();
}

Object* Evaluator::primitiveSMIGreaterEqualThan() {
    auto arg = this->_context->firstArgument();
    return arg->isSmallInteger() ?
        boolObject(this->_context->self()->asSmallInteger()->asNative() >= (arg->asSmallInteger()->asNative())) :
        this->failPrimitive();
}

Object* Evaluator::primitiveSMIGreaterThan() {
    auto arg = this->_context->firstArgument();
    return arg->isSmallInteger() ?
        boolObject(this->_context->self()->asSmallInteger()->asNative() > (arg->asSmallInteger()->asNative())) :
        this->failPrimitive();
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
    auto arg = this->_context->firstArgument();
    return arg->isSmallInteger() ?
        boolObject(this->_context->self()->asSmallInteger()->asNative() != (arg->asSmallInteger()->asNative())) :
        this->failPrimitive();
}

Object* Evaluator::primitiveSMIPlus() {
    auto arg = this->_context->firstArgument();
    return arg->isSmallInteger() ?
        newIntObject((this->_context->self()->asSmallInteger()->asNative() + this->_context->firstArgument()->asSmallInteger()->asNative())) :
        this->failPrimitive();
}

Object* Evaluator::primitiveSMISize() {
    auto number = this->_context->self()->asSmallInteger()->asNative();

    auto size = number < 0 ? 1 : (static_cast<int>(log2(number)) >> 3) + 1;
    
    return newIntObject(size);
}

Object* Evaluator::primitiveSMITimes() {
    auto arg = this->_context->firstArgument();
    return arg->isSmallInteger() ?
        newIntObject((this->_context->self()->asSmallInteger()->asNative() * arg->asSmallInteger()->asNative())) :
        this->failPrimitive();
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

Object* Evaluator::primitiveUnderBeSpecial() {
    auto receiver = this->_context->self();
    if (!receiver->isSmallInteger())
        receiver->asHeapObject()->beSpecial();

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

void Evaluator::initializeCIF(HeapObject *method, int argCount) {

    HeapObject *dll = this->_context->receiver()->asHeapObject();
    Object *handle = dll->slotAt_(1); // the handle
    if (handle->asHeapObject()->untypedSlot(0) == nullptr) {
        error_("trying to execute FFI method " + method->printString() + " on closed library");
    }

    HeapObject *fnName = _runtime->ffiMethodSymbol_(method);

    FFIDescriptorImpl *descriptor_impl = new FFIDescriptorImpl;
    descriptor_impl->cif = new ffi_cif();
    descriptor_impl->argTypes = new ffi_type*[argCount + 1];
    descriptor_impl->fnAddr = (void(*)())FindSymbol(*(uintptr_t*)handle, (char*)fnName);;

    HeapObject *descriptor = _runtime->ffiMethodDescriptor_(method);

    // iterate all arguments _and_ return type
    for (int i = 0; i < argCount + 1; i++) {
        uchar type = descriptor->byteAt_(i + 1); // 1-based index
        ffi_type **argType = &descriptor_impl->argTypes[i];
        switch (type) {
            case FFI_void: ASSERT(i == argCount);  *argType = &ffi_type_void; break;
            case FFI_uint8:  *argType = &ffi_type_uint8; break;
            case FFI_sint8:  *argType = &ffi_type_sint8; break;
            case FFI_uint16: *argType = &ffi_type_uint16; break;
            case FFI_sint16: *argType = &ffi_type_sint16; break;
            case FFI_uint32: *argType = &ffi_type_uint32; break;
            case FFI_sint32: *argType = &ffi_type_sint32; break;
            case FFI_uint64: *argType = &ffi_type_uint64; break;
            case FFI_sint64: *argType = &ffi_type_sint64; break;

            case FFI_float:  *argType = &ffi_type_float; break;
            case FFI_double: *argType = &ffi_type_double; break;

            case FFI_uchar:  *argType = &ffi_type_uchar; break;
            case FFI_schar:  *argType = &ffi_type_schar; break;
            case FFI_ushort: *argType = &ffi_type_ushort; break;
            case FFI_sshort: *argType = &ffi_type_sshort; break;
            case FFI_uint:   *argType = &ffi_type_uint; break;
            case FFI_sint:   *argType = &ffi_type_sint; break;
            case FFI_ulong:  *argType = &ffi_type_ulong; break;
            case FFI_slong:  *argType = &ffi_type_slong; break;
            case FFI_longdouble: *argType = &ffi_type_longdouble; break;

            case FFI_pointer: *argType = &ffi_type_pointer; break;

            // case FFI_complex_float:      *argType = &ffi_type_complex_float; break;
            // case FFI_complex_double:     *argType = &ffi_type_complex_double; break;
            // case FFI_complex_longdouble: *argType = &ffi_type_complex_longdouble; break;
            default: error_("wrong descriptor"); break;
        }
    }
    if (ffi_prep_cif(descriptor_impl->cif, FFI_DEFAULT_ABI, argCount, descriptor_impl->argTypes[argCount], descriptor_impl->argTypes) != FFI_OK) {
        error_(std::string("ffi_prep_cif failed for ") + method->printString());
    }

    _runtime->ffiMethodAddress_put_(method, SmallInteger::from((intptr_t)descriptor_impl));

}

Object* Evaluator::demarshalFFIResult(void *retval, uint8_t type) {
    switch (type) {
       case FFI_uint8:  return newIntObject(*reinterpret_cast<uint8_t*>(retval)); break;
       case FFI_sint8:  return newIntObject(*reinterpret_cast<int8_t*>(retval)); break;
       case FFI_uint16: return newIntObject(*reinterpret_cast<uint16_t*>(retval)); break;
       case FFI_sint16: return newIntObject(*reinterpret_cast<int16_t*>(retval)); break;
       case FFI_uint32: return newIntObject(*reinterpret_cast<uint32_t*>(retval)); break;
       case FFI_sint32: return newIntObject(*reinterpret_cast<int32_t*>(retval)); break;
       case FFI_uint64: return newIntObject(*reinterpret_cast<uint64_t*>(retval)); break;
       case FFI_sint64: return newIntObject(*reinterpret_cast<int64_t*>(retval)); break;

       case FFI_float:  return newDoubleObject(*reinterpret_cast<float*>(retval)); break;
       case FFI_double: return newDoubleObject(*reinterpret_cast<double*>(retval)); break;

       case FFI_uchar:  return newIntObject(*reinterpret_cast<uint8_t*>(retval)); break;
       case FFI_schar:  return newIntObject(*reinterpret_cast<int8_t*>(retval)); break;
       case FFI_ushort: return newIntObject(*reinterpret_cast<uint16_t*>(retval)); break;
       case FFI_sshort: return newIntObject(*reinterpret_cast<int16_t*>(retval)); break;
       case FFI_uint:   return newIntObject(*reinterpret_cast<unsigned int*>(retval)); break;
       case FFI_sint:   return newIntObject(*reinterpret_cast<int*>(retval)); break;
       case FFI_ulong:  return newIntObject(*reinterpret_cast<ulong*>(retval)); break;
       case FFI_slong:  return newIntObject(*reinterpret_cast<long*>(retval)); break;

       case FFI_pointer: return newIntObject(*reinterpret_cast<uintptr_t*>(retval)); break;
       case FFI_void: return newIntObject(0); break;
       default: error_("wrong descriptor"); break;
    }
    error_("unreachable");
    return nullptr;
}


Object* Evaluator::primitiveFFICall() {
    HeapObject *method = this->_context->method();
    int argCount = _runtime->methodArgumentCount_(method);
    Object *address = _runtime->ffiMethodAddress_(method);

    if (address == (Object*)_nilObj) {
        initializeCIF(method, argCount);
        address = _runtime->ffiMethodAddress_(method);
    }

    FFIDescriptorImpl *desc = (FFIDescriptorImpl*)address->asSmallInteger()->asNative();

    void **args = (void**)alloca(argCount* sizeof(void*));
    Object **lastArg = this->_context->lastArgumentAddress();

    Object **passedArgs = (Object**)alloca(argCount * sizeof(uintptr_t*));
    memcpy(passedArgs, lastArg, argCount * sizeof(uintptr_t*));

    for (int i = 0; i < argCount; i++)
    {
        Object **argAddress = &passedArgs[argCount - i - 1];

        // the arg passed is either:
        // a. a tagged smi (and has to be converted to a native int), or
        // b. a heap object where its first slot _is_ the native value.
        // Notice that this just works for passing small ints, floats/doubles,
        // addresses, and large integers.
        // Support for passing structures by value greater than pointer size remains
        // to be implemented.
        if (argAddress[0]->isSmallInteger()) {
            argAddress[0] = (Object*)argAddress[0]->asSmallInteger()->asNative();
            args[i] = argAddress;
        } else {
            args[i] = *argAddress;
        }
    }

    HeapObject *descriptor = _runtime->ffiMethodDescriptor_(method);

    void *retval = alloca(desc->argTypes[argCount]->size);
    ffi_call(desc->cif, desc->fnAddr, retval, args);


    uint8_t retType = descriptor->byteAt_(descriptor->size() - 1);
    return this->demarshalFFIResult(retval, retType);
}

Object* Evaluator::underprimitiveBasicAt(Object *receiver, std::vector<Object*> &args) {
    return receiver->asHeapObject()->untypedSlotAt_(args[0]->asSmallInteger()->asNative());
}

Object* Evaluator::underprimitiveBasicAtPut(Object *receiver, std::vector<Object*> &args) {
    receiver->asHeapObject()->untypedSlotAt_(args[0]->asSmallInteger()->asNative()) = args[1];
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
    auto result = receiver->asHeapObject()->unsafeByteAt_(args[0]->asSmallInteger()->asNative());
    return newIntObject(result);
}

Object* Evaluator::underprimitiveByteAtPut(Object *receiver, std::vector<Object*> &args) {
    receiver->asHeapObject()->unsafeByteAt_(args[0]->asSmallInteger()->asNative()) = args[1]->asSmallInteger()->asNative();
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
    auto result = offset > 7 ? 0 : reinterpret_cast<uint8_t*>(&integer)[offset];
    return newIntObject(result);
}

Object* Evaluator::underprimitiveSmallSize(Object *receiver, std::vector<Object*> &args) {
    if (!receiver->asHeapObject()->isSmall()) {
        error("underprimitiveSmallSize: object must be small");
    }
    return newIntObject(receiver->asHeapObject()->size());
}

Object* Evaluator::underprimitiveULargeAtOffset(Object *receiver, std::vector<Object*> &args) {
    auto result = receiver->asHeapObject()->uint64offset((args[0]->asSmallInteger()->asNative()));
    return newIntObject(result);
}

Object* Evaluator::underprimitiveULargeAtOffsetPut(Object *receiver, std::vector<Object*> &args) {
    auto value = args[1];
    receiver->asHeapObject()->uint64offset((args[0]->asSmallInteger()->asNative())) = value->asSmallInteger()->asNative();
    return value;
}

Object* Evaluator::underprimitiveULongAtOffset(Object *receiver, std::vector<Object*> &args) {
    auto result = receiver->asHeapObject()->uint32offset((args[0]->asSmallInteger()->asNative()));
    return newIntObject(result);
}

Object* Evaluator::underprimitiveULongAtOffsetPut(Object *receiver, std::vector<Object*> &args) {
    auto value = args[1];
    receiver->asHeapObject()->uint32offset((args[0]->asSmallInteger()->asNative())) = value->asSmallInteger()->asNative();
    return value;
}

Object* Evaluator::underprimitiveUShortAtOffset(Object *receiver, std::vector<Object*> &args) {
    auto result = receiver->asHeapObject()->uint16offset((args[0]->asSmallInteger()->asNative()));
    return newIntObject(result);
}

Object* Evaluator::underprimitiveUShortAtOffsetPut(Object *receiver, std::vector<Object*> &args) {
    auto value = args[1];
    receiver->asHeapObject()->uint16offset((args[0]->asSmallInteger()->asNative())) = value->asSmallInteger()->asNative();
    return value;
}
