'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Warning category: #Kernel!
Notification subclass: #Warning
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Warning commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Warning methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:38'!
defaultAction
	Kernel host logWarning: self description, String cr
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Warning class' category: #Kernel!
Warning class
	instanceVariableNames: ''!


