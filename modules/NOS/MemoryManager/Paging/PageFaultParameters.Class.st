'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PageFaultParameters category: 'SqueakNOS-MemoryManager-Paging'!
Alien subclass: #PageFaultParameters
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-MemoryManager-Paging'!
!PageFaultParameters methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:24'!
dataSize
	^4
! !

!PageFaultParameters methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
virtualFaultAddress
	^self unsignedLongAt: 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PageFaultParameters class' category: 'SqueakNOS-MemoryManager-Paging'!
PageFaultParameters class
	instanceVariableNames: ''!


