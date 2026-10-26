'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #NullBlockCache category: 'SqueakNOS-Storage'!
Object subclass: #NullBlockCache
	instanceVariableNames: 'device'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Storage'!
!NullBlockCache methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
flushWrites
! !

!NullBlockCache methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
from: firstBlock to: lastBlock
	^device from: firstBlock to: lastBlock.
	

! !

!NullBlockCache methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aDevice
	device := aDevice.
! !

!NullBlockCache methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
readInto: byteArray startWritingAtByte: destOffset startReadingAtByte: sourceOffset bytesCount: bytesCount
	
	| data firstBlock lastBlock firstBlockBytesOffset |
	firstBlock := device blockNumberFromByteIndex: sourceOffset.
	lastBlock := device blockNumberFromByteIndex: sourceOffset + bytesCount - 1.
	
	data := device from: firstBlock to: lastBlock.
	
	firstBlockBytesOffset := device positionInBlockOf: sourceOffset.
	byteArray replaceFrom: destOffset to: destOffset + bytesCount - 1 with: data startingAt: firstBlockBytesOffset.
	^bytesCount.
	

! !

!NullBlockCache methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
replaceFromByte: destOffset bytesCount: bytesCount with: source startingAtByte: sourceOffset
	"Write count bytes from source starting at startIndex bytes. We handle half sector
	 overwriting."
	| data firstBlock lastBlock blocksCount firstBlockBytesOffset lastBlockBytesCount blockData firstSectorRead |
	
	firstBlock := device blockNumberFromByteIndex: destOffset.
	lastBlock := device blockNumberFromByteIndex: destOffset + bytesCount - 1.
	blocksCount := lastBlock - firstBlock + 1.
	
	firstSectorRead := false.
	
	data := ByteArray new: blocksCount * device blockSize.
	
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
	
	Transcript show: 'Writing ', blocksCount asString, ' sectors starting at ', firstBlock asString, '
	'.
	device at: firstBlock writeArray: data.
	

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NullBlockCache class' category: 'SqueakNOS-Storage'!
NullBlockCache class
	instanceVariableNames: ''!

!NullBlockCache class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aDevice
	^self new on: aDevice
! !


