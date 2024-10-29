"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPLiteralParser,
	#superclass : #PPParser,
	#instVars : [
		'literal',
		'message'
	],
	#category : #Parsers
}

{ #category : #'instance creation' }
PPLiteralParser class >> on: anObject [
	^ self on: anObject message: anObject printString , ' expected'
]

{ #category : #'instance creation' }
PPLiteralParser class >> on: anObject message: aString [
	^ self new initializeOn: anObject message: aString
]

{ #category : #operators }
PPLiteralParser >> caseInsensitive [
	"Answer a parser that can parse the receiver case-insensitive."

	self subclassResponsibility
]

{ #category : #initialization }
PPLiteralParser >> initializeOn: anObject message: aString [
	literal := anObject.
	message := aString
]

{ #category : #accessing }
PPLiteralParser >> literal [
	"Answer the parsed literal."

	^ literal
]

{ #category : #accessing }
PPLiteralParser >> message [
	"Answer the failure message."

	^ message
]

{ #category : #printing }
PPLiteralParser >> printNameOn: aStream [
	super printNameOn: aStream.
	aStream nextPutAll: ', '.
	literal storeOn: aStream
]

{ #category : #printing }
PPLiteralParser >> printOn: aStream [
	literal literalString printOn: aStream.
	aStream nextPutAll: ' asParser'
]

{ #category : #printing }
PPLiteralParser >> printTextOn: rtf [
	literal literalString printTextOn: rtf.
	rtf nextPutAll: ' asParser'
]

