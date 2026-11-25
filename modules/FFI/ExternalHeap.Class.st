'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #ExternalHeap category: #FFI!
Object subclass: #ExternalHeap
	instanceVariableNames: 'clib'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!ExternalHeap commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that represents a dynamic library such as an so, a dll or a dylib
!

!ExternalHeap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
allocate: anInteger
	^self subclassResponsibility
! !

!ExternalHeap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
free: anExternalMemory
	^self subclassResponsibility
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExternalHeap class' category: #FFI!
ExternalHeap class
	instanceVariableNames: ''!


