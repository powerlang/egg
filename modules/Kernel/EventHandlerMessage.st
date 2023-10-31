"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #EventHandlerMessage,
	#superclass : #MessageSend,
	#instVars : [
		'arity'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
EventHandlerMessage class >> receiver: anObject selector: aSymbol [
	^self new receiver: anObject; selector: aSymbol
]

{ #category : #accessing }
EventHandlerMessage >> arity [
	^arity
]

{ #category : #accessing }
EventHandlerMessage >> receiver: anObject selector: aSymbol arguments: anArray [
	super receiver: anObject selector: aSymbol arguments: anArray.
	arity := selector arity.
	arguments size > arity ifTrue: [
		self
			error: 'The event expects no more than ' , arity asString
				, (' argument' pluralize: arity > 1)]
]

{ #category : #accessing }
EventHandlerMessage >> selector: aSymbol [
	self ASSERT: false
]

