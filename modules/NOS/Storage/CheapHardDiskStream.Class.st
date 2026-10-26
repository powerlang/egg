'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #CheapHardDiskStream category: 'SqueakNOS-Storage'!
StandardFileStream subclass: #CheapHardDiskStream
	instanceVariableNames: 'fileSize offset'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!CheapHardDiskStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
device: device
	fileID := device.
	buffer1 := String new: 1.
	name := device printString.
	position := 0.
	offset := 0.
	fileSize := 199493210.
	rwmode := true.
	self enableReadBuffering
! !

!CheapHardDiskStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fileSize
	"Answer the value of fileSize"

	^ fileSize
! !

!CheapHardDiskStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fileSize: anObject
	"Set the value of fileSize"

	fileSize := anObject
! !

!CheapHardDiskStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primAtEnd: id
	^(self primSize: id) = position
! !

!CheapHardDiskStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primClose: id
! !

!CheapHardDiskStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primCloseNoError: id
! !

!CheapHardDiskStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primFlush: id
	id flush
! !

!CheapHardDiskStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primGetPosition: id
	^offset
! !

!CheapHardDiskStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primRead: aDriveNumber into: byteArray startingAt: startIndex count: count

	fileID
		readInto: byteArray
		startWritingAtByte: startIndex
		startReadingAtByte: offset + 1
		bytesCount: count.
	
	offset := offset + count.
	^count

! !

!CheapHardDiskStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primSetPosition: id to: anInteger
	anInteger > fileSize ifTrue: [self error: 'Out of bounds'].
	offset := anInteger
! !

!CheapHardDiskStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primSize: id
	^offset
! !

!CheapHardDiskStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primSizeNoError: id
	^self primSize: id
! !

!CheapHardDiskStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primTruncate: id to: anInteger
! !

!CheapHardDiskStream methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:32:25'!
primWrite: aDriveNumber from: stringOrByteArray startingAt: startIndex count: count
	"remember that fileID isn't an ID but actually an ATA Device."
	| pos |
	pos := self primGetPosition: fileID.
	fileID replaceFromByte: offset + 1 bytesCount: count 
		  with: stringOrByteArray startingAtByte: startIndex.
	fileSize := fileSize max: pos + count.
	self primSetPosition: fileID to: pos + count.
	^count

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CheapHardDiskStream class' category: 'SqueakNOS-Storage'!
CheapHardDiskStream class
	instanceVariableNames: ''!

!CheapHardDiskStream class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: anATADevice
	^self new device: anATADevice.
! !


