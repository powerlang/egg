"
    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
"

Extension { #name : #Character }

{ #category : '*Extensions' }
Character class >> codePoint: anInteger [
	"
	Just for ANSI Compliance
	"
	^self value: anInteger
]

{ #category : '*Extensions' }
Character >> asParser [
	^ PPLiteralObjectParser on: self
]

{ #category : '*Extensions' }
Character >> parserTo: aCharacter [
	^PPPredicateObjectParser between: self and: aCharacter
]

{ #category : '*Extensions' }
Character >> sameAs: aCharacter [
	^self asLowercase = aCharacter asLowercase
]

