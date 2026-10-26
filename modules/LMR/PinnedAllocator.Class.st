'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PinnedAllocator category: #Kernel!
Allocator subclass: #PinnedAllocator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!PinnedAllocator commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!PinnedAllocator methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocate: anInteger
	^memory pinnedAllocate: anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PinnedAllocator class' category: #Kernel!
PinnedAllocator class
	instanceVariableNames: ''!


