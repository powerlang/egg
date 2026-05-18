#include <map>
#include <sstream>

#include "Runtime.h"
#include "Loader.h"
#include "Evaluator.h"
#include "Allocator/GCHeap.h"
#include "SAbstractMessage.h"
#include "KnownConstants.h"
#include "GCedRef.h"
#include "StackGCedRef.h"
#include "Utils/CRLFStream.h"

using namespace Egg;

Runtime *Egg::debugRuntime = nullptr;


Runtime::Runtime(Loader* loader, ImageSegment* kernel, SymbolProvider* symbolProvider):
    _loader(loader),
    _kernel(kernel),
    _symbolProvider(symbolProvider),
    _lastHash(1) // LFSR seed; must be non-zero (0 is a fixed point).
{
    debugRuntime = this;
    this->initializeKernelObjects();
    KnownObjects::initializeFrom(this);
    _heap = new GCHeap(this);

}

void Runtime::initializeEvaluator() {
    _evaluator = new Evaluator(this, _falseObj, _trueObj, _nilObj);
    this->initializeClosureReturnMethod();

}

void Runtime::initializeClosureReturnMethod() {
    auto symbol = this->existingSymbolFrom_("return:");
    if (!symbol) {
        std::cerr << "Warning: 'return:' symbol not found" << std::endl;
        return;
    }
    auto behavior = this->speciesInstanceBehavior_(_closureClass);
    auto method = this->lookup_startingAt_(symbol, behavior);
    if (!method) {
        std::cerr << "Warning: Could not find 'return:' method in Closure behavior" << std::endl;
        return;
    }
    this->_closureReturnMethod = method->asHeapObject();
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
    StackGCedRef gcedBehavior(_evaluator->context(), (Object*)behavior);
	auto result = _heap->allocateBytes_(size);
              
    result->behavior(gcedBehavior.asHeapObject());
    return result;
}

HeapObject *Runtime::newSlots_size_(HeapObject *species, uint32_t size) {
	auto ivars = this->speciesInstanceSize_(species);
    HeapObject *behavior = this->speciesInstanceBehavior_(species);
    auto slotSize = ivars + size;
    StackGCedRef gcedBehavior(_evaluator->context(), (Object*)behavior);
    HeapObject *result = _heap->allocateSlots_(slotSize);
    result->behavior(gcedBehavior.asHeapObject());
    if (size > 0)
        result->beArrayed();
    if (ivars > 0)
        result->beNamed();
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
     HeapObject *result = this->newSlots_size_(_methodClass, 0);
     result->slot(Offsets::MethodFormat) = (Object *)this->newInteger_(0);
     return result;
}

HeapObject *Runtime::newEnvironmentSized_(uint32_t size)
{
    return this->newArraySized_(size);
}

HeapObject *Runtime::newExecutableCodeFor_with_(HeapObject *compiledCode,
                                                PlatformCode *platformCode) {
    auto result = this->newSlots_size_(_arrayClass, 2); // fixme: use a proper kind of object for this
    this->executableCodePlatformCode_put_(result, platformCode);
    this->executableCodeCompiledCode_put_(result, compiledCode);
    return result;
}

HeapObject *Runtime::newString_(const std::string &str)
{
    auto result = this->newBytes_size_(_stringClass, str.size() + 1); // fixme: use a proper kind of object for this
    str.copy((char*)result, str.size());
    return result;
}

HeapObject *Runtime::addSymbol_(const std::string &str){
    auto result = _symbolProvider->symbolFor_(str);
    return result->asHeapObject();
}

Object* Runtime::send_to_(Object *symbol, Object *receiver) {
    std::vector<Object*> args;
    return this->_evaluator->send_to_with_(symbol, receiver, args);
}

Object* Runtime::send_to_with_(Object *symbol, Object *receiver, Object* arg1) {
    std::vector<Object*> args;
    args.push_back(arg1);
    return this->_evaluator->send_to_with_(symbol, receiver, args);
}

void Runtime::switchToDynamicSymbolProvider_(HeapObject* symbolTable) {
    // Don't delete old provider — Bootstrapper may still reference it
    _symbolProvider = new DynamicSymbolProvider(this, symbolTable);
;
}

HeapObject *Runtime::loadModule_(HeapObject *name) {
    return _loader->loadModule_(name->asLocalString());
}

HeapObject *Runtime::loadModuleFromPath_(const std::string &path) {
    return _loader->loadModuleFromPath_(path);
}

