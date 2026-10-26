'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #LMRSymbol category: #Kernel!
Symbol subclass: #LMRSymbol
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!LMRSymbol commentStamp: '<historical>' prior: 0!

	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
!

!LMRSymbol methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
flushCacheFor: species
	GlobalDispatchCache current flush: self forSpecies: species.
	SendSite flush: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LMRSymbol class' category: #Kernel!
LMRSymbol class
	instanceVariableNames: ''!


