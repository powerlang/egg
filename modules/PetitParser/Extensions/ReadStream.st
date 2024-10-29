"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Extension { #name : #ReadStream }

{ #category : '*Extensions' }
ReadStream >> asPetitStream [
	^self collection asPetitStream
]

