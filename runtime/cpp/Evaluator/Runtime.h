#ifndef _RUNTIME_H_
#define _RUNTIME_H_

#include <KnownObjects.h>
#include <vector>
#include <map>
#include <functional>

#include "HeapObject.h"
#include "ImageSegment.h"
#include "KnownConstants.h"
#include "PlatformCode.h"
#include "GCedRef.h"

namespace Egg {

class Evaluator;
class SAbstractMessage;
class GCHeap;
class SExpression;
class Runtime;
class Bootstrapper;

extern Runtime *debugRuntime;

class Runtime {
	std::string printGlobalCache();
public:
	void checkCache();
    Bootstrapper *_bootstrapper;
    ImageSegment *_kernel;
    Evaluator *_evaluator;
    GCHeap *_heap;

    std::map<std::string, GCedRef*> _knownSymbols;

    //typedef std::vector<SAbstractMessage*> inline_cache;
    std::map<GCedRef*, std::vector <SAbstractMessage *> *, GCedRef::Comparator > _inlineCaches;

    typedef std::pair<GCedRef*,GCedRef*> gced_global_cache_key;
	typedef std::pair<Object*,Object*> global_cache_key;

    std::map<gced_global_cache_key, GCedRef*, GCedRef::Comparator> _globalCache;
    uint16_t _lastHash;

public:
    Runtime(Bootstrapper *bootstrapper, ImageSegment *kernel);

    std::string print_(HeapObject* obj);
    void log_code_(std::string &string, uintptr_t code);

    void initializeEvaluator();

	Object* sendLocal_to_(const std::string &selector, Object *receiver) {
        std::vector<Object*>args;
		return this->sendLocal_to_withArgs_(selector, receiver, args);
	}

	Object* sendLocal_to_withArgs_(const std::string &selector, Object *receiver, std::vector<Object*> &arguments);
    Object* sendLocal_to_with_(const std::string &selector, Object *receiver, Object *arg1);
    Object* sendLocal_to_with_with_(const std::string &selector, Object *receiver, Object *arg1, Object* arg2);
    
    Object* lookup_startingAt_(Object *symbol, HeapObject *behavior);
    Object* doLookup_startingAt_(Object *symbol, HeapObject *behavior);
    Object* methodFor_in_(Object *symbol, HeapObject *behavior);

    Object* existingSymbolFrom_(const std::string &selector);
    Object* symbolTableAt_(const std::string &selector);

    HeapObject* lookupAssociationFor_in_(Object *symbol, HeapObject *dictionary);

    void flushDispatchCache_(Object *aSymbol);
    void flushDispatchCache_in_(Object *aSymbol, HeapObject *klass);

    HeapObject* newDouble_(double value) {
        auto result = newBytes_size_(_floatClass, sizeof(double));
        *((double*)result) = value;
        return result;
    }
    
    SmallInteger* newInteger_(intptr_t value) {
        return SmallInteger::from(value);
    }

    uintptr_t arrayedSizeOf_(Object *anObject);


    HeapObject* newBytes_size_(HeapObject* species, uint32_t size);
    HeapObject* newSlots_size_(HeapObject *species, uint32_t size);
    HeapObject* newSlotsOf_(HeapObject* species);
    HeapObject* newOf_sized_(HeapObject* species, uint32_t size);

    HeapObject* newArray_(std::vector<Object*> &elems);
    HeapObject* newArray_(std::vector<HeapObject*> &elems);// needed because HeapObject is not a subclass of Object. Should it be?
    HeapObject* newArraySized_(uint32_t);
    HeapObject* newClosureFor_(HeapObject *block);
    HeapObject* newCompiledMethod();
    HeapObject* newEnvironmentSized_(uint32_t);

    HeapObject* newExecutableCodeFor_with_(HeapObject *compiledCode, PlatformCode *platformCode);
    HeapObject* newString_(const std::string &str);
    HeapObject* addSymbol_(const std::string &str);
    void addKnownSymbol_(const std::string &str, Object *symbol) {
        _knownSymbols[str] = new GCedRef(symbol);
    }
    HeapObject* loadModule_(HeapObject *name);
	void addSegmentSpace_(ImageSegment *segment);

    uintptr_t hashFor_(Object *anObject);

