'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #MallocHeap category: #FFI!
Object subclass: #MallocHeap
	instanceVariableNames: 'libc'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!MallocHeap commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás. 
    See (MIT) license in root directory.

	I'm an object that represents a dynamic library such as an so, a dll or a dylib
!

!MallocHeap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
allocate: anInteger
	| address |
	address := libc calloc: anInteger size: 1.
	^ExternalMemory at: address heap: self.
! !

!MallocHeap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
free: anExternalMemory
	libc free: anExternalMemory asParameter.
! !

!MallocHeap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	libc := FFI libc
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MallocHeap class' category: #FFI!
MallocHeap class
	instanceVariableNames: ''!


MallocHeap initialize!

