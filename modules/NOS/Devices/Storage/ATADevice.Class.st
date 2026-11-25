'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #ATADevice category: 'SqueakNOS-Devices-Storage'!
BlockDevice subclass: #ATADevice
	instanceVariableNames: 'controller deviceNumber cachedSector cachedSectorNumber'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Storage'!
!ATADevice commentStamp: '<historical>' prior: 0!

An ATADevice is our high level representation of an ATA Hard Disk, which is a BlockDevice with blocks (sectors) of 512 bytes. It uses an ATA Controller to control the device at the lowest level. The deviceNumber is a low-level number used by the controller, where 0 means master and 1 means slave.
!

!ATADevice methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
at: aBlockNumber
	"Retrieve sector number aBlockNumber from device"

	^ controller at: aBlockNumber count: 1 of: deviceNumber	"Decrement 1 because block num comes 1-based and LBA indexes are 0-based"
! !

!ATADevice methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
at: firstBlockNumber count: numberOfBlocks
	"Retrieve numberOfBlocks sector number aBlockNumber from device.
	 NumberOfBlocks should be no more than 256"

	^ controller at: firstBlockNumber count: numberOfBlocks of: deviceNumber
! !

!ATADevice methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
at: firstBlockNumber writeArray: aByteArray
	"Write aByteArray to disk starting at firstBlockNumber. aByteArray size should be multiple of the sector size"

	controller at: firstBlockNumber of: deviceNumber putAll: aByteArray
! !

!ATADevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
blockSize
	"Answer the size of a single block"

	^ 512
! !

!ATADevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
controller
	"Answer the value of controller"

	^ controller
! !

!ATADevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
controller: aController
	"Set the value of controller"

	controller := aController
! !

!ATADevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
deviceNumber
	"Answer the value of deviceNumber"

	^ deviceNumber
! !

!ATADevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
deviceNumber: aDeviceNumber
	"Set the value of deviceNumber"

	deviceNumber := aDeviceNumber
! !

!ATADevice methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
from: firstBlockNumber to: lastBlockNumber
	^controller from: firstBlockNumber to: lastBlockNumber device: deviceNumber.
		
! !

!ATADevice methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
information
	"I retrieve information about this device"
	| info |
	info := controller
		selectDrive: deviceNumber;
		cmdIdentifyDevice;
		readAllAvailable.
	^IDEHardDiskDeviceInformation fromHandle: info asByteArray
! !

!ATADevice methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
reset
	"Reset the device. Useful after errors"
	^ controller resetDevice: deviceNumber.
	
! !

!ATADevice methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
size
	^self information sectorsExtended

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ATADevice class' category: 'SqueakNOS-Devices-Storage'!
ATADevice class
	instanceVariableNames: ''!

!ATADevice class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
controlledBy: aController device: aDeviceNumber
	loadedDevices ifNil: [ loadedDevices := Dictionary new ].
	(loadedDevices at: aController 
		ifAbsentPut: [ Dictionary new ])
		at: aDeviceNumber
			ifAbsentPut: [self new controller: aController; deviceNumber: aDeviceNumber].
	^(loadedDevices at: aController) at: aDeviceNumber.
! !


