"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OTernaryOperation',
	#superclass : 'OPrimitiveOperation',
	#instVars : [
		'receiver',
		'left',
		'right'
	],
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core',
	#tag : 'IR'
}

{ #category : 'unclassified' }
OTernaryOperation class >> receiver: receiver
left: left
right: right
name: selector [
	^self new
		receiver: receiver;
		left: left;
		right: right;
		name: selector
]

{ #category : 'unclassified' }
OTernaryOperation >> atOperand: named [
	^named == #receiver
		ifTrue: [receiver]
		ifFalse: [named == #left ifTrue: [left] ifFalse: [right]]
]

{ #category : 'unclassified' }
OTernaryOperation >> atOperand: operandName put: instruction [
	operandName = #receiver ifTrue: [receiver := instruction] ifFalse: [
		operandName = #left
			ifTrue: [left := instruction]
			ifFalse: [right := instruction]]
]

{ #category : 'unclassified' }
OTernaryOperation >> basicAcceptVisitor: aVisitor [
	^aVisitor visitTernary: self
]

{ #category : 'unclassified' }
OTernaryOperation >> basicPrintString [
	^'['
		, (receiver isInstruction
			ifTrue: [receiver primitivePrintString]
			ifFalse: [receiver printString]) , ' ' , name , ' '
		, left primitivePrintString
		, ', '
		, right primitivePrintString
		, ']'
]

{ #category : 'unclassified' }
OTernaryOperation >> isTernaryOperation [
	^true
]

{ #category : 'unclassified' }
OTernaryOperation >> left [
	^left
]

{ #category : 'unclassified' }
OTernaryOperation >> left: value [
	left := value.
	left isInstruction ifTrue: [left addUse: self at: #left]
]

{ #category : 'private' }
OTernaryOperation >> operandsDo: aBlock [
	aBlock value: receiver.
	left isInstruction ifTrue: [aBlock value: left].
	aBlock value: right
]

{ #category : 'unclassified' }
OTernaryOperation >> printStringUsing: names [
	^(receiver isInstruction
		ifTrue: [names at: receiver]
		ifFalse: [receiver printString]) , ' ' , name , ' '
		, (left isInstruction ifTrue: [names at: left] ifFalse: [left printString])
		, ', '
		, (right isInstruction
			ifTrue: [names at: right]
			ifFalse: [right printString])
]

{ #category : 'unclassified' }
OTernaryOperation >> receiver [
	^receiver
]

{ #category : 'unclassified' }
OTernaryOperation >> receiver: value [
	receiver := value.
	receiver addUse: self at: #receiver
]

{ #category : 'unclassified' }
OTernaryOperation >> right [
	^right
]

{ #category : 'unclassified' }
OTernaryOperation >> right: value [
	right := value.
	right addUse: self at: #right
]

{ #category : 'unclassified' }
OTernaryOperation >> usesResultOf: anInstruction [
	^receiver == anInstruction
		or: [left == anInstruction or: [right == anInstruction]]
]
