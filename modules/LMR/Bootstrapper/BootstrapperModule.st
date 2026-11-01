"
	Copyright (c) 2025, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #BootstrapperModule,
	#superclass : #Module,
	#instVars : [
		'codeSegments',
		'environment',
		'kernelOverrides',
		'replacements',
		'roots'
	],
	#category : #'LMR-Bootstrapper'
}

{ #category : #spec }
BootstrapperModule >> imports [
	^{
		#Kernel -> #(OrderedCollection IdentityDictionary Object Magnitude ProtoObject SmallInteger CallbackBehavior MethodDictionary).
		#'Kernel.LMR' -> #(LMRProtoObject).
		#LMR -> #(Memory NativeCode SendSite GCSpace CriticalArray).
		#'LMR.Nativizer' -> #(NativizerModule NativizationPlatform NativizationEnvironment LookupNativizer LookupLinker)
	}
]

{ #category : #running }
BootstrapperModule >> main: args [
	| lmrModule nativizer platform names |
	names := args allButFirst: 2.
	roots := names collect: [:name | Kernel load: name asSymbol].
	lmrModule := Memory module.
	nativizer := NativizerModule module.
	platform := NativizationPlatform host.
	self
		bootstrapLMR: lmrModule nativizer: nativizer platform: platform;
		writeSegments.
]

{ #category : #running }
BootstrapperModule >> __start__ [
	<callback: slong ()>
	^42
]

{ #category : #bootstrapping }
BootstrapperModule >> bootstrapLMR: anLMRModule nativizer: aNativizerModule platform: aPlatform [
	| env |

	env := aNativizerModule newNativizationEnvironmentFor: aPlatform.
	env lmrModule: anLMRModule.

	SendSite lmr: anLMRModule.
	self
		initializeGlobalsFor: anLMRModule;
		nativizeInvokeFor: anLMRModule env: env nativizer: aNativizerModule;
		nativizeWriteBarrierFor: anLMRModule env: env nativizer: aNativizerModule;
		nativizeLookupFor: anLMRModule env: env nativizer: aNativizerModule;
		nativizeSendSiteStubs: env.

	env initializeLinkersFor: anLMRModule; completeInitialization.
	environment := env.
	kernelOverrides := self kernelOverrides.
	self nativizeEntriesOf: self with: env.
	roots do: [:module | self nativizeEntriesOf: module with: env]
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeEntriesOf: aModule with: env [
	aModule class methodDictionary do: [:method |
		method isCallback ifTrue: [self nativizeEntry: method of: aModule with: env]]
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeEntry: aCompiledMethod of: aModule with: env [
	| code machineCode original behavior |
	code := aCompiledMethod copy.
	code receiver: aModule.
	env nativize: code.
	machineCode := code optimizedCode code.
	original := machineCode behavior.
	behavior := CallbackBehavior new
		classBinding: original classBinding;
		methods: MethodDictionary new;
		next: original;
		nativeCode: code optimizedCode;
		yourself.
	machineCode behavior: behavior.
	aModule export: code optimizedCode as: aCompiledMethod selector.
	(self codeSegmentOf: aModule) add: machineCode
]

{ #category : #bootstrapping }
BootstrapperModule >> initializeGlobalsFor: anLMRModule [
	| placeholders |
	placeholders := anLMRModule class globalNames
		collect: [:name | NativeCode new code: name , ' placeholder'].
	anLMRModule
		globals: placeholders;
		globalNamed: #SmallIntegerBehavior put: SmallInteger instanceBehavior
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeInvokeFor: anLMRModule env: env nativizer: aNativizerModule [
	| nativeCode |
	nativeCode := env nativizeOptimizing: (SendSite >> #_invokeOn:) copy.
	anLMRModule mapGlobal: #Invoke to: nativeCode
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeLookupFor: anLMRModule env: env nativizer: aNativizerModule [
	| nativizer lookup lookupSuper |
	nativizer := LookupNativizer new
		nativizer: env;
		nativizeMethods.
	lookup := nativizer methodFor: #_dispatchOn:.
	lookupSuper := nativizer methodFor: #_dispatchOn:startingAt:.
	anLMRModule
		mapGlobal: #Lookup to: lookup optimizedCode;
		mapGlobal: #LookupSuper to: lookupSuper optimizedCode
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeWriteBarrierFor: anLMRModule env: env nativizer: aNativizerModule [
	| map inlined barrier dispatcher |
	map := {
		(Memory class -> #(current)).
		(Memory -> #(isYoung: isYoungSafe: remember:)).
		(CriticalArray -> #(unsafeAdd: #unsafeAt:put:)).
		(Magnitude -> #(#between:and:))
	}.
	inlined := aNativizerModule methodSubset: map.
	inlined addAll: aNativizerModule undermethods.
	barrier := (LMRProtoObject >> #holdRefererIfNeeded:) copy.
	LookupNativizer new nativizer: env; nativizeMethods.
	dispatcher := LookupLinker new initializeFrom: anLMRModule.
	NativizationEnvironment new
		platform: env platform;
		inlinedMethods: inlined;
		messageLinker: dispatcher;
		lmrModule: anLMRModule;
		completeInitialization;
		nativizeOptimizing: barrier.
	anLMRModule mapGlobal: #WriteBarrier to: barrier optimizedCode.
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeSendSiteStubs: env [
	| mic pic |
	mic := self nativizeMonomorphicCacheWith: env.
	pic := self nativizePolymorphicCacheWith: env.
	env lmrModule micStub: mic; picStub: pic.
	(self codeSegmentOf: env lmrModule) add: mic; add: pic
]

{ #category : #initialization }
BootstrapperModule >> justLoaded [
	super justLoaded.
	codeSegments := IdentityDictionary new.
	roots := #()
]

{ #category : #snapshotting }
BootstrapperModule >> codeSegmentOf: aModule [
	^codeSegments at: aModule ifAbsentPut: [OrderedCollection new]
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeMonomorphicCacheWith: env [
	| asm lookup next smiIndex lookupIndex cacheIndex |
	asm := env newAssembler.
	lookup := asm newLabel.
	smiIndex := env lmrModule indexOfGlobal: #SmallIntegerBehavior.
	lookupIndex := env lmrModule indexOfGlobal: #Lookup.
	cacheIndex := SendSite indexOfSlot: 'cache'.
	asm
		loadTwithAindex: cacheIndex;
		loadSwithGindex: smiIndex.
	next := asm labeledNonIntegerBitTestOfR.
	asm
		loadSwithRbehavior;
		@ next;
		compareSwithTindex: 1;
		shortJumpIfNotEqualTo: lookup;
		loadMwithTindex: 2;
		jumpToMindex: 1;
		@ lookup;
		loadMwithGindex: lookupIndex;
		jumpToMindex: 1;
		applyFixups.
	^asm nativeCode code
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizePolymorphicCacheWith: env [
	| asm smi lookupIndex cacheIndex case2 case3 case4 case5 case6 case7 lookup |
	asm := env newAssembler.
	case2 := asm newLabel.
	case3 := asm newLabel.
	case4 := asm newLabel.
	case5 := asm newLabel.
	case6 := asm newLabel.
	case7 := asm newLabel.
	lookup := asm newLabel.
	lookupIndex := env lmrModule indexOfGlobal: #Lookup.
	cacheIndex := SendSite indexOfSlot: 'cache'.
	asm loadTwithAindex: cacheIndex.
	smi := asm labeledNonIntegerBitTestOfR.
	asm
		loadSwithRbehavior;
		compareSwithTindex: 1;
		shortJumpIfNotEqualTo: case2;
		loadMwithTindex: 2;
		jumpToMindex: 1;
		@ case2;
		compareSwithTindex: 3;
		shortJumpIfNotEqualTo: case3;
		loadMwithTindex: 4;
		jumpToMindex: 1;
		@ case3;
		compareSwithTindex: 5;
		shortJumpIfNotEqualTo: case4;
		loadMwithTindex: 6;
		jumpToMindex: 1;
		@ case4;
		compareSwithTindex: 7;
		shortJumpIfNotEqualTo: case5;
		loadMwithTindex: 8;
		jumpToMindex: 1;
		@ case5;
		compareSwithTindex: 9;
		shortJumpIfNotEqualTo: case6;
		loadMwithTindex: 10;
		jumpToMindex: 1;
		@ case6;
		compareSwithTindex: 11;
		shortJumpIfNotEqualTo: case7;
		loadMwithTindex: 12;
		jumpToMindex: 1;
		@ case7;
		compareSwithTindex: 13;
		shortJumpIfNotEqualTo: lookup;
		loadMwithTindex: 14;
		jumpToMindex: 1;
		@ lookup;
		loadMwithGindex: lookupIndex;
		jumpToMindex: 1;
		@ smi;
		loadMwithTindex: 15;
		jumpToMindex: 1;
		applyFixups.
	^asm nativeCode code
]

{ #category : #writing }
BootstrapperModule >> writeSegments [
	| all closure |
	all := {
		Memory module.                 "LMR"
		NativizerModule module.        "LMR.Nativizer"
		self class module.             "LMR.Bootstrapper"
	} , roots.
	closure := self importsClosureFor: all.
	Kernel load: #'ImageSegmentBuilder.Native'.
	closure do: [:module | self writeSegmentOf: module].
]

{ #category : #snapshotting }
BootstrapperModule >> writeSegmentOf: aModule [
	| filename builder code |
	filename := 'image-segments/lmr/' , aModule name , '.ems'.
	builder := self segmentBuilderFor: aModule.
	code := codeSegments at: aModule ifAbsent: [#()].
	code do: [:bytes | builder addCode: bytes].
	aModule writeCachedSegmentAt: filename with: builder
]

{ #category : #snapshotting }
BootstrapperModule >> prepareForSnapshot: aBuilder [
	"bootstrap state, not part of the segment"
	super prepareForSnapshot: aBuilder.
	aBuilder
		map: codeSegments to: nil;
		map: environment to: nil;
		map: kernelOverrides to: nil;
		map: replacements to: nil;
		map: roots to: nil
]

{ #category : #snapshotting }
BootstrapperModule >> importsClosureFor: roots [
	
	| kernel seen result pending |
	kernel := ProtoObject module.   "the KernelModule singleton"
	seen := IdentityDictionary new.
	result := OrderedCollection new.
	pending := OrderedCollection new.
	roots do: [:m | pending add: m].
	[pending isEmpty] whileFalse: [
		| m |
		m := pending removeFirst.
		(seen at: m ifAbsent: [nil]) isNil ifTrue: [
			seen at: m put: m.
			result add: m.
			m imports do: [:descriptor |
				| dep |
				dep := kernel loadedModuleNamed: descriptor key.
				dep isNil ifFalse: [pending add: dep]]]].
	^result
]

{ #category : #writing }
BootstrapperModule >> segmentBuilderFor: aModule [
	| builder |
	builder := aModule newSegmentBuilder.
	(self requiresNativization: aModule) ifTrue: [builder nativizer: environment].
	aModule == Kernel ifTrue: [self addKernelOverridesTo: builder].
	^builder
]

{ #category : #writing }
BootstrapperModule >> requiresNativization: aModule [
	^({Kernel. LMRProtoObject module. Memory module} includes: aModule) or: [roots includes: aModule]
]

{ #category : #writing }
BootstrapperModule >> addKernelOverridesTo: aBuilder [
	kernelOverrides do: [:each | aBuilder override: each key with: each value].
	replacements keysAndValuesDo: [:method :copy | aBuilder map: method to: copy]
]

{ #category : #bootstrapping }
BootstrapperModule >> kernelOverrides [
	| overrides lmr |
	overrides := OrderedCollection new.
	replacements := IdentityDictionary new.
	lmr := LMRProtoObject module.
	lmr classes do: [:replacement | | target |
		target := replacement superclass.
		(replacement !== lmr class and: [target module == Kernel])
			ifTrue: [
				self addOverridesFrom: replacement to: target into: overrides.
				self addOverridesFrom: replacement class to: target class into: overrides]].
	self addExtensionsOf: Memory module into: overrides.
	^overrides
]

{ #category : #bootstrapping }
BootstrapperModule >> addExtensionsOf: aModule into: aCollection [
	aModule extensions keysAndValuesDo: [:key :methods | | meta name class target |
		meta := key endsWith: ' class'.
		name := meta ifTrue: [(key trimTail: ' class') asSymbol] ifFalse: [key].
		class := aModule namespace at: name.
		target := meta ifTrue: [class class] ifFalse: [class].
		self addExtensions: methods of: target into: aCollection]
]

{ #category : #bootstrapping }
BootstrapperModule >> addExtensions: aCollection of: aClass into: anOrderedCollection [
	aCollection do: [:method | | copy |
		copy := (aClass compiledMethodAt: method selector) copy.
		self add: copy replacing: method into: anOrderedCollection]
]

{ #category : #bootstrapping }
BootstrapperModule >> addOverridesFrom: aClass to: anotherClass into: aCollection [
	aClass methodDictionary do: [:method | | copy |
		copy := method copy.
		copy classBinding: anotherClass.
		self add: copy replacing: method into: aCollection]
]

{ #category : #bootstrapping }
BootstrapperModule >> add: aCompiledMethod replacing: anotherMethod into: aCollection [
	environment nativize: aCompiledMethod.
	replacements at: anotherMethod put: aCompiledMethod.
	aCollection add: aCompiledMethod classBinding -> aCompiledMethod
]
