"
	Copyright (c) 2021 Aucerna.
	See (MIT) license in root directory.
"

Extension { #name : #CharacterArray }

{ #category : '*SUnit' }
CharacterArray >> sunitAsSymbol [
	^self asSymbol
]

{ #category : '*SUnit' }
CharacterArray >> sunitMatch: aString [
	"Answer if there is a match starting at 1"
	| n |
	n := self size.
	aString size < n ifTrue: [^false].
	1 to: n do: [:i | (self at: i) == (aString at: i) ifFalse: [^false]].
	^true.
]

