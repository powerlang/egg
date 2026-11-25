'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #BlockDevice category: 'SqueakNOS-Devices-Storage'!
Object subclass: #BlockDevice
	instanceVariableNames: 'cache'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Storage'!
!BlockDevice commentStamp: '<historical>' prior: 0!

A BlockDevice is an <<abstract class>> that represents a device that is accessed by block index. Maybe it should subclass ArrayedCollection and not Object. It implements a veeeeery primitive caching mechanism.

ATADevice is an example of a block device.
!

!BlockDevice methodsFor:  'real access' stamp: 'KenD 28/Jun/2026 13:32:24'!
at: aBlockNumber
	^ self subclassResponsibility
! !

!BlockDevice methodsFor:  'real access' stamp: 'KenD 28/Jun/2026 13:32:24'!
at: aBlockNumber write: aBlock
	^ self subclassResponsibility
! !

!BlockDevice methodsFor:  'real access' stamp: 'KenD 28/Jun/2026 13:32:24'!
at: aBlockNumber writeArray: aByteArray
	^ self subclassResponsibility
! !

!BlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
blockNumberFromByteIndex: anInteger

	^anInteger - 1 // self blockSize + 1.
! !

!BlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
blockSize
	"Answer the size of a single block"
	^ self subclassResponsibility.
! !

!BlockDevice methodsFor:  'real access' stamp: 'KenD 28/Jun/2026 13:32:24'!
byteAt: anInteger
	"blockNumberFromByteOffset: is 1-based"
	| blockNumber blockOffset |
	blockNumber := self blockNumberFromByteIndex: anInteger.
	blockOffset := anInteger - 1 \\ 512.
	^self byteAtBlock: blockNumber offset: blockOffset.

! !

!BlockDevice methodsFor:  'real access' stamp: 'KenD 28/Jun/2026 13:32:24'!
byteAt: anInteger put: value
	| byte |
	(value < 0 or: [ value > 255 ]) ifTrue: [ self halt ].
	byte := ByteArray with: value.
	^self replaceFromByte: anInteger bytesCount: 1 with: byte startingAtByte: 1

! !

!BlockDevice methodsFor:  'real access' stamp: 'KenD 28/Jun/2026 13:32:24'!
byteAtBlock: blockNumber offset: blockOffset
	^(self at: blockNumber) at: blockOffset + 1

! !

!BlockDevice methodsFor:  'real access' stamp: 'KenD 28/Jun/2026 13:32:24'!
byteAtOffset: offset
	^self byteAt: offset + 1
! !

!BlockDevice methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
bytesAt: index count: bytesCount
	^self fromByte: index bytesCount: bytesCount

! !

!BlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
disableCache
	cache flushWrites.
	cache := NullBlockCache on: self.
! !

!BlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
enableCache
	cache flushWrites.
	cache := BlockCache on: self.
! !

!BlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
flush
	
	cache flushWrites.
! !

!BlockDevice methodsFor:  'real access' stamp: 'KenD 28/Jun/2026 13:32:24'!
from: firstBlockNumber to: lastBlockNumber
	"returns a bytearray containing all blocks from firstBlockNumber to lastBlockNumber included. Block number is a 1-based index."
	^ self subclassResponsibility.
	
! !

!BlockDevice methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
fromByte: byteIndex bytesCount: bytesCount
	| data firstBlock lastBlock firstBlockBytesOffset |
	firstBlock := self blockNumberFromByteIndex: byteIndex.
	lastBlock := self blockNumberFromByteIndex: byteIndex + bytesCount - 1.
	data := self from: firstBlock to: lastBlock.
	firstBlockBytesOffset := (byteIndex - 1) \\ 512 + 1.
	^ data copyFrom: firstBlockBytesOffset to: firstBlockBytesOffset + bytesCount - 1
! !

!BlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
fromByte: firstByte toByte: lastByte
	
	| data firstBlock lastBlock firstBlockBytesOffset |
	firstBlock := self blockNumberFromByteIndex: firstByte.
	lastBlock := self blockNumberFromByteIndex: lastByte.
	
	data := self from: firstBlock to: lastBlock.
		
	firstBlockBytesOffset := self positionInBlockOf: firstByte.
	^ data copyFrom: firstBlockBytesOffset to: firstBlockBytesOffset + lastByte - firstByte.

! !

!BlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	cache := ReadBlockCache on: self
	
! !

!BlockDevice methodsFor:  'filesystem' stamp: 'KenD 28/Jun/2026 13:32:24'!
masterBootRecord
	^ MasterBootRecord on: (self at: 1)
! !

!BlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
oldreplaceFromByte: destOffset bytesCount: bytesCount with: source startingAtByte: sourceOffset
	"Write count bytes from source starting at startIndex bytes. We handle half sector
	 overwriting."
	| data firstBlock lastBlock blocksCount firstBlockBytesOffset lastBlockBytesCount blockData firstSectorRead |
	
	firstBlock := self blockNumberFromByteIndex: destOffset.
	lastBlock := self blockNumberFromByteIndex: destOffset + bytesCount - 1.
	blocksCount := lastBlock - firstBlock + 1.
	
	firstSectorRead := false.
	
	data := ByteArray new: blocksCount * self blockSize.
	
	cache := Array new: 3.
	
	"If it starts at block boundaries, we don't need to read the block. We'll probably overwrite it entirely"
	firstBlockBytesOffset := self positionInBlockOf: destOffset.
	firstBlockBytesOffset ~= 1 ifTrue: [
		firstSectorRead := true.
		blockData := self at: firstBlock.
		data replaceFrom: 1	to: self blockSize with: blockData startingAt: 1.
	].
	
	"If it ends at block boundaries, we don't need to read the last block. We'll probably overwrite it entirely"
	lastBlockBytesCount := self positionInBlockOf: destOffset + bytesCount - 1.
	lastBlockBytesCount ~= self blockSize ifTrue: [
		(blocksCount = 1 & firstSectorRead) ifFalse: [
			blockData := self at: lastBlock.
			data replaceFrom: 1	to: self blockSize with: blockData startingAt: 1.
		].
	].

	data
		replaceFrom: firstBlockBytesOffset to: (firstBlockBytesOffset + bytesCount - 1)
		with: source startingAt: sourceOffset.
	
	self at: firstBlock writeArray: data.
	
! !

!BlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
positionInBlockOf: aByteOffset
	^ aByteOffset - 1 \\ self blockSize + 1.
! !

!BlockDevice methodsFor:  'filesystem' stamp: 'KenD 28/Jun/2026 13:32:24'!
primaryFilesystem
	| mbr record segment bytes |
	mbr := self masterBootRecord.
	1 to: 4 do: [ :i | 
		record := mbr partitionRecord: i.
		segment := record partitionSegmentOn: self.
		bytes := ByteArrayOnBlockDevice on: segment.
		"FIXME: check if it is a fat32 partition"
		^ (FAT32FileSystem on: bytes) open ]
! !

!BlockDevice methodsFor:  'filesystem' stamp: 'KenD 28/Jun/2026 13:32:24'!
primaryPartition
	| mbr record segment |
	mbr := self masterBootRecord.
		record := mbr partitionRecord: 1.
		segment := record partitionSegmentOn: self.
	^ByteArrayOnBlockDevice on: segment.

! !

!BlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
readInto: byteArray startWritingAtByte: destOffset startReadingAtByte: sourceOffset bytesCount: bytesCount
	
	| firstBlock lastBlock firstBlockBytesOffset |
	firstBlock := self blockNumberFromByteIndex: sourceOffset.
	lastBlock := self blockNumberFromByteIndex: sourceOffset + bytesCount - 1.
	
	firstBlockBytesOffset := self positionInBlockOf: sourceOffset.
	byteArray replaceFrom: destOffset to: destOffset + bytesCount - 1 with: (cache from: firstBlock to: lastBlock) startingAt: firstBlockBytesOffset.
	^bytesCount.
	
	

! !

!BlockDevice methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:24'!
replaceFromByte: destOffset bytesCount: bytesCount with: source startingAtByte: sourceOffset
	"Write count bytes from source starting at startIndex bytes. We handle half sector
	 overwriting."
	cache replaceFromByte: destOffset bytesCount: bytesCount with: source startingAtByte: sourceOffset.
! !

!BlockDevice methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:24'!
segmentFrom: start size: size
	^BlockDeviceSegment on: self from: start to: start + size - 1
! !

!BlockDevice methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:32:24'!
sizeInBytes
	^self size * self blockSize 
! !

!BlockDevice methodsFor:  'real access' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedLongAt: anInteger
	^ (self bytesAt: anInteger count: 4) unsignedLongAt: 1
! !

!BlockDevice methodsFor:  'real access' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedLongAt: anInteger put: value
	| long |
	(value < 0 or: [ value >= 16r100000000 ]) ifTrue: [ self halt ].
	long := ByteArray with: (value digitAt: 1) with: (value digitAt: 2) with: (value digitAt: 3) with: (value digitAt: 4).
	^self replaceFromByte: anInteger bytesCount: 4 with: long startingAtByte: 1

! !

!BlockDevice methodsFor:  'real access' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedShortAt: anInteger
	^ (self bytesAt: anInteger count: 2) unsignedShortAt: 1
! !

!BlockDevice methodsFor:  'real access' stamp: 'KenD 28/Jun/2026 13:32:24'!
unsignedShortAt: anInteger put: value
	| short |
	(value < 0 or: [ value >= 16r10000 ]) ifTrue: [ self halt ].
	short := ByteArray with: (value digitAt: 1) with: (value digitAt: 2).
	^self replaceFromByte: anInteger bytesCount: 2 with: short startingAtByte: 1

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BlockDevice class' category: 'SqueakNOS-Devices-Storage'!
BlockDevice class
	instanceVariableNames: ''!


BlockDevice initialize!

