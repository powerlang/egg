"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ByteArraySegment,
	#superclass : #ArrayedCollection,
	#instVars : [
		'contents',
		'offset',
		'size'
	],
	#category : #Kernel
}

{ #category : #private }
ByteArraySegment class >> on: aByteArray from: start size: size [
	^self on: aByteArray from: start to: start + size - 1
]

{ #category : #private }
ByteArraySegment class >> on: aByteArray from: start to: stop [
	^self new on: aByteArray from: start to: stop
]

{ #category : #comparing }
ByteArraySegment >> = aCollection [
	| index |
	self == aCollection ifTrue: [^true].
	self class == aCollection class ifFalse: [^false].
	index := self size.
	index != aCollection size ifTrue: [^false].
	[index <= 0] whileFalse: [
		(self at: index) = (aCollection at: index) ifFalse: [^false].
		index := index - 1].
	^true
]

{ #category : #converting }
ByteArraySegment >> asByteArray [
	^self copyFrom: 1 to: size
]

{ #category : #converting }
ByteArraySegment >> asInteger [
	^self inject: 0 into: [:sum :each | (sum bitShift: 8) + each]
]

{ #category : #converting }
ByteArraySegment >> asParameter [
	^self asByteArray asParameter
]

{ #category : #converting }
ByteArraySegment >> asString [
	| string n |
	n := self size.
	(n > 0 and: [(self at: n) = 0]) ifTrue: [n := n - 1].
	string := String new: n.
	^string replaceBytesFrom: 1 to: n with: self startingAt: 1
]

{ #category : #accessing }
ByteArraySegment >> at: anInteger [
	^self byteAt: anInteger
]

{ #category : #accessing }
ByteArraySegment >> at: anInteger put: byte [
	^self byteAt: anInteger put: byte
]

{ #category : #accessing }
ByteArraySegment >> byteAt: index [
	self validateIndex: index.
	^contents at: offset + index
]

{ #category : #accessing }
ByteArraySegment >> byteAt: index put: byte [
	self validateIndex: index.
	^contents at: offset + index put: byte
]

{ #category : #accessing }
ByteArraySegment >> byteAtOffset: anInteger [
	^self byteAt: anInteger + 1
]

{ #category : #accessing }
ByteArraySegment >> byteAtOffset: anInteger put: byte [
	^self byteAt: anInteger + 1 put: byte
]

{ #category : #accessing }
ByteArraySegment >> bytesAtOffset: anInteger put: aByteArray [
	self
		replaceFrom: anInteger + 1
		to: anInteger + aByteArray sizeInBytes
		with: aByteArray
		startingAt: 1
]

{ #category : #accessing }
ByteArraySegment >> copyFrom: start to: end [
	| s |
	self validateIndex: start toIndex: end.
	^contents copyFrom: offset + start to: offset + end
]

{ #category : #accessing }
ByteArraySegment >> endOffset [
	^offset + size
]

{ #category : #accessing }
ByteArraySegment >> externalCopy [
	^ExternalMemory fromByteArray: self asByteArray
]

{ #category : #comparing }
ByteArraySegment >> hash [
	| hash |
	hash := size.
	offset + 1
		to: offset + size
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (contents at: i)].
	^hash
]

{ #category : #accessing }
ByteArraySegment >> longAtOffset: anInteger [
	self validateIndex: anInteger + 1 toIndex: anInteger + 4.
	^contents longAtOffset: offset + anInteger
]

{ #category : #accessing }
ByteArraySegment >> longAtOffset: anInteger put: long [
	self validateIndex: anInteger + 1 toIndex: anInteger + 4.
	contents longAtOffset: offset + anInteger put: long
]

{ #category : #accessing }
ByteArraySegment >> offset [
	^offset
]

{ #category : #accessing }
ByteArraySegment >> offset: anInteger [
	offset := anInteger
]

{ #category : #private }
ByteArraySegment >> on: aByteArray from: start to: stop [
	contents := aByteArray.
	offset := start - 1.
	size := stop - start + 1
]

{ #category : #accessing }
ByteArraySegment >> replaceBytesUpTo: count with: aCollection [
	count > size ifTrue: [self validateIndex: count].
	self replaceFrom: 1 to: count with: aCollection
]

{ #category : #accessing }
ByteArraySegment >> replaceFrom: start to: end with: another [
	^self replaceFrom: start to: end with: another startingAt: 1
]

{ #category : #accessing }
ByteArraySegment >> replaceFrom: start
to: end
with: another
startingAt: index [
	self validateIndex: start toIndex: end.
	^contents
		replaceFrom: offset + start
		to: offset + end
		with: another
		startingAt: index
]

{ #category : #accessing }
ByteArraySegment >> segmentFrom: index size: anInteger [
	^ByteArraySegment on: self from: index size: anInteger
]

{ #category : #accessing }
ByteArraySegment >> size [
	^size
]

{ #category : #accessing }
ByteArraySegment >> sizeInBytes [
	^size
]

{ #category : #accessing }
ByteArraySegment >> uLargeAtOffset: anInteger [
	self validateIndex: anInteger + 1 toIndex: anInteger + 8.
	^contents uLargeAtOffset: offset + anInteger
]

{ #category : #accessing }
ByteArraySegment >> uLargeAtOffset: anInteger put: ularge [
	self validateIndex: anInteger + 1 toIndex: anInteger + 8.
	^contents uLargeAtOffset: offset + anInteger put: ularge
]

{ #category : #accessing }
ByteArraySegment >> uLongAtOffset: anInteger [
	self validateIndex: anInteger + 1 toIndex: anInteger + 4.
	^contents uLongAtOffset: offset + anInteger
]

{ #category : #accessing }
ByteArraySegment >> uLongAtOffset: anInteger put: long [
	self validateIndex: anInteger + 1 toIndex: anInteger + 4.
	contents uLongAtOffset: offset + anInteger put: long
]

{ #category : #accessing }
ByteArraySegment >> uShortAtOffset: anInteger [
	self validateIndex: anInteger + 1 toIndex: anInteger + 2.
	^contents uShortAtOffset: offset + anInteger
]

{ #category : #accessing }
ByteArraySegment >> uShortAtOffset: anInteger put: long [
	self validateIndex: anInteger + 1 toIndex: anInteger + 2.
	contents uShortAtOffset: offset + anInteger put: long
]

{ #category : #accessing }
ByteArraySegment >> utf16 [
	^UTF16 current decode: self asByteArray
]

{ #category : #accessing }
ByteArraySegment >> validateIndex: index [
	(index between: 1 and: size) ifFalse: [self outOfBoundsIndex: index]
]

{ #category : #accessing }
ByteArraySegment >> validateIndex: start toIndex: end [
	1 <= start ifFalse: [self outOfBoundsIndex: start].
	end <= size ifFalse: [self outOfBoundsIndex: end]
]

