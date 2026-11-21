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
	aBasicBlock parameters do: [:parameter | self simplify: parameter]
]

{ #category : #unclassified }
OptimizingParameterSimplification >> processFrom: firstBlock [
	firstBlock instructionsWithSuccessorsDo: [:inst | self mark: inst].
	firstBlock reversePostOrderDo: [:block | self process: block]
]

{ #category : #unclassified }
OptimizingParameterSimplification >> simplify: aParameter [
	| vars |
	vars := aParameter variables.
	vars size to: 1 by: -1 do: [:i | | var |
		var := vars at: i.
		((self isMarked: var) or: [aParameter isUntied]) ifFalse: [aParameter removeVariable: var at: i]]
]

