"
An ATADevice is our high level representation of an ATA Hard Disk, which is a BlockDevice with blocks (sectors) of 512 bytes. It uses an ATA Controller to control the device at the lowest level. The deviceNumber is a low-level number used by the controller, where 0 means master and 1 means slave.
"
Class {
	#name : #ATADevice,
	#superclass : #BlockDevice,
	#instVars : [
		'controller',
		'deviceNumber',
		'cachedSector',
		'cachedSectorNumber'
	],
	#classInstVars : [
		'loadedDevices'
	],
	#category : 'SqueakNOS-Devices-Storage'
}

{ #category : #'as yet unclassified' }
ATADevice class >> controlledBy: aController device: aDeviceNumber [
	loadedDevices ifNil: [ loadedDevices := Dictionary new ].
	(loadedDevices at: aController 
		ifAbsentPut: [ Dictionary new ])
		at: aDeviceNumber
			ifAbsentPut: [self new controller: aController; deviceNumber: aDeviceNumber].
	^(loadedDevices at: aController) at: aDeviceNumber.
]

{ #category : #services }
ATADevice >> at: aBlockNumber [
	"Retrieve sector number aBlockNumber from device"

	^ controller at: aBlockNumber count: 1 of: deviceNumber	"Decrement 1 because block num comes 1-based and LBA indexes are 0-based"
]

{ #category : #services }
ATADevice >> at: firstBlockNumber count: numberOfBlocks [
	"Retrieve numberOfBlocks sector number aBlockNumber from device.
	 NumberOfBlocks should be no more than 256"

	^ controller at: firstBlockNumber count: numberOfBlocks of: deviceNumber
]

{ #category : #services }
ATADevice >> at: firstBlockNumber writeArray: aByteArray [
	"Write aByteArray to disk starting at firstBlockNumber. aByteArray size should be multiple of the sector size"

	controller at: firstBlockNumber of: deviceNumber putAll: aByteArray
]

{ #category : #accessing }
ATADevice >> blockSize [
	"Answer the size of a single block"

	^ 512
]

{ #category : #accessing }
ATADevice >> controller [
	"Answer the value of controller"

	^ controller
]

{ #category : #accessing }
ATADevice >> controller: aController [
	"Set the value of controller"

	controller := aController
]

{ #category : #accessing }
ATADevice >> deviceNumber [
	"Answer the value of deviceNumber"

	^ deviceNumber
]

{ #category : #accessing }
ATADevice >> deviceNumber: aDeviceNumber [
	"Set the value of deviceNumber"

	deviceNumber := aDeviceNumber
]

{ #category : #services }
ATADevice >> from: firstBlockNumber to: lastBlockNumber [
	^controller from: firstBlockNumber to: lastBlockNumber device: deviceNumber.
		
]

{ #category : #services }
ATADevice >> information [
	"I retrieve information about this device"
	| info |
	info := controller
		selectDrive: deviceNumber;
		cmdIdentifyDevice;
		readAllAvailable.
	^IDEHardDiskDeviceInformation fromHandle: info asByteArray
]

{ #category : #services }
ATADevice >> reset [
	"Reset the device. Useful after errors"
	^ controller resetDevice: deviceNumber.
	
]

{ #category : #services }
ATADevice >> size [
	^self information sectorsExtended

]
