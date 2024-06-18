"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'ODispatchInliner',
	#superclass : 'Object',
	#instVars : [
		'methodInliner',
		'types',
		'send',
		'receiver',
		'arguments',
		'phi',
		'currentBlock',
		'end'
	],
	#category : 'OCompiler-Core-Main',
	#package : 'OCompiler-Core',
	#tag : 'Main'
}

{ #category : 'accessing' }
ODispatchInliner >> canBeInlined [
	^types notEmpty
]

{ #category : 'accessing' }
ODispatchInliner >> checkedInline: aCompiledMethod for: aBehavior on: receiverBehavior [
	| compare inlined next left |
	left := receiverBehavior ifNil: [receiver].
	compare := OBinaryConstantOperation left: left right: aBehavior name: #'=='.
	inlined := self inlineMethod: aCompiledMethod.
	next := OBasicBlock new.
	currentBlock
		add: compare;
		endWithJumpFalseTo: next skipping: inlined if: compare.
	currentBlock := next
]

{ #category : 'accessing' }
ODispatchInliner >> initialize [
	types := #()
]

{ #category : 'accessing' }
ODispatchInliner >> inline: aMessageSend in: block [
	| remaining recBehavior current |
	send := aMessageSend.
	receiver := aMessageSend receiver.
	arguments := aMessageSend arguments.
	remaining := OrderedCollection withAll: types.
	currentBlock := block.
	end := block splitAfter: aMessageSend.
	phi := OPhi new.
	end afterInsert: phi.
	self needsBehavior ifTrue: [recBehavior := self loadReceiverBehavior].
	current := remaining removeFirst.
	[remaining isEmpty] whileFalse: [
		self checkedInline: current value for: current key on: recBehavior.
		current := remaining removeFirst].
	self lastInline: current value.
	aMessageSend replaceAllUsesWith: phi; dissolve.
	^phi -> end
]

{ #category : 'accessing' }
ODispatchInliner >> inlineMethod: aCompiledMethod [
	| nativizer initial last return source |
	nativizer := OptimizingNativizer new.
	initial := nativizer
		environment: methodInliner environment;
		method: aCompiledMethod;
		decompose;
		firstBlock.
	methodInliner
		bindArgumentsOf: initial with: send;
		bindTemporariesOf: initial activationRecord.
	last := initial lastBlock.
	return := last lastValue.
	self _ASSERT: return isReturn.
	source := return source.
	phi addVariable: source from: last.
	return dissolve.
	last endWithJumpTo: end.
	^initial
]

{ #category : 'accessing' }
ODispatchInliner >> lastInline: aCompiledMethod [
	| inlined |
	inlined := self inlineMethod: aCompiledMethod.
	currentBlock endWithJumpTo: inlined
]

{ #category : 'accessing' }
ODispatchInliner >> loadReceiverBehavior [
	| constant heap header test merge join |
	constant := OLoadConstant valued: SmallInteger instanceBehavior.
	currentBlock add: constant.
	heap := OBasicBlock new.
	header := OLoadOperation base: receiver longSlotAtImm: 0.
	heap add: header.
	test := OUnaryOperation receiver: receiver name: #_isSmallInteger.
	merge := OBasicBlock new.
	currentBlock
		add: test;
		endWithJumpTrueTo: merge skipping: heap if: test.
	join := OPhi with: constant from: currentBlock with: header from: heap.
	merge add: join.
	currentBlock := merge.
	^join
]

{ #category : 'accessing' }
ODispatchInliner >> methodInliner: anOptimizingMethodInliner [
	methodInliner := anOptimizingMethodInliner
]

{ #category : 'accessing' }
ODispatchInliner >> needsBehavior [
	^types anySatisfy: [:assoc | assoc key class == Behavior]
]

{ #category : 'accessing' }
ODispatchInliner >> types: aSequenceableCollection [
	types := aSequenceableCollection
]
