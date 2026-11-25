'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #IdentityDictionary category: #Kernel!
InlinedDictionary subclass: #IdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!IdentityDictionary commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!IdentityDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
equates: key1 with: key2
	^key1 == key2
! !

!IdentityDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashFor: object
	^object basicHash * 16273
! !

!IdentityDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyCollector
	^IdentitySet new: self size
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IdentityDictionary class' category: #Kernel!
IdentityDictionary class
	instanceVariableNames: ''!


