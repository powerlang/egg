"
	Copyright (c) 2025, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #BootstrapperModule,
	#superclass : #Module,
	#instVars : [
		'nativizedCodes'
	],
	#category : #'LMR-Bootstrapper'
}

{ #category : #spec }
BootstrapperModule >> imports [
	^{
		#Kernel -> #(OrderedCollection IdentityDictionary Object Magnitude ProtoObject).
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

{ #category : #bootstrapping }
BootstrapperModule >> bootstrapLMR: anLMRModule nativizer: aNativizerModule platform: aPlatform [
	| env |

	nativizedCodes := IdentityDictionary new.
	env := aNativizerModule newNativizationEnvironmentFor: aPlatform.
	env lmrModule: anLMRModule.

	self
		nativizeInvokeFor: anLMRModule env: env nativizer: aNativizerModule;
		nativizeWriteBarrierFor: anLMRModule env: env nativizer: aNativizerModule;
		nativizeLookupFor: anLMRModule env: env nativizer: aNativizerModule;
		nativizeSendSiteStubs: env.

	env initializeLinkersFor: anLMRModule; completeInitialization.
]

{ #category : #bootstrapping }
BootstrapperModule >> recordNativizedOriginal: anOriginalMethod code: aNativeCode [
	aNativeCode isNil ifTrue: [^self].
	nativizedCodes at: anOriginalMethod put: aNativeCode
]

{ #category : #bootstrapping }
BootstrapperModule >> recordNativizationsFromLookupNativizer: aLookupNativizer [
	aLookupNativizer originals withIndexDo: [:original :i |
		self recordNativizedOriginal: original code: (aLookupNativizer methods at: i) executableCode]
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeInvokeFor: anLMRModule env: env nativizer: aNativizerModule [
	| original invoke nativeCode |
	original := SendSite >> #_invokeOn:.
	invoke := original copy.
	nativeCode := env nativizeOptimizing: invoke.
	self recordNativizedOriginal: original code: nativeCode.
	anLMRModule mapGlobal: #Invoke to: nativeCode
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeLookupFor: anLMRModule env: env nativizer: aNativizerModule [
	| nativizer lookup lookupSuper |
	nativizer := LookupNativizer new
		nativizer: env;
		nativizeMethods.
	self recordNativizationsFromLookupNativizer: nativizer.
	lookup := nativizer methodFor: #_dispatchOn:.
	lookupSuper := nativizer methodFor: #_dispatchOn:startingAt:.
	anLMRModule
		mapGlobal: #Lookup to: lookup executableCode;
		mapGlobal: #LookupSuper to: lookupSuper executableCode
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeWriteBarrierFor: anLMRModule env: env nativizer: aNativizerModule [
	| map inlined barrier original lookupNativizer dispatcher |
	map := {
		(Memory class -> #(current)).
		(Memory -> #(isYoung: isYoungSafe: remember:)).
		(CriticalArray -> #(unsafeAdd: #unsafeAt:put:)).
		(Magnitude -> #(#between:and:))
	}.
	inlined := aNativizerModule methodSubset: map.
	inlined addAll: aNativizerModule undermethods.
	original := LMRProtoObject >> #holdRefererIfNeeded:.
	barrier := original copy.
	lookupNativizer := LookupNativizer new nativizer: env; nativizeMethods.
	self recordNativizationsFromLookupNativizer: lookupNativizer.
	dispatcher := LookupLinker new initializeFrom: anLMRModule.
	NativizationEnvironment new
		platform: env platform;
		inlinedMethods: inlined;
		messageLinker: dispatcher;
		lmrModule: anLMRModule;
		completeInitialization;
		nativizeOptimizing: barrier.
	self recordNativizedOriginal: original code: barrier executableCode.
	anLMRModule mapGlobal: #WriteBarrier to: barrier executableCode.
]

{ #category : #bootstrapping }
BootstrapperModule >> nativizeSendSiteStubs: env [
	SendSite
		monomorphicCache: (self nativizeMonomorphicCacheWith: env);
		polymorphicCache: (self nativizePolymorphicCacheWith: env)
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
		loadLongSwithRindex: 0;
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
		loadLongSwithRindex: 0;
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
	| host roots closure handler |
	host := ProtoObject module host.   "Kernel module's host"
	roots := {
		Memory module.                 "LMR"
		NativizerModule module.        "LMR.Nativizer"
		self class module.             "LMR.Bootstrapper"
	}.
	closure := self importsClosureFor: roots.
	handler := [:original :copy |
		copy executableCode: (nativizedCodes at: original ifAbsent: [nil])].
	closure do: [:m |
		| filename |
		filename := 'image-segments/lmr/' , m name , '.ems'.
		m writeCachedSegmentAt: filename methodCopyHandler: handler].
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
