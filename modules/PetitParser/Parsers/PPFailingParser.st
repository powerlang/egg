"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPFailingParser,
	#superclass : #PPParser,
	#instVars : [
		'message'
	],
	#category : #Parsers
}

{ #category : #'instance creation' }
PPFailingParser class >> message: aString [
	^ self new setMessage: aString
]

{ #category : #accessing }
PPFailingParser >> message [
	"Answer the error message of the receiving parser."

	^ message
]

{ #category : #parsing }
PPFailingParser >> parseOn: aStream [
	^PPFailure message: message from: aStream
]

{ #category : #printing }
PPFailingParser >> printNameOn: aStream [
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: message
]

{ #category : #initialization }
PPFailingParser >> setMessage: aString [
	message := aString
]

