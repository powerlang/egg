'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #BlockDeviceOnStream category: 'SqueakNOS-Storage'!
BlockDevice subclass: #BlockDeviceOnStream
	instanceVariableNames: 'stream blockSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!BlockDeviceOnStream commentStamp: '<historical>' prior: 0!

I provide objects that allow to see files as block devices. It's similar to loop devices in linux.
!

!BlockDeviceOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: aBlockNumber
	"Retrieve sector number aBlockNumber from device"

	stream position: (aBlockNumber - 1) * self blockSize.
	^ stream next: self blockSize
! !

!BlockDeviceOnStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: aBlockNumber count: blocksCount
	"Retrieve sector number aBlockNumber from device"

	stream position: (aBlockNumber - 1 * self blockSize).
	^stream next: self blockSize * blocksCount.
! !

!BlockDeviceOnStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: firstBlockNumber writeArray: aByteArray
	"Write aByteArray to disk starting at firstBlockNumber. aByteArray size should be multiple of the sector size"

	stream position: (firstBlockNumber - 1) * self blockSize.
	stream nextPutAll: aByteArray
! !

!BlockDeviceOnStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
blockSize
	^blockSize.
! !

!BlockDeviceOnStream methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
from: firstBlockNumber to: lastBlockNumber
	"Retrieve sectorst from firstBlockNumber to lastBlockNumber"

	^self at: firstBlockNumber count: lastBlockNumber - firstBlockNumber + 1.
! !

!BlockDeviceOnStream methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aStream blockSize: aBlockSize
	stream := aStream.
	stream binary.
	blockSize := aBlockSize.
! !

!BlockDeviceOnStream methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^stream size / self blockSize
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BlockDeviceOnStream class' category: 'SqueakNOS-Storage'!
BlockDeviceOnStream class
	instanceVariableNames: ''!

!BlockDeviceOnStream class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aStream blockSize: anInteger
	^self new on: aStream blockSize: anInteger  
! !


