'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #String category: #Kernel!
CharacterArray subclass: #String
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!String commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!String methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
, aString
	aString isString ifFalse: [^super , aString].
	self isWide = aString isWide ifTrue: [^super , aString].
	^self asWideString , aString asWideString
! !

!String methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aString
	| n |
	(self equals: aString) ifTrue: [^true].
	aString isSymbol ifTrue: [^false].
	aString isString ifFalse: [^false].
	n := self size.
	n = aString size ifFalse: [^false].
	1 to: n do: [:i | (self codeAt: i) = (aString codeAt: i) ifFalse: [^false]].
	^true
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
ansiz
	^Ansi current parameterFrom: self
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asByteArray
	| array |
	array := ByteArray new: self sizeInBytes.
	^array
		replaceBytesFrom: 1
		to: array size
		with: self
		startingAt: 1
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asParameter
	self ASSERT: false.
	^self
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asSymbol
	^Symbol intern: self
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asWideSymbol
	^WideSymbol intern: self
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger < self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self characterAtValid: anInteger
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger put: aCharacter
	^self basicAt: anInteger put: aCharacter
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index putCode: codePoint
	self byteAt: index put: codePoint
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
atValid: anInteger
	^self characterAtValid: anInteger
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: anInteger
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger < self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self characterAtValid: anInteger
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: anInteger put: aCharacter
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger < self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	aCharacter isCharacter
		ifFalse: [^self
			error: self class name , ' can''t hold ' , aCharacter class name].
	aCharacter isByteCharacter
		ifFalse: [^self
			error: 'Byte strings cannot hold non-latin1 characters'].
	^self _byteAt: anInteger put: aCharacter asInteger
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicSize
	^self _size - 1
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
byteAt: anInteger
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger < self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self _byteAt: anInteger
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
byteAt: position put: asciiValue
	position _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= position and: [position < self _size])
		ifFalse: [^self outOfBoundsIndex: position].
	(0 <= asciiValue and: [asciiValue < 256])
		ifFalse: [^self error: 'invalid character'].
	^self _byteAt: position put: asciiValue
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
bytes
	| array |
	array := ByteArray new: self _size.
	^array
		replaceBytesFrom: 1
		to: self sizeInBytes
		with: self
		startingAt: 1
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
characterSize
	^1
! !

!String methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
eol
	| n code |
	n := self size.
	n = 0 ifTrue: [^nil].
	code := self codeAt: n.
	code = 13 ifTrue: [^String with: Cr].
	code = 10 ifTrue: [
		^n = 1 ifTrue: [String with: Lf] ifFalse: [
			(self codeAt: n - 1) = 13
				ifTrue: [String with: Cr with: Lf]
				ifFalse: [String with: Lf]]].
	1 to: n - 1 do: [:i | 
		code := self codeAt: i.
		code = 13 ifTrue: [
			^(self codeAt: i + 1) = 10
				ifTrue: [String with: Cr with: Lf]
				ifFalse: [String with: Cr]].
		code = 10 ifTrue: [^String with: Lf]].
	^nil
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
existingSymbol
	^Symbol findInterned: self
! !

!String methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
goodHash
	| hash |
	hash := self size.
	self
		do: [:char | hash := (hash * 16r19660D bitAnd: 16rFFFFFFF)
			bitXor: char asInteger].
	^hash
! !

!String methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOf: anObject between: start and: end ifAbsent: aBlock
	| index cp |
	self characterSize = 1
		ifFalse: [^super
			indexOf: anObject
			between: start
			and: end
			ifAbsent: aBlock].
	cp := anObject codePoint.
	index := start.
	[index <= end] whileTrue: [
		(self byteAt: index) = cp ifTrue: [^index].
		index := index + 1].
	^aBlock value
! !

!String methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOfString: aString from: start to: stop td1: anArray
	| m k |
	m := aString size.
	m = 0 ifTrue: [^0].
	k := start.
	[k + m - 1 <= stop] whileTrue: [| i byte delta |
		i := 1.
		[i <= m and: [(aString at: i) = (self at: k + i - 1)]]
			whileTrue: [i := i + 1].
		i > m ifTrue: [^k].
		k + m > stop ifTrue: [^0].
		byte := self byteAt: k + m.
		delta := (anArray at: byte + 1) ifNil: [m + 1].
		k := k + delta].
	^0
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
length
	^self size
! !

!String methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
normalizeToC
	"
	do nothing
	"
	
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
nullTerminated
	^self class withAll: self with: Character null
! !

!String methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
primitiveReplaceFrom: start to: stop withObject: aCharacter
	self checkCharacter: aCharacter.
	aCharacter isByteCharacter
		ifFalse: [self error: 'Strings cannot hold non-latin1 characters'].
	start to: stop do: [:i | self at: i put: aCharacter].
	^aCharacter

