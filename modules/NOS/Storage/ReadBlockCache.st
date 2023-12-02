Class {
	#name : #ReadBlockCache,
	#superclass : #Object,
	#instVars : [
		'device',
		'cache',
		'count'
	],
	#category : 'SqueakNOS-Storage'
}

{ #category : #'as yet unclassified' }
ReadBlockCache class >> on: aDevice [
	^self new on: aDevice
]

{ #category : #'as yet unclassified' }
ReadBlockCache >> flushWrites [
]

{ #category : #'as yet unclassified' }
ReadBlockCache >> from: firstBlock to: lastBlock [
	 | data |
	"Very primitive caching mechanism"
	(firstBlock = (cache at: 1)) & (lastBlock = (cache at: 2)) ifFalse: [
		data := device from: firstBlock to: lastBlock.
		cache := Array with: firstBlock with: lastBlock with: data.
	] ifTrue: [ data := cache at: 3].

	^data.
	

]

{ #category : #'as yet unclassified' }
ReadBlockCache >> on: aDevice [
	device := aDevice.
	cache := Array with: nil with: nil with: nil.
	count := 0.
]

{ #category : #'as yet unclassified' }
ReadBlockCache >> replaceFromByte: destOffset bytesCount: bytesCount with: source startingAtByte: sourceOffset [
	"Write count bytes from source starting at startIndex bytes. We handle half sector
	 overwriting."
	| data firstBlock lastBlock blocksCount firstBlockBytesOffset lastBlockBytesCount blockData firstSectorRead |
	
	firstBlock := device blockNumberFromByteIndex: destOffset.
	lastBlock := device blockNumberFromByteIndex: destOffset + bytesCount - 1.
	blocksCount := lastBlock - firstBlock + 1.
	
	firstSectorRead := false.
	
	data := ByteArray new: blocksCount * device blockSize.
	cache := Array with: nil with: nil with: nil.
	"If it starts at block boundaries, we don't need to read the block. We'll probably overwrite it entirely"
	firstBlockBytesOffset := device positionInBlockOf: destOffset.
	firstBlockBytesOffset ~= 1 ifTrue: [
		firstSectorRead := true.
		blockData := device at: firstBlock.
		data replaceFrom: 1	to: device blockSize with: blockData startingAt: 1.
	].
	
	"If it ends at block boundaries, we don't need to read the last block. We'll probably overwrite it entirely"
	lastBlockBytesCount := device positionInBlockOf: destOffset + bytesCount - 1.
	lastBlockBytesCount ~= device blockSize ifTrue: [
		(blocksCount = 1 & firstSectorRead) ifFalse: [
			blockData := device at: lastBlock.
			data replaceFrom: 1	to: device blockSize with: blockData startingAt: 1.
		].
	].

	data
		replaceFrom: firstBlockBytesOffset to: (firstBlockBytesOffset + bytesCount - 1)
		with: source startingAt: sourceOffset.
	
	count > 10000 ifTrue: [ count := 0.
		"Transcript show: 'Writing ', blocksCount asString, ' sectors starting at ', firstBlock asString, '
'."
	].
	count := count + bytesCount.
	
	device at: firstBlock writeArray: data.
	

]
