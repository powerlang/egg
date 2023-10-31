"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #WideString,
	#superclass : #String,
	#type : #bytes,
	#category : #Kernel
}

{ #category : #instances }
WideString class >> basicNew: anInteger [
	^self primitiveNewBytes: anInteger
]

{ #category : #'instance creation' }
WideString class >> fromBytes: aByteArray [
	^UTF16 current
		decodeStringFrom: aByteArray readStream
		on: (self new: aByteArray size)
]

{ #category : #'instance creation' }
WideString class >> fromCodePoints: aCollection [
	| string |
	string := self new: aCollection size.
	^string fromCodePoints: aCollection
]

{ #category : #'instance creation' }
WideString class >> fromExternalUTF16: anExternalMemory [
	^UTF16 current decodeStringFrom: anExternalMemory readStream
]

{ #category : #'instance creation' }
WideString class >> fromExternalUTF16: anExternalMemory length: anInteger [
	| stream |
	stream := anExternalMemory readStream.
	stream readLimit: anInteger.
	^UTF16 current decodeStringFrom: stream
]

{ #category : #'instance creation' }
WideString class >> fromExternalUTF8: anExternalMemory [
	^UTF8 current decodeStringFrom: anExternalMemory readStream
]

{ #category : #'instance creation' }
WideString class >> fromMemory: anExternalMemory [
	| s i |
	s := self new: 1.
	i := 1.
	[
		s replaceBytesFrom: 1 to: 2 with: anExternalMemory startingAt: i.
		(s codeAt: 1) = 0]
		whileFalse: [i := i + 2].
	^self fromMemory: anExternalMemory length: i - 1 // 2
]

{ #category : #'instance creation' }
WideString class >> fromMemory: anExternalMemory length: anInteger [
	| bytes |
	bytes := anExternalMemory readStream readLimit: anInteger * 2.
	^UTF16 current decodeStringFrom: bytes on: (self new: anInteger)
]

{ #category : #'instance creation' }
WideString class >> fromMultiByte: aByteArray codePage: anInteger [
	"
	WideString fromMultiByte: #[16rFA] codePage: 1251
	"
	| bytes string |
	bytes := aByteArray externalCopy.
	string := self
		fromMultiByteAddress: bytes
		codePage: anInteger
		size: aByteArray sizeInBytes.
	bytes free.
	^string
]

{ #category : #'instance creation' }
WideString class >> fromString: aString [
	aString class == String ifTrue: [^aString asWideString].
	aString class == self ifTrue: [^aString].
	^self fromUTF8: aString asString utf8
]

{ #category : #'instance creation' }
WideString class >> fromUTF8: aByteArray [
	^UTF8 current
		decodeStringFrom: aByteArray readStream
		on: (self new: aByteArray size)
]

{ #category : #instances }
WideString class >> new: anInteger [
	^self basicNew: anInteger * 4
]

{ #category : #gs }
WideString class >> newFrom: aByteArray [
	^aByteArray copy changeClassTo: self
]

{ #category : #'instance creation' }
WideString class >> stringFromMemory: anExternalMemory [
	| s i |
	s := self new: 1.
	i := 1.
	[
		s replaceBytesFrom: 1 to: 2 with: anExternalMemory startingAt: i.
		(s codeAt: 1) = 0]
		whileFalse: [i := i + 2].
	^UTF16 decodeFromAddress: anExternalMemory length: i - 1 // 2
]

{ #category : #services }
WideString class >> stringsFromAddress: anExternalMemory [
	| strings memory |
	strings := OrderedCollection new.
	memory := anExternalMemory.
	[(memory at: 1) = 0 and: [(memory at: 2) = 0]] whileFalse: [| s |
		s := self stringFromMemory: memory.
		strings add: s.
		memory := memory + (s size + 1 * 2)].
	^strings
]

{ #category : #operations }
WideString >> , aString [
	| n string |
	aString isString ifFalse: [^super , aString].
	n := self size.
	string := WideString new: n + aString size.
	^string
		replaceBytesFrom: 1 to: self sizeInBytes with: self startingAt: 1;
		replaceFrom: n + 1 to: string size with: aString startingAt: 1
]

{ #category : #comparing }
WideString >> <= aString [
	^UTF16 current isString: self lessThanOrEqualTo: aString
]

{ #category : #converting }
WideString >> asAnsi [
	^Ansi current reduce: self
]

{ #category : #converting }
WideString >> asLowercase [
	^UTF16 current lowercaseOf: self
]

{ #category : #converting }
WideString >> asSymbol [
	self isAnsiCompliant ifTrue: [^self reduced asSymbol].
	^WideSymbol intern: self
]

{ #category : #converting }
WideString >> asUnicode [
	self ASSERT: false.
	^self
]

{ #category : #converting }
WideString >> asUppercase [
	^UTF16 current uppercaseOf: self
]

{ #category : #converting }
WideString >> asWideString [
	^self
]

{ #category : #private }
WideString >> at: index [
	| cp |
	cp := self checkIndex: index; codeAt: index.
	^Character value: cp
]

{ #category : #accessing }
WideString >> at: anInteger put: aCharacter [
	self
		checkCharacter: aCharacter;
		at: anInteger putCode: aCharacter codePoint.
	^aCharacter
]

{ #category : #private }
WideString >> at: index putCode: codePoint [
	^self
		checkIndex: index;
		uLongAtOffset: index - 1 * 4 put: codePoint
]

{ #category : #private }
WideString >> atValid: index [
	| cp |
	cp := self codeAt: index.
	^Character value: cp
]

{ #category : #private }
WideString >> atValid: anInteger put: aCharacter [
	self at: anInteger putCode: aCharacter codePoint.
	^aCharacter
]

{ #category : #private }
WideString >> atValid: index putCode: codePoint [
	^self uLongAtOffset: index - 1 * 4 put: codePoint
]

{ #category : #accessing }
WideString >> basicAt: anInteger [
	^self basicByteAt: anInteger
]

{ #category : #accessing }
WideString >> basicAt: anInteger put: anObject [
	^self basicByteAt: anInteger put: anObject
]

{ #category : #accessing }
WideString >> basicSize [
	^self _size
]

{ #category : #accessing }
WideString >> byteAt: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self _byteAt: anInteger
]

{ #category : #accessing }
WideString >> byteAt: position put: asciiValue [
	position _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= position and: [position <= self _size])
		ifFalse: [^self outOfBoundsIndex: position].
	(0 <= asciiValue and: [asciiValue < 256])
		ifFalse: [^self error: 'invalid character'].
	^self _byteAt: position put: asciiValue
]

{ #category : #accessing }
WideString >> characterSize [
	^4
]

{ #category : #private }
WideString >> checkByteIndex: index [
	index isInteger ifFalse: [self error: 'strings are indexed by integers'].
	(index between: 1 and: self sizeInBytes)
		ifFalse: [self
			error: 'index: ' , index printString , ' is outside of string bounds']
]

{ #category : #private }
WideString >> codeAt: index [
	^self uLongAtOffset: index - 1 * 4
]

{ #category : #services }
WideString >> composeCharacters [
	^UTF16 current compose: self
]

{ #category : #services }
WideString >> decomposeCharacters [
	^UTF16 current decompose: self
]

{ #category : #converting }
WideString >> existingSymbol [
	^WideSymbol findInterned: self
]

{ #category : #services }
WideString >> foldDigits [
	^UTF16 current foldDigitsOf: self
]

{ #category : #private }
WideString >> fromCodePoints: aCollection [
	1 to: aCollection size do: [:i | | ci |
		ci := aCollection at: i.
		self at: i putCode: ci]
]

{ #category : #comparing }
WideString >> hash [
	| hash |
	hash := self size.
	0
		to: self sizeInBytes - 4
		by: 4
		do: [:i | hash := (hash hashMultiply: 16r19660D)
			bitXor: (self uLongAtOffset: i)].
	^hash
]

{ #category : #private }
WideString >> indexAt: anInteger [
	^anInteger
]

{ #category : #parsing }
WideString >> indexOfString: aString
from: start
to: stop
td1: anArray [
	| m k |
	m := aString size.
	m = 0 ifTrue: [^0].
	k := start.
	[k + m - 1 <= stop] whileTrue: [| i code delta |
		i := 1.
		[i <= m and: [(aString at: i) = (self at: k + i - 1)]]
			whileTrue: [i := i + 1].
		i > m ifTrue: [^k].
		k + m > stop ifTrue: [^0].
		code := self codeAt: k + m.
		delta := anArray at: code + 1 ifAbsent: nil.
		delta isNil ifTrue: [delta := m + 1].
		k := k + delta].
	^0
]

{ #category : #testing }
WideString >> isCNormal [
	^UTF16 current isCNormal: self
]

{ #category : #testing }
WideString >> isDNormal [
	^UTF16 current isDNormal: self
]

{ #category : #testing }
WideString >> isKCNormal [
	^UTF16 current isKCNormal: self
]

{ #category : #testing }
WideString >> isKDNormal [
	^UTF16 current isKDNormal: self
]

{ #category : #testing }
WideString >> isUnicode [
	^true
]

{ #category : #testing }
WideString >> isUnicodeString [
	^true
]

{ #category : #testing }
WideString >> isWideString [
	^true
]

{ #category : #inquires }
WideString >> length [
	^UTF16 current lengthOf: self
]

{ #category : #services }
WideString >> normalizeToC [
	^UTF16 current normalizeToC: self
]

{ #category : #services }
WideString >> normalizeToD [
	^(UTF16 current normalizeToD: self) reduced
]

{ #category : #services }
WideString >> normalizeToKC [
	^UTF16 current normalizeToKC: self
]

{ #category : #services }
WideString >> normalizeToKD [
	^UTF16 current normalizeToKD: self
]

{ #category : #printing }
WideString >> printChunkOn: aStream from: anInteger [
	^self printUTF8ChunkOn: aStream from: anInteger
]

{ #category : #converting }
WideString >> reduced [
	^self isAnsiCompliant ifTrue: [self asAnsi] ifFalse: [self]
]

{ #category : #replacing }
WideString >> replace: anInteger with: aString [
	1 to: anInteger do: [:i | | char |
		char := aString at: i.
		self at: i put: char]
]

{ #category : #replacing }
WideString >> replaceFirst: anInteger with: aString [
	1 to: anInteger do: [:i | | char |
		char := aString at: i.
		self at: i put: char]
]

{ #category : #replacing }
WideString >> replaceFrom: start
to: stop
with: aString
startingAt: position [
	| string |
	string := self replacementFrom: aString.
	super
		replaceFrom: start - 1 * 4 + 1
		to: stop * 4
		with: string
		startingAt: position - 1 * 4 + 1
]

{ #category : #replacing }
WideString >> replaceFrom: start to: stop withObject: aCharacter [
	self checkIndex: start; checkIndex: stop.
	start to: stop do: [:i | self at: i put: aCharacter]
]

{ #category : #replacing }
WideString >> replacementFrom: aString [
	| n wide |
	aString class == self class ifTrue: [^aString].
	aString isExternalMemory ifTrue: [^WideString fromMemory: aString].
	n := aString size.
	wide := WideString new: n.
	1 to: n do: [:i | | ch |
		ch := aString atValid: i.
		wide atValid: i put: ch].
	^wide
]

{ #category : #accessing }
WideString >> size [
	^self basicSize // 4
]

{ #category : #converting }
WideString >> sizeInBytes [
	^self basicSize
]

{ #category : #private }
WideString >> td1 [
	| m td1 |
	m := self size.
	td1 := Dictionary new: m.
	m to: 1 by: -1 do: [:i | | code |
		code := self codeAt: i.
		td1 at: code + 1 ifAbsentPut: [m - i + 1]].
	^td1
]

{ #category : #private }
WideString >> primitiveULongAtOffset: offset [
put: anInteger
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 3 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self uLongAtValidOffset: offset put: anInteger
]

{ #category : #unclassified }
WideString >> uLongAtValidOffset: offset put: anInteger [
	anInteger size > 4 ifTrue: [self error: 'does not fit in 32 bits'].
	self _uLongAtOffset: offset put: anInteger.
	^anInteger
]

{ #category : #services }
WideString >> unaccented [
	^self normalizeToD reject: [:ch | ch isNonSpacingMark]
]

{ #category : #converting }
WideString >> utf8Bytes [
	^UTF8 current encode: self
]

