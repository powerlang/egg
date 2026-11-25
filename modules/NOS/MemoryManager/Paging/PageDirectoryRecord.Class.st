'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PageDirectoryRecord category: 'SqueakNOS-MemoryManager-Paging'!
Alien subclass: #PageDirectoryRecord
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-MemoryManager-Paging'!
!PageDirectoryRecord methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:24'!
initializeSameAddresses
	| i |
	i := 1.
	self records do: [:record | record address: i]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PageDirectoryRecord class' category: 'SqueakNOS-MemoryManager-Paging'!
PageDirectoryRecord class
	instanceVariableNames: ''!


