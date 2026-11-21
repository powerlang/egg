"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OptimizingCSSATransformer,
	#superclass : #Object,
	#instVars : [
		'firstBlock',
		'liveness'
	],
	#category : #OCompiler
}

{ #category : #accessing }
OptimizingCSSATransformer >> applyTransformation [
	self splitPhis; coalescePhis
]

{ #category : #accessing }
OptimizingCSSATransformer >> coalescePhis [
	"
	to do
	"
	
]

{ #category : #accessing }
OptimizingCSSATransformer >> firstBlock: block [
	firstBlock := block
]

{ #category : #accessing }
OptimizingCSSATransformer >> liftPhisIn: block [
	block parametersDo: [:parameter |
		parameter variablesWithBlocksDo: [:var :pred | | copy |
			copy := var insertCopyBefore: pred lastInstruction.
			parameter atOperand: pred put: copy.
			var removeUse: parameter at: pred; dissolveIfUnused.
			copy addUse: parameter at: pred]]
]

{ #category : #accessing }
OptimizingCSSATransformer >> splitPhis [
	firstBlock withSuccessorsPostOrder do: [:block | self liftPhisIn: block]
]

