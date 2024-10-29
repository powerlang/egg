"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPStream,
	#superclass : #InternalReadStream,
	#instVars : [
		'failure'
	],
	#category : #PetitParser
}

{ #category : #converting }
PPStream >> asPetitStream [
	^ self
]

{ #category : #accessing }
PPStream >> failure [
	^failure
]

{ #category : #accessing }
PPStream >> failure: aPPFailure [
	(failure isNil or: [failure position < aPPFailure position])
		ifTrue: [failure := aPPFailure]
]

{ #category : #accessing }
PPStream >> next: anInteger [
	| answer endPosition |
	endPosition := position + anInteger min: limit.
	answer := contents copyFrom: position + 1 to: endPosition.
	position := endPosition.
	^answer
]

{ #category : #accessing }
PPStream >> peek [
	"
	An improved version of peek, that is slightly faster than the built in version.
	"
	^self atEnd ifFalse: [contents at: position + 1]
]

{ #category : #accessing }
PPStream >> position: anInteger [
	"The receiver does not check for invalid arguments passed to this method, as it is solely used with valid indexes for backtracking."

	position := anInteger
]

{ #category : #printing }
PPStream >> printOn: aStream [
	aStream
		nextPutAll: (contents copyFrom: 1 to: position);
		nextPutAll: 'ꞈ';
		nextPutAll: (contents copyFrom: position + 1 to: limit)
]

{ #category : #accessing }
PPStream >> uncheckedPeek [
	"
	An unchecked version of peek that throws an error if we try to peek over the end of the stream, even faster than #peek.
	"
	^contents at: position + 1
]

