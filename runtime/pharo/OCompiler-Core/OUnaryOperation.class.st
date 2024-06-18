"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OUnaryOperation',
	#superclass : 'OPrimitiveOperation',
	#instVars : [
		'receiver'
	],
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core',
	#tag : 'IR'
}

{ #category : 'unclassified' }
OUnaryOperation class >> receiver: receiver name: aString [
	^self new name: aString; receiver: receiver
]

{ #category : 'unclassified' }
OUnaryOperation >> atOperand: operandName [
	^receiver
]

{ #category : 'unclassified' }
OUnaryOperation >> atOperand: operandName put: instruction [
	receiver := instruction
]

{ #category : 'unclassified' }
OUnaryOperation >> basicAcceptVisitor: aVisitor [
	^aVisitor visitUnary: self
]

{ #category : 'unclassified' }
OUnaryOperation >> basicPrintString [
	^'['
		, (receiver isInstruction
			ifTrue: [receiver primitivePrintString]
			ifFalse: [receiver printString]) , ' ' , name , ']'
]

{ #category : 'testing' }
OUnaryOperation >> canHaveSideEffects [
	^name == #push or: [name == #pop]
]

{ #category : 'accessing' }
OUnaryOperation >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy receiver: (receiver duplicateWith: map)
]

{ #category : 'testing' }
OUnaryOperation >> isBoolean [
	^name == #_isSmallInteger or: [name == #copy and: [receiver isBoolean]]
]

{ #category : 'unclassified' }
OUnaryOperation >> isUnaryOperation [
	^true
]

{ #category : 'unclassified' }
OUnaryOperation >> operandsDo: aBlock [
	aBlock value: receiver
]

{ #category : 'accessing' }
OUnaryOperation >> printStringUsing: names [
	^(receiver isInstruction
		ifTrue: [names at: receiver ifAbsent: '?']
		ifFalse: [receiver printString]) , ' ' , name
]

{ #category : 'unclassified' }
OUnaryOperation >> receiver [
	^receiver
]

{ #category : 'unclassified' }
OUnaryOperation >> receiver: operation [
	receiver := operation.
	operation addUse: self at: #receiver
]

{ #category : 'unclassified' }
OUnaryOperation >> usesResultOf: anInstruction [
	^receiver == anInstruction
]
