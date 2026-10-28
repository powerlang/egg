"
	Copyright (c) 2025, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #BootstrapperModule,
	#superclass : #Module,
	#category : #'LMR-Bootstrapper'
}

{ #category : #spec }
BootstrapperModule >> imports [
	^{
		#Kernel -> #(OrderedCollection IdentityDictionary Object Magnitude ProtoObject SmallInteger CallbackBehavior).
		#'Kernel.LMR' -> #(LMRProtoObject).
		#LMR -> #(Memory NativeCode SendSite GCSpace CriticalArray).
		#'LMR.Nativizer' -> #(NativizerModule NativizationPlatform NativizationEnvironment LookupNativizer LookupLinker)
	}
]

{ #category : #running }
BootstrapperModule >> main: args [
	| lmrModule nativizer platform |
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
	self nativizeStartEntry: env.
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeStartEntry: env [
	| code machineCode original behavior |
	code := (BootstrapperModule >> #__start__) copy.
	env nativize: code.
	machineCode := code optimizedCode code.
	original := machineCode behavior.
	behavior := CallbackBehavior new
		classBinding: original classBinding;
		methods: original methods;
		next: original next;
		nativeCode: code optimizedCode;
		yourself.
	machineCode behavior: behavior.
	self export: code optimizedCode as: #__start__
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
	env lmrModule
		micStub: (self nativizeMonomorphicCacheWith: env);
		picStub: (self nativizePolymorphicCacheWith: env)
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeMonomorphicCacheWith: env [
	| asm lookup next smiIndex lookupIndex |
	asm := env newAssembler.
	lookup := asm newLabel.
	smiIndex := env lmrModule indexOfGlobal: #SmallIntegerBehavior.
	lookupIndex := env lmrModule indexOfGlobal: #Lookup.
	asm
		loadTwithAindex: 3;
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
	| asm smi lookupIndex case2 case3 case4 case5 case6 case7 lookup |
	asm := env newAssembler.
	case2 := asm newLabel.
	case3 := asm newLabel.
	case4 := asm newLabel.
	case5 := asm newLabel.
	case6 := asm newLabel.
	case7 := asm newLabel.
	lookup := asm newLabel.
	lookupIndex := env lmrModule indexOfGlobal: #Lookup.
	asm loadTwithAindex: 3.
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
	| roots closure |
	roots := {
		Memory module.                 "LMR"
		NativizerModule module.        "LMR.Nativizer"
		self class module.             "LMR.Bootstrapper"
	}.
	closure := self importsClosureFor: roots.
	closure do: [:m |
		| filename |
		filename := 'image-segments/lmr/' , m name , '.ems'.
		m writeCachedSegmentAt: filename].
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
