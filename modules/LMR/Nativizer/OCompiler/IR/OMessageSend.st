"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OMessageSend,
	#superclass : #OInstruction,
	#instVars : [
		'receiver',
		'selector',
		'arguments'
	],
	#category : #IR
}

{ #category : #unclassified }
OMessageSend class >> receiver: receiver selector: selector arguments: arguments [
	^self new
		receiver: receiver;
		selector: selector;
		arguments: arguments;
		yourself
]

{ #category : #unclassified }
OMessageSend class >> selector: selector [
	^self new selector: selector
]

{ #category : #unclassified }
OMessageSend >> arguments [
	^arguments
]

{ #category : #unclassified }
OMessageSend >> arguments: operands [
	arguments := operands
]

{ #category : #unclassified }
OMessageSend >> atOperand: named [
	^named == #receiver ifTrue: [receiver] ifFalse: [arguments at: named]
]

{ #category : #unclassified }
OMessageSend >> atOperand: name put: instruction [
	name = #receiver
		ifTrue: [receiver := instruction]
		ifFalse: [arguments at: name put: instruction]
]

{ #category : #unclassified }
OMessageSend >> basicAcceptVisitor: aVisitor [
	^aVisitor visitMessageSend: self
]

{ #category : #unclassified }
OMessageSend >> basicPrintString [
	^String streamContents: [:s |
		s nextPutAll: '[send #'; nextPutAll: selector;
			nextPutAll: ' to '; nextPutAll: receiver primitivePrintString.
		arguments notEmpty ifTrue: [
			s nextPutAll: ' with: '.
			arguments
				do: [:arg | s nextPutAll: arg primitivePrintString]
				separatedBy: [s nextPutAll: ', ']].
		s nextPut: $]]
]

{ #category : #unclassified }
OMessageSend >> isMessageSend [
	^true
]

{ #category : #unclassified }
OMessageSend >> operandsDo: aBlock [
	aBlock value: receiver.
	arguments do: aBlock
]

{ #category : #unclassified }
OMessageSend >> primitivePrintString [
	^'{#' , selector , '}'
]

{ #category : #unclassified }
OMessageSend >> printStringUsing: names [
	^String streamContents: [:s |
		s nextPutAll: 'send #'; nextPutAll: selector;
			nextPutAll: ' to '; nextPutAll: (names at: receiver ifAbsent: ['missing']).
		arguments notEmpty ifTrue: [
			s nextPutAll: ' with: '.
			arguments
				do: [:arg | s nextPutAll: (names at: arg ifAbsent: ['missing'])]
				separatedBy: [s nextPutAll: ', ']]]
]

{ #category : #unclassified }
OMessageSend >> receiver [
	^receiver
]

{ #category : #unclassified }
OMessageSend >> receiver: operand [
	receiver := operand
]

{ #category : #unclassified }
OMessageSend >> selector [
	^selector
]

{ #category : #unclassified }
OMessageSend >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #unclassified }
OMessageSend >> usesResultOf: anInstruction [
	^receiver == anInstruction
		or: [arguments anySatisfy: [:argument | argument == anInstruction]]
]

