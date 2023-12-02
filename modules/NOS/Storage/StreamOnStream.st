Class {
	#name : #StreamOnStream,
	#superclass : #PositionableStream,
	#instVars : [
		'contentLength',
		'offset',
		'stream'
	],
	#category : 'SqueakNOS-Storage'
}

{ #category : #accessing }
StreamOnStream >> contents [
	| contents  pos |
	pos := self position.
	self position: 0.
	contents := self next: self size.
	self position: pos.
	^contents
]

{ #category : #'methodsFor:' }
StreamOnStream >> new [
	^self basicNew
]

{ #category : #accessing }
StreamOnStream >> next [
	^stream next
]

{ #category : #accessing }
StreamOnStream >> next: anInteger [ 
	^stream next: anInteger
]

{ #category : #accessing }
StreamOnStream >> nextPut: aCharacter [
	self atEnd ifFalse: [
		(stream nextPut: aCharacter) ifNotNil: [:char | 
			position := position + 1.
			^char
		]
	]
]

{ #category : #'methodsFor:' }
StreamOnStream >> on: aStream [
	^self on: aStream offset: 0.
]

{ #category : #accessing }
StreamOnStream >> on: aStream from: anIndex to: anOffset [
	stream := aStream clone.
	stream setFrom: anIndex to: anOffset.
	self setFrom: 1 to: anOffset - anIndex.
	offset := anIndex.
	self binary
]

{ #category : #'methodsFor:' }
StreamOnStream >> on: aStream offset: anOffset [
	^self on: aStream offset: anOffset size: aStream size - anOffset.
]

{ #category : #accessing }
StreamOnStream >> position [
	^position
]

{ #category : #accessing }
StreamOnStream >> position: aNumber [
	position := aNumber.
	stream position: offset + aNumber
		
]

{ #category : #accessing }
StreamOnStream >> size [
	^ readLimit
]
