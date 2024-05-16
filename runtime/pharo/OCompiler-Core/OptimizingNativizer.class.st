"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #OptimizingNativizer,
	#superclass : #Object,
	#instVars : [
		'environment',
		'method',
		'firstBlock'
	],
	#category : #'OCompiler-Core-Main'
}

{ #category : #unclassified }
OptimizingNativizer class >> on: aCompiledMethod [
	^self new method: aCompiledMethod
]

{ #category : #allocation }
OptimizingNativizer >> allocate [
	| allocator |
	allocator := OptimizingRegisterAllocator new
		abi: environment abi;
		firstBlock: firstBlock.
	^allocator doAllocation
]

{ #category : #unclassified }
OptimizingNativizer >> assembleUsing: allocation [
	^OptimizingCodeEmitter new
		method: method;
		abi: environment abi;
		allocation: allocation;
		messageLinker: environment messageLinker;
		assembleFrom: firstBlock;
		nativeCode
]

{ #category : #actions }
OptimizingNativizer >> decompose [
	self
		validateAllInstructions;
		inlineMethods;
		validateAllInstructions;
		verifyPredecessors;
		unifyReturns;
		validateAllInstructions;
		verifyPredecessors;
		simplifyCFG
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

{ #category : #accessing }
OptimizingNativizer >> environment: aNativizationEnvironment [
	environment := aNativizationEnvironment
]

{ #category : #unclassified }
OptimizingNativizer >> firstBlock [
	^firstBlock
]

{ #category : #unclassified }
OptimizingNativizer >> fragmentInstructions [
	| binder |
	binder := OptimizingInstructionFragmenter new firstBlock: firstBlock.
	binder doFragment
]

{ #category : #private }
OptimizingNativizer >> inlineMethods [
	OptimizingMethodInliner new
		firstBlock: firstBlock;
		environment: environment;
		inlineAllMessages
]

{ #category : #accessing }
OptimizingNativizer >> method: aCompiledMethod [
	| visitor |
	method := aCompiledMethod.
	visitor := OptimizingRBVisitor new environment: environment; method: method.
	firstBlock := visitor visit: aCompiledMethod parseTree
]

{ #category : #unclassified }
OptimizingNativizer >> nativeCode [
	^self nativize
]

{ #category : #nativizing }
OptimizingNativizer >> nativize [
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
OptimizingNativizer >> validateAllInstructions [
	firstBlock validateAllInstructions
]

{ #category : #unclassified }
OptimizingNativizer >> verifyPredecessors [
	firstBlock validateCFG
]
