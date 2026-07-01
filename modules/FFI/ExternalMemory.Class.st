'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #ExternalMemory category: #FFI!
Object subclass: #ExternalMemory
	instanceVariableNames: 'address heap'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FFI'!
!ExternalMemory commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ExternalMemory methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:37'!
- anInteger
	^self + anInteger negated
! !

!ExternalMemory methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:37'!
+ anInteger
	^ExternalMemory at: self asInteger + anInteger
! !

!ExternalMemory methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:37'!
= anExternalMemory
	self class == anExternalMemory class ifFalse: [^false].
	^address = anExternalMemory contents
! !

!ExternalMemory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
address: anInteger
	address pointerAtOffset: 0 put: anInteger
! !

!ExternalMemory methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:37'!
asInteger
	^self asUnsignedInteger
! !

!ExternalMemory methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:37'!
asParameter
	^address
! !

!ExternalMemory methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:37'!
asUnsignedInteger
	^address pointerAtOffset: 0
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
at: index
	^self atOffset: index - 1
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
at: index ifAbsent: aBlock
	index > self length ifTrue: [^aBlock value].
	^self at: index
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
at: index put: byte
	^self atOffset: index - 1 put: byte
! !

!ExternalMemory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
atOffset: offset
	^(address _basicAt: 1) _byteAt: offset + 1
! !

!ExternalMemory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:37'!
atOffset: offset put: byte
	^(address _basicAt: 1) _byteAt: offset + 1 put: byte
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
byteAt: anInteger
	^self at: anInteger
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
byteAt: anInteger put: byte
	^self at: anInteger put: byte
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
byteAtOffset: anInteger
	^self atOffset: anInteger
! !

!ExternalMemory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
bytes
	self subclassResponsibility
! !

!ExternalMemory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
clear: n
	| blank |
	blank := ByteArray new: n.
	self replaceFrom: 1 to: n with: blank startingAt: 1
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
contents
	^address
! !

!ExternalMemory methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:37'!
copy
	^self shouldNotImplement
! !

!ExternalMemory methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:37'!
copyFrom: start to: stop
	| size |
	size := stop - start + 1.
	^(ByteArray new: size)
		replaceFrom: 1
		to: size
		with: self
		startingAt: start
! !

!ExternalMemory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
externalCopy
	^self
! !

!ExternalMemory methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:37'!
finalizationRegistry
	^Kernel session resourceRegistry
! !

!ExternalMemory methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:37'!
finalize
	^self release
! !

!ExternalMemory methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:37'!
free
	self release; ignoreFinalization
! !

!ExternalMemory methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hash
	^address hash
! !

!ExternalMemory methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasBytes
	^true
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
heap
	^heap
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
heap: anExternalHeap
	heap := anExternalHeap
! !

!ExternalMemory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:37'!
indexOf: byte
	| offset |
	offset := 0.
	[
		(self atOffset: offset) = byte ifTrue: [^offset + 1].
		offset := offset + 1] repeat
! !

!ExternalMemory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:37'!
indexOf: byte between: start and: end ifAbsent: aBlock
	| index |
	index := start.
	[index <= end] whileTrue: [
		(self at: index) = byte ifTrue: [^index].
		index := index + 1].
	^aBlock value
! !

!ExternalMemory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:37'!
indexOf: byte startingAt: start ifAbsent: aBlock
	^self indexOf: byte between: start and: self length ifAbsent: aBlock
! !

!ExternalMemory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:37'!
indexOfSubcollection: aCollection from: start to: stop td1: aDictionary
	| m k |
	m := aCollection sizeInBytes.
	m = 0 ifTrue: [^0].
	k := start.
	[k + m - 1 <= stop] whileTrue: [| i object delta |
		i := 1.
		[i <= m and: [(aCollection at: i) = (self at: k + i - 1)]]
			whileTrue: [i := i + 1].
		i > m ifTrue: [^k].
		k + m > stop ifTrue: [^0].
		object := self at: k + m.
		delta := aDictionary at: object ifAbsent: [m + 1].
		delta isNil ifTrue: [delta := m + 1].
		k := k + delta].
	^0
! !

!ExternalMemory methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	super initialize.
	address := ByteArray new: self class sizeInBytes
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
invalidate
	address := NullAddress
