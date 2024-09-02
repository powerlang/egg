
#include "Runtime.h"
#include "Evaluator.h"
#include "GCHeap.h"
#include "SAbstractMessage.h"
#include "KnownConstants.h"

using namespace Egg;

Runtime *Egg::debugRuntime = 0;

void Runtime::initializeEvaluator() {
    _heap = new GCHeap;
    _evaluator = new Evaluator(this, _falseObj, _trueObj, _nilObj);
}

uintptr_t Runtime::arrayedSizeOf_(Object *anObject) {
    if (anObject->isSmallInteger())
        return 0;
    
    auto species = this->speciesOf_(anObject);
    auto ivars = this->speciesInstanceSize_(species);

    return anObject->asHeapObject()->size() - ivars;
}

HeapObject* Runtime::newBytes_size_(HeapObject *species, uint32_t size)
{
	auto behavior = this->speciesInstanceBehavior_(species);
	auto result = _heap->allocateBytes_(size);
              
    result->behavior(behavior);
    return result;
}

HeapObject* Runtime::newBytesOf_sized_(HeapObject *species, uint32_t size)
{
    return this->newBytes_size_(species, size);
}

HeapObject *Runtime::newSlots_size_(HeapObject *species, uint32_t size) {
	auto ivars = this->speciesInstanceSize_(species);
    HeapObject *behavior = this->speciesInstanceBehavior_(species);
    auto slotSize = ivars + size;
    HeapObject *result = _heap->allocateSlots_(slotSize);
    result->behavior(behavior);
    return result;
 }

HeapObject* Runtime::newSlotsOf_(HeapObject *species) {
    return this->newSlots_size_(species, 0);
}

HeapObject *Runtime::newOf_sized_(HeapObject *species, uint32_t size) {
    return (speciesIsBytes_(species)) ?
        newBytes_size_(species, size) :
        newSlots_size_(species, size);
}

HeapObject* Runtime::newArray_(std::vector<Object*> &anArray)
{
    auto result = this->newArraySized_(anArray.size());
    for (int i = 0; i < anArray.size(); i++)
        result->slot(i) = anArray[i];
	return result;
}

HeapObject* Runtime::newArray_(std::vector<HeapObject*> &anArray)
{
    auto result = this->newArraySized_(anArray.size());
    for (int i = 0; i < anArray.size(); i++)
        result->slot(i) = (Object*)anArray[i];
	return result;
}

HeapObject* Runtime::newArraySized_(uint32_t anInteger) { 
    HeapObject *behavior = this->speciesInstanceBehavior_(_arrayClass);
    HeapObject *result = _heap->allocateSlots_(anInteger);
    result->behavior(behavior);
    result->beArrayed();
    return result;
 }

HeapObject *Runtime::newClosureFor_(HeapObject *block)
{
	auto size = this->blockEnvironmentCount_(block);
	auto closure = this->newSlots_size_(_closureClass, size);
	closure->slot(Offsets::ClosureBlock) = (Object*)block;
	return  closure;
}

 HeapObject *Runtime::newCompiledMethod() {
     HeapObject *behavior = this->speciesInstanceBehavior_(_methodClass);
     HeapObject *result = _heap->allocateSlots_(Offsets::MethodInstSize);
     result->behavior(behavior);
     result->beNamed();
     result->beArrayed();
     result->slot(Offsets::MethodFormat) = (Object *)this->newInteger_(0);

     return result;
 
}

HeapObject *Runtime::newEnvironmentSized_(uint32_t size)
{
    return this->newArraySized_(size);
 }

HeapObject *Runtime::newExecutableCodeFor_with_(HeapObject *compiledCode,
                                                HeapObject *platformCode) {
    auto behavior = this->speciesInstanceBehavior_(_arrayClass);
    auto result = _heap->allocateSlots_(2); // fixme: use a proper kind of object for this
    result->behavior(behavior);
    result->beArrayed();
    this->executableCodePlatformCode_put_(result, (Object *)platformCode);
    this->executableCodeCompiledCode_put_(result, (Object *)compiledCode);
    return result;
}

HeapObject *Runtime::newString_(const std::string &str)
{
    auto behavior = this->speciesInstanceBehavior_(_stringClass);
    auto result = _heap->allocateBytes_(str.size() + 1); // fixme: use a proper kind of object for this
    result->behavior(behavior);
    result->beBytes();
    result->beArrayed();
    str.copy((char*)result, str.size());
    return result;
}

HeapObject *Runtime::addSymbol_(const std::string &str){
    return this->sendLocal_to_("asSymbol", (Object*)this->newString_(str))->asHeapObject();
}

HeapObject *Runtime::loadModule_(HeapObject *name) {
    _evaluator->_halt();
    return _evaluator->context()->self()->asHeapObject();
}

uintptr_t Runtime::hashFor_(Object *anObject)
{
    if (anObject->isSmallInteger()) 
        return anObject->asSmallInteger()->asNative();

    uintptr_t current = anObject->asHeapObject()->hash();
    if (current != 0)
        return current;

    auto hash = this->nextHash();
    anObject->asHeapObject()->hash(hash);
    return hash;
 }

