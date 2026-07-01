'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #IdentitySet category: #Kernel!
Set subclass: #IdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!IdentitySet commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!IdentitySet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
equates: key with: element
	^key == element
! !

!IdentitySet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashFor: object
	^object basicHash * 16273
! !

!IdentitySet methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
includesIdentical: anObject
	^self includes: anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IdentitySet class' category: #Kernel!
IdentitySet class
	instanceVariableNames: ''!


