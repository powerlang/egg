"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPOptionalParser,
	#superclass : #PPDelegateParser,
	#category : #Parsers
}

{ #category : #parsing }
PPOptionalParser >> parseOn: aStream [
	| element |
	element := parser parseOn: aStream.
	^ element isPetitFailure ifFalse: [ ^ element ]
]

{ #category : #printing }
PPOptionalParser >> printTextOn: rtf [
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' optional'
]

