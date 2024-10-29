"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPFailure,
	#superclass : #Object,
	#instVars : [
		'message',
		'position'
	],
	#category : #PetitParser
}

{ #category : #'instance creation' }
PPFailure class >> message: aString from: aStream [
	^self basicNew message: aString from: aStream
]

{ #category : #accessing }
PPFailure >> description [
	^message
]

{ #category : #testing }
PPFailure >> isPetitFailure [
	"I am the only class that should implement this method to return true."

	^ true
]

{ #category : #accessing }
PPFailure >> message [
	"Answer a human readable error message of this parse failure."
	
	^ message
]

{ #category : #initialization }
PPFailure >> message: aString from: aStream [
	message := aString.
	position := aStream position.
	aStream failure: self
]

{ #category : #accessing }
PPFailure >> position [
	"Answer the position in the source string that caused this parse failure."

	^ position
]

{ #category : #printing }
PPFailure >> printOn: aStream [
	aStream nextPutAll: self message; nextPutAll: ' at '; print: position
]

