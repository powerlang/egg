"
	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #NativizerModule,
	#superclass : #Module,
	#instVars : [
		'environment',
	],
	#category : #Nativization
}


{ #category : #bootstrapping }
NativizerModule >> bootstrap: anLMRModule for: aPlatform [
	environment := self newNativizationEnvironmentFor: aPlatform.

	self
		nativizeInvokeFor: anLMRModule;
		nativizeWriteBarrierFor: anLMRModule;
		nativizeLookupFor: anLMRModule;
		nativizeSendSiteStubs.

	environment initializeLinkersFor: anLMRModule; completeInitialization
]

{ #category : #spec }
NativizerModule >> imports [
	^{
		#Kernel -> #(Behavior CharacterArray Closure CompiledBlock CompiledMethod Float OrderedCollection Species String).
		#LMR -> #(CriticalArray GCSpace GlobalDispatchCache Memory NativeCode SendSite Thread)
	}
] 

{ #category : #accessing }
NativizerModule >> inlinedMethods [
	| map |
	map := {
		(ProtoObject -> #(#objectAtValid: #objectAtValid:put: #behavior #class #primitiveAt: #_cachedLookup: #_cachedLookup:in:)).
		(Object -> #(#byteAtValid: #byteAtValid:put: #basicObjectIndexOf: #at:put:)).
		(Species -> #(#instSize #_instancesAreArrayed #_instancesHavePointers #memory #instanceBehavior #primitiveNew #primitiveNew:)).
		(CompiledMethod -> #(#prepareForExecution #isNativized #nativeCode #blockCount #literalIndexFrom:)).
		(CompiledBlock -> #(#argumentCount #blockNumber #blockCode #method)).
		(NativeCode -> #(#code)).
		(GCSpace -> #(#commitedLimit #nextFree #nextFree:)).
		(CharacterArray -> #(#characterAtValid:))}.
	^SendSite undermethods , (self methodSubset: map)
]

{ #category : #accessing }
NativizerModule >> invokedMethods [
	| map |
	map := {
		(ProtoObject -> #(behavior class primitiveAt: #initializeExtended:contentSize:)).
		(Object -> #(#_replaceFrom:to:with:)).
		(Species -> #(#allocate:size: instanceBehavior _instancesAreArrayed _instancesHavePointers #nil:slotsOf: memory primitiveNewBytes: primitiveNewPointers: #zero:bytesOf:))}.
	^SendSite undermethods , (self methodSubset: map)
]

{ #category : #accessing }
NativizerModule >> methodSubset: aDictionary [
	| result |
	result := OrderedCollection new.
	aDictionary keysAndValuesDo: [ :species :selectors | 
		selectors collect: [:sel | | m | species >> sel ifNil: [self ASSERT: false] ] into: result].
	^result
]

{ #category : #accessing }
NativizerModule >> optimizedMethods [
	| map |
	map := {
		(ProtoObject -> #(behavior class primitiveAt: #primitiveAt:put: #initializeExtended:contentSize:)).
		(Object -> #(at: #at:put: basicByteAt: #basicByteAt:put: byteAtValid: #byteAtValid:put:
					 basicObjectAt: #basicObjectAt:put: #replaceBytesForwardFrom:to:with:startingAt:)).
		(SendSite -> #(_dispatchOn: #_dispatchOn:startingAt: _dispatchDebuggableOn: #_dispatchDebuggableOn:startingAt:)).
		(Species -> #(#allocate:size: primitiveNew primitiveNew: instSize primitiveNewBytes: primitiveNewPointers:)).
		(Float class -> #(new)).
		(CompiledBlock -> #(argumentCount arity blockCode method)).
		(Closure -> #(value value: #value:value:)).
		(CompiledMethod -> #(blockCount isNativized)).
		(String -> #(at: #at:put: byteAt: #byteAt:put:)).
		(GCSpace -> #(lockedAllocateIfPossible: lockedAllocateUnsafe: shallowCopy:)).
		(Memory -> #(shallowCopy:))}.
	^SendSite undermethods , (self methodSubset: map)
]

{ #category : #bootstrapping }
NativizerModule >> nativizeInvokeFor: anLMRModule [
	| invoke |
	invoke := SendSite >> #_invokeOn:.
	environment nativizeOptimizing: invoke.
	anLMRModule mapGlobal: #Invoke to: invoke
]

{ #category : #bootstrapping }
NativizerModule >> nativizeLookupFor: anLMRModule [
	| nativizer lookup lookupSuper |
	nativizer := LookupNativizer new
		environment: environment;
		nativizeMethods.
	lookup := nativizer methodFor: #_dispatchOn:.
	lookupSuper := nativizer methodFor: #_dispatchOn:startingAt:.
	anLMRModule
		mapGlobal: #Lookup to: lookup nativeCode;
		mapGlobal: #LookupSuper to: lookupSuper nativeCode
]

{ #category : #bootstrapping }
NativizerModule >> nativizeMonomorphicCache [
	| asm lookup next smiGlobal lookupGlobal |
	asm := environment newAssembler.
	lookup := asm newLabel.
	smiGlobal := self indexOfGlobal: #SmallIntegerBehavior.
	lookupGlobal := self indexOfGlobal: #Lookup
	asm
		loadTwithAindex: 3;
		loadSwithGindex: smiGlobal.
	next := asm labeledNonIntegerBitTestOfR.
	asm
		loadLongSwithRindex: 0;
		@ next;
		compareSwithTindex: 1;
		shortJumpIfNotEqualTo: lookup;
		loadMwithTindex: 2;
		jumpToMindex: 1;
		@ lookup;
		loadMwithGindex: lookupGlobal;
		jumpToMindex: 1;
		applyFixups.
	^asm nativeCode code
]

{ #category : #bootstrapping }
NativizerModule >> nativizePolymorphicCache [
	| asm smi lookupGlobal case2 case3 case4 case5 case6 case7 lookup |
	asm := environment newAssembler.
	smi := asm newLabel.
	case2 := asm newLabel.
	case3 := asm newLabel.
	case4 := asm newLabel.
	case5 := asm newLabel.
	case6 := asm newLabel.
	case7 := asm newLabel.
	lookup := asm newLabel.
	asm loadTwithAindex: 3.
	smi := asm labeledNonIntegerBitTestOfR.
	lookupGlobal := self indexOfGlobal: #Lookup.
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
		loadMwithGindex: lookupGlobal;
		jumpToMindex: 1;
		@ smi;
		loadMwithTindex: 15;
		jumpToMindex: 1;
		applyFixups.
	^asm nativeCode code
]

{ #category : #bootstrapping }
NativizerModule >> nativizeSendSiteStubs [
	SendSite 
		monomorphicCache: self nativizeMonomorphicCache;
		polymorphicCache: self nativizePolymorphicCache.
]

{ #category : #bootstrapping }
NativizerModule >> nativizeWriteBarrierFor: anLMRModule [
	| map inlined barrier dispatcher |
	map := {
		(Memory class -> #(current)).
		(Memory -> #(isYoung: isYoungSafe: remember:)).
		(CriticalArray -> #(unsafeAdd: #unsafeAt:put:)).
		(Magnitude -> #(#between:and:))
	}.
	inlined := self methodSubset: map.
	inlined addAll: self undermethods.
	barrier := ProtoObject >> #holdRefererIfNeeded:.
	dispatcher := LookupLinker new initializeFrom: nativizer.
	NativizationEnvironment new
		platform: environment platform;
		inlinedMethods: inlined;
		messageLinker: dispatcher;
		completeInitialization;
		nativizeOptimizing: barrier.
	anLMRModule mapGlobal: #WriteBarrier to: barrier nativeCode
]

{ #category : #services }
NativizerModule >> newNativizationEnvironmentFor: aPlatform [
	^NativizationEnvironment new
		platform: aPlatform;
		inlinedMethods: self inlinedMethods;
		invokedMethods: self invokedMethods;
		optimizedMethods: self optimizedMethods
]