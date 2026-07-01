'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPUnresolvedParser category: #Tools!
PPParser subclass: #PPUnresolvedParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tools'!
!PPUnresolvedParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPUnresolvedParser methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isUnresolved
	^ true
! !

!PPUnresolvedParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	self error: self printString , ' need to be resolved before execution.'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPUnresolvedParser class' category: #Tools!
PPUnresolvedParser class
	instanceVariableNames: ''!


