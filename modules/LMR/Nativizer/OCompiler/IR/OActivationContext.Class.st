'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OActivationContext category: #IR!
OLoadImplicit subclass: #OActivationContext
	instanceVariableNames: 'hasFrame temporaries storesPreviousSelf'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OActivationContext commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OActivationContext methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
doSavePreviousSelf
	storesPreviousSelf := true
! !

!OActivationContext methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasFrame
	^hasFrame
! !

!OActivationContext methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
haveFrame
	hasFrame := true
! !

!OActivationContext methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	hasFrame := false.
	storesPreviousSelf := false
! !

!OActivationContext methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
savesPreviousSelf
	^storesPreviousSelf
! !

!OActivationContext methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
temporaries
	^temporaries
! !

!OActivationContext methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
temporaries: aNumber
	temporaries := aNumber.
	aNumber > 0 ifTrue: [self haveFrame]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OActivationContext class' category: #IR!
OActivationContext class
	instanceVariableNames: ''!

!OActivationContext class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


OActivationContext initialize!

