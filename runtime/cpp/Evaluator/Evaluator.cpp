
#include "Evaluator.h"
#include "Runtime.h"
#include "Allocator/GCHeap.h"
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
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>

#include "Compat.h"

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
        debugRuntime = _runtime;
        _linearizer = new SExpressionLinearizer();
        _linearizer->runtime_(_runtime);
        _context = new EvaluationContext(runtime);
        this->initializeUndermessages();
        this->initializePrimitives();
    }


void Evaluator::_halt()
{
	warning("_halt encountered");
}

void Evaluator::addPrimitive(const std::string &name, Evaluator::PrimitivePointer primitive)
{
    Object *symbol = _runtime->existingSymbolFrom_(name);
    _primitives[symbol] = primitive;
}

void Evaluator::addUndermessage(const std::string &name, UndermessagePointer primitive) {
    Object *symbol = _runtime->existingSymbolFrom_(name);
    if (!symbol) {
        // Symbol does not (yet) exist in the kernel symbol table; skip registration
        // to avoid storing the undermessage under a nullptr key, which would later
        // be matched by any send whose selector cannot be resolved.
        return;
    }
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
    this->addUndermessage("_returnTo:", &Evaluator::underprimitiveReturnTo);
    this->addUndermessage("_quotientTowardZero:", &Evaluator::underprimitiveSMIQuotientTowardZero);
    this->addUndermessage("_remainderTowardZero:", &Evaluator::underprimitiveSMIRemainderTowardZero);
    this->addUndermessage("_bitShiftLeft:", &Evaluator::underprimitiveSMIBitShiftLeft);
    this->addUndermessage("_bitShiftRight:", &Evaluator::underprimitiveSMIBitShiftRight);
    this->addUndermessage("_smiBitAnd:", &Evaluator::underprimitiveSMIBitAnd);
    this->addUndermessage("_smiBitOr:", &Evaluator::underprimitiveSMIBitOr);
    this->addUndermessage("_halt", &Evaluator::underprimitiveHalt);
    this->addUndermessage("_error:", &Evaluator::underprimitiveError);
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
    this->addPrimitive("FloatNewFromInteger", &Evaluator::primitiveFloatNewFromInteger);
    this->addPrimitive("FloatPlus", &Evaluator::primitiveFloatPlus);
    this->addPrimitive("FloatMinus", &Evaluator::primitiveFloatMinus);
    this->addPrimitive("FloatMultiply", &Evaluator::primitiveFloatMultiply);
    this->addPrimitive("FloatDiv", &Evaluator::primitiveFloatDiv);
    this->addPrimitive("FloatLess", &Evaluator::primitiveFloatLess);
    this->addPrimitive("FloatEqual", &Evaluator::primitiveFloatEqual);

    this->addPrimitive("FloatFractionPart", &Evaluator::primitiveFloatFractionPart);
    this->addPrimitive("FloatSignificand", &Evaluator::primitiveFloatSignificand);
    this->addPrimitive("FloatSqrt", &Evaluator::primitiveFloatSqrt);
    this->addPrimitive("FloatTimesTwoPower", &Evaluator::primitiveFloatTimesTwoPower);
    this->addPrimitive("FloatTruncated", &Evaluator::primitiveFloatTruncated);

    this->addPrimitive("FlushDispatchCaches", &Evaluator::primitiveFlushDispatchCaches);
    //this->addPrimitive("BootstrapDictBeConstant", &Evaluator::primitiveBootstrapDictBeConstant);
    //this->addPrimitive("BootstrapDictKeys", &Evaluator::primitiveBootstrapDictKeys);
    //this->addPrimitive("BootstrapDictNew", &Evaluator::primitiveBootstrapDictNew);
    //this->addPrimitive("BootstrapDictAt", &Evaluator::primitiveBootstrapDictAt);
    //this->addPrimitive("BootstrapDictAtPut", &Evaluator::primitiveBootstrapDictAtPut);
    //this->addPrimitive("HostSuspendedBecause", &Evaluator::primitiveHostSuspendedBecause);
    this->addPrimitive("HostLoadModule", &Evaluator::primitiveHostLoadModule);
    //this->addPrimitive("HostFixOverrides", &Evaluator::primitiveHostFixOverrides);
    this->addPrimitive("DictionaryNew", &Evaluator::primitiveDictionaryNew);
    this->addPrimitive("PrimeFor", &Evaluator::primitivePrimeFor);
    this->addPrimitive("FlushFromCaches", &Evaluator::primitiveFlushFromCaches);
    this->addPrimitive("FFICall", &Evaluator::primitiveFFICall);
    this->addPrimitive("HostInitializeFFI", &Evaluator::primitiveHostInitializeFFI);
    this->addPrimitive("HostPlatformName", &Evaluator::primitiveHostPlatformName);
    this->addPrimitive("HostCurrentMilliseconds", &Evaluator::primitiveHostCurrentMilliseconds);
    this->addPrimitive("HostLog", &Evaluator::primitiveHostLog);
    this->addPrimitive("HostExit", &Evaluator::primitiveHostExit);
    this->addPrimitive("HostReadFile", &Evaluator::primitiveHostReadFile);
    this->addPrimitive("HostWriteFile", &Evaluator::primitiveHostWriteFile);
    this->addPrimitive("HostCreateDirectory", &Evaluator::primitiveHostCreateDirectory);
    this->addPrimitive("HostPathExists", &Evaluator::primitiveHostPathExists);
    this->addPrimitive("HostCurrentDirectory", &Evaluator::primitiveHostCurrentDirectory);
    this->addPrimitive("HostGetEnv", &Evaluator::primitiveHostGetEnv);
    this->addPrimitive("HostLoadModuleFromPath", &Evaluator::primitiveHostLoadModuleFromPath);


    this->addPrimitive("PrepareForExecution", &Evaluator::primitivePrepareForExecution);
    this->addPrimitive("ProcessVMStackInitializeWithNewBuffer", &Evaluator::primitiveProcessVMStackInitializeWithNewBuffer);
    this->addPrimitive("ProcessVMStackInitializeWithActiveBuffer", &Evaluator::primitiveProcessVMStackInitializeWithActiveBuffer);
    this->addPrimitive("ProcessVMStackAt", &Evaluator::primitiveProcessStackAt);
    this->addPrimitive("ProcessVMStackAtPut", &Evaluator::primitiveProcessVMStackAtPut);
    this->addPrimitive("ProcessVMStackBpAtPut", &Evaluator::primitiveProcessVMStackBpAtPut);
    this->addPrimitive("ProcessVMStackPcAtPut", &Evaluator::primitiveProcessVMStackPcAtPut);
    this->addPrimitive("ProcessVMStackBP", &Evaluator::primitiveProcessBP);
    this->addPrimitive("ProcessVMStackBufferSize", &Evaluator::primitiveProcessVMStackBufferSize);
    this->addPrimitive("ProcessVMStackContextSwitchTo", &Evaluator::primitiveProcessVMStackContextSwitchTo);
    _linearizer->primitives_(_primitives);
}