	int16_t nextHash() {
		auto prev = this->_lastHash;
			auto shifted = this->_lastHash >> 1;
			this->_lastHash = (this->_lastHash & 1) == 0 ? shifted : shifted ^ 0xB9C8;
		if (this->_lastHash == 0) {
			return prev;
		}
			return this->_lastHash;
	}

    void registerCache_for_(SAbstractMessage *message, Object *symbol) {
        auto it = _inlineCaches.find(symbol);
        std::vector <SAbstractMessage*> *messages; 
        if (it == _inlineCaches.end())
        {
            messages = new std::vector<SAbstractMessage*>();
            _inlineCaches.insert({new GCedRef(symbol), messages});
        }
        else {
            messages = it->second;
        }

	    messages->push_back(message);
    }

    HeapObject* booleanFor_(bool aBoolean)
	{
        return aBoolean ? _trueObj : _falseObj;
    }

	Object* instanceVarOf_at_(HeapObject *receiver, int anInteger) {
		return receiver->slotAt_(anInteger);
	}

	void instanceVarOf_at_put_(HeapObject *receiver, int anInteger, Object *value) {
		receiver->slotAt_(anInteger) = value;
	}


    /// Field accessors
    Object* associationKey_(HeapObject *association) {
        return association->slot(Offsets::AssociationKey);
    }

    void associationKey_put_(HeapObject *association, Object *value) {
        association->slot(Offsets::AssociationKey) = value;
    }

    Object* associationValue_(HeapObject *association) {
        return association->slot(Offsets::AssociationValue);
    }

    void associationValue_put_(HeapObject *association, Object *value) {
        association->slot(Offsets::AssociationValue) = value;
    }

    HeapObject* behaviorClass_(HeapObject *behavior) {
        return behavior->slot(Offsets::BehaviorClass)->asHeapObject();
    }

    HeapObject* behaviorNext_(HeapObject *behavior) {
        return behavior->slot(Offsets::BehaviorNext)->asHeapObject();
    }

    HeapObject* behaviorMethodDictionary_(HeapObject *behavior) {
        return behavior->slot(Offsets::BehaviorMethodDictionary)->asHeapObject();
    }

    HeapObject* behaviorOf_(Object *anObject) {
	    return anObject->isSmallInteger() ? this->_smallIntegerBehavior : anObject->asHeapObject()->behavior();
    }

    int blockArgumentCount_(HeapObject *block) {
        return (this->blockFlags(block) & 0x3F);
    }

    int blockTempCount_(HeapObject *block) {
	    return ((this->blockFlags(block) & 0x3FC0) >> 6);
	}

    int blockNumber_(HeapObject *block) {
	    return ((this->blockFlags(block) & 0x3FC000) >> 14);
	}

    intptr_t blockFlags(HeapObject *block) {
        return block->slot(Offsets::MethodFormat)->asSmallInteger()->asNative();
    }

    bool blockCapturesHome_(HeapObject *block) {
        return (this->blockFlags(block) & BlockFlags::CapturesHome) != 0;
    }

    bool blockCapturesSelf_(HeapObject *block) {
        return (this->blockFlags(block) & BlockFlags::CapturesSelf) != 0;  
    }

    int blockEnvironmentCount_(HeapObject *block) {
        return ((this->blockFlags(block) >> 24) & 0x7F);
    }

    HeapObject* blockExecutableCode_(HeapObject *block) {
        return methodExecutableCode_(block);
    }

    void blockExecutableCode_put_(HeapObject* block, HeapObject *anObject) {
        return methodExecutableCode_put_(block, anObject);
    }

    HeapObject* closureBlock_(HeapObject *closure) {
        return closure->slot(Offsets::ClosureBlock)->asHeapObject();
    }

    HeapObject* closureHome_(HeapObject *closure) {
		return closure->slot(Offsets::ClosureHome)->asHeapObject();
		/*
        auto block = this->closureBlock_(closure);
        if (!this->blockCapturesHome_(block))
		    error("closure has no home");
        
	    return (this->blockCapturesSelf_(block)) ?
            closure->slotAt_(_closureInstSize + 2)->asHeapObject() :
		    closure->slotAt_(_closureInstSize + 1)->asHeapObject();
		    */
    }

	void closureHome_put_(HeapObject *closure, Object *anObject)
	{
		closure->slot(Offsets::ClosureHome) = anObject;
	}