Object* Runtime::sendLocal_to_with_(const std::string &selector, Object *receiver, std::vector<Object*> &arguments) {
    auto symbol = this->existingSymbolFrom_(selector);

    return this->_evaluator->send_to_with_(symbol, receiver, arguments);
}

Object* Runtime::sendLocal_to_with_(const std::string &selector, Object *receiver, Object* arg1) {
    auto symbol = this->existingSymbolFrom_(selector);
    std::vector<Object*> args;
    args.push_back(arg1);

    return this->_evaluator->send_to_with_(symbol, receiver, args);
}

Object* Runtime::sendLocal_to_with_with_(const std::string &selector, Object *receiver, Object *arg1, Object* arg2) {
    auto symbol = this->existingSymbolFrom_(selector);
    std::vector<Object*> args;
    args.push_back(arg1);
    args.push_back(arg2);

    return this->_evaluator->send_to_with_(symbol, receiver, args);
}
HeapObject* Runtime::lookup_startingAt_(HeapObject *symbol, HeapObject *behavior)
{
    auto iter = _globalCache.find(global_cache_key(symbol,behavior));
    if (iter != _globalCache.end())
        return iter->second;
    
    auto method = this->doLookup_startingAt_(symbol, behavior);
	_globalCache[global_cache_key(symbol,behavior)] = method;
    return method;
}

HeapObject* Runtime::doLookup_startingAt_(HeapObject *symbol, HeapObject *startBehavior)
{
	auto behavior = startBehavior;
	do {
        auto m = this->methodFor_in_(symbol, behavior);
    	if (m) return m;
     	behavior = this->behaviorNext_(behavior);
    }
    while (behavior != _nilObj);

	return nullptr;
}

HeapObject* Runtime::methodFor_in_(HeapObject *symbol, HeapObject *behavior)
{
	auto md = this->behaviorMethodDictionary_(behavior);
	auto table = this->dictionaryTable_(md);
	for (int index = 2; index < table->size(); index += 2) { 
		if (table->slotAt_(index) == (Object*)symbol)
			return table->slotAt_(index + 1)->asHeapObject();
    }
	return nullptr;
}

HeapObject* Runtime::existingSymbolFrom_(const std::string &selector)
{
    auto it = this->_knownSymbols.find(selector);
    if (it != this->_knownSymbols.end())
        return it->second;
    HeapObject *table = this->_symbolTable->slotAt_(2)->asHeapObject();
    for (int i = 2; i < table->size(); i++){
        auto symbol = table->slotAt_(i)->asHeapObject();
        if (symbol != this->_nilObj){
            //    std::cout << "symbol" << symbol->printString() << " at: 0x" << i << std::endl;
            if (symbol->sameBytesThan(selector))
               return  symbol;
        }
    }
    std::string str = std::string("symbol #") + selector + " not found in image";
    error(str.c_str());
    return nullptr;
}

HeapObject* Runtime::lookupAssociationFor_in_(HeapObject *symbol, HeapObject *dictionary) {
    auto table = this->dictionaryTable_(dictionary);
    for (int index = 2; index <= table->size(); index++) {
        auto assoc = table->slotAt_(index)->asHeapObject();
        if (assoc != this->_nilObj) {
            auto key = assoc->slotAt_(1)->asHeapObject();
           if (key == symbol)
                return assoc;
        }
    }
    return nullptr;
}

void Runtime::flushDispatchCache_(HeapObject *aSymbol) {

    auto iter = _inlineCaches.find(aSymbol);
    if (iter != _inlineCaches.end()) {
        auto messages = _inlineCaches[aSymbol];
        for (auto& m : *messages) {
            m->flushCache();
        }
    }

    std::vector<global_cache_key> cached;
    for (const auto& entry : _globalCache) {
        if (entry.first.first == aSymbol) {
            cached.push_back(entry.first);
        }
    }

    for (const auto& key : cached) {
        _globalCache.erase(key);
    }
}

void Runtime::flushDispatchCache_in_(HeapObject *aSymbol, HeapObject *klass) {

    HeapObject *behavior = this->speciesInstanceBehavior_(klass);

    auto iter = _inlineCaches.find(aSymbol);
    if (iter != _inlineCaches.end()) {
    
        auto messages = _inlineCaches[aSymbol];
        for (auto& m : *messages) {
            m->flushCache();
        }
    }

    _globalCache.erase(std::make_pair(aSymbol, behavior));
}

std::string Egg::Runtime::print_(HeapObject *obj) {
	auto species = this->behaviorClass_(obj->behavior());
	if (species == _stringClass)
		return "<'" , obj->asLocalString() + "'>";
	if (species == _methodClass)
	{
        auto selector = (HeapObject*)obj->slot(Offsets::MethodSelector);
		auto s = (selector == _nilObj) ? "<nil>" : selector->asLocalString();
		return "<" + (this->methodClassBinding_(obj)->printString()) +
				">>#" + s + ">";
    }
	auto name = this->speciesLocalName_(species);
	if (name == "Symbol")
		return "<#" + obj->asLocalString() + ">";
	
    return "<a " + name + ">";
 }
