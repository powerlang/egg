"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OptimizingNativizer,
	#superclass : #Object,
	#instVars : [
		'method',
		'firstBlock',
		'messageLinker',
		'inlinedMethods',
		'abi',
		'environment'
	],
	#category : #OCompiler
}

{ #category : #unclassified }
OptimizingNativizer class >> new [
	^self basicNew initialize
]

{ #category : #unclassified }
OptimizingNativizer class >> on: aCompiledMethod [
	^self new method: aCompiledMethod
]

{ #category : #unclassified }
OptimizingNativizer >> abi: anAbi [
	abi := anAbi
]

{ #category : #accessing }
OptimizingNativizer >> environment: aNativizationEnvironment [
	environment := aNativizationEnvironment.
	abi := aNativizationEnvironment abi.
	inlinedMethods := aNativizationEnvironment inlinedMethods
]

{ #category : #allocation }
OptimizingNativizer >> allocate [
	| allocator |
	allocator := OptimizingRegisterAllocator new
		abi: abi;
		firstBlock: firstBlock.
	^allocator doAllocation
]

{ #category : #unclassified }
OptimizingNativizer >> assembleUsing: allocation [
	| assembler |
	assembler := OptimizingCodeEmitter new
		method: method;
		abi: abi;
		platform: environment platform;
		allocation: allocation;
		messageLinker: messageLinker.
	assembler assembleFrom: firstBlock.
	^assembler nativeCode
]

{ #category : #unclassified }
OptimizingNativizer >> bindVariables [
	| binder |
	binder := OptimizingVariableBinder new
		abi: abi;
		method: method.
	binder doBindingFrom: firstBlock
]

{ #category : #unclassified }
OptimizingNativizer >> decompose [
	self
		inlineBlocks;
		verifyPredecessors;
		inlineMethods;
		verifyPredecessors;
		unifyReturns;
		verifyPredecessors;
		bindVariables
]

{ #category : #private }
OptimizingNativizer >> defaultInlinedMethods [
	^OrderedCollection new
		add: Object >> #byteAtValid:;
		add: Object >> #byteAtValid:put:;
		add: ProtoObject >> #objectAtValid:;
		add: ProtoObject >> #objectAtValid:put:;
		add: ProtoObject >> #basicObjectIndexOf:;
		add: LMRProtoObject >> #primitiveAt:put:;
		add: LMRProtoObject >> #behavior;
		add: ProtoObject >> #class;
		add: Species >> #instSize;
		add: Species >> #_instancesAreArrayed;
		add: Species >> #_instancesHavePointers;
		add: LMRSpecies >> #memory;
		add: Species >> #instanceBehavior;
		add: LMRSpecies >> #primitiveNew;
		add: LMRSpecies >> #primitiveNew:;
		add: LMRProtoObject >> #primitiveAt:;
		add: LMRProtoObject >> #_cachedLookup:;
		add: LMRProtoObject >> #_cachedLookup:in:;
		add: CompiledMethod >> #prepareForExecution;
		add: CompiledMethod >> #isNativized;
		add: CompiledMethod >> #executableCode;
		add: CompiledMethod >> #blockCount;
		add: CompiledMethod >> #literalIndexFrom:;
		add: CompiledBlock >> #argumentCount;
		add: CompiledBlock >> #blockNumber;
		add: CompiledBlock >> #blockCode;
		add: CompiledBlock >> #method;
		add: NativeCode >> #code;
		add: CharacterArray >> #characterAtValid:;
		add: GCSpace >> #commitedLimit;
		add: GCSpace >> #nextFree;
		add: GCSpace >> #nextFree:;
		yourself
]

{ #category : #unclassified }
OptimizingNativizer >> eliminateDeadPhis [
	OptimizingPhiSimplification new processFrom: firstBlock
]

{ #category : #unclassified }
OptimizingNativizer >> enforceTwoAddressCodeUsing: allocation [
	| enforcer |
	enforcer := OptimizingTwoAddressEnforcer new
		allocation: allocation;
		firstBlock: firstBlock.
	^enforcer doEnforce
]

{ #category : #unclassified }
OptimizingNativizer >> firstBlock [
	^firstBlock
]

{ #category : #unclassified }
OptimizingNativizer >> fragmentInstructions [
	| binder |
	binder := OptimizingInstructionFragmenter new abi: abi.
	binder
		fragmentArgumentsIn: firstBlock with: method;
		fragmentInstructionsFrom: firstBlock
]

{ #category : #unclassified }
OptimizingNativizer >> initialize [
	inlinedMethods := self defaultInlinedMethods
]

{ #category : #unclassified }
OptimizingNativizer >> inlineBlocks [
	OptimizingBlockInliner new on: firstBlock; doInline
]

{ #category : #private }
OptimizingNativizer >> inlinedMethods [
	^inlinedMethods
]

{ #category : #private }
OptimizingNativizer >> inlinedMethods: aCollection [
	inlinedMethods := aCollection
]

{ #category : #unclassified }
OptimizingNativizer >> inlineMethods [
	(OptimizingMethodInliner on: firstBlock)
		abi: abi;
		methods: self inlinedMethods;
		inlineAllMessages
]

{ #category : #unclassified }
OptimizingNativizer >> irFor: aCompiledMethod [
	| visitor cm |
	visitor := OptimizingVisitor new.
	cm := (SendSite isUndermethod: aCompiledMethod selector)
		ifTrue: [LMRProtoObject >> aCompiledMethod selector]
		ifFalse: [aCompiledMethod].
	^visitor visit: cm sexpressions
]

{ #category : #unclassified }
OptimizingNativizer >> messageLinker: aMessageLinker [
	messageLinker := aMessageLinker
]

{ #category : #unclassified }
OptimizingNativizer >> method: aCompiledMethod [
	method := aCompiledMethod.
	firstBlock := self irFor: aCompiledMethod
]

{ #category : #unclassified }
OptimizingNativizer >> nativeCode [
	^self nativize
]

{ #category : #nativizing }
OptimizingNativizer >> nativize [
	| allocation |
	self
		decompose;
		fragmentInstructions;
		simplifyCFG;
		removeRedundantCode;
		simplifyCFG;
		eliminateDeadPhis;
		splitCriticalEdges;
		transformToCSSA.
	allocation := self allocate.
	self
		enforceTwoAddressCodeUsing: allocation;
		simplifyCFG.
	^self assembleUsing: allocation
]

{ #category : #unclassified }
OptimizingNativizer >> removeRedundantCode [
	OptimizingValueNumbering new workFrom: firstBlock
]

{ #category : #unclassified }
OptimizingNativizer >> selectInstructions [
	| allocator |
	allocator := OptimizingInstructionSelector new firstBlock: firstBlock.
	^allocator doSelection
]

{ #category : #unclassified }
OptimizingNativizer >> simplifyCFG [
	OptimizingCFGSimplifier new cleanFrom: firstBlock
]

{ #category : #unclassified }
OptimizingNativizer >> splitCriticalEdges [
	firstBlock splitAllCriticalEdges
]

{ #category : #allocation }
OptimizingNativizer >> transformToCSSA [
	| transformer |
	transformer := OptimizingCSSATransformer new firstBlock: firstBlock.
	transformer applyTransformation
]

{ #category : #unclassified }
OptimizingNativizer >> unifyReturns [
	firstBlock unifyReturns
]

{ #category : #unclassified }
OptimizingNativizer >> verifyPredecessors [
	firstBlock verifyAllPredecessorsSanity
]

