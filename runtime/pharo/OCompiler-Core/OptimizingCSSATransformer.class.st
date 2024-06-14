"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OptimizingCSSATransformer',
	#superclass : 'Object',
	#instVars : [
		'firstBlock',
		'liveness'
	],
	#category : 'OCompiler-Core-Main',
	#package : 'OCompiler-Core-Main'
}

{ #category : 'accessing' }
OptimizingCSSATransformer >> applyTransformation [
	self splitPhis; coalescePhis
]

{ #category : 'accessing' }
OptimizingCSSATransformer >> coalescePhis [
	"
	to do
	"
	
]

{ #category : 'accessing' }
OptimizingCSSATransformer >> firstBlock: block [
	firstBlock := block
]

{ #category : 'accessing' }
OptimizingCSSATransformer >> insertionPointFor: anOBasicBlock [
	| instruction prev |
	instruction := anOBasicBlock lastInstruction.
	instruction isConditionalJump ifFalse: [^instruction].
	prev := instruction prev.
	^prev == instruction variable ifTrue: [prev] ifFalse: [instruction]
]

{ #category : 'accessing' }
OptimizingCSSATransformer >> liftPhi: phi [
	phi variablesWithBlocksDo: [:var :pred | | copy insertion |
		insertion := self insertionPointFor: pred.
		copy := var insertCopyBefore: insertion.
		phi atOperand: pred put: copy.
		var removeUse: phi at: pred; dissolveIfUseless.
		copy addUse: phi at: pred]
]

{ #category : 'accessing' }
OptimizingCSSATransformer >> liftPhisIn: block [
	block
		phisDo: [:phi | phi isUsed
			ifTrue: [self liftPhi: phi]
			ifFalse: [phi dissolve]]
]

{ #category : 'accessing' }
OptimizingCSSATransformer >> splitPhis [
	firstBlock withSuccessorsPostOrder do: [:block | self liftPhisIn: block]
]
