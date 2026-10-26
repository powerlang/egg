'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OLiveRange category: #IR!
Object subclass: #OLiveRange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OLiveRange commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OLiveRange methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isUsedBy: anInstruction
	^self allDefinitions
		anySatisfy: [:definition | anInstruction usesResultOf: definition]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OLiveRange class' category: #IR!
OLiveRange class
	instanceVariableNames: ''!

!OLiveRange class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


