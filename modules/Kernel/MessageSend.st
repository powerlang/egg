"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #MessageSend,
	#superclass : #Message,
	#instVars : [
		'receiver'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
MessageSend class >> receiver: anObject selector: aSymbol arguments: anArray [
	^self new receiver: anObject selector: aSymbol arguments: anArray
]

{ #category : #comparing }
MessageSend >> = aMessage [
	super = aMessage ifFalse: [^false].
	^self receiver == aMessage receiver
]

{ #category : #evaluating }
MessageSend >> evaluate [
	^self perform
]

{ #category : #evaluating }
MessageSend >> evaluateFor: anObject [
	^self evaluateWithArguments: {anObject}
]

{ #category : #evaluating }
MessageSend >> evaluateWith: argObject [
	^selector arity = 1
		ifTrue: [receiver perform: selector with: argObject]
		ifFalse: [super evaluateWith: argObject]
]

{ #category : #evaluating }
MessageSend >> evaluateWithArguments: anArray [
	| args |
	args := self buildArguments: anArray.
	^receiver perform: selector withArguments: args
]

{ #category : #comparing }
MessageSend >> hash [
	^receiver hashWith: selector with: arguments
]

{ #category : #converting }
MessageSend >> newProcess [
	^Process new evaluating: self
]

{ #category : #evaluating }
MessageSend >> perform [
	^self performOn: receiver
]

{ #category : #printing }
MessageSend >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: receiver class printString;
		nextPutAll: '>>';
		nextPutAll: selector printString;
		nextPut: $)
]

{ #category : #accessing }
MessageSend >> receiver [
	^receiver
]

{ #category : #accessing }
MessageSend >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
MessageSend >> receiver: anObject selector: aSymbol arguments: anArray [
	receiver := anObject.
	selector := aSymbol.
	arguments := anArray
]

{ #category : #evaluating }
MessageSend >> value [
	^self perform
]

{ #category : #evaluating }
MessageSend >> value: value1 value: value2 [
	arguments
		at: 1 put: value1;
		at: 2 put: value2.
	^self perform
]

