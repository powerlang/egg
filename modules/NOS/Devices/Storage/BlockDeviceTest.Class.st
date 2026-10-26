'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #BlockDeviceTest category: #'SqueakNOS-Devices-Storage'!
TestCase subclass: #BlockDeviceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Storage'!
!BlockDeviceTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
fill: aByteArray
	1 to: 512 do: [ :i | aByteArray at: i put: i \\ 256 ].
! !

!BlockDeviceTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
test005Creation
	self shouldnt: [ATAController primary master] raise: Error.
	self shouldnt: [ATAController secondary slave] raise: Error.

! !

!BlockDeviceTest methodsFor:  'objects' stamp: 'KenD 28/Jun/2026 13:32:24'!
testDevice
	"Should warn that this will read and WRITE secondary slave hard disk"
	^ ATAController secondary slave.
! !

!BlockDeviceTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
testImageSaving
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
	
! !

!BlockDeviceTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
testRead
	| ba value |
	ba := ByteArray new: 4.
	value := -1.
	self shouldnt: [ba longAt: 1 put: value bigEndian: true] raise: Error.
	self assert: (ba longAt: 1 bigEndian: true) = value.
	self shouldnt: [ba longAt: 1 put: value bigEndian: false] raise: Error.
	self assert: (ba longAt: 1 bigEndian: false) = value.
! !

!BlockDeviceTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
testWriteChangesSector
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
! !

!BlockDeviceTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
testWriteManySectors
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
! !

!BlockDeviceTest methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
testWriteSector
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
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BlockDeviceTest class' category: #'SqueakNOS-Devices-Storage'!
BlockDeviceTest class
	instanceVariableNames: ''!


