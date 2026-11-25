'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #NativizerModule category: #Nativization!
Module subclass: #NativizerModule
	instanceVariableNames: 'environment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization'!
!NativizerModule commentStamp: '<historical>' prior: 0!

	Copyright (c) 2023, Javier Pimás.
	See (MIT) license in root directory.
!

!NativizerModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:40'!
bootstrap: anLMRModule with: aPlatform
	environment := self newNativizationEnvironmentFor: aPlatform.

	self
		nativizeInvokeFor: anLMRModule;
		nativizeWriteBarrierFor: anLMRModule;
		nativizeLookupFor: anLMRModule;
		nativizeSendSiteStubs.

	environment initializeLinkersFor: anLMRModule; completeInitialization
! !

!NativizerModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:40'!
environment
	^environment
! !

!NativizerModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:40'!
imports
	^{
		#Kernel -> #(Behavior CharacterArray Closure CompiledBlock CompiledMethod Float OrderedCollection ProtoObject Species String).
		#Kernel.LMR -> #(LMRProtoObject LMRFloat LMRSpecies).
		#LMR -> #(CriticalArray GCSpace GlobalDispatchCache Memory NativeCode SendSite Thread).
	}
! !

!NativizerModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeFor: anLMRModule with: aPlatform
	environment := self newNativizationEnvironmentFor: aPlatform.
	environment initializeLinkersFor: anLMRModule; completeInitialization
! !

!NativizerModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
inlinedMethods
	| map |
	map := {
		(ProtoObject -> #(#basicObjectIndexOf: #class #objectAtValid: #objectAtValid:put:)).
		(LMRProtoObject -> #(#behavior #primitiveAt: #_cachedLookup: #_cachedLookup:in:)).
		(Object -> #(#byteAtValid: #byteAtValid:put: #at:put:)).
		(Species -> #(#instSize #_instancesAreArrayed #_instancesHavePointers #instanceBehavior)).
		(LMRSpecies -> #(#memory #primitiveNew #primitiveNew:)).
		(CompiledMethod -> #(#prepareForExecution #isNativized #executableCode #blockCount #literalIndexFrom:)).
		(CompiledBlock -> #(#argumentCount #blockNumber #blockCode #method)).
		(NativeCode -> #(#code)).
		(GCSpace -> #(#commitedLimit #nextFree #nextFree:)).
		(CharacterArray -> #(#characterAtValid:))}.
	^self undermethods , (self methodSubset: map)
! !

!NativizerModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
invokedMethods
	| map |
	map := {
		(ProtoObject -> #(class)).
		(LMRProtoObject -> #(behavior #initializeExtended:contentSize: primitiveAt:)).
		(Object -> #(_replaceFrom:to:with:)).
		(Species -> #(instanceBehavior _instancesAreArrayed _instancesHavePointers)).
		(LMRSpecies -> #(allocate:size: nil:slotsOf: memory primitiveNewBytes: primitiveNewPointers: zero:bytesOf:))}.
	^self undermethods , (self methodSubset: map)
! !

!NativizerModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
justLoaded
	InlineMessageLinker initializeInlineMessageLinkerFlags
! !

!NativizerModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
methodSubset: associations
	| result dict |
	result := OrderedCollection new.
	dict := Dictionary withAll: associations.
	dict keysAndValuesDo: [ :species :selectors | 
		selectors collect: [:sel | | m | species >> sel ifNil: [self ASSERT: false] ] in: result].
	^result
! !

!NativizerModule methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
optimizedMethods
	| map |
	map := {
		(ProtoObject -> #(basicByteAt: #basicByteAt:put: basicObjectAt: #basicObjectAt:put: class)).
		(LMRProtoObject -> #(behavior primitiveAt: #primitiveAt:put: #initializeExtended:contentSize:)). 
		(Object -> #(at: #at:put: byteAtValid: #byteAtValid:put: #replaceBytesForwardFrom:to:with:startingAt:)).
		(SendSite -> #(_dispatchOn: #_dispatchOn:startingAt: _dispatchDebuggableOn: #_dispatchDebuggableOn:startingAt:)).
		(Species -> #(instSize)).
		(LMRSpecies -> #(allocate:size: primitiveNew primitiveNew: primitiveNewBytes: primitiveNewPointers:)).
		(LMRFloat class -> #(new)).
		(CompiledBlock -> #(argumentCount arity blockCode method)).
		(Closure -> #(value value: #value:value:)).
		(CompiledMethod -> #(blockCount isNativized)).
		(String -> #(at: #at:put: byteAt: #byteAt:put:)).
		(GCSpace -> #(lockedAllocateIfPossible: shallowCopy:)).
		(Memory -> #(shallowCopy:))}.
	^self undermethods , (self methodSubset: map)
! !

!NativizerModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizeInvokeFor: anLMRModule
	| invoke |
	invoke := SendSite >> #_invokeOn:.
	environment nativizeOptimizing: invoke.
	anLMRModule mapGlobal: #Invoke to: invoke
! !

!NativizerModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizeLookupFor: anLMRModule
	| nativizer lookup lookupSuper |
	nativizer := LookupNativizer new
		environment: environment;
		nativizeMethods.
	lookup := nativizer methodFor: #_dispatchOn:.
	lookupSuper := nativizer methodFor: #_dispatchOn:startingAt:.
	anLMRModule
		mapGlobal: #Lookup to: lookup executableCode;
		mapGlobal: #LookupSuper to: lookupSuper executableCode
! !

!NativizerModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizeMonomorphicCache
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
! !

!NativizerModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizePolymorphicCache
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
! !

!NativizerModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizeSendSiteStubs
	SendSite 
		monomorphicCache: self nativizeMonomorphicCache;
		polymorphicCache: self nativizePolymorphicCache.
! !

!NativizerModule methodsFor:  'bootstrapping' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativizeWriteBarrierFor: anLMRModule
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
	anLMRModule mapGlobal: #WriteBarrier to: barrier executableCode
! !

!NativizerModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
newNativizationEnvironmentFor: aPlatform
	^NativizationEnvironment new
		platform: aPlatform;
		inlinedMethods: self inlinedMethods;
		invokedMethods: self invokedMethods;
		optimizedMethods: self optimizedMethods
! !

!NativizerModule methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
undermethods
	^SendSite undermethods
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NativizerModule class' category: #Nativization!
NativizerModule class
	instanceVariableNames: ''!


