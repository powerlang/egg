"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPTrimmingParser,
	#superclass : #PPDelegateParser,
	#instVars : [
		'trimmer'
	],
	#category : #Parsers
}

{ #category : #'instance creation' }
PPTrimmingParser class >> on: aParser trimmer: aTrimParser [
	^ self new
		setParser: aParser;
		setTrimmer: aTrimParser;
		yourself
]

{ #category : #parsing }
PPTrimmingParser >> parseOn: aStream [
	| position element |
	position := aStream position.
	[ (trimmer parseOn: aStream) isPetitFailure ]
		whileFalse.
	element := parser parseOn: aStream.
	element isPetitFailure ifTrue: [
		aStream position: position.
		^ element ].
	[ (trimmer parseOn: aStream) isPetitFailure ]
		whileFalse.
	^ element
]

{ #category : #printing }
PPTrimmingParser >> printTextOn: rtf [
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' trim'
]

{ #category : #initialization }
PPTrimmingParser >> setTrimmer: aParser [
	trimmer := aParser
]

{ #category : #operations }
PPTrimmingParser >> trim [
	"There is no point in trimming more than once."

	^ self
]

