"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #OptimizingMethodInliner,
	#superclass : #Object,
	#instVars : [
		'firstBlock',
		'methods',
		'environment',
		'changed'
	],
	#category : #'OCompiler-Core-Main'
}

{ #category : #unclassified }
OptimizingMethodInliner class >> on: basicBlock [
	^self new firstBlock: basicBlock
]

{ #category : #unclassified }
OptimizingMethodInliner >> bindArgumentsOf: firstBlockInlined with: aMessageSend [
	| inlined args |
	inlined := firstBlockInlined activationRecord.
	args := aMessageSend arguments.
	inlined arguments do: [:arg | | passed index |
		index := args size - arg index + 3.
		passed := args at: index.
		arg replaceAllUsesWith: passed; dissolve].
	inlined receiver replaceAllUsesWith: aMessageSend receiver; dissolve
]

{ #category : #private }
OptimizingMethodInliner >> bindTemporariesOf: inlinedFrame [
	| inlinerFrame current added |
	inlinerFrame := firstBlock activationRecord.
	current := inlinerFrame temporaries.
	added := inlinedFrame temporaries.
	inlinerFrame temporaries: current + added.
	inlinedFrame
		usesDo: [:operand | | user |
			user := operand instruction.
			user isMemoryOperation
				ifTrue: [
					"only temps remain, arguments have been dissolved"
					self _ASSERT: user index < 0.
					user indexImm: user index - current]
				ifFalse: [self _ASSERT: user isReturn]];
		replaceAllUsesWith: inlinerFrame;
		dissolve
]

{ #category : #unclassified }
OptimizingMethodInliner >> bindTemporariesOf: inlinedFrame into: inlinerFrame [
	| current added |
	current := inlinerFrame temporaries.
	added := inlinedFrame temporaries.
	"added > 0 ifTrue: [self halt]."
	inlinerFrame temporaries: current + added.
	inlinedFrame
		usesDo: [:operand | | user |
			user := operand instruction.
			user isMemoryOperation
				ifTrue: [
					"only temps remain, arguments have been dissolved"
					self _ASSERT: user index < 0.
					user indexImm: user index - current]
				ifFalse: [self _ASSERT: user isReturn]];
		replaceAllUsesWith: inlinerFrame;
		dissolve
]

{ #category : #unclassified }
OptimizingMethodInliner >> blockInliner [
	^OptimizingBlockInliner new inlinerActivation: firstBlock activationRecord
]

{ #category : #private }
OptimizingMethodInliner >> booleanInliner: selector [
	| dispatcher types |
	dispatcher := self newDispatcher.
	types := {true. false} collect: [:bool | | method |
		method := bool behavior findMethodFor: selector.
		bool -> method].
	^dispatcher types: types
]

{ #category : #unclassified }
OptimizingMethodInliner >> dynamicDispatch [
	^self newDispatcher
]

{ #category : #accessing }
OptimizingMethodInliner >> environment [
	^environment
]

{ #category : #accessing }
OptimizingMethodInliner >> environment: aNativizationEnvironment [
	environment := aNativizationEnvironment.
	self methods: environment inlinedMethods
]

{ #category : #unclassified }
OptimizingMethodInliner >> firstBlock: aBasicBlock [
	firstBlock := aBasicBlock
]

{ #category : #unclassified }
OptimizingMethodInliner >> initialize [
	methods := Dictionary new
]

{ #category : #unclassified }
OptimizingMethodInliner >> inlineAllMessages [
	[
		changed := false.
		firstBlock withSuccessorsPostOrder do: [:block | | current |
			current := block.
			block instructionsAsCollection do: [:instruction | 
				instruction isMessageSend
					ifTrue: [current := (self tryOptimizingSend: instruction in: current) value]]].
		changed] whileTrue
]

{ #category : #unclassified }
OptimizingMethodInliner >> isBooleanMessage: selector [
	^#(#ifTrue: #ifFalse: #ifTrue:ifFalse: #ifFalse:ifTrue: #and: #or:)
		includes: selector
]

{ #category : #json }
OptimizingMethodInliner >> lookup: aMessageSend [
	| receiver selector |
	receiver := aMessageSend receiver.
	selector := aMessageSend selector.
	receiver isBlockClosure ifTrue: [^self blockInliner].
	receiver isConstant ifTrue: [^self lookup: selector for: receiver value].
	(self isBooleanMessage: selector) ifTrue: [^self booleanInliner: selector].
	(self methodForSelector: selector)
		ifNotNil: [:method | ^self staticInliner: method].
	^self dynamicDispatch
]

{ #category : #private }
OptimizingMethodInliner >> lookup: selector for: constant [
	| behavior method |
	behavior := constant behavior.
	method := behavior findMethodFor: selector.
	(method isNil or: [method primitiveNumber > 0])
		ifTrue: [^self dynamicDispatch].
	^self newDispatcher types: {behavior -> method}
]

{ #category : #private }
OptimizingMethodInliner >> methodForSelector: selector [
	^methods at: selector ifAbsent: nil
]

{ #category : #unclassified }
OptimizingMethodInliner >> methods: inlinedMethods [
	inlinedMethods do: [:m | methods at: m selector put: m]
]

{ #category : #unclassified }
OptimizingMethodInliner >> newDispatcher [
	^ODispatchInliner new methodInliner: self
]

{ #category : #unclassified }
OptimizingMethodInliner >> staticInliner: method [
	^self newDispatcher types: {nil -> method}
]

{ #category : #unclassified }
OptimizingMethodInliner >> tryOptimizingSend: aMessageSend in: aBasicBlock [
	| inliner |
	inliner := self lookup: aMessageSend.
	^inliner canBeInlined
		ifTrue: [
			changed := true.
			inliner inline: aMessageSend in: aBasicBlock]
		ifFalse: [aMessageSend -> aBasicBlock]
]
