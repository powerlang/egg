"
A BlockDevice is an <<abstract class>> that represents a device that is accessed by block index. Maybe it should subclass ArrayedCollection and not Object. It implements a veeeeery primitive caching mechanism.

ATADevice is an example of a block device.
"
Class {
	#name : #BlockDevice,
	#superclass : #Object,
	#instVars : [
		'cache'
	],
	#category : #'SqueakNOS-Devices-Storage'
}

{ #category : #'real access' }
BlockDevice >> at: aBlockNumber [
	^ self subclassResponsibility
]

{ #category : #'real access' }
BlockDevice >> at: aBlockNumber write: aBlock [
	^ self subclassResponsibility
]

{ #category : #'real access' }
BlockDevice >> at: aBlockNumber writeArray: aByteArray [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
BlockDevice >> blockNumberFromByteIndex: anInteger [

	^anInteger - 1 // self blockSize + 1.
]

{ #category : #accessing }
BlockDevice >> blockSize [
	"Answer the size of a single block"
	^ self subclassResponsibility.
]

{ #category : #'real access' }
BlockDevice >> byteAt: anInteger [
	"blockNumberFromByteOffset: is 1-based"
	| blockNumber blockOffset |
	blockNumber := self blockNumberFromByteIndex: anInteger.
	blockOffset := anInteger - 1 \\ 512.
	^self byteAtBlock: blockNumber offset: blockOffset.

]

{ #category : #'real access' }
BlockDevice >> byteAtBlock: blockNumber offset: blockOffset [
	^(self at: blockNumber) at: blockOffset + 1

]

{ #category : #'real access' }
BlockDevice >> byteAtOffset: offset [
	^self byteAt: offset + 1
]

{ #category : #accessing }
BlockDevice >> bytesAt: index count: bytesCount [
	^self fromByte: index bytesCount: bytesCount

]

{ #category : #'as yet unclassified' }
BlockDevice >> disableCache [
	cache flushWrites.
	cache := NullBlockCache on: self.
]

{ #category : #'as yet unclassified' }
BlockDevice >> enableCache [
	cache flushWrites.
	cache := BlockCache on: self.
]

{ #category : #'as yet unclassified' }
BlockDevice >> flush [
	
	cache flushWrites.
]

{ #category : #'real access' }
BlockDevice >> from: firstBlockNumber to: lastBlockNumber [
	"returns a bytearray containing all blocks from firstBlockNumber to lastBlockNumber included. Block number is a 1-based index."
	^ self subclassResponsibility.
	
]

{ #category : #'instance creation' }
BlockDevice >> fromByte: byteIndex bytesCount: bytesCount [
	| data firstBlock lastBlock firstBlockBytesOffset |
	firstBlock := self blockNumberFromByteIndex: byteIndex.
	lastBlock := self blockNumberFromByteIndex: byteIndex + bytesCount - 1.
	data := self from: firstBlock to: lastBlock.
	firstBlockBytesOffset := (byteIndex - 1) \\ 512 + 1.
	^ data copyFrom: firstBlockBytesOffset to: firstBlockBytesOffset + bytesCount - 1
]

{ #category : #'as yet unclassified' }
BlockDevice >> fromByte: firstByte toByte: lastByte [
	
	| data firstBlock lastBlock firstBlockBytesOffset |
	firstBlock := self blockNumberFromByteIndex: firstByte.
	lastBlock := self blockNumberFromByteIndex: lastByte.
	
	data := self from: firstBlock to: lastBlock.
		
	firstBlockBytesOffset := self positionInBlockOf: firstByte.
	^ data copyFrom: firstBlockBytesOffset to: firstBlockBytesOffset + lastByte - firstByte.

]

{ #category : #'as yet unclassified' }
BlockDevice >> initialize [
	cache := ReadBlockCache on: self
	
]

{ #category : #filesystem }
BlockDevice >> masterBootRecord [
	^ MasterBootRecord on: (self at: 1)
]

{ #category : #'as yet unclassified' }
BlockDevice >> oldreplaceFromByte: destOffset bytesCount: bytesCount with: source startingAtByte: sourceOffset [
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
	
]

{ #category : #'as yet unclassified' }
BlockDevice >> positionInBlockOf: aByteOffset [
	^ aByteOffset - 1 \\ self blockSize + 1.
]

{ #category : #filesystem }
BlockDevice >> primaryFilesystem [
	| mbr record segment bytes |
	mbr := self masterBootRecord.
	1 to: 4 do: [ :i | 
		record := mbr partitionRecord: i.
		segment := record partitionSegmentOn: self.
		bytes := ByteArrayOnBlockDevice on: segment.
		"FIXME: check if it is a fat32 partition"
		^ (FAT32FileSystem on: bytes) open ]
]

{ #category : #filesystem }
BlockDevice >> primaryPartition [
	| mbr record segment |
	mbr := self masterBootRecord.
		record := mbr partitionRecord: 1.
		segment := record partitionSegmentOn: self.
	^ByteArrayOnBlockDevice on: segment.

]

{ #category : #'as yet unclassified' }
BlockDevice >> readInto: byteArray startWritingAtByte: destOffset startReadingAtByte: sourceOffset bytesCount: bytesCount [
	
	| firstBlock lastBlock firstBlockBytesOffset |
	firstBlock := self blockNumberFromByteIndex: sourceOffset.
	lastBlock := self blockNumberFromByteIndex: sourceOffset + bytesCount - 1.
	
	firstBlockBytesOffset := self positionInBlockOf: sourceOffset.
	byteArray replaceFrom: destOffset to: destOffset + bytesCount - 1 with: (cache from: firstBlock to: lastBlock) startingAt: firstBlockBytesOffset.
	^bytesCount.
	
	

]

{ #category : #'as yet unclassified' }
BlockDevice >> replaceFromByte: destOffset bytesCount: bytesCount with: source startingAtByte: sourceOffset [
	"Write count bytes from source starting at startIndex bytes. We handle half sector
	 overwriting."
	cache replaceFromByte: destOffset bytesCount: bytesCount with: source startingAtByte: sourceOffset.
]

{ #category : #converting }
BlockDevice >> segmentFrom: start size: size [
	^BlockDeviceSegment on: self from: start to: start + size - 1
]

{ #category : #converting }
BlockDevice >> sizeInBytes [
	^self size * self blockSize 
]

{ #category : #'real access' }
BlockDevice >> unsignedLongAt: anInteger [
	^ (self bytesAt: anInteger count: 4) unsignedLongAt: 1
]

{ #category : #'real access' }
BlockDevice >> unsignedShortAt: anInteger [
	^ (self bytesAt: anInteger count: 2) unsignedShortAt: 1
]
