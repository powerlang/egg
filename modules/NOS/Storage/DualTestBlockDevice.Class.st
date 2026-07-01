'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #DualTestBlockDevice category: 'SqueakNOS-Storage'!
BlockDevice subclass: #DualTestBlockDevice
	instanceVariableNames: 'deviceA deviceB'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!DualTestBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: aBlockNumber
	"Retrieve sector number aBlockNumber from device"

	| result |
	result := deviceA at: aBlockNumber.
	(deviceB at: aBlockNumber) = result
		ifFalse: [ self error: 'Read failed' ].
	^ result
! !

!DualTestBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: aBlockNumber count: blocksCount
	"Retrieve sector number aBlockNumber from device"

	| result |
	result := deviceA at: aBlockNumber count: blocksCount.
	(deviceB at: aBlockNumber count: blocksCount) = result
		ifFalse: [ self error: 'Read failed' ].
	^ result
! !

!DualTestBlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: firstBlockNumber writeArray: aByteArray
	"Write aByteArray to disk starting at firstBlockNumber. aByteArray size should be multiple of the sector size"

	deviceA at: firstBlockNumber writeArray: aByteArray.
	deviceB at: firstBlockNumber writeArray: aByteArray.
	self at: firstBlockNumber count: aByteArray size / self blockSize
! !

!DualTestBlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
blockSize
	^deviceA blockSize.
! !

!DualTestBlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
deviceA: aDeviceA deviceB: aDeviceB
	deviceA := aDeviceA.
	deviceB := aDeviceB.
! !

!DualTestBlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
from: firstBlockNumber to: lastBlockNumber
	"Retrieve sectorst from firstBlockNumber to lastBlockNumber"

	^self at: firstBlockNumber count: lastBlockNumber - firstBlockNumber + 1.
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DualTestBlockDevice class' category: 'SqueakNOS-Storage'!
DualTestBlockDevice class
	instanceVariableNames: ''!

!DualTestBlockDevice class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
deviceA: aDeviceA deviceB: aDeviceB
	^(self basicNew deviceA: aDeviceA deviceB: aDeviceB) initialize.
! !


