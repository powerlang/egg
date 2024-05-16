"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #OBinaryOperation,
	#superclass : #OPrimitiveOperation,
	#instVars : [
		'left',
		'right'
	],
	#category : #'OCompiler-Core-IR'
}

{ #category : #unclassified }
OBinaryOperation class >> left: left right: right name: selector [
	^self new
		left: left;
		right: right;
		name: selector
]

{ #category : #unclassified }
OBinaryOperation >> atOperand: named [
	^named == #left ifTrue: [left] ifFalse: [right]
]

{ #category : #unclassified }
OBinaryOperation >> atOperand: operandName put: instruction [
	operandName = #left
		ifTrue: [left := instruction]
		ifFalse: [right := instruction]
]

{ #category : #unclassified }
OBinaryOperation >> canHaveSideEffects [
	^name = #_transferControlTo:
]

{ #category : #unclassified }
OBinaryOperation >> copyTo: copy with: map [
	super copyTo: copy with: map.
	left isInstruction ifTrue: [copy left: (left duplicateWith: map)].
	right isInstruction ifTrue: [copy right: (right duplicateWith: map)]
]

{ #category : #unclassified }
OBinaryOperation >> invertOperation [
	name == #'<' ifTrue: [^name := #'>'].
	name == #'<=' ifTrue: [^name := #'>='].
	name == #'>' ifTrue: [^name := #'<'].
	name == #'>=' ifTrue: [^name := #'<='].
	name == #'==' ifTrue: [^name].
	self halt
]

{ #category : #unclassified }
OBinaryOperation >> isBoolean [
	^self isComparison
]

{ #category : #unclassified }
OBinaryOperation >> isComparison [
	^#(< <= = == != >= >) includes: name
]

{ #category : #unclassified }
OBinaryOperation >> left [
	^left
]

{ #category : #unclassified }
OBinaryOperation >> left: anInstruction [
	left := anInstruction.
	left addUse: self at: #left
]

{ #category : #unclassified }
OBinaryOperation >> negateOperation [
	name == #'<' ifTrue: [^name := #'>='].
	name == #'<=' ifTrue: [^name := #'>'].
	name == #'>' ifTrue: [^name := #'<='].
	name == #'>=' ifTrue: [name := #'<']
]

{ #category : #unclassified }
OBinaryOperation >> right [
	^right
]

{ #category : #unclassified }
OBinaryOperation >> right: anInstruction [
	right := anInstruction.
	right addUse: self at: #right
]

{ #category : #unclassified }
OBinaryOperation >> swapOperands [
	| temp |
	left removeUseBy: self.
	right removeUseBy: self.
	temp := left.
	left := right.
	right := temp.
	left addUse: self at: #left.
	right addUse: self at: #right
]

{ #category : #unclassified }
OBinaryOperation >> usesResultOf: anInstruction [
	^left == anInstruction or: [right == anInstruction]
]
