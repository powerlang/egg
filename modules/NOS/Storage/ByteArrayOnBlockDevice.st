"
I look like a byte array, but map operations to an underlying block device.

People talk to me as if I were a byte array, but under the hood I transform operations to block device operations (remember that block devices have a 512 byte granularity).
"
Class {
	#name : #ByteArrayOnBlockDevice,
	#superclass : #ArrayedCollection,
	#instVars : [
		'contents'
	],
	#category : 'SqueakNOS-Storage'
}

{ #category : #'instance creation' }
ByteArrayOnBlockDevice class >> on: aBlockStorage [

	^self new contents: aBlockStorage
]

{ #category : #accessing }
ByteArrayOnBlockDevice >> at: anInteger [
	^self byteAt: anInteger
]

{ #category : #accessing }
ByteArrayOnBlockDevice >> at: anInteger put: byte [
	^self byteAt: anInteger put: byte
]

{ #category : #accessing }
ByteArrayOnBlockDevice >> byteAt: index [
	^contents byteAt: index
]

{ #category : #accessing }
ByteArrayOnBlockDevice >> byteAt: index put: value [
	^contents byteAt: index put: value
]

{ #category : #accessing }
ByteArrayOnBlockDevice >> contents: aBlockStorage [
	contents := aBlockStorage
]

{ #category : #converting }
ByteArrayOnBlockDevice >> copyToMemory [
	| sectors |
	sectors := 256 * 1024. "should use 'device size' after checking ATADevices answer correctly to 'size'"
	
	^ contents from: 1 to: sectors
]

{ #category : #accessing }
ByteArrayOnBlockDevice >> segmentFrom: start to: end [
	^ByteArraySegment on: self from: start to: end
]

{ #category : #accessing }
ByteArrayOnBlockDevice >> size [
	^ contents sizeInBytes 
]

{ #category : #accessing }
ByteArrayOnBlockDevice >> species [
	^ByteArray
]

{ #category : #converting }
ByteArrayOnBlockDevice >> unsignedByteAt: byteIndex put: value [
	contents unsignedByteAt: byteIndex + offset put: value
]

{ #category : #converting }
ByteArrayOnBlockDevice >> unsignedLongAt: byteIndex [
	^ contents unsignedLongAt: byteIndex
]

{ #category : #converting }
ByteArrayOnBlockDevice >> unsignedLongAt: byteIndex put: value [
	contents unsignedLongAt: byteIndex put: value
]

{ #category : #converting }
ByteArrayOnBlockDevice >> unsignedLongAtOffset: byteOffset [
	^ self unsignedLongAt: byteOffset + 1
]

{ #category : #converting }
ByteArrayOnBlockDevice >> unsignedLongAtOffset: byteOffset put: value [
	^ self unsignedLongAt: byteOffset + 1 put: value
]

{ #category : #converting }
ByteArrayOnBlockDevice >> unsignedShortAt: byteIndex [
	^ contents unsignedShortAt: byteIndex
]

{ #category : #converting }
ByteArrayOnBlockDevice >> unsignedShortAt: byteIndex put: value [
	contents unsignedShortAt: byteIndex put: value
]

{ #category : #converting }
ByteArrayOnBlockDevice >> unsignedShortAtOffset: byteOffset [
	^self unsignedShortAt: byteOffset + 1
]

{ #category : #converting }
ByteArrayOnBlockDevice >> unsignedShortAtOffset: byteOffset put: value [
	^ self unsignedShortAt: byteOffset + 1 put: value
]
