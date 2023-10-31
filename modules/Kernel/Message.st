"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Message,
	#superclass : #Object,
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Message class >> receiver: anObject selector: aSymbol [
	| arguments |
	arguments := Array new: aSymbol arity.
	^self receiver: anObject selector: aSymbol arguments: arguments
]

{ #category : #'instance creation' }
Message class >> receiver: anObject selector: aSymbol argument: anotherObject [
	^self receiver: anObject selector: aSymbol arguments: {anotherObject}
]

{ #category : #'instance creation' }
Message class >> receiver: anObject selector: aSymbol arguments: anArray [
	^MessageSend new receiver: anObject selector: aSymbol arguments: anArray
]

{ #category : #'instance creation' }
Message class >> selector: aSymbol [
	^self selector: aSymbol arguments: #()
]

{ #category : #'instance creation' }
Message class >> selector: aSymbol argument: anObject [
	^self selector: aSymbol arguments: {anObject}
]

{ #category : #'instance creation' }
Message class >> selector: aSymbol arguments: anArray [
	^self new selector: aSymbol; arguments: anArray
]

{ #category : #comparing }
Message >> = aMessage [
	self == aMessage ifTrue: [^true].
	self class == aMessage class ifFalse: [^false].
	self selector == aMessage selector ifFalse: [^false].
	^self arguments = aMessage arguments
]

{ #category : #accessing }
Message >> argumentAt: anInteger [
	^arguments at: anInteger
]

{ #category : #accessing }
Message >> argumentAt: anInteger put: anObject [
	arguments at: anInteger put: anObject
]

{ #category : #accessing }
Message >> arguments [
	^arguments
]

{ #category : #accessing }
Message >> arguments: anArray [
	arguments := anArray
]

{ #category : #accessing }
Message >> arity [
	^selector isNil
		ifTrue: [arguments size]
		ifFalse: [selector arity]
]

{ #category : #private }
Message >> buildArguments: aCollection [
	| predefined args |
	predefined := self arguments.
	aCollection size = predefined size ifTrue: [^aCollection].
	args := predefined isNil
		ifTrue: [Array new: selector arity]
		ifFalse: [predefined copy].
	^args
		replaceFrom: 1
		to: (aCollection size min: args size)
		with: aCollection
		startingAt: 1
]

{ #category : #comparing }
Message >> hash [
	^selector hashWith: arguments
]

{ #category : #testing }
Message >> isMessage [
	^true
]

{ #category : #evaluating }
Message >> performOn: anObject [
	^anObject perform: selector withArguments: arguments
]

{ #category : #printing }
Message >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: selector printString;
		nextPut: $)
]

{ #category : #accessing }
Message >> receiver [
	^nil
]

{ #category : #accessing }
Message >> selector [
	^selector
]

{ #category : #accessing }
Message >> selector: aSymbol [
	selector := aSymbol
]

