"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ByteArray,
	#superclass : #ArrayedCollection,
	#type : #bytes,
	#category : #Kernel
}

{ #category : #'instance creation' }
ByteArray class >> fromBytes: anObject length: anInteger [
	| bytes |
	bytes := self new: anInteger.
	bytes replaceFrom: 1 to: anInteger with: anObject startingAt: 1.
	^bytes
]

{ #category : #'instance creation' }
ByteArray class >> fromMemory: anExternalMemory length: anInteger [
	^self fromBytes: anExternalMemory length: anInteger
]

{ #category : #converting }
ByteArray >> asByteArray [
	^self
]

{ #category : #converting }
ByteArray >> asParameter [
	^self
]

{ #category : #converting }
ByteArray >> asString [
	| string n |
	n := self size.
	(n > 0 and: [(self at: n) = 0]) ifTrue: [n := n - 1].
	string := String new: n.
	^string replaceBytesFrom: 1 to: n with: self startingAt: 1
]

{ #category : #printing }
ByteArray >> basicPrintOn: aStream [
	self printOn: aStream base: 16
]

{ #category : #printing }
ByteArray >> basicPrintTextOn: rtf [
	self printOn: rtf base: 16
]

{ #category : #converting }
ByteArray >> binaryReadStream [
	^self readStream
]

{ #category : #printing }
ByteArray >> canBePrintedAsLiteral [
	^true
]

{ #category : #copying }
ByteArray >> copyToMemory: anExternalMemory [
	anExternalMemory replaceFrom: 1 to: self size with: self startingAt: 1
]

{ #category : #services }
ByteArray >> eol [
	| n byte |
	n := self size.
	n = 0 ifTrue: [^nil].
	byte := self at: n.
	byte = 13 ifTrue: [^String cr].
	byte = 10 ifTrue: [
		^n = 1
			ifTrue: [String lf]
			ifFalse: [(self at: n - 1) = 13 ifTrue: [String crlf] ifFalse: [String lf]]].
	1 to: n - 1 do: [:i | 
		byte := self at: i.
		byte = 13
			ifTrue: [^(self at: i + 1) = 10 ifTrue: [String crlf] ifFalse: [String cr]].
		byte = 10 ifTrue: [^String lf]].
	^nil
]

{ #category : #copying }
ByteArray >> externalCopy [
	^ExternalMemory fromByteArray: self
]

{ #category : #comparing }
ByteArray >> goodHash [
	| hash |
	hash := self size.
	self
		do: [:byte | hash := (hash * 16r19660D bitAnd: 16rFFFFFFF) bitXor: byte].
	^hash
]

{ #category : #comparing }
ByteArray >> hash [
	| hash |
	hash := self size.
	1
		to: hash
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (self at: i)].
	^hash
]

{ #category : #printing }
ByteArray >> integerAt: i bytes: n [
	| word m |
	word := 0.
	m := self size - i + 1 min: n.
	1 to: m do: [:j | | byte |
		i + j - 1 > self size ifFalse: [
			byte := self at: i + j - 1.
			word := word + (byte bitShift: j - 1 * 8)]].
	^word
]

{ #category : #testing }
ByteArray >> isByteArray [
	^true
]

{ #category : #testing }
ByteArray >> isValid [
	^true
]

{ #category : #converting }
ByteArray >> pointedMemory [
	^ExternalMemory at: self
]

{ #category : #printing }
ByteArray >> printOn: aStream base: anInteger [
	aStream nextPutAll: '#['.
	self
		do: [:byte | byte printOn: aStream base: anInteger paddedTo: 2]
		separatedBy: [aStream space].
	aStream nextPut: $]
]

{ #category : #replacing }
ByteArray >> replaceBytesUpTo: count with: aCollection [
	^self replaceBytesFrom: 1 to: count with: aCollection startingAt: 1
]

{ #category : #replacing }
ByteArray >> replaceFirst: count with: aCollection [
	^self replaceFrom: 1 to: count with: aCollection startingAt: 1
]

{ #category : #replacing }
ByteArray >> replaceFrom: start to: stop with: aCollection [
	stop - start + 1 <= aCollection sizeInBytes
		ifFalse: [^self error: 'replacement collection has the wrong size'].
	self
		replaceFrom: start
		to: stop
		with: aCollection
		startingAt: 1
]

{ #category : #replacing }
ByteArray >> replaceFrom: start
to: stop
with: collection
startingAt: position [
	| pos |
	collection class isBytes ifTrue: [
		pos := collection isUnicodeString
			ifTrue: [collection indexAt: position]
			ifFalse: [position].
		^self replaceBytesFrom: start to: stop with: collection startingAt: pos].
	super replaceFrom: start to: stop with: collection startingAt: position
]

{ #category : #converting }
ByteArray >> segmentFrom: index size: size [
	^ByteArraySegment on: self from: index size: size
]

{ #category : #accessing }
ByteArray >> sizeInBytes [
	^self size
]

{ #category : #accessing }
ByteArray >> smallPointerAtOffset: offset [
	| low high |
	WordSize = 8 ifTrue: [^(self pointerAtOffset: offset) // 2].
	low := self uShortAtOffset: offset.
	low := low bitShift: -1.
	high := self uShortAtOffset: offset + 2.
	high := high bitShift: 15.
	^high + low
]

{ #category : #accessing }
ByteArray >> smallPointerAtOffset: offset put: anInteger [
	| low high |
	WordSize = 8 ifTrue: [^self pointerAtOffset: offset put: anInteger * 2].
	low := anInteger bitAnd: 0xFFFF.
	low := low bitShift: 1.
	low := low bitAnd: 0xFFFF.
	self uShortAtOffset: offset put: low.
	high := anInteger bitShift: -15.
	self uShortAtOffset: offset + 2 put: high
]

{ #category : #printing }
ByteArray >> storeOn: aStream [
	self storeOn: aStream base: 16
]

{ #category : #printing }
ByteArray >> storeOn: aStream base: anInteger [
	aStream nextPutAll: '#['.
	self
		do: [:byte | byte printOn: aStream base: anInteger]
		separatedBy: [aStream space].
	aStream nextPut: $]
]

{ #category : #printing }
ByteArray >> storeOn: aStream base: base bytes: bytes [
	| limit digits width n stream end |
	limit := 1 bitShift: bytes * 8.
	digits := limit - 1 digitsBase: base.
	width := digits size.
	n := self size min: self printLimit.
	stream := '' writeStream.
	1 to: n by: bytes do: [:i | | word string char |
		word := self integerAt: i bytes: bytes.
		i - 1 \\ 16 = 0 ifTrue: [
			stream reset.
			string := i - 1 printPaddedWith: $0 to: 4 base: 16.
			aStream
				nextPutAll: '<16r';
				nextPutAll: string;
				nextPutAll: '>  '].
		string := word printPaddedWith: $0 to: width base: base.
		aStream nextPutAll: string; space.
		char := (word < 32 or: [(word bitShift: -18) > 255])
			ifTrue: [$.]
			ifFalse: [word asCharacter].
		stream nextPut: char.
		i + bytes - 1 \\ 16 = 0
			ifTrue: [aStream space; nextPutAll: stream contents; cr]].
	self size \\ 16 = 0 ifFalse: [
		end := self size + 16 truncateTo: 16.
		self size + 1
			to: end
			by: bytes
			do: [:i | width + 1 timesRepeat: [aStream space]].
		aStream space; nextPutAll: stream contents].
	n < self size ifTrue: [aStream cr; nextPut: $…]
]

{ #category : #printing }
ByteArray >> storeStringBase: base [
	^self storeStringBase: base bytes: 1
]

{ #category : #printing }
ByteArray >> storeStringBase: base bytes: bytes [
	^String
		streamContents: [:strm | self storeOn: strm base: base bytes: bytes]
]

{ #category : #accessing }
ByteArray >> utf16 [
	^UTF16 current decode: self
]

