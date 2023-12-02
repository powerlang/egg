Class {
	#name : #DualTestBlockDevice,
	#superclass : #BlockDevice,
	#instVars : [
		'deviceA',
		'deviceB'
	],
	#category : 'SqueakNOS-Storage'
}

{ #category : #'as yet unclassified' }
DualTestBlockDevice class >> deviceA: aDeviceA deviceB: aDeviceB [
	^(self basicNew deviceA: aDeviceA deviceB: aDeviceB) initialize.
]

{ #category : #accessing }
DualTestBlockDevice >> at: aBlockNumber [
	"Retrieve sector number aBlockNumber from device"

	| result |
	result := deviceA at: aBlockNumber.
	(deviceB at: aBlockNumber) = result
		ifFalse: [ self error: 'Read failed' ].
	^ result
]

{ #category : #accessing }
DualTestBlockDevice >> at: aBlockNumber count: blocksCount [
	"Retrieve sector number aBlockNumber from device"

	| result |
	result := deviceA at: aBlockNumber count: blocksCount.
	(deviceB at: aBlockNumber count: blocksCount) = result
		ifFalse: [ self error: 'Read failed' ].
	^ result
]

{ #category : #accessing }
DualTestBlockDevice >> at: firstBlockNumber writeArray: aByteArray [
	"Write aByteArray to disk starting at firstBlockNumber. aByteArray size should be multiple of the sector size"

	deviceA at: firstBlockNumber writeArray: aByteArray.
	deviceB at: firstBlockNumber writeArray: aByteArray.
	self at: firstBlockNumber count: aByteArray size / self blockSize
]

{ #category : #'as yet unclassified' }
DualTestBlockDevice >> blockSize [
	^deviceA blockSize.
]

{ #category : #'as yet unclassified' }
DualTestBlockDevice >> deviceA: aDeviceA deviceB: aDeviceB [
	deviceA := aDeviceA.
	deviceB := aDeviceB.
]

{ #category : #'as yet unclassified' }
DualTestBlockDevice >> from: firstBlockNumber to: lastBlockNumber [
	"Retrieve sectorst from firstBlockNumber to lastBlockNumber"

	^self at: firstBlockNumber count: lastBlockNumber - firstBlockNumber + 1.
]
