'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #BlockArithmetic0 category: 'SqueakNOS-Storage'!
BlockArithmetic subclass: #BlockArithmetic0
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!BlockArithmetic0 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
blockNumberOf: anInteger
	^anInteger // self blockSize.
! !

!BlockArithmetic0 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
firstPositionInSameBlockOf: position
	^position - (position \\ blockSize)
! !

!BlockArithmetic0 methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
offsetInBlockOf: position
	^position \\ blockSize
! !

!BlockArithmetic0 methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:25'!
size: aSize
	^self new size: aSize
! !

!BlockArithmetic0 methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:25'!
size: aSize index: index
	^self new size: aSize index: index
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BlockArithmetic0 class' category: 'SqueakNOS-Storage'!
BlockArithmetic0 class
	instanceVariableNames: ''!


