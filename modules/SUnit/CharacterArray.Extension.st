'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!


!CharacterArray methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
sunitAsSymbol
	^self asSymbol
! !

!CharacterArray methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
sunitMatch: aString
	"Answer if there is a match starting at 1"
	| n |
	n := self size.
	aString size < n ifTrue: [^false].
	1 to: n do: [:i | (self at: i) == (aString at: i) ifFalse: [^false]].
	^true.
! !


