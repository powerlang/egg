Class {
	#name : #BlockDeviceSegment,
	#superclass : #BlockDevice,
	#instVars : [
		'device',
		'offset',
		'size'
	],
	#category : #'SqueakNOS-Storage'
}

{ #category : #initialization }
BlockDeviceSegment class >> on: aBlockStorage from: start to: stop [
	^self new on: aBlockStorage from: start to: stop

]

{ #category : #accessing }
BlockDeviceSegment >> at: index [
	^device at: index + offset
]

{ #category : #initialization }
BlockDeviceSegment >> blockSize [
	^ device blockSize
]

{ #category : #accessing }
BlockDeviceSegment >> from: start to: stop [
	^device from: start + offset to: stop + offset
]

{ #category : #initialization }
BlockDeviceSegment >> on: aBlockStorage from: start to: stop [
	device := aBlockStorage.
	offset := start - 1.
	size := stop - start + 1 . size >= 0
		ifFalse: [ self halt ]
]

{ #category : #initialization }
BlockDeviceSegment >> size [
	^size
]

{ #category : #initialization }
BlockDeviceSegment >> sizeInBytes [
	^size * device blockSize
]

{ #category : #converting }
BlockDeviceSegment >> unsignedLongAt: byteIndex [
	^ device unsignedLongAt: byteIndex + (offset * self blockSize)
]

{ #category : #converting }
BlockDeviceSegment >> unsignedLongAt: byteIndex put: value [
	^ device unsignedLongAt: byteIndex + (offset * self blockSize) put: value
]

{ #category : #converting }
BlockDeviceSegment >> unsignedShortAt: byteIndex [
	^ device unsignedShortAt: byteIndex + (offset * self blockSize)
]

{ #category : #converting }
BlockDeviceSegment >> unsignedShortAt: byteIndex put: value [
	^ device unsignedShortAt: byteIndex + (offset * self blockSize) put: value
]