void Evaluator::evaluatePerform_in_withArgs_(Object *aSymbol, Object *receiver, Object *arguments) {
    HeapObject *behavior = this->_runtime->behaviorOf_(receiver);
    if (aSymbol->printString() == "#asBehavior") {
        int a = 0;
    }
    Object *method = this->_runtime->lookup_startingAt_(aSymbol, behavior);
    if (!method)
        error_(std::string("cannot perform ") + aSymbol->printString() + " on " + receiver->printString());
    auto heapargs = arguments->asHeapObject();
    for (int i = 1; i <= heapargs->size(); i++) {
        this->_context->pushOperand_(heapargs->slotAt_(i));
    }
    this->invoke_with_(method->asHeapObject(), receiver);
}

Object*
Evaluator::lookup_startingAt_sendSite_(Object *symbol, HeapObject *behavior, SAbstractMessage *message)
{
	auto method = _runtime->lookup_startingAt_(symbol, behavior);
	if (!method) return nullptr;

    message->registerCacheWith_(_runtime);
    message->cache_when_((Object*)method, (Object*)behavior);
    
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

Object* Evaluator::send_to_with_(Object *symbol, Object *receiver, std::vector<Object*> &args) {
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
/*
	Having the adaptor causes argument popping work transparently. The adaptor frame's
	PC is pointed to the instant after the send, so it just pops the message and continues
*/
	auto count = message->arguments().size();
	std::vector<Object*> args;
    for (size_t i = 1; i <= count; i++)
    {
        args.push_back(_context->operandAt_(count - i));
    }
	auto array = _runtime->newArray_(args);
	_context->push_(message->selector());
	_context->push_((Object*)array);
    auto symbol = (Object*)_runtime->addSymbol_("_doesNotUnderstand:with:");
    auto behavior = _runtime->behaviorOf_(_regR);
	auto dnu = _runtime->lookup_startingAt_((Object*)symbol, behavior);
    if (!dnu)
    {
        std::string errmsg = std::string("Message not understood!\n") +
     this->_regR->printString() + " does not understand " + message->selector()->printString() +
     "\nmethod #_doesNotUnderstand:with: not found on receiver";
        error_(errmsg);

    }

	this->invoke_with_(dnu->asHeapObject(), _regR);
}

void Evaluator::doesNotKnow(const Object *symbol) { ASSERT(false); }

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

    UndermessagePointer undermessage = message->cachedUndermessage();
    if (undermessage != nullptr) {
        return this->evaluateUndermessage_with_(message, undermessage);
    }

	auto behavior =
        message->receiver()->isSuper() ? 
            _runtime->superBehaviorOf_(_context->classBinding()) :
		    _runtime->behaviorOf_(_regR);

    auto method = message->methodFor_((Object*)behavior);
	if (method)
    {
        this->invoke_with_(method->asHeapObject(), _regR);
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

	this->invoke_with_(method->asHeapObject(), _regR);
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
	auto method = _context->compiledCode();
	auto code = _runtime->methodExecutableCode_(method);
	_work = _runtime->executableCodeWork_(code);
}

void Evaluator::visitOpReturn(SOpReturn *anSOpReturn)
{
    this->popFrameAndPrepare();

    if (!_runtime->_heap->isAtGCUnsafepoint())
        _runtime->_heap->collectIfTime();
}

void Evaluator::visitOpNonLocalReturn(SOpNonLocalReturn *anSOpNonLocalReturn)
{
    _context->push_(_regR);
    this->invoke_with_(_runtime->_closureReturnMethod, (Object*)_context->environment());
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

Object* Evaluator::failPrimitiveWith_(Object* errorObject)
{
    // Same as failPrimitive, but additionally publishes `errorObject` to the
    // Smalltalk fallback code by writing it into the method's first temp.
    // The fallback method should declare a `| error |` temp to receive it.
    // Temp indices are 1-based (matches compiler/linearizer convention).
    auto method = this->_context->method();
    if (this->_runtime->methodTempCount_(method) > 0)
        this->_context->stackTemporaryAt_put_(1, errorObject);
    return this->failPrimitive();
}


Object* Evaluator::primitiveAt() {
    auto receiver = this->_context->self();
    auto index = this->_context->firstArgument();

    if (receiver->isSmallInteger())
        return this->failPrimitive();

    if (!index->isSmallInteger())
        return this->failPrimitive();
    
    auto index_int = index->asSmallInteger()->asNative();

    auto heapreceiver = receiver->asHeapObject();
    if (heapreceiver->isBytes()) {
        if (index_int < 1 || (unsigned)(index_int - 1) >= heapreceiver->size())
            return this->failPrimitive();
        return newIntObject(heapreceiver->byteAt_(index_int));
    } else {
        auto instSize = heapreceiver->isNamed() ? (int)_runtime->speciesInstanceSize_(_runtime->speciesOf_((Object*)heapreceiver)) : 0;
        auto rawSlot = heapreceiver->isNamed() ? index_int + instSize : index_int;
        if (rawSlot < 1 || (unsigned)(rawSlot - 1) >= heapreceiver->size())
            return this->failPrimitive();
        return _runtime->indexedSlotAt_(heapreceiver, index_int);
    }
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

Object* Evaluator::primitiveDictionaryNew() {
    auto guard = this->_runtime->_heap->atGCSafepoint();
    // self is Namespace class (or any HashedCollection subclass metaclass).
    // Equivalent to: self basicNew initialize: (self sizeFor: 5)
    // sizeFor: 5 => 7 max: (5*3//2) = 7. primeFor: 7 => 7.
    auto species = this->_context->self()->asHeapObject();
    auto table = this->_runtime->newSlots_size_(this->_runtime->_openHashTableClass, 7);
    auto instance = this->_runtime->newSlotsOf_(species);
    // tally := 0
    instance->slot(0) = (Object*)this->_runtime->newInteger_(0);
    // table := aHashTable
    instance->slot(1) = (Object*)table;
    // hashTable policy := instance (OpenHashTable named slot 0 = policy)
    table->slot(0) = (Object*)instance;
    return (Object*)instance;
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
    auto guard = _runtime->_heap->atGCUnsafepoint();
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

Object* Evaluator::primitiveFloatNewFromInteger() {
    auto arg = this->_context->firstArgument();
    if (!arg->isSmallInteger())
        return this->failPrimitive();

    return this->newDoubleObject((double)arg->asSmallInteger()->asNative());
}

Object* Evaluator::primitiveFloatPlus() {
    auto arg = this->_context->firstArgument();
    if (_runtime->speciesOf_(arg) != _runtime->_floatClass)
        return this->failPrimitive();

    auto self = this->_context->self();
    return this->newDoubleObject(*(double*)self+*(double*)arg);
}

Object* Evaluator::primitiveFloatMinus() {
    auto arg = this->_context->firstArgument();
    if (_runtime->speciesOf_(arg) != _runtime->_floatClass)
        return this->failPrimitive();

    auto self = this->_context->self();
    return this->newDoubleObject(*(double*)self-*(double*)arg);
}

Object* Evaluator::primitiveFloatMultiply () {
    auto arg = this->_context->firstArgument();
    if (_runtime->speciesOf_(arg) != _runtime->_floatClass)
        return this->failPrimitive();

    auto self = this->_context->self();
    return this->newDoubleObject((*(double*)self) * (*(double*)arg));
}

Object* Evaluator::primitiveFloatDiv() {
    auto arg = this->_context->firstArgument();
    if (_runtime->speciesOf_(arg) != _runtime->_floatClass)
        return this->failPrimitive();

    auto self = this->_context->self();
    return this->newDoubleObject(*(double*)self / *(double*)arg);
}

Object* Evaluator::primitiveFloatLess() {
    auto arg = this->_context->firstArgument();
    if (_runtime->speciesOf_(arg) != _runtime->_floatClass)
        return this->failPrimitive();

    auto self = this->_context->self();
    return this->boolObject(*(double*)self < *(double*)arg);
}

Object* Evaluator::primitiveFloatEqual() {
    auto arg = this->_context->firstArgument();
    if (_runtime->speciesOf_(arg) != _runtime->_floatClass)
        return this->failPrimitive();

    auto self = this->_context->self();
    return this->boolObject(*(double*)self == *(double*)arg);
}

Object* Evaluator::primitiveFloatFractionPart() {
    auto self = this->_context->self();
    double intPart;
    return this->newDoubleObject(std::modf(*(double*)self, &intPart));
}

Object* Evaluator::primitiveFloatSignificand() {
    error_("unimplemented");
    return this->_context->self();
}

Object* Evaluator::primitiveFloatSqrt() {
    auto self = this->_context->self();
    double intPart;
    return this->newDoubleObject(std::sqrt(*(double*)self));
}

Object* Evaluator::primitiveFloatTimesTwoPower() {
    auto arg = this->_context->firstArgument();
    if (!arg->isSmallInteger())
        return this->failPrimitive();

    auto self = this->_context->self();
    int exp = (int)arg->asSmallInteger()->asNative();
    return this->newDoubleObject(std::ldexp(*(double*)self, exp));
}

Object* Evaluator::primitiveFloatTruncated() {
    auto self = this->_context->self();
    double intPart;
    std::modf(*(double*)self, &intPart);
    return this->newIntObject(intPart);
}


Object* Evaluator::primitiveFlushDispatchCaches() {
    this->_runtime->flushDispatchCache_in_(this->_context->self(), this->_context->firstArgument()->asHeapObject());
    return this->_context->self();
}

Object* Evaluator::primitiveFlushFromCaches() {
    this->_runtime->flushDispatchCache_(this->_runtime->methodSelector_(this->_context->self()->asHeapObject()));
    return this->_context->self();
}

Evaluator::PrimitivePointer Evaluator::primitiveFor_(Object *aSymbol) {
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

Object* Evaluator::primitiveHostExit() {
    auto arg = this->_context->firstArgument();
    int code = 0;
    if (arg->isSmallInteger())
        code = (int)arg->asSmallInteger()->asNative();
    std::exit(code);
    return (Object*)this->_runtime->_nilObj;
}

Object* Evaluator::primitiveHostReadFile() {
    auto filename = this->_context->firstArgument();
    std::ifstream file(filename->asHeapObject()->asLocalString(), std::ios::binary);
    if (!file)
        return this->failPrimitive();
    std::stringstream buffer;
    buffer << file.rdbuf();

    return (Object*)this->_runtime->newString_(buffer.str());
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
    auto guard = this->_runtime->_heap->atGCUnsafepoint();
    auto name = this->_context->firstArgument()->asHeapObject()->asLocalString();
    std::cout << "loading " << name << "..." << std::endl;
    try {
        auto module = (Object*)this->_runtime->loadModule_(this->_context->firstArgument()->asHeapObject());
        std::cout << " done loading " << name << std::endl;
        return module;
    } catch (const std::exception& e) {
        return this->failPrimitiveWith_((Object*)this->_runtime->newString_(e.what()));
    }
}

Object* Evaluator::primitiveHostWriteFile() {
    auto filename = this->_context->firstArgument()->asHeapObject()->asLocalString();
    auto contents = this->_context->secondArgument()->asHeapObject()->asLocalString();
    std::ofstream file(filename, std::ios::binary);
    if (!file)
        return this->failPrimitive();
    file.write(contents.data(), contents.size());
    return (Object*)this->_context->self();
}

Object* Evaluator::primitiveHostCreateDirectory() {
    namespace fs = std::filesystem;
    auto path = this->_context->firstArgument()->asHeapObject()->asLocalString();
    std::error_code ec;
    fs::create_directories(path, ec);
    return (Object*)this->_runtime->booleanFor_(!ec);
}

Object* Evaluator::primitiveHostPathExists() {
    namespace fs = std::filesystem;
    auto path = this->_context->firstArgument()->asHeapObject()->asLocalString();
    std::error_code ec;
    bool exists = fs::exists(path, ec);
    return (Object*)this->_runtime->booleanFor_(exists && !ec);
}

Object* Evaluator::primitiveHostCurrentDirectory() {
    namespace fs = std::filesystem;
    std::error_code ec;
    auto cwd = fs::current_path(ec);
    if (ec)
        return this->failPrimitive();
    return (Object*)this->_runtime->newString_(cwd.string());
}

Object* Evaluator::primitiveHostGetEnv() {
    auto name = this->_context->firstArgument()->asHeapObject()->asLocalString();
    const char *value = std::getenv(name.c_str());
    if (value == nullptr)
        return (Object*)this->_runtime->_nilObj;
    return (Object*)this->_runtime->newString_(std::string(value));
}

Object* Evaluator::primitiveHostLoadModuleFromPath() {
    auto guard = this->_runtime->_heap->atGCUnsafepoint();
    auto path = this->_context->firstArgument()->asHeapObject()->asLocalString();
    std::cout << "loading from " << path << "..." << std::endl;
    try {
        auto module = (Object*)this->_runtime->loadModuleFromPath_(path);
        std::cout << " done loading " << path << std::endl;
        return module;
    } catch (const std::exception& e) {
        return this->failPrimitiveWith_((Object*)this->_runtime->newString_(e.what()));
    }
}

Object* Evaluator::primitiveNew() {
    auto guard = this->_runtime->_heap->atGCSafepoint();
    return (Object*)this->_runtime->newSlotsOf_(this->_context->self()->asHeapObject());
}

Object* Evaluator::primitiveNewBytes() {
    auto arg = this->_context->firstArgument();
    if (!arg->isSmallInteger())
        return this->failPrimitive();
    auto guard = this->_runtime->_heap->atGCSafepoint();
    auto size = arg->asSmallInteger()->asNative();
    return (Object*)this->_runtime->newBytes_size_(this->_context->self()->asHeapObject(), size);
}

Object* Evaluator::primitiveNewSized() {
    auto arg = this->_context->firstArgument();
    if (!arg->isSmallInteger())
        return this->failPrimitive();
    auto guard = this->_runtime->_heap->atGCSafepoint();
    auto size = arg->asSmallInteger()->asNative();
    return (Object*)this->_runtime->newOf_sized_(this->_context->self()->asHeapObject(), size);
}

Object* Evaluator::primitivePerformWithArguments() {
    this->evaluatePerform_in_withArgs_(
        this->_context->firstArgument(),
        this->_context->self(),
        this->_context->secondArgument());
    return this->_context->self();
}

Object* Evaluator::primitiveProcessBP()
{
    return (Object*)this->_runtime->newInteger_(this->_context->framePointer());
}

Object* Evaluator::primitiveProcessStackAt()
{
    return _context->stackAt_(this->_context->firstArgument()->asSmallInteger()->asNative());
}

Object* Evaluator::primitiveProcessVMStackInitializeWithNewBuffer()
{
    // Allocate the off-heap buffer that backs a (suspended) process's stack and
    // stash it (tagged as a SmallInteger so the GC won't try to follow it) into
    // the receiver.
    // TODO: this buffer leaks when the wrapping ProcessVMStack is GC'd.
    // Wiring a real finalizer requires GC-sweep hooks (see GarbageCollector::
    // rememberSpecial_ for the special-class machinery). For now the leak is
    // bounded by the number of Process objects ever created (1 OS-page-sized
    // buffer each) and reclaimed by the OS on exit.
    auto pvm = this->_context->self()->asHeapObject();
    uintptr_t size = this->_context->stackSize();
    Object **buffer = new Object*[size];
    for (uintptr_t i = 0; i < size; ++i) buffer[i] = (Object*)_runtime->_nilObj;
    _runtime->processVMStackBuffer_put_(pvm, buffer);
    _runtime->processVMStackBufferSize_put_(pvm, size);
    return (Object*)pvm;
}

Object* Evaluator::primitiveProcessVMStackInitializeWithActiveBuffer()
{
    // Adopt the live C++ evaluator stack: the receiver becomes the wrapper
    // around the buffer that the running native code is currently using.
    // SP/BP/env are written by the suspending side (contextSwitchTo:) so we
    // don't initialize them here. The GC distinguishes the active stack from
    // suspended ones by comparing buffer pointers with the evaluator context.
    auto pvm = this->_context->self()->asHeapObject();
    auto ctx = this->_context;
    _runtime->processVMStackBuffer_put_(pvm, ctx->stack());
    _runtime->processVMStackBufferSize_put_(pvm, ctx->stackSize());
    return (Object*)pvm;
}

Object* Evaluator::primitiveProcessVMStackBufferSize()
{
    auto receiver = this->_context->self()->asHeapObject();
    return receiver->slot(Offsets::ProcessVMStackBufferSize);
}

Object* Evaluator::primitiveProcessVMStackAtPut()
{
    auto receiver = this->_context->self()->asHeapObject();
    auto buffer = this->_runtime->processVMStackBuffer_(receiver);
    if (!buffer) return failPrimitive();
    auto index = this->_context->firstArgument()->asSmallInteger()->asNative();
    auto value = this->_context->secondArgument();
    auto size = this->_runtime->processVMStackBufferSize_(receiver);
    if (index < 1 || (uintptr_t)index > size) return failPrimitive();
    buffer[index - 1] = value;
    return value;
}

Object* Evaluator::primitiveProcessVMStackBpAtPut()
{
    auto receiver = this->_context->self()->asHeapObject();
    auto buffer = this->_runtime->processVMStackBuffer_(receiver);
    if (!buffer) return failPrimitive();
    auto index = this->_context->firstArgument()->asSmallInteger()->asNative();
    auto bp    = this->_context->secondArgument()->asSmallInteger()->asNative();
    auto size  = this->_runtime->processVMStackBufferSize_(receiver);
    if (index < 1 || (uintptr_t)index > size) return failPrimitive();
    buffer[index - 1] = (Object*)(uintptr_t)bp;
    return this->_context->secondArgument();
}

Object* Evaluator::primitiveProcessVMStackPcAtPut()
{
    auto receiver = this->_context->self()->asHeapObject();
    auto buffer = this->_runtime->processVMStackBuffer_(receiver);
    if (!buffer) return failPrimitive();
    auto index = this->_context->firstArgument()->asSmallInteger()->asNative();
    auto pc    = this->_context->secondArgument()->asSmallInteger()->asNative();
    // third argument is the code object; not stored at this slot in our model,
    // but mirrors the Smalltalk signature `pcAt:put:of:`.
    auto size  = this->_runtime->processVMStackBufferSize_(receiver);
    if (index < 1 || (uintptr_t)index > size) return failPrimitive();
    buffer[index - 1] = (Object*)(uintptr_t)pc;
    return this->_context->secondArgument();
}

Object* Evaluator::primitiveProcessVMStackContextSwitchTo()
{
    auto outgoing = this->_context->self()->asHeapObject();      // current stack
    auto incoming = this->_context->firstArgument()->asHeapObject(); // target stack

    // Snapshot live registers into the outgoing PVMStack ivars.
    this->_runtime->processStackSP_put_(outgoing, this->_context->stackPointer());
    this->_runtime->processStackBP_put_(outgoing, this->_context->framePointer());
    this->_runtime->processStackEnv_put_(outgoing, (Object*)this->_context->environment());

    // Bind the evaluator buffer to the incoming stack's buffer.
    auto buffer = this->_runtime->processVMStackBuffer_(incoming);
    auto size   = this->_runtime->processVMStackBufferSize_(incoming);
    this->_context->bindToBuffer_size_(buffer, size);

    // Restore SP from the incoming PVMStack.
    // Just popFrame to load M/E/S/PC/BP from the topmost frame.
    auto sp = this->_runtime->processStackSP_(incoming);
    this->_context->stackPointer_(sp + 1);
    this->_context->framePointer_(this->_context->stackPointer());

    // popFrame reads the method out of the buffer; ensure that method has
    // its executable code prepared (the Smalltalk-level prepareForExecution
    // primitive is a no-op so that may not yet have happened).
    this->_context->popFrame();
    auto method = this->_context->compiledCode();
    if (this->_runtime->methodExecutableCode_(method) == this->_runtime->_nilObj)
        this->prepareForExecution_(method);
    auto code = this->_runtime->methodExecutableCode_(method);
    _work = this->_runtime->executableCodeWork_(code);


    return (Object*)this->_runtime->_trueObj;
}

Object* Evaluator::primitivePrepareForExecution()
{
    // CompiledMethod>>prepareForExecution. In this runtime methods are
    // compiled lazily on first invoke, so this is a no-op.
    return this->_context->self();
}

Object* Evaluator::primitivePrimeFor() {
    return this->primitivePrimeFor_(this->_context->firstArgument()->asSmallInteger()->asNative());
}

Object* Evaluator::primitivePrimeFor_(auto anInteger) {
    // Table matches HashTable>>goodPrimes in Smalltalk (covers up to ~1.07 billion).
     static const int primes[] = {
        2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71,
        73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157,
        163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251,
        269, 359, 479, 641, 857, 1151, 1549, 2069,
        2237, 2423, 2617, 2797, 2999, 3167, 3359, 3539, 3727, 3911,
        4441, 4787, 5119, 5471, 5801, 6143, 6521, 6827, 7177, 7517, 7853,
        8783, 9601, 10243, 10867, 11549, 12239, 12919, 13679, 14293, 15013, 15731,
        17569, 19051, 20443, 21767, 23159, 24611, 25847, 27397, 28571, 30047, 31397,
        35771, 38201, 40841, 43973, 46633, 48989, 51631, 54371, 57349, 60139, 62969,
        70589, 76091, 80347, 85843, 90697, 95791, 101051, 106261, 111143, 115777, 120691, 126311,
        140863, 150523, 160969, 170557, 181243, 190717, 201653, 211891, 221251, 232591, 242873, 251443,
        282089, 300869, 321949, 341227, 362353, 383681, 401411, 422927, 443231, 464951, 482033, 504011,
        562621, 605779, 647659, 681607, 723623, 763307, 808261, 844709, 886163, 926623, 967229, 1014617,
        1121987, 1201469, 1268789, 1345651, 1429531, 1492177, 1577839, 1651547, 1722601, 1800377, 1878623, 1942141, 2028401,
        2242727, 2399581, 2559173, 2686813, 2836357, 3005579, 3144971, 3283993, 3460133, 3582923, 3757093, 3903769, 4061261,
        4455361, 4783837, 5068529, 5418079, 5680243, 6000023, 6292981, 6611497, 6884641, 7211599, 7514189, 7798313, 8077189,
        9031853, 9612721, 10226107, 10745291, 11338417, 11939203, 12567671, 13212697, 13816333, 14337529, 14938571, 15595673, 16147291,
        17851577, 18993941, 20180239, 21228533, 22375079, 23450491, 24635579, 25683871, 26850101, 27921689, 29090911, 30153841, 31292507, 32467307,
        35817611, 37983761, 40234253, 42457253, 44750177, 46957969, 49175831, 51442639, 53726417, 55954637, 58126987, 60365939, 62666977, 64826669,
        71582779, 76039231, 80534381, 84995153, 89500331, 93956777, 98470819, 102879613, 107400389, 111856841, 116365721, 120819287, 125246581, 129732203,
        143163379, 152076289, 161031319, 169981667, 179000669, 187913573, 196826447, 205826729, 214748357, 223713691, 232679021, 241591901, 250504801, 259470131,
        285162679, 301939921, 318717121, 335494331, 352271573, 369148753, 385926017, 402603193, 419480419, 436157621, 453034849, 469712051, 486589307, 503366497, 520043707,
        570475349, 603929813, 637584271, 671138659, 704693081, 738247541, 771801929, 805356457, 838910803, 872365267, 905919671, 939574117, 973128521, 1006682977, 1040137411,
        1073741833
    };

    for (int i = 0; i < (int)(sizeof(primes) / sizeof(primes[0])); i++) {
        auto prime = primes[i];
        if (prime >= anInteger)
            return newIntObject(prime);
    }
    return failPrimitive(); // fall back to Smalltalk for values > 1073741833
}

Object* Evaluator::primitiveSMIBitAnd() {
    auto arg = this->_context->firstArgument();
    if (!arg->isSmallInteger()) return failPrimitive();
    return newIntObject((this->_context->self()->asSmallInteger()->asNative() & arg->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMIBitOr() {
    auto arg = this->_context->firstArgument();
    if (!arg->isSmallInteger()) return failPrimitive();
    return newIntObject((this->_context->self()->asSmallInteger()->asNative() | arg->asSmallInteger()->asNative()));
}

Object* Evaluator::primitiveSMIBitShift() {
    auto self = this->_context->self()->asSmallInteger()->asNative();
    auto firstArg = this->_context->firstArgument()->asSmallInteger()->asNative();
    if (firstArg > 0) {
        if (firstArg >= 63 || (self != 0 && (self > (SmallInteger::SMALLINT_MAX >> firstArg) || self < (SmallInteger::SMALLINT_MIN >> firstArg))))
            return failPrimitive();
        return newIntObject(self << firstArg);
    }
    auto rshift = -firstArg;
    if (rshift >= 63) return newIntObject(self < 0 ? -1 : 0);
    return newIntObject(self >> rshift);
}

Object* Evaluator::primitiveSMIBitXor() {
    auto arg = this->_context->firstArgument();
    if (!arg->isSmallInteger()) return failPrimitive();
    return newIntObject(this->_context->self()->asSmallInteger()->asNative() ^ arg->asSmallInteger()->asNative());
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
    // Smalltalk // is floored division (toward negative infinity)
    auto a = this->_context->self()->asSmallInteger()->asNative();
    auto b = this->_context->firstArgument()->asSmallInteger()->asNative();
    auto q = a / b;
    // Adjust: if remainder is nonzero and signs differ, subtract 1
    if ((a % b != 0) && ((a ^ b) < 0))
        q -= 1;
    return newIntObject(q);
}

Object* Evaluator::primitiveSMIIntQuot() {
    // Smalltalk \\ is floored remainder (modulo), same sign as divisor
    auto a = this->_context->self()->asSmallInteger()->asNative();
    auto b = this->_context->firstArgument()->asSmallInteger()->asNative();
    auto r = a % b;
    // Adjust: if remainder is nonzero and signs differ, add divisor
    if (r != 0 && ((a ^ b) < 0))
        r += b;
    return newIntObject(r);
}

Object* Evaluator::primitiveSMIMinus() {
    auto arg = this->_context->firstArgument();
    if (!arg->isSmallInteger()) return this->failPrimitive();
    auto result = this->_context->self()->asSmallInteger()->asNative() - arg->asSmallInteger()->asNative();
    if (result < SmallInteger::SMALLINT_MIN || result > SmallInteger::SMALLINT_MAX) return this->failPrimitive();
    return newIntObject(result);
}

Object* Evaluator::primitiveSMINotEqual() {
    auto arg = this->_context->firstArgument();
    return arg->isSmallInteger() ?
        boolObject(this->_context->self()->asSmallInteger()->asNative() != (arg->asSmallInteger()->asNative())) :
        this->failPrimitive();
}

Object* Evaluator::primitiveSMIPlus() {
    auto arg = this->_context->firstArgument();
    if (!arg->isSmallInteger()) return this->failPrimitive();
    auto result = this->_context->self()->asSmallInteger()->asNative() + arg->asSmallInteger()->asNative();
    if (result < SmallInteger::SMALLINT_MIN || result > SmallInteger::SMALLINT_MAX) return this->failPrimitive();
    return newIntObject(result);
}

Object* Evaluator::primitiveSMISize() {
    auto number = this->_context->self()->asSmallInteger()->asNative();

    auto size = number < 0 ? 1 : (static_cast<int>(log2(number)) >> 3) + 1;
    
    return newIntObject(size);
}

Object* Evaluator::primitiveSMITimes() {
    auto arg = this->_context->firstArgument();
    if (!arg->isSmallInteger()) return this->failPrimitive();
    intptr_t a = this->_context->self()->asSmallInteger()->asNative();
    intptr_t b = arg->asSmallInteger()->asNative();
    intptr_t result;
    if (mul_overflow_iptr(a, b, &result) || result < SmallInteger::SMALLINT_MIN || result > SmallInteger::SMALLINT_MAX)
        return this->failPrimitive();
    return newIntObject(result);
}

Object* Evaluator::primitiveSetBehavior() {
    auto receiver = this->_context->self()->asHeapObject();
    receiver->behavior(this->_context->firstArgument()->asHeapObject());
    return this->_context->self();
}

Object* Evaluator::primitiveSize() {
    auto self = this->_context->self();
    auto result = this->_runtime->arrayedSizeOf_(self);
    return newIntObject(result);
}

Object* Evaluator::primitiveStringReplaceFromToWithStartingAt() {
    auto receiver = this->_context->self()->asHeapObject();
    auto from = this->_context->firstArgument();
    auto to = this->_context->secondArgument();
    auto source = this->_context->thirdArgument();
    auto starting = this->_context->fourthArgument();

    if (!from->isSmallInteger() || !to->isSmallInteger() || !starting->isSmallInteger())
        return this->failPrimitive();

    if (source->isSmallInteger())
        return this->failPrimitive();

    if (_runtime->speciesOf_((Object*)receiver) != _runtime->speciesOf_(source))
        return this->failPrimitive();

    auto fromint = from->asSmallInteger()->asNative();
    auto toint = to->asSmallInteger()->asNative();
    auto startingint = starting->asSmallInteger()->asNative();

    // Empty replacement (from > to) is a no-op.
    if (fromint > toint)
        return (Object*)receiver;

    if (fromint < 1 || toint > (intptr_t)receiver->size())
        return this->failPrimitive();

    auto len = toint - fromint + 1;
    auto last = startingint + len - 1;
    auto hsource = source->asHeapObject();
    if (startingint < 1 || last > (intptr_t)hsource->size())
        return this->failPrimitive();

    receiver->replaceBytesFrom_to_with_startingAt_(
        fromint, toint, hsource, startingint);

    return (Object*)receiver;
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
    descriptor_impl->fnAddr = (void(*)())FindSymbol(*(uintptr_t*)handle, (char*)fnName);

    if (descriptor_impl->fnAddr == nullptr)
    {
        delete descriptor_impl;
        error_("could not find FFI method " + method->printString());
    }

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
    auto value = receiver->asSmallInteger()->asNative();
    auto shift = args[0]->asSmallInteger()->asNative();
    if (shift >= 63 || (value != 0 && shift > 0 && (value > (SmallInteger::SMALLINT_MAX >> shift) || value < (SmallInteger::SMALLINT_MIN >> shift))))
        return (Object*)_nilObj;
    auto result = value << shift;
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

Object* Evaluator::underprimitiveError(Object *receiver, std::vector<Object*> &args) {
    std::string msg = args[0]->asHeapObject()->printString();
    error_(msg);
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

Object* Evaluator::underprimitiveReturnTo(Object* receiver, std::vector<Object*>& args)
{
    _context->framePointer_(args[0]->asSmallInteger()->asNative());
    this->popFrameAndPrepare();
    /* after returning from underprimitive evaluation, interpreter will try to restore
     * stack pointer (args were popped), but in this case we must leave stack as is. To
	 * avoid the problem, we move the sp further down
	*/
    _context->reserveStackSlots_(-1);
    return receiver;
}

Object* Evaluator::underprimitiveSMIBitAnd(Object *receiver, std::vector<Object*> &args) {
    return newIntObject((receiver->asSmallInteger()->asNative() & args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMIBitOr(Object *receiver, std::vector<Object*> &args) {
    return newIntObject((receiver->asSmallInteger()->asNative() | args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMIBitShiftLeft(Object *receiver, std::vector<Object*> &args) {
    auto value = receiver->asSmallInteger()->asNative();
    auto shift = args[0]->asSmallInteger()->asNative();
    if (shift >= 63 || (value != 0 && shift > 0 && (value > (SmallInteger::SMALLINT_MAX >> shift) || value < (SmallInteger::SMALLINT_MIN >> shift))))
        return (Object*)_nilObj;
    return newIntObject(value << shift);
}

Object* Evaluator::underprimitiveSMIBitShiftRight(Object *receiver, std::vector<Object*> &args) {
    auto value = receiver->asSmallInteger()->asNative();
    auto shift = args[0]->asSmallInteger()->asNative();
    if (shift >= 63) return newIntObject(value < 0 ? -1 : 0);
    return newIntObject(value >> shift);
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
    auto result = receiver->asSmallInteger()->asNative() - args[0]->asSmallInteger()->asNative();
    if (result < SmallInteger::SMALLINT_MIN || result > SmallInteger::SMALLINT_MAX)
        return (Object*)_nilObj;
    return newIntObject(result);
}

Object* Evaluator::underprimitiveSMIPlus(Object *receiver, std::vector<Object*> &args) {
    auto result = receiver->asSmallInteger()->asNative() + args[0]->asSmallInteger()->asNative();
    if (result < SmallInteger::SMALLINT_MIN || result > SmallInteger::SMALLINT_MAX)
        return (Object*)_nilObj;
    return newIntObject(result);
}

Object* Evaluator::underprimitiveSMIQuotientTowardZero(Object *receiver, std::vector<Object*> &args) {
    return newIntObject(receiver->asSmallInteger()->asNative() / (args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMIRemainderTowardZero(Object *receiver, std::vector<Object*> &args) {
    return newIntObject(receiver->asSmallInteger()->asNative() % (args[0]->asSmallInteger()->asNative()));
}

Object* Evaluator::underprimitiveSMITimes(Object *receiver, std::vector<Object*> &args) {
    intptr_t a = receiver->asSmallInteger()->asNative();
    intptr_t b = args[0]->asSmallInteger()->asNative();
    intptr_t result;
    if (mul_overflow_iptr(a, b, &result) || result < SmallInteger::SMALLINT_MIN || result > SmallInteger::SMALLINT_MAX)
        return (Object*)_nilObj;
    return newIntObject(result);
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