! !

!String methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPut: $'.
	self do: [:char | 
		aStream nextPut: char.
		char = $' ifTrue: [aStream nextPut: char]].
	aStream nextPut: $'
! !

!String methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printUTF8ChunkOn: aStream from: anInteger
	| token encoder lf |
	token := $!! asInteger.
	encoder := UTF8 current.
	lf := aStream eol = String crlf.
	anInteger to: self size do: [:i | | char |
		char := self at: i.
		encoder encode: char on: aStream.
		char = $!!
			ifTrue: [aStream nextBytePut: token]
			ifFalse: [(lf and: [char = Cr]) ifTrue: [aStream
				nextBytePut: Lf asInteger]]].
	aStream nextBytePut: token
! !

!String methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFirst: count with: aCollection
	^self replaceFrom: 1 to: count with: aCollection startingAt: 1
! !

!String methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFrom: start to: stop with: aString startingAt: position
	aString hasBytes
		ifTrue: [self
			replaceBytesFrom: start
			to: stop
			with: aString
			startingAt: position]
		ifFalse: [super
			replaceFrom: start
			to: stop
			with: aString
			startingAt: position]
! !

!String methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFrom: start to: stop withObject: aCharacter
	start > 0 ifFalse: [
		self
			error: 'Invalid argument in ' , self storeString
				, '>>#replaceFrom:to:withObject:'].
	^self primitiveReplaceFrom: start to: stop withObject: aCharacter
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	^self _size - 1
! !

!String methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeInBytes
	^self size
! !

!String methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
td1
	"
	Sunday Algorithm
	ShellDLL current openWebPage: 'http://www.cin.ufpe.br/~paguso/courses/if767/bib/Sunday_1990.pdf'
	"
	| m td1 |
	m := self size.
	td1 := Array new: 256.
	m to: 1 by: -1 do: [:i | | byte j |
		byte := self byteAt: i.
		j := byte + 1.
		(td1 at: j) isNil ifTrue: [td1 at: j put: m - i + 1]].
	^td1
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
utf16
	^UTF16 current encode: self
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
utf16z
	^UTF16 current parameterFrom: self
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
utf8
	"
	(WideString fromBytes: #[16r91 16r21]) utf8
	"
	^self utf8z: false
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
utf8Bytes
	^self utf8
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
utf8z
	"
	(WideString fromBytes: #[16r91 16r21]) utf8z
	"
	^self utf8z: true
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
utf8z: aBoolean
	^aBoolean
		ifTrue: [UTF8 current parameterFrom: self]
		ifFalse: [UTF8 current encode: self]
! !

!String methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
withCrLf
	| index char |
	index := self indexOf: Cr.
	index = 0 ifTrue: [^self].
	char := self at: index + 1 ifAbsent: [^self copyWith: Lf].
	char = Lf ifTrue: [^self].
	^self replaceAll: String cr with: String crlf
! !

!String methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
withoutBlanks
	^self reject: [:c | c = Space]
! !

!String methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
writeStream
	^WriteStringStream on: self
! !

!String methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
zapLfs
	^self reject: [:c | c isLf]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'String class' category: #Kernel!
String class
	instanceVariableNames: ''!

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicNew: anInteger
	^self primitiveNewBytes: anInteger + 1
! !

!String class methodsFor:  'named characters' stamp: 'KenD 28/Jun/2026 13:27:38'!
cr
	^self with: Cr
! !

!String class methodsFor:  'named characters' stamp: 'KenD 28/Jun/2026 13:27:38'!
crlf
	^self with: Cr with: Lf
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromBytes: aByteArray
	| n string |
	n := aByteArray sizeInBytes.
	string := self basicNew: n.
	^string
		replaceBytesFrom: 1
		to: n
		with: aByteArray
		startingAt: 1
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromUTF8: aByteArray
	^(aByteArray conform: [:byte | byte asInteger < 128])
		ifTrue: [String fromBytes: aByteArray]
		ifFalse: [UTF8 current decode: aByteArray]
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self new: 0
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	^self primitiveNewBytes: anInteger + 1
! !

!String class methodsFor:  'gs' stamp: 'KenD 28/Jun/2026 13:27:38'!
newFrom: aByteArray
	| string |
	string := self new: aByteArray size.
	^string replaceFirst: aByteArray size with: aByteArray
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
readFrom: aStream
	| writer |
	writer := (self new: 50) writeStream.
	aStream upTo: $'.
	[
		writer nextPutAll: (aStream upTo: $').
		aStream peek == $']
		whileTrue: [writer nextPut: aStream next].
	^writer contents
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: aCharacter
	self == String ifFalse: [^super with: aCharacter].
	aCharacter isByteCharacter ifTrue: [^super with: aCharacter].
	^WideString with: aCharacter
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: ch1 with: ch2
	self == String ifFalse: [^super with: ch1 with: ch2].
	ch1 isByteCharacter ifFalse: [^WideString with: ch1 with: ch2].
	ch2 isByteCharacter ifFalse: [^WideString with: ch1 with: ch2].
	^super with: ch1 with: ch2
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: ch1 with: ch2 with: ch3
	self == String ifFalse: [^super with: ch1 with: ch2 with: ch3].
	ch1 isByteCharacter ifFalse: [^WideString with: ch1 with: ch2 with: ch3].
	ch2 isByteCharacter ifFalse: [^WideString with: ch1 with: ch2 with: ch3].
	ch3 isByteCharacter ifFalse: [^WideString with: ch1 with: ch2 with: ch3].
	^super with: ch1 with: ch2 with: ch3
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: ch1 with: ch2 with: ch3 with: ch4
	self == String ifFalse: [^super with: ch1 with: ch2 with: ch3 with: ch4].
	ch1 isByteCharacter ifFalse: [^WideString with: ch1 with: ch2 with: ch3 with: ch4].
	ch2 isByteCharacter ifFalse: [^WideString with: ch1 with: ch2 with: ch3 with: ch4].
	ch3 isByteCharacter ifFalse: [^WideString with: ch1 with: ch2 with: ch3 with: ch4].
	ch4 isByteCharacter ifFalse: [^WideString with: ch1 with: ch2 with: ch3 with: ch4].
	^super with: ch1 with: ch2 with: ch3 with: ch4
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: ch1 with: ch2 with: ch3 with: ch4 with: ch5
	self == String ifFalse: [
		^super
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5].
	ch1 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5].
	ch2 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5].
	ch3 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5].
	ch4 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5].
	ch5 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5].
	^super
		with: ch1
		with: ch2
		with: ch3
		with: ch4
		with: ch5
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: ch1 with: ch2 with: ch3 with: ch4 with: ch5 with: ch6
	self == String ifFalse: [
		^super
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	ch1 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	ch2 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	ch3 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	ch4 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	ch5 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	ch6 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	^super
		with: ch1
		with: ch2
		with: ch3
		with: ch4
		with: ch5
		with: ch6
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: ch1 with: ch2 with: ch3 with: ch4 with: ch5 with: ch6 with: ch7
	self == String ifFalse: [
		^super
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch1 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch2 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch3 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch4 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch5 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch6 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch7 isByteCharacter ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	^super
		with: ch1
		with: ch2
		with: ch3
		with: ch4
		with: ch5
		with: ch6
		with: ch7
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: ch1 with: ch2 withAll: collection
	self == String ifFalse: [^super with: ch1 with: ch2 withAll: collection].
	ch1 isByteCharacter ifFalse: [^WideString with: ch1 with: ch2 withAll: collection].
	ch2 isByteCharacter ifFalse: [^WideString with: ch1 with: ch2 withAll: collection].
	(collection conform: [:ch | ch isByteCharacter])
		ifFalse: [^WideString with: ch1 with: ch2 withAll: collection].
	^super with: ch1 with: ch2 withAll: collection
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: aCharacter withAll: aCollection
	self == String ifFalse: [^super with: aCharacter withAll: aCollection].
	aCharacter isByteCharacter
		ifFalse: [^WideString with: aCharacter withAll: aCollection].
	(aCollection conform: [:ch | ch isByteCharacter])
		ifFalse: [^WideString with: aCharacter withAll: aCollection].
	^super with: aCharacter withAll: aCollection
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAll: aCollection
	self == String ifFalse: [^super withAll: aCollection].
	(aCollection conform: [:ch | ch isByteCharacter])
		ifFalse: [^WideString withAll: aCollection].
	^super withAll: aCollection
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAll: aCollection with: aCharacter
	self == String ifFalse: [^super withAll: aCollection with: aCharacter].
	aCharacter isByteCharacter
		ifFalse: [^WideString withAll: aCollection with: aCharacter].
	(aCollection conform: [:ch | ch isByteCharacter])
		ifFalse: [^WideString withAll: aCollection with: aCharacter].
	^super withAll: aCollection with: aCharacter
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAll: collection with: ch1 with: ch2
	self == String ifFalse: [^super withAll: collection with: ch1 with: ch2].
	ch1 isByteCharacter ifFalse: [^WideString withAll: collection with: ch1 with: ch2].
	ch2 isByteCharacter ifFalse: [^WideString withAll: collection with: ch1 with: ch2].
	(collection conform: [:ch | ch isByteCharacter])
		ifFalse: [^WideString withAll: collection with: ch1 with: ch2].
	^super withAll: collection with: ch1 with: ch2
! !


