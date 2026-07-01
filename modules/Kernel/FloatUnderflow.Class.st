'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #FloatUnderflow category: #Kernel!
Notification subclass: #FloatUnderflow
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!FloatUnderflow commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!FloatUnderflow methodsFor:  'error handling' stamp: 'KenD 28/Jun/2026 13:27:38'!
defaultAction
	^0.0
! !

!FloatUnderflow methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
type
	^#underflow
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FloatUnderflow class' category: #Kernel!
FloatUnderflow class
	instanceVariableNames: ''!


