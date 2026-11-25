'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #MultiBootMemoryMap category: 'SqueakNOS-External-Structures'!
ExternalStructure subclass: #MultiBootMemoryMap
	instanceVariableNames: 'size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-External-Structures'!
!MultiBootMemoryMap methodsFor:  'collection' stamp: 'KenD 28/Jun/2026 13:32:25'!
do: aBlock
	| memoryAddress entry |
	memoryAddress := self address.
		[memoryAddress - self address > self size] 
	whileFalse:
		[entry := MultiBootMemoryMapEntry fromHandle: (ExternalAddress new fromInteger: memoryAddress).
		aBlock value: entry.
		memoryAddress := memoryAddress + entry size]
! !

!MultiBootMemoryMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^size
! !

!MultiBootMemoryMap methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size: anInteger
	size := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MultiBootMemoryMap class' category: 'SqueakNOS-External-Structures'!
MultiBootMemoryMap class
	instanceVariableNames: ''!

!MultiBootMemoryMap class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
fromHandle: handle size: anInteger
	^(self fromHandle: handle) size: anInteger
! !


