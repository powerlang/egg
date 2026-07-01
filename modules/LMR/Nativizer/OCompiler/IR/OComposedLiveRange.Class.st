'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OComposedLiveRange category: #IR!
OLiveRange subclass: #OComposedLiveRange
	instanceVariableNames: 'ranges'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OComposedLiveRange commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
add: range
	ranges add: range
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addAll: range
	ranges addAll: range
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
allDefinitions
	^ranges gather: #allDefinitions
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
allUses
	^ranges gather: #allUses
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
anyDefinition
	^ranges last anyDefinition
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
definitionsWithBlocksDo: aBlock
	^ranges do: [:range | range definitionsWithBlocksDo: aBlock]
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
endsAt: operation
	^false
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
expirationPoints
	| definitions uses |
	definitions := self allDefinitions.
	uses := ranges gather: #usesWithBlocks.
	^uses
		select: [:use | definitions
			noneSatisfy: [:def | def livesAfter: use key orOutOf: use value]]
		thenCollect: #key
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	ranges := OrderedCollection new
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isLiveAt: aBlock
	^self allDefinitions
		anySatisfy: [:def | def
			livesAfter: aBlock firstInstruction prev
			orOutOf: aBlock]
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSpilled
	^ranges anySatisfy: #isSpilled
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	| rangesStrings |
	rangesStrings := (ranges collect: #printString) gather: [:x | x , String cr].
	aStream nextPutAll: 'CLR: ' , String cr , rangesStrings
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
simpleRanges
	^ranges
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
startsAt: operation
	^ranges anySatisfy: [:range | range startsAt: operation]
! !

!OComposedLiveRange methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesWithBlocksDo: aBlock
	^ranges do: [:range | range usesWithBlocksDo: aBlock]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OComposedLiveRange class' category: #IR!
OComposedLiveRange class
	instanceVariableNames: ''!

!OComposedLiveRange class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


OComposedLiveRange initialize!

