'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingNativizer category: #OCompiler!
Object subclass: #OptimizingNativizer
	instanceVariableNames: 'method firstBlock messageLinker inlinedMethods abi'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingNativizer commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
abi: anAbi
	abi := anAbi
! !

!OptimizingNativizer methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocate
	| allocator |
	allocator := OptimizingRegisterAllocator new
		abi: abi;
		firstBlock: firstBlock.
	^allocator doAllocation
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleUsing: allocation
	| assembler |
	assembler := OptimizingCodeEmitter new
		method: method;
		abi: abi;
		allocation: allocation;
		messageLinker: messageLinker.
	assembler assembleFrom: firstBlock.
	^assembler nativeCode
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
bindVariables
	| binder |
	binder := OptimizingVariableBinder new abi: abi.
	binder doBindingFrom: firstBlock
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
decompose
	self
		inlineBlocks;
		verifyPredecessors;
		inlineMethods;
		verifyPredecessors;
		unifyReturns;
		verifyPredecessors;
		bindVariables
! !

!OptimizingNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
defaultInlinedMethods
	^BeeNativizationEnvironment primitiveObjectMethods , ((OrderedCollection new
		add: Object >> #byteAtValid:;
		add: Object >> #byteAtValid:put:;
		add: ProtoObject >> #objectAtValid:;
		add: ProtoObject >> #objectAtValid:put:;
		add: Object >> #basicObjectIndexOf:;
		add: Object >> #primitiveAt:put:;
		add: ProtoObject >> #behavior;
		add: ProtoObject >> #class;
		add: Species >> #instSize;
		add: Species >> #_instancesAreArrayed;
		add: Species >> #_instancesHavePointers;
		add: Species >> #memory;
		add: Species >> #instanceBehavior;
		add: Species >> #primitiveNew;
		add: Species >> #primitiveNew:;
		add: ProtoObject >> #primitiveAt:;
		add: ProtoObject >> #_cachedLookup:;
		add: ProtoObject >> #_cachedLookup:in:;
		add: CompiledMethod >> #prepareForExecution;
		add: CompiledMethod >> #isNativized;
		add: CompiledMethod >> #nativeCode;
		add: CompiledMethod >> #blockCount;
		add: CompiledMethod >> #literalIndexFrom:;
		add: CompiledBlock >> #argumentCount;
		add: CompiledBlock >> #blockNumber;
		add: CompiledBlock >> #blockCode;
		add: CompiledBlock >> #method;
		add: NativeCode >> #code;
		add: NativeCode >> #isFresh;
		add: CharacterArray >> #characterAtValid:;
		add: GCSpace >> #commitedLimit;
		add: GCSpace >> #nextFree;
		add: GCSpace >> #nextFree:;
		yourself)
		collect: [:cm | cm dmrVersion ifNil: [cm]])
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
eliminateDeadPhis
	OptimizingPhiSimplification new processFrom: firstBlock
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
enforceTwoAddressCodeUsing: allocation
	| enforcer |
	enforcer := OptimizingTwoAddressEnforcer new
		allocation: allocation;
		firstBlock: firstBlock.
	^enforcer doEnforce
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstBlock
	^firstBlock
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fragmentInstructions
	| binder |
	binder := OptimizingInstructionFragmenter new abi: abi.
	binder
		fragmentArgumentsIn: firstBlock with: method;
		fragmentInstructionsFrom: firstBlock
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	inlinedMethods := self defaultInlinedMethods
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineBlocks
	OptimizingBlockInliner new on: firstBlock; doInline
! !

!OptimizingNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlinedMethods
	^inlinedMethods
! !

!OptimizingNativizer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlinedMethods: aCollection
	inlinedMethods := aCollection
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inlineMethods
	(OptimizingMethodInliner on: firstBlock)
		abi: abi;
		methods: self inlinedMethods;
		inlineAllMessages
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
irFor: aCompiledMethod
	| visitor ir cm |
	visitor := OptimizingVisitor new.
	cm := (SendSite isUndermethod: aCompiledMethod selector)
		ifTrue: [ProtoObject >> aCompiledMethod selector]
		ifFalse: [aCompiledMethod].
	ir := visitor visit: cm parseTree.
	^ir
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
messageLinker: aMessageLinker
	messageLinker := aMessageLinker
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
method: aCompiledMethod
	method := aCompiledMethod.
	firstBlock := self irFor: aCompiledMethod
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
nativeCode
	^self nativize
! !

!OptimizingNativizer methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:39'!
nativize
	| allocation |
	allocation := self
		decompose;
		fragmentInstructions;
		simplifyCFG;
		removeRedundantCode;
		simplifyCFG;
		splitCriticalEdges;
		transformToCSSA;
		allocate.
	^self
		enforceTwoAddressCodeUsing: allocation;
		simplifyCFG;
		assembleUsing: allocation
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeRedundantCode
	OptimizingValueNumbering new workFrom: firstBlock
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
selectInstructions
	| allocator |
	allocator := OptimizingInstructionSelector new firstBlock: firstBlock.
	^allocator doSelection
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
simplifyCFG
	OptimizingCFGSimplifier new cleanFrom: firstBlock
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
splitCriticalEdges
	firstBlock splitAllCriticalEdges
! !

!OptimizingNativizer methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
transformToCSSA
	| transformer |
	transformer := OptimizingCSSATransformer new firstBlock: firstBlock.
	transformer applyTransformation
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
unifyReturns
	firstBlock unifyReturns
! !

!OptimizingNativizer methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
verifyPredecessors
	firstBlock verifyAllPredecessorsSanity
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingNativizer class' category: #OCompiler!
OptimizingNativizer class
	instanceVariableNames: ''!

!OptimizingNativizer class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !

!OptimizingNativizer class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aCompiledMethod
	^self new method: aCompiledMethod
! !


OptimizingNativizer initialize!

