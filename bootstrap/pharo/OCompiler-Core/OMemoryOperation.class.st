"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #OMemoryOperation,
	#superclass : #OPrimitiveOperation,
	#instVars : [
		'base',
		'index'
	],
	#category : #'OCompiler-Core-IR'
}

{ #category : #accessing }
OMemoryOperation >> atOperand: operandName [
	^operandName == #base ifTrue: [base] ifFalse: [index]
]

{ #category : #accessing }
OMemoryOperation >> atOperand: operandName put: instruction [
	operandName == #base
		ifTrue: [base := instruction]
		ifFalse: [index := instruction]
]

{ #category : #accessing }
OMemoryOperation >> base [
	^base
]

{ #category : #accessing }
OMemoryOperation >> base: anInstruction [
	base := anInstruction.
	anInstruction addUse: self at: #base
]

{ #category : #accessing }
OMemoryOperation >> copyTo: copy with: map [
	| i |
	super copyTo: copy with: map.
	copy base: (base duplicateWith: map).
	index isInstruction
		ifTrue: [
			i := index duplicateWith: map.
			copy index: i]
		ifFalse: [copy indexImm: index]
]

{ #category : #accessing }
OMemoryOperation >> index [
	^index
]

{ #category : #accessing }
OMemoryOperation >> index: anInstruction [
	index := anInstruction.
	anInstruction addUse: self at: #index
]

{ #category : #accessing }
OMemoryOperation >> indexImm: anInteger [
	index := anInteger
]

{ #category : #accessing }
OMemoryOperation >> isMemoryOperation [
	^true
]

{ #category : #testing }
OMemoryOperation >> usesResultOf: anInstruction [
	^base == anInstruction or: [index == anInstruction]
]
