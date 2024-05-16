"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #OJump,
	#superclass : #OInstruction,
	#instVars : [
		'target'
	],
	#category : #'OCompiler-Core-IR'
}

{ #category : #unclassified }
OJump class >> to: aDestination [
	^self new target: aDestination
]

{ #category : #unclassified }
OJump >> afterConnect: anInstruction [
	self _ASSERT: anInstruction isEnd.
	^super afterConnect: anInstruction
]

{ #category : #unclassified }
OJump >> basicAcceptVisitor: aVisitor [
	^aVisitor visitJump: self
]

{ #category : #unclassified }
OJump >> basicPrintString [
	^'[jump to ' , target name , ']'
]

{ #category : #private }
OJump >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy target: (target duplicateWith: map)
]

{ #category : #unclassified }
OJump >> isJump [
	^true
]

{ #category : #private }
OJump >> operandsDo: aBlock [
	
]

{ #category : #unclassified }
OJump >> primitivePrintString [
	^'{jump}'
]

{ #category : #unclassified }
OJump >> printStringUsing: names [
	^'jump to ' , (names at: target ifAbsent: ['?'])
]

{ #category : #unclassified }
OJump >> retargetFrom: aBasicBlock to: otherBasicBlock [
	target := otherBasicBlock
]

{ #category : #private }
OJump >> successorsDo: aBlock [
	aBlock value: target
]

{ #category : #unclassified }
OJump >> target [
	^target
]

{ #category : #unclassified }
OJump >> target: aBasicBlock [
	target := aBasicBlock
]

{ #category : #unclassified }
OJump >> targets [
	^OrderedCollection with: target
]

{ #category : #unclassified }
OJump >> usesResultOf: anInstruction [
	^false
]
