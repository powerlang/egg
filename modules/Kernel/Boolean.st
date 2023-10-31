"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Boolean,
	#superclass : #Object,
	#category : #Kernel
}

{ #category : #'instance creation' }
Boolean class >> new [
	^self shouldNotImplement
]

{ #category : #'instance creation' }
Boolean class >> new: anInteger [
	^self shouldNotImplement
]

{ #category : #converting }
Boolean >> asBoolean [
	^self
]

{ #category : #printing }
Boolean >> canBePrintedAsLiteral [
	^true
]

{ #category : #copying }
Boolean >> deepCopy [
	^self
]

{ #category : #testing }
Boolean >> isBoolean [
	^true
]

{ #category : #testing }
Boolean >> isFixedObject [
	^true
]

{ #category : #copying }
Boolean >> shallowCopy [
	^self
]

{ #category : #printing }
Boolean >> storeOn: aStream [
	self printOn: aStream
]

{ #category : #'flow control' }
Boolean >> whileFalse: aBlock [
	[self] whileFalse: [aBlock value]
]

{ #category : #'flow control' }
Boolean >> whileTrue: aBlock [
	[self] whileTrue: [aBlock value]
]

