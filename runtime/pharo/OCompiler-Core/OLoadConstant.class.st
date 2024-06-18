"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OLoadConstant',
	#superclass : 'OInstruction',
	#instVars : [
		'constant'
	],
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core',
	#tag : 'IR'
}

{ #category : 'unclassified' }
OLoadConstant class >> valued: value [
	^self new value: value
]

{ #category : 'unclassified' }
OLoadConstant >> basicAcceptVisitor: aVisitor [
	^aVisitor visitLoadConstant: self
]

{ #category : 'unclassified' }
OLoadConstant >> basicPrintString [
	^'[load cst ' , constant printString , ']'
]

{ #category : 'unclassified' }
OLoadConstant >> canHaveSideEffects [
	^false
]

{ #category : 'private' }
OLoadConstant >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy value: constant
]

{ #category : 'unclassified' }
OLoadConstant >> isBoolean [
	^constant isBoolean
]

{ #category : 'unclassified' }
OLoadConstant >> isConstant [
	^true
]

{ #category : 'private' }
OLoadConstant >> newCopy [
	^self class valued: constant
]

{ #category : 'unclassified' }
OLoadConstant >> operandsDo: aBlock [
	constant isInstruction ifTrue: [
		self halt.
		aBlock value: constant]
]

{ #category : 'unclassified' }
OLoadConstant >> primitivePrintString [
	^'{' , constant printString , '}'
]

{ #category : 'unclassified' }
OLoadConstant >> printStringUsing: names [
	^'load cst ' , constant printString
]

{ #category : 'unclassified' }
OLoadConstant >> usesResultOf: anInstruction [
	^false
]

{ #category : 'unclassified' }
OLoadConstant >> value [
	^constant
]

{ #category : 'unclassified' }
OLoadConstant >> value: value [
	constant := value
]