    HeapObject::ObjectSlot& closureIndexedSlotAt_(HeapObject *closure, int index) {
	    return closure->slotAt_(_closureInstSize + index);
	}

    HeapObject::ObjectSlot& environmentIndexedSlotAt_(HeapObject *closureOrArray, int index) {
	    return closureOrArray->isNamed() ? this->closureIndexedSlotAt_(closureOrArray, index) : closureOrArray->slotAt_(index);
	}

    HeapObject::ObjectSlot& indexedSlotAt_(HeapObject *anObject, int index) {
	    auto slot = anObject->isNamed() ?
	        index + (int)this->speciesInstanceSize_(this->speciesOf_((Object*)anObject)) :
	        index;
	    return anObject->slotAt_(slot);
	}

    HeapObject* compiledCodeExecutableCode_(HeapObject *block) {
        return block->slot(Offsets::CompiledCodeExecutableCode)->asHeapObject();
    }

    Object* executableCodePlatformCode_(HeapObject *code) {
		return code->slot(Offsets::ExecutableCodePlatformCode);
    }

    void executableCodePlatformCode_put_(HeapObject *code, PlatformCode *platformCode) {
        auto smi = SmallInteger::smallpointerFrom((void*)platformCode);
        code->slot(Offsets::ExecutableCodePlatformCode) = (Object*)smi;
    }

    HeapObject* executableCodeCompiledCode_(HeapObject *code) {
        return code->slot(Offsets::ExecutableCodeCompiledCode)->asHeapObject();
    }

    PlatformCode* executableCodeWork_(HeapObject *code) {
        auto slot = this->executableCodePlatformCode_(code);
		return (PlatformCode*)slot->asSmallInteger()->asObject();
    }

    void executableCodeCompiledCode_put_(HeapObject *code, HeapObject *compiledCode) {
        code->slot(Offsets::ExecutableCodeCompiledCode) = (Object*)compiledCode;
    }

    HeapObject* blockMethod_(HeapObject* block) {
        return block->slot(Offsets::BlockMethod)->asHeapObject();
    }

    HeapObject* dictionaryTable_(HeapObject* dictionary) {
        return dictionary->slot(Offsets::DictionaryTable)->asHeapObject();
    }

    int argumentCountOf_(HeapObject *code) {
	    return this->isBlock_(code) ?
	        this->blockArgumentCount_(code) :
	        this->methodArgumentCount_(code);
	}

    int temporaryCountOf_(HeapObject *code) {
	    return this->isBlock_(code) ?
            this->blockTempCount_(code) :
            this->methodTempCount_(code);
	}
    bool isBlock_(HeapObject *compiledCode) {
        return this->behaviorClass_(compiledCode->behavior()) == this->_blockClass;
    }

    int methodArgumentCount_(HeapObject *method) {
        return (this->methodFlags(method) & MethodFlags::MethodArgCount);
    }

    int methodTempCount_(HeapObject *method) {
        return (this->methodFlags(method) & MethodFlags::MethodTempCount) >> MethodFlags::MethodTempCountShift;
    }

    bool methodIsExtension_(HeapObject *method) {
	    return this->methodFlags(method) & MethodFlags::MethodIsExtension;
	}

    HeapObject* methodTreecodes_(HeapObject *method) {
        return method->slot(Offsets::MethodTreecodes)->asHeapObject();
    }
    Object* method_literalAt_(HeapObject *method, intptr_t index) {
        return method->slot(Offsets::MethodInstSize + index - 1);
    }

    HeapObject* methodClassBinding_(HeapObject *method) {
        return method->slot(Offsets::MethodClassBinding)->asHeapObject();
    }

    intptr_t methodFlags(HeapObject *method) {
        return method->slot(Offsets::MethodFormat)->asSmallInteger()->asNative();
    }

    int methodEnvironmentSize_(HeapObject *method) {
        return ((this->methodFlags(method) >> 25) & 0x3F);
    }

    int methodNeedsEnviornment_(HeapObject *method) {
		return this->methodFlags(method) & MethodFlags::MethodNeedsEnvironment;
    }

    HeapObject* methodExecutableCode_(HeapObject *method) {

        return method->slot(Offsets::CompiledCodeExecutableCode)->asHeapObject();
    }

    void methodExecutableCode_put_(HeapObject *method, HeapObject *executableCode) {
        method->slot(Offsets::CompiledCodeExecutableCode) = (Object*)executableCode;
    }

