Class {
	#name : #BlockDeviceTest,
	#superclass : #TestCase,
	#category : #'SqueakNOS-Devices-Storage'
}

{ #category : #'as yet unclassified' }
BlockDeviceTest >> fill: aByteArray [
	1 to: 512 do: [ :i | aByteArray at: i put: i \\ 256 ].
]

{ #category : #'as yet unclassified' }
BlockDeviceTest >> test005Creation [
	self shouldnt: [ATAController primary master] raise: Error.
	self shouldnt: [ATAController secondary slave] raise: Error.

]

{ #category : #objects }
BlockDeviceTest >> testDevice [
	"Should warn that this will read and WRITE secondary slave hard disk"
	^ ATAController secondary slave.
]

{ #category : #'as yet unclassified' }
BlockDeviceTest >> testImageSaving [
	| image collection raw tester cache bytes strm1 strm2 sizeToTest |
	image := StandardFileStream fileNamed: SmalltalkImage current imageName.
	sizeToTest := 1000000.
	bytes := (image next: sizeToTest) asByteArray.
	collection := OrderedCollection new: sizeToTest.
	strm1 := ReadWriteStream on: collection.
	strm2 := ReadWriteStream on: collection copy.
	cache := BlockDeviceOnStream on: strm1 blockSize: 512.
	cache enableCache.
	raw := BlockDeviceOnStream on: strm2 blockSize: 512.
	tester := DualTestBlockDevice deviceA: cache deviceB: raw.
	tester at: 1 writeArray: bytes; flush.
	self assert: (tester fromByte: 1 bytesCount: bytes size) asByteArray = bytes.
	image close
	
]

{ #category : #'as yet unclassified' }
BlockDeviceTest >> testRead [
	| ba value |
	ba := ByteArray new: 4.
	value := -1.
	self shouldnt: [ba longAt: 1 put: value bigEndian: true] raise: Error.
	self assert: (ba longAt: 1 bigEndian: true) = value.
	self shouldnt: [ba longAt: 1 put: value bigEndian: false] raise: Error.
	self assert: (ba longAt: 1 bigEndian: false) = value.
]

{ #category : #'as yet unclassified' }
BlockDeviceTest >> testWriteChangesSector [
	| device newBytes originalBytes |
	"(self confirm: 'This test is going to permanently write into secondary master partition, are you sure you want to continue?')
		ifFalse: [^self]."
	device           := ATAController secondary master.
	originalBytes := device at: 100.
	newBytes      := ByteArray new: 512.
	
	self fill: newBytes.

	[
		device at: 100 writeArray: newBytes.
		self assert: (device at: 100) = newBytes asString
	] ensure: [ "Try to restore the original contents"
		device at: 100 writeArray: originalBytes
	]
]

{ #category : #'as yet unclassified' }
BlockDeviceTest >> testWriteManySectors [
	| device newBytes originalBytes |
	"(self confirm: 'This test is going to permanently write into secondary master partition, are you sure you want to continue?')
		ifFalse: [^self]."
	"
	device           := ATAController secondary master.
	originalBytes := device at: 100.
	newBytes      := ByteArray new: 512.
	
	self fill: newBytes.

	[
		device replaceFromByte: 1030 bytesCount: 1500 with: newBytes startingAtByte: 20.

		self assert: (device at: 100) = newBytes asString
	] ensure: [ ""Try to restore the original contents""
		device at: 100 writeArray: originalBytes
	]"
]

{ #category : #'as yet unclassified' }
BlockDeviceTest >> testWriteSector [
	| device newBytes originalBytes |
	"(self confirm: 'This test is going to permanently write into secondary master partition, are you sure you want to continue?')
		ifFalse: [^self]."
	device           := ATAController secondary master.
	originalBytes := device at: 100.
	newBytes      := ByteArray new: 512.
	
	self fill: newBytes.

	[
		device at: 100 writeArray: newBytes.
		self assert: (device at: 100) = newBytes asString
	] ensure: [ "Try to restore the original contents"
		device at: 100 writeArray: originalBytes
	]
]
