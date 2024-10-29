"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPAndParser,
	#superclass : #PPDelegateParser,
	#category : #Parsers
}

{ #category : #operations }
PPAndParser >> and [
	^ self
]

{ #category : #parsing }
PPAndParser >> parseOn: aStream [
	| element position |
	position := aStream position.
	element := parser parseOn: aStream.
	aStream position: position.
	^ element
]

{ #category : #printing }
PPAndParser >> printTextOn: rtf [
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' and'
]

