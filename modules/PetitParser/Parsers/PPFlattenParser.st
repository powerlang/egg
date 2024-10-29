"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPFlattenParser,
	#superclass : #PPDelegateParser,
	#category : #Parsers
}

{ #category : #hooks }
PPFlattenParser >> create: aCollection start: aStartInteger stop: aStopInteger [
	^ aCollection copyFrom: aStartInteger to: aStopInteger
]

{ #category : #parsing }
PPFlattenParser >> parseOn: aStream [
	| start element stop |
	start := aStream position.
	element := parser parseOn: aStream.
	element isPetitFailure ifTrue: [
		aStream position: start.
		^ element ].
	stop := aStream position.
	^ self create: aStream collection start: start + 1 stop: stop
]

{ #category : #printing }
PPFlattenParser >> printTextOn: rtf [
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' flatten'
]

