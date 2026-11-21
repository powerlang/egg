"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OptimizingPhiSimplification,
	#superclass : #Object,
	#instVars : [
		'marks'
	],
	#category : #OCompiler
}

{ #category : #unclassified }
OptimizingPhiSimplification class >> new [
	^self basicNew initialize
]

{ #category : #unclassified }
OptimizingPhiSimplification >> initialize [
	marks := Set new
]

{ #category : #unclassified }
OptimizingPhiSimplification >> isMarked: instruction [
	^marks includes: instruction
]

{ #category : #unclassified }
OptimizingPhiSimplification >> mark: instruction [
	^marks add: instruction
]

{ #category : #unclassified }
OptimizingPhiSimplification >> process: aBasicBlock [
	| instruction |
	instruction := aBasicBlock firstInstruction.
	[instruction isPhi] whileTrue: [| next |
		next := instruction next.
		self simplify: instruction.
		instruction := next]
]

{ #category : #unclassified }
OptimizingPhiSimplification >> processFrom: firstBlock [
	firstBlock instructionsWithSuccessorsDo: [:inst | self mark: inst].
	firstBlock reversePostOrderDo: [:block | self process: block]
]

{ #category : #unclassified }
OptimizingPhiSimplification >> simplify: aParameter [
	| vars |
	vars := aParameter variables.
	vars size to: 1 by: -1 do: [:i | | var |
		var := vars at: i.
		((self isMarked: var) or: [aParameter isUntied]) ifFalse: [aParameter removeVariable: var at: i]]
]