! !

!ExternalMemory methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isExternalMemory
	^true
! !

!ExternalMemory methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
isValid
	^address !!= NullAddress
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
length
	^nil
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
longAtOffset: offset
	offset _isSmallInteger
		ifFalse: [^self error: offset printString , ' should be an SmallInteger'].
	^self longAtValidOffset: offset
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
longAtOffset: offset put: integer
	integer < 0
		ifTrue: [self uLongAtOffset: offset put: integer + 16r100000000]
		ifFalse: [self uLongAtOffset: offset put: integer]
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
longAtValidOffset: offset
	| lo hi sign |
	lo := self uShortAtValidOffset: offset.
	hi := self uShortAtValidOffset: offset + 2.
	sign := hi bitAnd: 16r8000.
	hi := hi - (sign * 2).
	^hi * 16r10000 + lo
! !

!ExternalMemory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
makeBytes
	| bytes |
	bytes := self bytes.
	self free.
	^bytes
! !

!ExternalMemory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
makeFloat
	^Float fromByteArray: self makeBytes
! !

!ExternalMemory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
makeString
	| string |
	string := String fromMemory: self.
	self free.
	^string
! !

!ExternalMemory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
makeULong
	| ulong |
	ulong := self uLongAtOffset: 0.
	self free.
	^ulong
! !

!ExternalMemory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
makeUnicode
	| unicode |
	unicode := WideString fromMemory: self.
	self free.
	^unicode
! !

!ExternalMemory methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:37'!
pointedMemory
	^self
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
uLargeAtOffset: offset
	| low hi |
	low := self uLongAtOffset: offset.
	hi := self uLongAtOffset: offset + 4.
	^(hi bitShift: 32) + low
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
uLargeAtOffset: offset put: value
	self uLongAtOffset: offset put: (value bitAnd: 16rFFFFFFFF).
	self uLongAtOffset: offset + 4 put: (value bitShift: -32)
! !

!ExternalMemory methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:37'!
printOn: aStream
	| hex |
	aStream nextPutAll: self class name , '{'.
	hex := self isValid
		ifTrue: [self asInteger printPaddedWith: $0 to: 8 base: 16]
		ifFalse: ['invalid'].
	aStream nextPutAll: hex; nextPut: $}
! !

!ExternalMemory methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:37'!
readStream
	| stream |
	stream := InternalReadStream on: self.
	^stream readLimit: SmallInteger maximum
! !

!ExternalMemory methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:37'!
release
	self releaseMemory; invalidate
! !

!ExternalMemory methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:37'!
releaseMemory
	heap ifNotNil: [heap free: self]	
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
replaceBytesUpTo: count with: aCollection
	^self replaceBytesFrom: 1 to: count with: aCollection startingAt: 1
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
replaceFirst: count with: aCollection
	^self replaceFrom: 1 to: count with: aCollection startingAt: 1
! !

!ExternalMemory methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:37'!
replaceFrom: start to: stop with: anObject startingAt: position
	| pos |
	pos := anObject isUnicodeString
		ifTrue: [anObject indexAt: position]
		ifFalse: [position].
	self
		replaceBytesFrom: start
		to: stop
		with: anObject
		startingAt: pos
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
segmentFrom: index size: size
	^ByteArraySegment on: self from: index size: size
! !

!ExternalMemory methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:37'!
sessionShutdown
	self ignoreFinalization
! !

!ExternalMemory methodsFor:  'startup' stamp: 'KenD 28/Jun/2026 13:27:37'!
sessionStartup
	self invalidate
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
shortAtValidOffset: offset
	| lo hi sign |
	lo := self atOffset: offset.
	hi := self atOffset: offset + 1.
	sign := hi bitAnd: 16r80.
	hi := hi - (sign * 2).
	^hi * 16r100 + lo
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
size
	^address size
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
sizeInBytes
	^self class sizeInBytes
! !

!ExternalMemory methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:37'!
smallPointer
	^address smallPointerAtOffset: 0
! !

