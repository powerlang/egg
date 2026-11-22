"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OptimizingParameterPruning,
	#superclass : #Object,
	#instVars : [
		'marks'
	],
	#category : #OCompiler
}

{ #category : #unclassified }
OptimizingParameterPruning class >> new [
	^self basicNew initialize
]

{ #category : #unclassified }
OptimizingParameterPruning >> initialize [
	marks := Set new
]

{ #category : #unclassified }
OptimizingParameterPruning >> isMarked: instruction [
	^marks includes: instruction
]

{ #category : #unclassified }
OptimizingParameterPruning >> mark: instruction [
	^marks add: instruction
]

{ #category : #unclassified }
OptimizingParameterPruning >> process: aBasicBlock [
	aBasicBlock parametersDo: [:parameter | self prune: parameter]
]

{ #category : #unclassified }
OptimizingParameterPruning >> processFrom: firstBlock [
	firstBlock instructionsWithSuccessorsDo: [:inst | self mark: inst].
	firstBlock reversePostOrderDo: [:block | self process: block]
]

{ #category : #unclassified }
OptimizingParameterPruning >> prune: aParameter [
	(aParameter variables conform: [:var | self isMarked: var]) ifTrue: [^self].
	self DENY: aParameter isUsed.
	aParameter dissolve
]

