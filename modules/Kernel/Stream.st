"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Stream,
	#superclass : #Object,
	#category : #Kernel
}

{ #category : #'initialization' }
Stream class >> initializePools [
	self addNamespace: Character namedCharacters
]

{ #category : #'instance creation' }
Stream class >> on: aCollection [
	^self new on: aCollection
]

{ #category : #converting }
Stream >> asStream [
	^self
]

{ #category : #testing }
Stream >> atEnd [
	self shouldNotImplement
]

{ #category : #services }
Stream >> close [
	
]

{ #category : #accessing }
Stream >> collectorClass [
	^self shouldNotImplement
]

{ #category : #private }
Stream >> eol [
	^String crlf
]

{ #category : #testing }
Stream >> isStream [
	^true
]

{ #category : #positioning }
Stream >> position [
	self shouldNotImplement
]

{ #category : #positioning }
Stream >> position: anInteger [
	self shouldNotImplement
]

{ #category : #positioning }
Stream >> reset [
	self position: 0
]

{ #category : #positioning }
Stream >> setToEnd [
	self position: self size
]

{ #category : #accessing }
Stream >> sizeToEnd [
	^self size - self position
]

{ #category : #positioning }
Stream >> skip [
	self skip: 1
]

{ #category : #positioning }
Stream >> skip: n [
	| p |
	p := self position + n min: self size.
	p := p max: 0.
	self position: p
]