!ExternalMemory methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:37'!
smallPointer: anInteger
	^address smallPointerAtOffset: 0 put: anInteger
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
smallPointerAtOffset: offset
	| low high |
	WordSize = 8 ifTrue: [^(self pointerAtOffset: offset) // 2].
	low := self uShortAtOffset: offset.
	low := low bitShift: -1.
	high := self uShortAtOffset: offset + 2.
	high := high bitShift: 15.
	^high + low
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
smallPointerAtOffset: offset put: anInteger
	| low high |
	WordSize = 8 ifTrue: [^self pointerAtOffset: offset put: anInteger * 2].
	low := anInteger bitAnd: 0xFFFF.
	low := low bitShift: 1.
	low := low bitAnd: 0xFFFF.
	self uShortAtOffset: offset put: low.
	high := anInteger bitShift: -15.
	self uShortAtOffset: offset + 2 put: high
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
uLargeAtOffset: offset
	| low hi |
	low := self uLongAtOffset: offset.
	hi := self uLongAtOffset: offset + 4.
	^(hi bitShift: 32) + low
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
uLargeAtOffset: offset put: value
	self uLongAtOffset: offset put: (value bitAnd: 16rFFFFFFFF).
	self uLongAtOffset: offset + 4 put: (value bitShift: -32)
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
uLongAtOffset: offset
	| ulong |
	ulong := 0.
	offset + 4
		to: offset + 1
		by: -1
		do: [:i | ulong := (ulong bitShift: 8) + (self byteAt: i)].
	^ulong
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
uLongAtOffset: offset put: anInteger
	| low high |
	low := anInteger isInteger
		ifTrue: [anInteger bitAnd: 0xFFFF]
		ifFalse: [anInteger lowPart].
	high := anInteger isInteger
		ifTrue: [anInteger bitShift: -16]
		ifFalse: [anInteger highPart].
	self
		byteAt: offset + 1 put: (low bitAnd: 16rFF);
		byteAt: offset + 2 put: (low bitShift: -8);
		byteAt: offset + 3 put: (high bitAnd: 16rFF);
		byteAt: offset + 4 put: ((high bitShift: -8) bitAnd: 16rFF)
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
uShortAtOffset: offset
	^(self atOffset: offset) + ((self atOffset: offset + 1) bitShift: 8)
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
uShortAtOffset: offset put: integer
	self
		atOffset: offset put: (integer bitAnd: 16rFF);
		atOffset: offset + 1 put: ((integer bitShift: -8) bitAnd: 16rFF)
! !

!ExternalMemory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
uShortAtValidOffset: offset
	^(self atOffset: offset + 1) * 16r100 + (self atOffset: offset)
! !

!ExternalMemory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:37'!
writeStream
	| writer |
	writer := InternalWriteStream on: self.
	writer writeLimit: self length.
	^writer
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExternalMemory class' category: #FFI!
ExternalMemory class
	instanceVariableNames: ''!

!ExternalMemory class methodsFor:  'inspecting' stamp: 'KenD 28/Jun/2026 13:27:37'!
allocate: anInteger
	^FFI defaultHeap allocate: anInteger
! !

!ExternalMemory class methodsFor:  'inspecting' stamp: 'KenD 28/Jun/2026 13:27:37'!
aspects
	^#(#asInteger)
! !

!ExternalMemory class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
at: anInteger
	^self new address: anInteger
! !

!ExternalMemory class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
at: anInteger heap: anExternalHeap
	^self new address: anInteger; heap: anExternalHeap
! !

!ExternalMemory class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
fromByteArray: aByteArray
	| count memory |
	count := aByteArray sizeInBytes.
	memory := self allocate: count.
	^memory replaceBytesUpTo: count with: aByteArray
! !

!ExternalMemory class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
fromString: aString
	| bytes extra memory |
	bytes := aString sizeInBytes.
	extra := aString characterSize.
	memory := self allocate: bytes + extra.
	memory replaceBytesUpTo: bytes with: aString.
	^memory
! !

!ExternalMemory class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasFixedSize
	^self hasVariableSize not
! !

!ExternalMemory class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasVariableSize
	^false
! !

!ExternalMemory class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initializeConstants
	self addNamespace
		at: #NullAddress put: (ByteArray new: WordSize);
		yourself.
! !

!ExternalMemory class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
sizeInBytes
	^WordSize
! !


ExternalMemory initialize!

