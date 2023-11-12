Class {
	#name : #BlockCache,
	#superclass : #Object,
	#instVars : [
		'device',
		'chunks',
		'writeList'
	],
	#category : #'SqueakNOS-Storage'
}

{ #category : #'as yet unclassified' }
BlockCache class >> on: aBlockDevice [
	^self new on: aBlockDevice.
]

{ #category : #'as yet unclassified' }
BlockCache >> blockSize [
	^device blockSize
]

{ #category : #'as yet unclassified' }
BlockCache >> chunkSize [
	^256
]

{ #category : #'as yet unclassified' }
BlockCache >> chunksFrom: firstBlockOfFirstChunk to: firstBlockOfLastChunk [
	
	^(firstBlockOfFirstChunk to: firstBlockOfLastChunk by: self chunkSize) collect: [ :firstBlockOfChunk |
		chunks at: firstBlockOfChunk ifAbsent: [ | aByteArray |
			aByteArray := device from: firstBlockOfChunk to: firstBlockOfChunk + self chunkSize - 1.
			chunks at: firstBlockOfChunk put: aByteArray.
			self updateChunk: aByteArray withWritesAt: firstBlockOfChunk.
			aByteArray
		]
	  ]
	
	
]

{ #category : #'as yet unclassified' }
BlockCache >> clear [
	"Discards all changes"
	chunks := Dictionary new.
	writeList := WriteList new.
]

{ #category : #'as yet unclassified' }
BlockCache >> concatenationFrom: first to: last of: aCollectionOfChunks [
	| result offsetInResult chunkFirst helper i |
	helper := BlockArithmetic new blockSize: self chunkSize.
	i := 1.
	result := ByteArray new: last - first + 1 * self blockSize.
	offsetInResult := 1.
	chunkFirst := first - 1 * self blockSize + 1.

	helper alignedFrom: first to: last do: [ :nextStart :nextEnd | | count |

		count := nextEnd - nextStart + 1 * self blockSize.
		result replaceFrom: offsetInResult to: offsetInResult + count - 1 with: (aCollectionOfChunks at: i) startingAt: chunkFirst.
		chunkFirst := 1.
		i := i + 1.
		offsetInResult := offsetInResult + count.
	].

	^result

]

{ #category : #'as yet unclassified' }
BlockCache >> flushWrites [
	| helper buffer |
	self halt.
	helper := BlockArithmetic new size: self blockSize.
	writeList do: [ :byteStart :byteEnd :segments |
	
		helper alignedStart: byteStart end: byteEnd with: [ :alignedByteStart :alignedByteEnd  |
			buffer := ByteArray new: alignedByteEnd - alignedByteStart + 1.
			self readHalfWrittenSectorsInto: buffer start: byteStart end: byteEnd.
		
			segments do: [ :aSegment | 
				buffer replaceFrom: (aSegment at: 1) - alignedByteStart + 1
					    to: (aSegment at: 1) - alignedByteStart + (aSegment at: 2) size
					    with: (aSegment at: 2) startingAt: 1
			].

			device at: (helper blockNumberOf: alignedByteStart) writeArray: buffer.
		
		]
	].

	writeList clear.
	
	
]

{ #category : #'as yet unclassified' }
BlockCache >> from: firstBlock to: lastBlock [
	| helper | 
	helper := BlockArithmetic new size: self chunkSize.
	
	helper alignedStart: firstBlock end: lastBlock with: [ :firstBlockOfFirstChunk :lastBlockOfLastChunk | | firstBlockOfLastChunk |
		firstBlockOfLastChunk := lastBlockOfLastChunk - self chunkSize + 1.
		^self concatenationFrom: firstBlock - firstBlockOfFirstChunk + 1
				to: lastBlock - firstBlockOfFirstChunk + 1
				of: (self chunksFrom: firstBlockOfFirstChunk to: firstBlockOfLastChunk).
	].
	
	
]

{ #category : #'as yet unclassified' }
BlockCache >> invalidateFrom: destOffset bytesCount: bytesCount [
	| helper |
	helper := BlockArithmetic new size: self chunkSize * self blockSize.
	helper from: (helper blockNumberOf: destOffset) to: (helper blockNumberOf: destOffset + bytesCount - 1) do: [ :chunkStart |
		chunks removeKey: chunkStart ifAbsent: [].
	].
]

{ #category : #'as yet unclassified' }
BlockCache >> on: aBlockDevice [
	device := aBlockDevice.
	chunks := Dictionary new.
	writeList := WriteList new.
]

{ #category : #'as yet unclassified' }
BlockCache >> readHalfWrittenSectorsInto: buffer start: byteStart end: byteEnd [

	| firstBlock lastBlock blocksCount firstSectorRead helper |

	helper := BlockArithmetic new blockSize: self blockSize.
	firstSectorRead := false.
	firstBlock := helper blockNumberOf: byteStart.
	lastBlock := helper blockNumberOf: byteEnd.
	blocksCount := lastBlock - firstBlock + 1.

	"If it starts at block boundaries, we don't need to read the block. We'll probably overwrite it entirely"
	(helper positionInBlockOf: byteStart ) ~= 1 ifTrue: [
		firstSectorRead := true.
		buffer replaceFrom: 1 to: self blockSize with: (device at: firstBlock) startingAt: 1.
	].

	"If it ends at block boundaries, we don't need to read the last block. We'll probably overwrite it entirely"
	(helper positionInBlockOf: byteEnd) ~= self blockSize ifTrue: [
		(blocksCount = 1 & firstSectorRead) ifFalse: [
			buffer replaceFrom: 1	to: self blockSize with: (device at: lastBlock) startingAt: 1.
		].
	].

]

{ #category : #'as yet unclassified' }
BlockCache >> replaceFromByte: destOffset bytesCount: bytesCount with: source startingAtByte: sourceOffset [
	"Transcript show: 'Writing from: ', destOffset, ' count: ', bytesCount, '
	'."
	writeList at: destOffset wrote: (source copyFrom: sourceOffset to: sourceOffset + bytesCount - 1).
	
	self updateChunksFrom: destOffset bytesCount: bytesCount with: source startingAtByte: sourceOffset.
		
]

{ #category : #'as yet unclassified' }
BlockCache >> updateChunk: aChunk withWritesAt: firstBlockOfChunk [
	writeList writeFrom: firstBlockOfChunk - 1 * self blockSize + 1
			  to: firstBlockOfChunk + self chunkSize - 1 * self blockSize
			  into: aChunk.
	
	
]

{ #category : #'as yet unclassified' }
BlockCache >> updateChunksFrom: destOffset bytesCount: bytesCount with: source startingAtByte: sourceOffset [
	| helper sourceStart |
	helper := BlockArithmetic new size: self chunkSize * self blockSize.
	sourceStart := sourceOffset.
	
	helper alignedFrom: destOffset to: destOffset + bytesCount - 1 do: [ :nextStart :nextEnd |
		chunks at: (helper firstPositionInSameBlockOf: nextStart) - 1 // self blockSize + 1 ifPresent: [ :aByteArray |
			aByteArray replaceFrom: (helper positionInBlockOf: nextStart) to: (helper positionInBlockOf: nextEnd) with: source startingAt: sourceStart.
			sourceStart := sourceStart + self blockSize.
		].
	].
]
