'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #BlockDeviceSegment category: 'SqueakNOS-Storage'!
BlockDevice subclass: #BlockDeviceSegment
	instanceVariableNames: 'device offset size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!BlockDeviceSegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: index
	^device at: index + offset
! !

!BlockDeviceSegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: firstBlockNumber writeArray: aByteArray
	^device at: firstBlockNumber + offset writeArray: aByteArray
! !

!BlockDeviceSegment methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
blockSize
	^ device blockSize
! !

!BlockDeviceSegment methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
from: start to: stop
	^device from: start + offset to: stop + offset
! !

!BlockDeviceSegment methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aBlockStorage from: start to: stop
	device := aBlockStorage.
	offset := start - 1.
	size := stop - start + 1 . size >= 0
		ifFalse: [ self halt ]
! !

!BlockDeviceSegment methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^size
! !

!BlockDeviceSegment methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
sizeInBytes
	^size * device blockSize
! !

!BlockDeviceSegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedLongAt: byteIndex
	^ device unsignedLongAt: byteIndex + (offset * self blockSize)
! !

!BlockDeviceSegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedLongAt: byteIndex put: value
	^ device unsignedLongAt: byteIndex + (offset * self blockSize) put: value
! !

!BlockDeviceSegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShortAt: byteIndex
	^ device unsignedShortAt: byteIndex + (offset * self blockSize)
! !

!BlockDeviceSegment methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:25'!
unsignedShortAt: byteIndex put: value
	^ device unsignedShortAt: byteIndex + (offset * self blockSize) put: value
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BlockDeviceSegment class' category: 'SqueakNOS-Storage'!
BlockDeviceSegment class
	instanceVariableNames: ''!

!BlockDeviceSegment class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aBlockStorage from: start to: stop
	^self new on: aBlockStorage from: start to: stop

! !


