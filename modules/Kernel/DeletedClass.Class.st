'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #DeletedClass category: #Kernel!
Class subclass: #DeletedClass
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!DeletedClass commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!DeletedClass methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
beDeleted
	"
	Do nothing
	"
	
! !

!DeletedClass methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isDeleted
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DeletedClass class' category: #Kernel!
DeletedClass class
	instanceVariableNames: ''!

!DeletedClass class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBeDeleted
	^false
! !


