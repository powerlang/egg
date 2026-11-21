"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OptimizingParameterSimplification,
	#superclass : #Object,
	#instVars : [
		'marks'
	],
	#category : #OCompiler
}

{ #category : #unclassified }
OptimizingParameterSimplification class >> new [
	^self basicNew initialize
]

{ #category : #unclassified }
OptimizingParameterSimplification >> initialize [
	marks := Set new
]

{ #category : #unclassified }
OptimizingParameterSimplification >> isMarked: instruction [
	^marks includes: instruction
]

{ #category : #unclassified }
OptimizingParameterSimplification >> mark: instruction [
	^marks add: instruction
]

{ #category : #unclassified }
OptimizingParameterSimplification >> process: aBasicBlock [
	aBasicBlock parametersDo: [:parameter | self simplify: parameter]
]

{ #category : #unclassified }
OptimizingParameterSimplification >> processFrom: firstBlock [
	firstBlock instructionsWithSuccessorsDo: [:inst | self mark: inst].
	firstBlock reversePostOrderDo: [:block | self process: block]
]

{ #category : #unclassified }
OptimizingParameterSimplification >> simplify: aParameter [
	(aParameter variables conform: [:var | self isMarked: var]) ifTrue: [^self].
	self DENY: aParameter isUsed.
	aParameter dissolve
]