void Runtime::addSegmentSpace_(ImageSegment* segment)
{
    GCSpace *space = GCSpace::allocatedAt_limit_(segment->spaceStart(), segment->spaceEnd(), false);
    // Handle bootstrapped kernel which doesn't have a module object yet
    if (segment->header.module != nullptr) {
        space->_name = this->moduleName_(segment->header.module)->asLocalString();
    } else {
        space->_name = "BootstrappedKernel";
    }
    this->_heap->addSpace_(space);
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

Object* Runtime::sendLocal_to_withArgs_(const std::string &selector, Object *receiver, std::vector<Object*> &arguments) {
    auto symbol = (Object*)this->addSymbol_(selector);
    return this->_evaluator->send_to_with_(symbol, receiver, arguments);
}

Object* Runtime::sendLocal_to_with_(const std::string &selector, Object *receiver, Object* arg1) {
    auto symbol = (Object*)this->addSymbol_(selector);
    std::vector<Object*> args;
    args.push_back(arg1);

    return this->_evaluator->send_to_with_(symbol, receiver, args);
}

Object* Runtime::sendLocal_to_with_with_(const std::string &selector, Object *receiver, Object *arg1, Object* arg2) {
    auto symbol = (Object*)this->addSymbol_(selector);
    std::vector<Object*> args;
    args.push_back(arg1);
    args.push_back(arg2);

    return this->_evaluator->send_to_with_(symbol, receiver, args);
}

std::string Runtime::printGlobalCache() {
    std::ostringstream stream;
    for (const auto& entry : _globalCache) {
        auto key_first = entry.first.first;
        auto key_second = entry.first.second;
        auto value = entry.second;

        stream << "Key: <" << key_first->get()->printString();
        stream << ", " << key_second->get()->printString();
        stream << "> -> Value: " << value->get()->printString();
        stream << std::endl;
    }

    return stream.str();
}

void Runtime::checkCache() {
    for (const auto& entry : _globalCache) {
        auto symbol = entry.first.first->get();
        auto methodSelector = debugRuntime->methodSelector_(entry.second->get()->asHeapObject());
        ASSERT( symbol ==  methodSelector);
        if (symbol != methodSelector) {
            int a = 0;
        }
    }
}

Object* Runtime::lookup_startingAt_(Object *symbol, HeapObject *behavior)
{
    checkCache();

    auto iter = _globalCache.find(global_cache_key(symbol,(Object*)behavior));
    if (iter != _globalCache.end()) {
        auto result = iter->second->get();
        return result;
    }
    
    auto method = this->doLookup_startingAt_(symbol, behavior);
    if (!method)
        return nullptr;
    auto key = gced_global_cache_key(new GCedRef(symbol),new GCedRef((Object*)behavior));
    auto value = new GCedRef((Object*)method);
	_globalCache.insert({key, value});
    checkCache();
    return method;
}

Object* Runtime::doLookup_startingAt_(Object *symbol, HeapObject *startBehavior)
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

Object* Runtime::methodFor_in_(Object *symbol, HeapObject *behavior)
{
	auto md = this->behaviorMethodDictionary_(behavior);
	HeapObject* symbolObj = symbol->asHeapObject();

	// Array-based method dict: linear scan of [selector, method, selector, method, ...]
	if (this->speciesOf_((Object*)md) == this->_arrayClass) {
		uint32_t size = md->size();
		for (uint32_t i = 0; i + 1 < size; i += 2) {
			Object* key = md->slot(i);
			if (key == (Object*)this->_nilObj)
				return nullptr;
			if (key == symbol)
				return md->slot(i + 1);
		}
		return nullptr;
	}

	// Hashed MethodDictionary lookup (InlinedHashTable: key-value pairs in indexed slots)
	// The table is an InlinedHashTable, a subclass of HashTable which extends Array
	// with a named ivar `policy` at slot(0). Indexed key-value pairs start at slot(1).
	auto table = this->dictionaryTable_(md);
	for (int index = 2; index < table->size(); index += 2) { 
		if (table->slotAt_(index) == symbol)
			return table->slotAt_(index + 1);
    }
	return nullptr;
}

Object* Runtime::existingSymbolFrom_(const std::string &selector) {
    return _symbolProvider->existingSymbolFor_(selector);
}
    
HeapObject* Runtime::lookupAssociationFor_in_(Object *symbol, HeapObject *dictionary) {
    auto table = this->dictionaryTable_(dictionary);
    for (int index = 2; index <= table->size(); index++) {
        auto assoc = table->slotAt_(index)->asHeapObject();
        if (assoc != this->_nilObj) {
            auto key = assoc->slotAt_(1);
           if (key == symbol)
                return assoc;
        }
    }
    return nullptr;
}

void Runtime::flushDispatchCache_(Object *aSymbol) {

    auto iter = _inlineCaches.find(aSymbol);
    if (iter != _inlineCaches.end()) {
        auto messages = iter->second;
        for (auto& m : *messages) {
            m->flushCache();
        }
    }

    std::vector<gced_global_cache_key> cached;
    for (const auto& entry : _globalCache) {
        if (entry.first.first->get() == aSymbol) {
            cached.push_back(entry.first);
        }
    }

    for (const auto& key : cached) {
        _globalCache.erase(key);
    }
}

void Runtime::flushDispatchCache_in_(Object *aSymbol, HeapObject *klass) {

    HeapObject *behavior = this->speciesInstanceBehavior_(klass);

    auto iter = _inlineCaches.find(aSymbol);
    if (iter != _inlineCaches.end()) {
    
        auto messages = iter->second;
        for (auto& m : *messages) {
            m->flushCache();
        }
    }

    global_cache_key pair = std::make_pair(aSymbol, (Object*)behavior);
    auto globalIter = _globalCache.find(pair);
    if (globalIter != _globalCache.end())
        _globalCache.erase(globalIter);
}

uintptr_t Runtime::assignGCedRefIndex() {
    if (_freeGCedRefs.empty())
    {
        auto index = _gcedRefs.size();
        _gcedRefs.push_back(nullptr);
        return index;
    }
    else
    {
        auto index = _freeGCedRefs.back();
        _freeGCedRefs.pop_back();
        return index;
    }
}

void Runtime::registerGCedRef_(GCedRef *gcedRef) {
    _gcedRefs[gcedRef->index()] = gcedRef;
}

GCedRef * Runtime::createGCedRef_(Object *object) {

    auto index = this->assignGCedRefIndex();
    GCedRef *result = new GCedRef(object, index);

    return result;
}

void Runtime::releaseGCedRef_(uintptr_t index) {
    _freeGCedRefs.push_back(index);
    _gcedRefs[index] = nullptr;
}

void Runtime::gcedRefsDo_(const std::function<void(GCedRef *)> &aBlock)
{
    for (auto ref : _gcedRefs)
    {
        if (ref != nullptr)
            aBlock(ref);
    }
}

std::string Egg::Runtime::print_(HeapObject *obj) {
	auto species = this->behaviorClass_(obj->behavior());
	if (species == _stringClass)
		return "'" + obj->asLocalString() + "'";
	if (species == _methodClass || species == _ffiMethodClass)
	{
        auto selector = (HeapObject*)obj->slot(Offsets::MethodSelector);
		auto s = (selector == _nilObj) ? "nil" : selector->asLocalString();
		return "" + (this->methodClassBinding_(obj)->printString()) +
				">>#" + s + "";
    }

    if (species == _blockClass) {
        auto method = this->blockMethod_(obj);
        auto index = this->blockNumber_(obj);
        return "block " + std::to_string(index) + " of " + method->printString();
    }

    if (species == _behaviorClass) {
        return speciesLocalName_(this->behaviorClass_(obj)) + " behavior";
    }

    if (speciesIsMetaclass_(species)) // then obj is a class
    {
        return "" + speciesLocalName_(obj) + "";
    }

    if (species == _metaclassClass) {
        return this->metaclassInstanceClass_(obj)->printString() + " class";
    }

	auto name = this->speciesLocalName_(species);
	if (name == "Symbol")
		return "#" + obj->asLocalString() + "";
	
    return "a " + name + "";
 }


// Color codes for different log levels
#define RESET   "\033[0m"
#define RED     "\033[31m"
#define YELLOW  "\033[33m"
#define GREEN   "\033[32m"
#define BLUE    "\033[34m"
#define MAGENTA "\033[35m"
#define CYAN    "\033[36m"

void Runtime::log_code_(std::string &message, uintptr_t level)
{
    std::ofstream logFile("error-log.txt", std::ios_base::app); // Open log file in append mode

    CRLFStream lfout(std::cout);

    switch(level) {
        case 0: // TRACE
            lfout << BLUE << "[trace] " + message; break;
        case 1: // DEBUG
            lfout << GREEN << message; break;
        case 2: // INFO
            lfout << message; break;
        case 3: // WARN
            lfout << YELLOW << "[warn] " + message;
            break;
        case 4: // ERROR
            lfout.setStream(std::cerr);
            lfout << RED << "[error] " + message;
            break;
        case 5: // FATAL
            lfout.setStream(std::cerr);
            lfout << MAGENTA << "[FATAL] " + message;
            break;
        default:
            return; // Invalid level
    }

    // Also write to file for all error levels
    if (level > 4) {
        logFile << "[LEVEL " << level << "] " << message;
    }
}

