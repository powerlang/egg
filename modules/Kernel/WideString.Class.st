'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #WideString category: #Kernel!
String subclass: #WideString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!WideString commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!WideString methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
, aString
	| n string |
	aString isString ifFalse: [^super , aString].
	n := self size.
	string := WideString new: n + aString size.
	^string
		replaceBytesFrom: 1 to: self sizeInBytes with: self startingAt: 1;
		replaceFrom: n + 1 to: string size with: aString startingAt: 1
! !

!WideString methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
<= aString
	^UTF16 current isString: self lessThanOrEqualTo: aString
! !

!WideString methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asByteCharacters
	| n result |
	n := self size.
	result := String new: n.
	1 to: n do: [:i | | code char |
		code := self codeAt: i.
		char := code < 256 ifTrue: [code] ifFalse: [$? asInteger].
		result byteAt: i put: char].
	^result
! !

!WideString methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asLowercase
	^UTF16 current lowercaseOf: self
! !

!WideString methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asSymbol
	^WideSymbol intern: self
! !

!WideString methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asUppercase
	^UTF16 current uppercaseOf: self
! !

!WideString methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asWideString
	^self
! !

!WideString methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index
	| cp |
	cp := self checkIndex: index; codeAt: index.
	^Character value: cp
! !

!WideString methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger put: aCharacter
	self
		checkCharacter: aCharacter;
		at: anInteger putCode: aCharacter codePoint.
	^aCharacter
! !

!WideString methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index putCode: codePoint
	^self
		checkIndex: index;
		uLongAtOffset: index - 1 * 4 put: codePoint
! !

!WideString methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
atValid: index
	| cp |
	cp := self codeAt: index.
	^Character value: cp
! !

!WideString methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
atValid: anInteger put: aCharacter
	self at: anInteger putCode: aCharacter codePoint.
	^aCharacter
! !

!WideString methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
atValid: index putCode: codePoint
	^self uLongAtOffset: index - 1 * 4 put: codePoint
! !

!WideString methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: anInteger
	^self basicByteAt: anInteger
! !

!WideString methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: anInteger put: anObject
	^self basicByteAt: anInteger put: anObject
! !

!WideString methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicSize
	^self _size
! !

!WideString methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
byteAt: anInteger
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger <= self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self _byteAt: anInteger
! !

!WideString methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
byteAt: position put: asciiValue
	position _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= position and: [position <= self _size])
		ifFalse: [^self outOfBoundsIndex: position].
	(0 <= asciiValue and: [asciiValue < 256])
		ifFalse: [^self error: 'invalid character'].
	^self _byteAt: position put: asciiValue
! !

!WideString methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
characterSize
	^4
! !

!WideString methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
checkByteIndex: index
	index isInteger ifFalse: [self error: 'strings are indexed by integers'].
	(index between: 1 and: self sizeInBytes)
		ifFalse: [self
			error: 'index: ' , index printString , ' is outside of string bounds']
! !

!WideString methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
codeAt: index
	^self uLongAtOffset: index - 1 * 4
! !

!WideString methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
composeCharacters
	^UTF16 current compose: self
! !

!WideString methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
decomposeCharacters
	^UTF16 current decompose: self
! !

!WideString methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
existingSymbol
	^WideSymbol findInterned: self
! !

!WideString methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
foldDigits
	^UTF16 current foldDigitsOf: self
! !

!WideString methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromCodePoints: aCollection
	1 to: aCollection size do: [:i | | ci |
		ci := aCollection at: i.
		self at: i putCode: ci]
! !

!WideString methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	| hash |
	hash := self size.
	0
		to: self sizeInBytes - 4
		by: 4
		do: [:i | hash := (hash hashMultiply: 16r19660D)
			bitXor: (self uLongAtOffset: i)].
	^hash
! !

!WideString methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexAt: anInteger
	^anInteger
! !

!WideString methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOfString: aString from: start to: stop td1: anArray
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
! !

!WideString methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isByteCompliant
	1 to: self size do: [:i | | char |
		char := self at: i.
		char isByteCharacter ifFalse: [^false]].
	^true
! !

!WideString methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCNormal
	^UTF16 current isCNormal: self
! !

!WideString methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isDNormal
	^UTF16 current isDNormal: self
! !

!WideString methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isKCNormal
	^UTF16 current isKCNormal: self
! !

!WideString methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isKDNormal
	^UTF16 current isKDNormal: self
! !

!WideString methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isWide
	^true
! !

!WideString methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isWideString
	^true
! !

!WideString methodsFor:  'inquires' stamp: 'KenD 28/Jun/2026 13:27:38'!
length
	^UTF16 current lengthOf: self
! !

!WideString methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
normalizeToC
	^UTF16 current normalizeToC: self
! !

!WideString methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
normalizeToD
	^(UTF16 current normalizeToD: self) reduced
! !

!WideString methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
normalizeToKC
	^UTF16 current normalizeToKC: self
! !

!WideString methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
normalizeToKD
	^UTF16 current normalizeToKD: self
! !

!WideString methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printChunkOn: aStream from: anInteger
	^self printUTF8ChunkOn: aStream from: anInteger
! !

