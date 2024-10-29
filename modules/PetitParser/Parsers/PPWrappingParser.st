"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Class {
	#name : #PPWrappingParser,
	#superclass : #PPActionParser,
	#category : #Parsers
}

{ #category : #parsing }
PPWrappingParser >> parseOn: aStream [
	^ block value: aStream value: [ parser parseOn: aStream ]
]

{ #category : #printing }
PPWrappingParser >> printTextOn: rtf [
	parser printSmalltalkReceiverOn: rtf.
	rtf
		useColor: PaintingVisitor new defaultColor
		while: [rtf nextPutAll: ' >=> '].
	block printTextOn: rtf
]