    HeapObject* methodExtensionModule_(HeapObject *method) {
        return this->associationValue_(method->slotAt_(method->size())->asHeapObject())->asHeapObject();
    }

    HeapObject* methodModule_(HeapObject * method) {
	    if (this->methodIsExtension_(method)) {
            return this->methodExtensionModule_(method);
	    }
	    else {
	        auto species = this->methodClassBinding_(method);
	        return this->speciesModule_(species);
	    }
	}

    Object* methodSelector_(HeapObject *method) {
        return method->slot(Offsets::MethodSelector);
    }

    bool methodIsFFI_(HeapObject *method) {
	    return this->speciesOf_((Object*)method) == _ffiMethodClass;
	}

    Object* ffiMethodAddress_(HeapObject * method) {
	    return method->slot(Offsets::FFIMethodAddress);
	}

    void ffiMethodAddress_put_(HeapObject * method, SmallInteger *address) {
	    method->slot(Offsets::FFIMethodAddress) = (Object*)address;
	}

    HeapObject* ffiMethodDescriptor_(HeapObject * method) {
	    return method->slot(Offsets::FFIMethodDescriptor)->asHeapObject();
	}

    HeapObject* ffiMethodSymbol_(HeapObject * method) {
	    return method->slot(Offsets::FFIMethodSymbol)->asHeapObject();
	}

    HeapObject* moduleNamespace_(HeapObject *module) {
        return module->slot(Offsets::ModuleNamespace)->asHeapObject();
    }

	HeapObject* moduleName_(HeapObject *module) {
		return module->slot(Offsets::ModuleName)->asHeapObject();
	}

    HeapObject* classModule_(HeapObject *class_) {
        return class_->slot(Offsets::ClassModule)->asHeapObject();
    }

    HeapObject* className_(HeapObject *class_) {
        return class_->slot(Offsets::ClassName)->asHeapObject();
    }

    HeapObject* classNamespaces_(HeapObject *class_) {
        return class_->slot(Offsets::ClassNamespaces)->asHeapObject();
    }

	HeapObject* metaclassInstanceClass_(HeapObject *metaclass) {
		return metaclass->slot(Offsets::MetaclassClass)->asHeapObject();
	}
    
    HeapObject* speciesOf_(Object *object) {
		auto behavior = this->behaviorOf_(object);
		return this->behaviorClass_(behavior);
	}

	HeapObject* speciesInstanceClass_(HeapObject *species) {
		return this->speciesIsMetaclass_(species) ? this->metaclassInstanceClass_(species) : species;
	}

	uint8_t speciesInstanceSize_(HeapObject *species) {
		return this->speciesFormat_(species)->asNative() & 0x7F;
	}

    HeapObject* speciesInstanceVariables_(HeapObject *species) {
        return species->slot(Offsets::SpeciesInstanceVariables)->asHeapObject();
    }

	bool speciesIsBytes_(HeapObject *species) {
		return !(this->speciesFormat_(species)->asNative() & 0x4000);
	}

	bool speciesIsMetaclass_(HeapObject *species) {
		return this->speciesOf_((Object*)species) == this->_metaclassClass;
	}

    std::string speciesLocalName_(HeapObject *species) {
		if (!this->speciesIsMetaclass_(species))
            return this->className_(species)->asLocalString();

		auto _class = this->metaclassInstanceClass_(species);
		return this->className_(_class)->asLocalString() + " class";
	}

	HeapObject* speciesModule_(HeapObject *species) {
		return this->classModule_(this->speciesInstanceClass_(species));
	}

    HeapObject* speciesInstanceBehavior_(HeapObject *species) {
        return species->slot(Offsets::SpeciesInstanceBehavior)->asHeapObject();
    }

    HeapObject* speciesNamespaces_(HeapObject *species) {
		return this->classNamespaces_(this->speciesInstanceClass_(species));
    }

    HeapObject* speciesSuperclass_(HeapObject *species) {
        return species->slot(Offsets::SpeciesSuperclass)->asHeapObject();
    }

    SmallInteger* speciesFormat_(HeapObject *species) {
        return species->slot(Offsets::SpeciesFormat)->asSmallInteger();
    }