!WideString methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
reduced
	^self isByteCompliant ifTrue: [self asByteCharacters] ifFalse: [self]
! !

!WideString methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replace: anInteger with: aString
	1 to: anInteger do: [:i | | char |
		char := aString at: i.
		self at: i put: char]
! !

!WideString methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFirst: anInteger with: aString
	1 to: anInteger do: [:i | | char |
		char := aString at: i.
		self at: i put: char]
! !

!WideString methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFrom: start to: stop with: aString startingAt: position
	| string |
	string := self replacementFrom: aString.
	super
		replaceFrom: start - 1 * 4 + 1
		to: stop * 4
		with: string
		startingAt: position - 1 * 4 + 1
! !

!WideString methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFrom: start to: stop withObject: aCharacter
	self checkIndex: start; checkIndex: stop.
	start to: stop do: [:i | self at: i put: aCharacter]
! !

!WideString methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replacementFrom: aString
	| n wide |
	aString class == self class ifTrue: [^aString].
	aString isExternalMemory ifTrue: [^WideString fromMemory: aString].
	n := aString size.
	wide := WideString new: n.
	1 to: n do: [:i | | ch |
		ch := aString atValid: i.
		wide atValid: i put: ch].
	^wide
! !

!WideString methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	^self basicSize // 4
! !

!WideString methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeInBytes
	^self basicSize
! !

!WideString methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
td1
	| m td1 |
	m := self size.
	td1 := Dictionary new: m.
	m to: 1 by: -1 do: [:i | | code |
		code := self codeAt: i.
		td1 at: code + 1 ifAbsentPut: [m - i + 1]].
	^td1
! !

!WideString methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveULongAtOffset: offset
put: anInteger
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 3 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self uLongAtValidOffset: offset put: anInteger
! !

!WideString methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
uLongAtValidOffset: offset put: anInteger
	anInteger size > 4 ifTrue: [self error: 'does not fit in 32 bits'].
	self _uLongAtOffset: offset put: anInteger.
	^anInteger
! !

!WideString methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
unaccented
	^self normalizeToD reject: [:ch | ch isNonSpacingMark]
! !

!WideString methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
utf8Bytes
	^UTF8 current encode: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WideString class' category: #Kernel!
WideString class
	instanceVariableNames: ''!

!WideString class methodsFor:  'instances' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicNew: anInteger
	^self primitiveNewBytes: anInteger
! !

!WideString class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromBytes: aByteArray
	^UTF16 current
		decodeStringFrom: aByteArray readStream
		on: (self new: aByteArray size)
! !

!WideString class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromCodePoints: aCollection
	| string |
	string := self new: aCollection size.
	^string fromCodePoints: aCollection
! !

!WideString class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromExternalUTF16: anExternalMemory
	^UTF16 current decodeStringFrom: anExternalMemory readStream
! !

!WideString class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromExternalUTF16: anExternalMemory length: anInteger
	| stream |
	stream := anExternalMemory readStream.
	stream readLimit: anInteger.
	^UTF16 current decodeStringFrom: stream
! !

!WideString class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromExternalUTF8: anExternalMemory
	^UTF8 current decodeStringFrom: anExternalMemory readStream
! !

!WideString class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromMemory: anExternalMemory
	| s i |
	s := self new: 1.
	i := 1.
	[
		s replaceBytesFrom: 1 to: 2 with: anExternalMemory startingAt: i.
		(s codeAt: 1) = 0]
		whileFalse: [i := i + 2].
	^self fromMemory: anExternalMemory length: i - 1 // 2
! !

!WideString class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromMemory: anExternalMemory length: anInteger
	| bytes |
	bytes := anExternalMemory readStream readLimit: anInteger * 2.
	^UTF16 current decodeStringFrom: bytes on: (self new: anInteger)
! !

!WideString class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromMultiByte: aByteArray codePage: anInteger
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
! !

!WideString class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromString: aString
	aString class == String ifTrue: [^aString asWideString].
	aString class == self ifTrue: [^aString].
	^self fromUTF8: aString asString utf8
! !

!WideString class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromUTF8: aByteArray
	^UTF8 current
		decodeStringFrom: aByteArray readStream
		on: (self new: aByteArray size)
! !

!WideString class methodsFor:  'instances' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	^self basicNew: anInteger * 4
! !

!WideString class methodsFor:  'gs' stamp: 'KenD 28/Jun/2026 13:27:38'!
newFrom: aByteArray
	^aByteArray copy changeClassTo: self
! !

!WideString class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
stringFromMemory: anExternalMemory
	| s i |
	s := self new: 1.
	i := 1.
	[
		s replaceBytesFrom: 1 to: 2 with: anExternalMemory startingAt: i.
		(s codeAt: 1) = 0]
		whileFalse: [i := i + 2].
	^UTF16 decodeFromAddress: anExternalMemory length: i - 1 // 2
! !

!WideString class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
stringsFromAddress: anExternalMemory
	| strings memory |
	strings := OrderedCollection new.
	memory := anExternalMemory.
	[(memory at: 1) = 0 and: [(memory at: 2) = 0]] whileFalse: [| s |
		s := self stringFromMemory: memory.
		strings add: s.
		memory := memory + (s size + 1 * 2)].
	^strings
! !


