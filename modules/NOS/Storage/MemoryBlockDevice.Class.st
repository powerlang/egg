'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #MemoryBlockDevice category: 'SqueakNOS-Storage'!
BlockDevice subclass: #MemoryBlockDevice
	instanceVariableNames: 'contents blockSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!MemoryBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: aBlockNumber
	"Retrieve sector number aBlockNumber from device"
	| start end |
	start := aBlockNumber - 1 * blockSize + 1.
	end := start + blockSize. 
	^contents copyFrom: start to: end
! !

!MemoryBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
blockSize
	^blockSize
! !

!MemoryBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
blockSize: anInteger
	blockSize := anInteger
! !

!MemoryBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents
	^contents
! !

!MemoryBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents: anInteger
	contents := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MemoryBlockDevice class' category: 'SqueakNOS-Storage'!
MemoryBlockDevice class
	instanceVariableNames: ''!

!MemoryBlockDevice class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: bytes blockSize: blockSize
	^self new contents: bytes; blockSize: blockSize
! !