    HeapObject* superBehaviorOf_(HeapObject *species) {
        auto superclass = this->speciesSuperclass_(species);
	    return this->speciesInstanceBehavior_(superclass);
    }

	HeapObject* processStack_(HeapObject *process) {
		return process->slot(Offsets::ProcessNativeStack)->asHeapObject();
	}

	bool processStackIsValid_(HeapObject *process) {
		return process->slot(Offsets::ProcessTopContext) != (Object*)KnownObjects::nil;
	}

	HeapObject* processVMStackProcess_(HeapObject * processVMStack) {
		return processVMStack->slot(Offsets::ProcessVMStackProcess)->asHeapObject();
	}

	uintptr_t processVMStackSP_(HeapObject * processVMStack) {
		return processVMStack->slot(Offsets::ProcessVMStackSP)->asSmallInteger()->asNative();
	}

	uintptr_t processVMStackBP_(HeapObject * processVMStack) {
		return processVMStack->slot(Offsets::ProcessVMStackBP)->asSmallInteger()->asNative();
	}

	void initializeKernelObjects()
	{
		this->_falseObj =                  _kernel->_exports["false"];
		this->_trueObj =                   _kernel->_exports["true"];
		this->_nilObj =                    _kernel->_exports["nil"];
		this->_arrayClass =                _kernel->_exports["Array"];
		this->_metaclassClass =            _kernel->_exports["Metaclass"];
		this->_methodClass =               _kernel->_exports["CompiledMethod"];
		this->_ffiMethodClass =            nullptr; // initialized lazily after FFI module is loaded
		this->_smallIntegerClass =         _kernel->_exports["SmallInteger"];
		this->_largePositiveIntegerClass = _kernel->_exports["LargePositiveInteger"];
		this->_largeNegativeIntegerClass = _kernel->_exports["LargeNegativeInteger"];
		this->_floatClass =                _kernel->_exports["Float"];
		this->_blockClass =                _kernel->_exports["CompiledBlock"];
		this->_byteArrayClass =            _kernel->_exports["ByteArray"];
		this->_stringClass =               _kernel->_exports["String"];
		this->_closureClass =              _kernel->_exports["Closure"];
		this->_closureInstSize =           this->speciesInstanceSize_(this->_closureClass);
		this->_behaviorClass =             _kernel->_exports["Behavior"];
	    this->_ephemeronClass =            _kernel->_exports["Ephemeron"];
		this->_processStackClass =         _kernel->_exports["ProcessVMStack"];
        this->_symbolTable =               _kernel->_exports["SymbolTable"];

        this->_smallIntegerBehavior = this->speciesInstanceBehavior_(_smallIntegerClass);
	}

	void initializeClosureReturnMethod()
	{
		auto symbol = this->addSymbol_("return:");
		auto behavior = this->speciesInstanceBehavior_(_closureClass);
		this->_closureReturnMethod = this->lookup_startingAt_((Object*)symbol, behavior)->asHeapObject();
	}

    HeapObject *_falseObj;
    HeapObject *_trueObj;
    HeapObject *_nilObj;
    HeapObject *_arrayClass;
    HeapObject *_metaclassClass;
    HeapObject *_methodClass;
    HeapObject *_ffiMethodClass;
    HeapObject *_smallIntegerClass;
    HeapObject *_largePositiveIntegerClass;
    HeapObject *_largeNegativeIntegerClass;
    HeapObject *_floatClass;
    HeapObject *_blockClass;
    HeapObject *_byteArrayClass;
    HeapObject *_stringClass;
    HeapObject *_closureClass;
    int _closureInstSize;
    HeapObject *_behaviorClass;
	HeapObject *_ephemeronClass;
	HeapObject *_processStackClass;
    HeapObject *_symbolTable;
	HeapObject *_closureReturnMethod;

    HeapObject *_smallIntegerBehavior;

	// API and state needed to alloc and free GCedRefs

	uintptr_t assignGCedRefIndex();
	void registerGCedRef_(GCedRef *gcedRef);
	GCedRef* createGCedRef_(Object * object);
	void releaseGCedRef_(uintptr_t index);
	void gcedRefsDo_(const std::function<void(GCedRef *)> &aBlock);


	std::vector<GCedRef*> _gcedRefs;
	std::vector<uintptr_t> _freeGCedRefs;

};

} // namespace Egg

#endif // ~ _RUNTIME_H_ ~
