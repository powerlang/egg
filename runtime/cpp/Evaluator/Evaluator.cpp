
#include "Evaluator.h"
#include "Runtime.h"
#include "TreecodeDecoder.h"

using namespace Egg;

void Evaluator::addPrimitive(const std::string &name, PrimitivePointer primitive)
{
    HeapObject *symbol = _runtime->existingSymbolFrom_(name);
    _primitives[symbol] = primitive;
}

void Evaluator::addUndermessage(const std::string &name, UndermessagePointer primitive) {
    HeapObject *symbol = _runtime->existingSymbolFrom_(name);
    _undermessages[symbol] = primitive;
}


Object* Evaluator::primitiveEqual()
{
    return (Object*)_runtime->booleanFor_(_context->receiver() == _context->firstArgument());
}

void Evaluator::initializePrimitives()
{
    this->addPrimitive("PrimitiveEqual", &Evaluator::primitiveEqual);
}

Object* Evaluator::underprimitiveSMIEquals(Object *receiver, std::vector<Object*> &args)
{
    return (Object*)_runtime->booleanFor_(receiver->asSmallInteger()->asNative() == args[0]->asSmallInteger()->asNative());
}

void Evaluator::evaluatePerform_in_withArgs_(HeapObject *aSymbol, Object *receiver, std::vector<Object*> &arguments) {
    HeapObject *behavior = this->_runtime->behaviorOf_(receiver);
    HeapObject *method = this->_runtime->lookup_startingAt_(aSymbol, behavior);
    for (auto arg = arguments.begin(); arg != arguments.end(); arg++) {
        this->_context->pushOperand_(*arg);
    }
    this->invoke_with_(method, receiver);
}

Object* Evaluator::invoke_with_(HeapObject* method, Object *receiver) {
        int size = _runtime->methodEnvironmentSize_(method);
        HeapObject *environment = _runtime->newEnvironmentSized_(size);
        HeapObject *executable = this->prepareForExecution_(method);

        this->buildMethodFrameFor_code_environment_(receiver, executable, environment);

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

    this->linearizer()->visitMethod_(sexpressions);
    executableCode = this->_runtime->newExecutableCodeFor_(method, this->linearizer()->operations().asArray());
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