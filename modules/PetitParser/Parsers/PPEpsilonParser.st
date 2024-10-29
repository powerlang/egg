"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPEpsilonParser,
	#superclass : #PPParser,
	#category : #Parsers
}

{ #category : #parsing }
PPEpsilonParser >> parseOn: aStream [
	^ nil
]

{ #category : #printing }
PPEpsilonParser >> printTextOn: rtf [
	rtf
		useColor: PaintingVisitor new specialColor
		while: [rtf nextPutAll: 'nil'].
	rtf nextPutAll: ' asParser'
]

