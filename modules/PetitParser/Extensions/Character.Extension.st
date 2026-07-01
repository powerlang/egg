'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Character methodsFor:  '*Extensions' stamp: 'KenD 28/Jun/2026 13:27:39'!
asParser
	^ PPLiteralObjectParser on: self
! !

!Character methodsFor:  '*Extensions' stamp: 'KenD 28/Jun/2026 13:27:39'!
parserTo: aCharacter
	^PPPredicateObjectParser between: self and: aCharacter
! !

!Character methodsFor:  '*Extensions' stamp: 'KenD 28/Jun/2026 13:27:39'!
sameAs: aCharacter
	^self asLowercase = aCharacter asLowercase
! !

!Character class methodsFor:  '*Extensions' stamp: 'KenD 28/Jun/2026 13:27:39'!
codePoint: anInteger
	"
	Just for ANSI Compliance
	"
	^self value: anInteger
! !


