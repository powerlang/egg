"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPNotParser,
	#superclass : #PPDelegateParser,
	#category : #Parsers
}

{ #category : #parsing }
PPNotParser >> parseOn: aStream [
	| element position |
	position := aStream position.
	element := parser parseOn: aStream.
	aStream position: position.
	^element isPetitFailure ifFalse: [PPFailure message: '' from: aStream]
]

{ #category : #printing }
PPNotParser >> printTextOn: rtf [
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' not'
]

