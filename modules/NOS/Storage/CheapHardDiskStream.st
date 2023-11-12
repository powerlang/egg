Class {
	#name : #CheapHardDiskStream,
	#superclass : #StandardFileStream,
	#instVars : [
		'fileSize',
		'offset'
	],
	#category : #'SqueakNOS-Storage'
}

{ #category : #'as yet unclassified' }
CheapHardDiskStream class >> on: anATADevice [
	^self new device: anATADevice.
]

{ #category : #accessing }
CheapHardDiskStream >> device: device [
	fileID := device.
	buffer1 := String new: 1.
	name := device printString.
	position := 0.
	offset := 0.
	fileSize := 199493210.
	rwmode := true.
	self enableReadBuffering
]

{ #category : #accessing }
CheapHardDiskStream >> fileSize [
	"Answer the value of fileSize"

	^ fileSize
]

{ #category : #accessing }
CheapHardDiskStream >> fileSize: anObject [
	"Set the value of fileSize"

	fileSize := anObject
]

{ #category : #primitives }
CheapHardDiskStream >> primAtEnd: id [
	^(self primSize: id) = position
]

{ #category : #primitives }
CheapHardDiskStream >> primClose: id [
]

{ #category : #primitives }
CheapHardDiskStream >> primCloseNoError: id [
]

{ #category : #primitives }
CheapHardDiskStream >> primFlush: id [
	id flush
]

{ #category : #primitives }
CheapHardDiskStream >> primGetPosition: id [
	^offset
]

{ #category : #primitives }
CheapHardDiskStream >> primRead: aDriveNumber into: byteArray startingAt: startIndex count: count [

	fileID
		readInto: byteArray
		startWritingAtByte: startIndex
		startReadingAtByte: offset + 1
		bytesCount: count.
	
	offset := offset + count.
	^count

]

{ #category : #primitives }
CheapHardDiskStream >> primSetPosition: id to: anInteger [
	anInteger > fileSize ifTrue: [self error: 'Out of bounds'].
	offset := anInteger
]

{ #category : #primitives }
CheapHardDiskStream >> primSize: id [
	^offset
]

{ #category : #primitives }
CheapHardDiskStream >> primSizeNoError: id [
	^self primSize: id
]

{ #category : #primitives }
CheapHardDiskStream >> primTruncate: id to: anInteger [
]

{ #category : #primitives }
CheapHardDiskStream >> primWrite: aDriveNumber from: stringOrByteArray startingAt: startIndex count: count [
	"remember that fileID isn't an ID but actually an ATA Device."
	| pos |
	pos := self primGetPosition: fileID.
	fileID replaceFromByte: offset + 1 bytesCount: count 
		  with: stringOrByteArray startingAtByte: startIndex.
	fileSize := fileSize max: pos + count.
	self primSetPosition: fileID to: pos + count.
	^count

]
