'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #BlockArithmetic category: 'SqueakNOS-Storage'!
Object subclass: #BlockArithmetic
	instanceVariableNames: 'blockSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!BlockArithmetic methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
alignedFrom: first to: last do: aBlock
	| nextEnd remaining |
	
	nextEnd := last min: (self lastPositionInSameBlockOf: first).
	aBlock value: first value: nextEnd.
	remaining := last - nextEnd.
	[remaining > 0] whileTrue: [ | nextStart |
		nextStart := nextEnd + 1.
		nextEnd := nextEnd + (remaining min: blockSize).
		aBlock value: nextStart value: nextEnd.
		remaining := remaining - blockSize.
	].
	
! !

!BlockArithmetic methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
alignedStart: first end: last with: aBlock
	aBlock value: (self firstPositionInSameBlockOf: first) value: (self lastPositionInSameBlockOf: last).
! !

!BlockArithmetic methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
blockNumberOf: anInteger
	^anInteger - 1 // self blockSize + 1.
! !

!BlockArithmetic methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
blockSize
	"Answer the value of blockSize"

	^ blockSize
! !

!BlockArithmetic methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
blockSize: anObject
	"Set the value of blockSize"

	blockSize := anObject
! !

!BlockArithmetic methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
firstPositionInSameBlockOf: position
	^position - (position - 1 \\ blockSize)
! !

!BlockArithmetic methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
from: first to: last do: aBlock
	first to: last by: blockSize do: [ :next | aBlock value: next ].
! !

!BlockArithmetic methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
lastPositionInSameBlockOf: position
	^(self firstPositionInSameBlockOf: position) + blockSize - 1.
! !

!BlockArithmetic methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
positionInBlockOf: position
	^ position - 1 \\ blockSize + 1.
! !

!BlockArithmetic methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	"Answer the value of blockSize"

	^ blockSize
! !

!BlockArithmetic methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size: anObject
	"Set the value of blockSize"

	blockSize := anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BlockArithmetic class' category: 'SqueakNOS-Storage'!
BlockArithmetic class
	instanceVariableNames: ''!


