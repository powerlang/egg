Class {
	#name : #MemoryBlockDevice,
	#superclass : #BlockDevice,
	#instVars : [
		'contents',
		'blockSize'
	],
	#category : 'SqueakNOS-Storage'
}

{ #category : #'instance creation' }
MemoryBlockDevice class >> on: bytes blockSize: blockSize [
	^self new contents: bytes; blockSize: blockSize
]

{ #category : #accessing }
MemoryBlockDevice >> at: aBlockNumber [
	"Retrieve sector number aBlockNumber from device"
	| start end |
	start := aBlockNumber - 1 * blockSize + 1.
	end := start + blockSize. 
	^contents copyFrom: start to: end
]

{ #category : #accessing }
MemoryBlockDevice >> blockSize [
	^blockSize
]

{ #category : #accessing }
MemoryBlockDevice >> blockSize: anInteger [
	blockSize := anInteger
]

{ #category : #accessing }
MemoryBlockDevice >> contents [
	^contents
]

{ #category : #accessing }
MemoryBlockDevice >> contents: anInteger [
	contents := anInteger
]
