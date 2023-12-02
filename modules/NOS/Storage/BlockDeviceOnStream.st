"
I provide objects that allow to see files as block devices. It's similar to loop devices in linux.
"
Class {
	#name : #BlockDeviceOnStream,
	#superclass : #BlockDevice,
	#instVars : [
		'stream',
		'blockSize'
	],
	#category : 'SqueakNOS-Storage'
}

{ #category : #'instance creation' }
BlockDeviceOnStream class >> on: aStream blockSize: anInteger [ 
	^self new on: aStream blockSize: anInteger  
]

{ #category : #accessing }
BlockDeviceOnStream >> at: aBlockNumber [
	"Retrieve sector number aBlockNumber from device"

	stream position: (aBlockNumber - 1) * self blockSize.
	^ stream next: self blockSize
]

{ #category : #'as yet unclassified' }
BlockDeviceOnStream >> at: aBlockNumber count: blocksCount [
	"Retrieve sector number aBlockNumber from device"

	stream position: (aBlockNumber - 1 * self blockSize).
	^stream next: self blockSize * blocksCount.
]

{ #category : #accessing }
BlockDeviceOnStream >> at: firstBlockNumber writeArray: aByteArray [
	"Write aByteArray to disk starting at firstBlockNumber. aByteArray size should be multiple of the sector size"

	stream position: (firstBlockNumber - 1) * self blockSize.
	stream nextPutAll: aByteArray
]

{ #category : #'as yet unclassified' }
BlockDeviceOnStream >> blockSize [
	^blockSize.
]

{ #category : #'as yet unclassified' }
BlockDeviceOnStream >> from: firstBlockNumber to: lastBlockNumber [
	"Retrieve sectorst from firstBlockNumber to lastBlockNumber"

	^self at: firstBlockNumber count: lastBlockNumber - firstBlockNumber + 1.
]

{ #category : #'methodsFor:' }
BlockDeviceOnStream >> on: aStream blockSize: aBlockSize [
	stream := aStream.
	stream binary.
	blockSize := aBlockSize.
]

{ #category : #'methodsFor:' }
BlockDeviceOnStream >> size [
	^stream size / self blockSize
]
