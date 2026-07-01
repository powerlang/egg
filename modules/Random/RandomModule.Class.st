'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #RandomModule category: #Random!
Module subclass: #RandomModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Random'!
!RandomModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!RandomModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:37'!
imports
	^{
		#Kernel -> #(Float).
	}
! !

!RandomModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:37'!
exports
	^#(Random)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RandomModule class' category: #Random!
RandomModule class
	instanceVariableNames: ''!


