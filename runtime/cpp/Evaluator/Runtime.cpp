
#include "Runtime.h"
#include "Evaluator.h"
#include "Memory.h"

using namespace Egg;

void Runtime::initializeEvaluator(){
    _evaluator = new Evaluator(this, _falseObj, _trueObj, _nilObj);
}

HeapObject* Runtime::newExecutableCodeFor_with_(HeapObject *compiledCode, HeapObject *platformCode)
{
    auto behavior = this->speciesInstanceBehavior_(_arrayClass);
    auto result = allocateSlots(0);
    result->behavior(behavior);
    result->beArrayed();
    this->executableCodePlatformCode_put_(result, (Object*)platformCode);
    this->executableCodeCompiledCode_put_(result, (Object*)compiledCode);
    return result;
}

Object* Runtime::sendLocal_to_with_(const std::string &selector, Object *receiver, std::vector<Object*> &arguments) {
    auto symbol = this->existingSymbolFrom_(selector);

    return this->_evaluator->send_to_with_(symbol, receiver, arguments);
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
    for (int i = 2; i < table->size(); i = i + 2){
        auto symbol = table->slotAt_(i)->asHeapObject();
        if (symbol != this->_nilObj && symbol->sameBytesThan(selector))
            return  symbol;
    }

    error("symbol not found");
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
