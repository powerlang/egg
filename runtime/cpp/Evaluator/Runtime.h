#ifndef _POWERTALKRUNTIME_H_
#define _POWERTALKRUNTIME_H_

#include <vector>
#include <map>

#include "../HeapObject.h"
#include "../ImageSegment.h"
#include "../KnownConstants.h"

namespace Egg {

class Evaluator;


class Runtime {
    ImageSegment *_kernel;
    Evaluator *_evaluator;
    std::map<std::string, HeapObject*> _knownSymbols;

    typedef std::vector<HeapObject*> inline_cache;
    std::map<HeapObject*, std::vector <inline_cache *> * > _inlineCaches;

    typedef std::pair<HeapObject*,HeapObject*> global_cache_key;
    std::map<global_cache_key, HeapObject*> _globalCache;
    uint16_t _lastHash;

public:
    Runtime(ImageSegment *kernel) : _kernel(kernel), _lastHash(0) {
        this->initializeKernelObjects();
    }

    void initializeEvaluator();

	Object* sendLocal_to_(const std::string &selector, Object *receiver) {
        std::vector<Object*>args;
		return this->sendLocal_to_with_(selector, receiver, args);
	}

	Object* sendLocal_to_with_(const std::string &selector, Object *receiver, std::vector<Object*> &arguments);
    
    HeapObject* lookup_startingAt_(HeapObject *symbol, HeapObject *behavior);
    HeapObject* doLookup_startingAt_(HeapObject *symbol, HeapObject *behavior);
    HeapObject* methodFor_in_(HeapObject *symbol, HeapObject *behavior);

    HeapObject* existingSymbolFrom_(const std::string &selector);

    HeapObject* lookupAssociationFor_in_(HeapObject *symbol, HeapObject *dictionary);

    SmallInteger* newInteger_(intptr_t value) {
        return SmallInteger::from(value);
    }

    HeapObject* newArraySized_(uint32_t);
    HeapObject* newCompiledMethod();
    HeapObject* newEnvironmentSized_(uint32_t);
    HeapObject* newExecutableCodeFor_(HeapObject *compiledCode, HeapObject *platformCode);

	int16_t nextHash() {
			auto shifted = this->_lastHash >> 1;
			this->_lastHash = (this->_lastHash & 1) == 0 ? shifted : shifted ^ 47560;
			return this->_lastHash;
	}

    void registerCache_for_(inline_cache *cache, HeapObject *symbol) {
        auto it = _inlineCaches.find(symbol);
        std::vector <inline_cache*> *messages; 
        if (it == _inlineCaches.end())
        {
            messages = new std::vector<inline_cache*>();
            _inlineCaches[symbol] = messages;
        }
        else {
            messages = it->second;
        }

	    messages->push_back(cache);
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

    void blockExecutableCode_put_(HeapObject* block, Object *anObject) {
        return methodExecutableCode_put_(block, anObject);
    }

    HeapObject* compiledCodeExecutableCode_(HeapObject *block) {
        return block->slot(Offsets::CompiledCodeExecutableCode)->asHeapObject();
    }

    HeapObject* executableCodePlatformCode_(HeapObject *code) {
        return code->slot(Offsets::ExecutableCodePlatformCode)->asHeapObject();
    }

    void executableCodePlatformCode_put_(HeapObject *code, Object *platformCode) {
        code->slot(Offsets::ExecutableCodePlatformCode) = platformCode;
    }

    HeapObject* executableCodeCompiledCode_(HeapObject *code) {
        return code->slot(Offsets::ExecutableCodeCompiledCode)->asHeapObject();
    }

    void executableCodeCompiledCode_put_(HeapObject *code, Object *compiledCode) {
        code->slot(Offsets::ExecutableCodeCompiledCode) = compiledCode;
    }

    HeapObject* blockMethod_(HeapObject* block) {
        return block->slot(Offsets::BlockMethod)->asHeapObject();
    }

    HeapObject* dictionaryTable_(HeapObject* dictionary) {
        return dictionary->slot(Offsets::DictionaryTable)->asHeapObject();
    }

    bool isBlock_(HeapObject *compiledCode) {
        return this->behaviorClass_(compiledCode->behavior()) == this->_blockClass;
    }

    int methodArgumentCount_(HeapObject *method) {
        return (this->methodFlags(method) & 0x3F);
    }

    int methodTempCount_(HeapObject *method) {
        return (this->methodFlags(method) & 0x1FE000) >> 13;
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

    HeapObject* methodExecutableCode_(HeapObject *method) {
        return method->slot(Offsets::CompiledCodeExecutableCode)->asHeapObject();
    }

    void methodExecutableCode_put_(HeapObject *method, Object *anObject) {
        method->slot(Offsets::CompiledCodeExecutableCode) = anObject;
    }

    HeapObject* moduleNamespace_(HeapObject *module) {
        return module->slot(Offsets::ModuleNamespace)->asHeapObject();
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

	void initializeKernelObjects()
	{
		this->_falseObj =                  _kernel->exports["false"];
		this->_trueObj =                   _kernel->exports["true"];
		this->_nilObj =                    _kernel->exports["nil"];
		this->_arrayClass =                _kernel->exports["Array"];
		this->_metaclassClass =            _kernel->exports["Metaclass"];
		this->_methodClass =               _kernel->exports["CompiledMethod"];
		this->_smallIntegerClass =         _kernel->exports["SmallInteger"];
		this->_largePositiveIntegerClass = _kernel->exports["LargePositiveInteger"];
		this->_largeNegativeIntegerClass = _kernel->exports["LargeNegativeInteger"];
		this->_blockClass =                _kernel->exports["CompiledBlock"];
		this->_byteArrayClass =            _kernel->exports["ByteArray"];
		this->_stringClass =               _kernel->exports["String"];
		this->_closureClass =              _kernel->exports["Closure"];
		this->_behaviorClass =             _kernel->exports["Behavior"];
        this->_symbolTable =               _kernel->exports["SymbolTable"];

        this->_smallIntegerBehavior = this->speciesInstanceBehavior_(_smallIntegerClass);
	}

    HeapObject *_falseObj;
    HeapObject *_trueObj;
    HeapObject *_nilObj;
    HeapObject *_arrayClass;
    HeapObject *_metaclassClass;
    HeapObject *_methodClass;
    HeapObject *_smallIntegerClass;
    HeapObject *_largePositiveIntegerClass;
    HeapObject *_largeNegativeIntegerClass;
    HeapObject *_blockClass;
    HeapObject *_byteArrayClass;
    HeapObject *_stringClass;
    HeapObject *_closureClass;
    HeapObject *_behaviorClass;
    HeapObject *_symbolTable;

    HeapObject *_smallIntegerBehavior;
};

} // namespace Egg

#endif // ~ _POWERTALKRUNTIME_H_ ~