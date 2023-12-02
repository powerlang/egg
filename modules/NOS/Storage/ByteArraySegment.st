"
I represent a logical segment of bytes inside a byte-array like object.

I remap the logical indexes accessed to indexes in the owner contents.
I can be nested.
"
Class {
	#name : #ByteArraySegment,
	#superclass : #ArrayedCollection,
	#instVars : [
		'contents',
		'offset',
		'size'
	],
	#category : 'SqueakNOS-Storage'
}

{ #category : #'as yet unclassified' }
ByteArraySegment class >> on: aByteArray from: start size: size [
	^self on: aByteArray from: start to: start + size - 1
]

{ #category : #initialization }
ByteArraySegment class >> on: aByteArray from: start to: stop [
	^self new on: aByteArray from: start to: stop
]

{ #category : #converting }
ByteArraySegment >> asByteArray [
	^self copyFrom: 1 to: size
]

{ #category : #converting }
ByteArraySegment >> at: anInteger [
	^self byteAt: anInteger
]

{ #category : #converting }
ByteArraySegment >> at: anInteger put: byte [
	^self byteAt: anInteger put: byte
]

{ #category : #converting }
ByteArraySegment >> byteAt: index [
	self validateIndex: index.
	^ contents byteAt: offset + index
]

{ #category : #converting }
ByteArraySegment >> byteAt: index put: byte [
	self validateIndex: index.
	^ contents byteAt: offset + index put: byte
]

{ #category : #converting }
ByteArraySegment >> byteAtOffset: anInteger [
	^self byteAt: anInteger + 1
]

{ #category : #converting }
ByteArraySegment >> byteAtOffset: anInteger put: byte [
	^self byteAt: anInteger + 1 put: byte
]

{ #category : #converting }
ByteArraySegment >> bytesAtOffset: anInteger put: anByteArray [
	self
		replaceFrom: anInteger + 1
		to: anInteger + anByteArray sizeInBytes
		with: anByteArray
		startingAt: 1
]

{ #category : #converting }
ByteArraySegment >> copyFrom: start to: end [
	| s |
	self validateIndex: start toIndex: end.
	^contents copyFrom: offset + start to: offset + end
]

{ #category : #converting }
ByteArraySegment >> endOffset [
	^offset + size
]

{ #category : #converting }
ByteArraySegment >> errorInBounds: anInteger [
	self error: 'out of bounds: ', anInteger printString
]

{ #category : #converting }
ByteArraySegment >> offset [
	^offset
]

{ #category : #converting }
ByteArraySegment >> offset: anInteger [
	offset := anInteger
]

{ #category : #converting }
ByteArraySegment >> on: aByteArray from: start to: stop [
	contents := aByteArray.
	offset := start - 1.
	size := stop - start + 1 . size >= 0
		ifFalse: [ self halt ]
]

{ #category : #converting }
ByteArraySegment >> replaceBytes: count with: aCollection [
	count > size ifTrue: [self validateIndex: count].
	self replaceFrom: 1 to: count with: aCollection
]

{ #category : #converting }
ByteArraySegment >> replaceFrom: start to: end with: another [
	^self replaceFrom: start to: end with: another startingAt: 1
]

{ #category : #converting }
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

{ #category : #converting }
ByteArraySegment >> segmentFrom: index size: anInteger [
	^ByteArraySegment on: self from: index size: anInteger
]

{ #category : #converting }
ByteArraySegment >> segmentFrom: start to: end [
	^ ByteArraySegment on: self from: start to: end
]

{ #category : #converting }
ByteArraySegment >> size [
	^size
]

{ #category : #converting }
ByteArraySegment >> sizeInBytes [
	^size
]

{ #category : #converting }
ByteArraySegment >> unsignedByteAt: byteIndex put: value [
	contents unsignedByteAt: byteIndex + offset put: value
]

{ #category : #converting }
ByteArraySegment >> unsignedLongAt: byteIndex [
	(1 <= byteIndex and: [ byteIndex + 3 <= size ])
		ifFalse: [ self errorInBounds: byteIndex ].
	^ contents unsignedLongAt: byteIndex + offset
]

{ #category : #converting }
ByteArraySegment >> unsignedLongAt: byteIndex put: value [
	contents unsignedLongAt: byteIndex + offset put: value
]

{ #category : #converting }
ByteArraySegment >> unsignedLongAtOffset: byteOffset [
	^ self unsignedLongAt: byteOffset + 1
]

{ #category : #converting }
ByteArraySegment >> unsignedLongAtOffset: byteOffset put: value [
	^ self unsignedLongAt: byteOffset + 1 put: value
]

{ #category : #converting }
ByteArraySegment >> unsignedShortAt: byteIndex [
	^ contents unsignedShortAt: byteIndex + offset
]

{ #category : #converting }
ByteArraySegment >> unsignedShortAt: byteIndex put: value [
	contents unsignedShortAt: byteIndex + offset put: value
]

{ #category : #converting }
ByteArraySegment >> unsignedShortAtOffset: byteOffset [
	^self unsignedShortAt: byteOffset + 1
]

{ #category : #converting }
ByteArraySegment >> unsignedShortAtOffset: byteOffset put: value [
	^ self unsignedShortAt: byteOffset + 1 put: value
]

{ #category : #converting }
ByteArraySegment >> validateIndex: index [
	(index between: 1 and: size) ifFalse: [self errorInBounds: index]
]

{ #category : #converting }
ByteArraySegment >> validateIndex: start toIndex: end [
	1 <= start ifFalse: [self errorInBounds: start].
	end <= size ifFalse: [self errorInBounds: end]
]
