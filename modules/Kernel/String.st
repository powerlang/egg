"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #String,
	#superclass : #CharacterArray,
	#type : #bytes,
	#category : #Kernel
}

{ #category : #'instance creation' }
String class >> basicNew: anInteger [
	^self primitiveNewBytes: anInteger + 1
]

{ #category : #'named characters' }
String class >> cr [
	^self with: Cr
]

{ #category : #'named characters' }
String class >> crlf [
	^self with: Cr with: Lf
]

{ #category : #'instance creation' }
String class >> fromBytes: aByteArray [
	| n string |
	n := aByteArray sizeInBytes.
	string := self basicNew: n.
	^string
		replaceBytesFrom: 1
		to: n
		with: aByteArray
		startingAt: 1
]

{ #category : #'instance creation' }
String class >> fromUTF8: aByteArray [
	^(aByteArray conform: [:byte | byte asInteger < 128])
		ifTrue: [String fromBytes: aByteArray]
		ifFalse: [UTF8 current decode: aByteArray]
]

{ #category : #'instance creation' }
String class >> new: anInteger [
	^self primitiveNewBytes: anInteger + 1
]

{ #category : #gs }
String class >> newFrom: aByteArray [
	| string |
	string := self new: aByteArray size.
	^string replaceFirst: aByteArray size with: aByteArray
]

{ #category : #'instance creation' }
String class >> readFrom: aStream [
	| writer |
	writer := (self new: 50) writeStream.
	aStream upTo: $'.
	[
		writer nextPutAll: (aStream upTo: $').
		aStream peek == $']
		whileTrue: [writer nextPut: aStream next].
	^writer contents
]

{ #category : #'instance creation' }
String class >> with: aCharacter [
	self == String ifFalse: [^super with: aCharacter].
	aCharacter isAnsi ifTrue: [^super with: aCharacter].
	^WideString with: aCharacter
]

{ #category : #'instance creation' }
String class >> with: ch1 with: ch2 [
	self == String ifFalse: [^super with: ch1 with: ch2].
	ch1 isAnsi ifFalse: [^WideString with: ch1 with: ch2].
	ch2 isAnsi ifFalse: [^WideString with: ch1 with: ch2].
	^super with: ch1 with: ch2
]

{ #category : #'instance creation' }
String class >> with: ch1 with: ch2 with: ch3 [
	self == String ifFalse: [^super with: ch1 with: ch2 with: ch3].
	ch1 isAnsi ifFalse: [^WideString with: ch1 with: ch2 with: ch3].
	ch2 isAnsi ifFalse: [^WideString with: ch1 with: ch2 with: ch3].
	ch3 isAnsi ifFalse: [^WideString with: ch1 with: ch2 with: ch3].
	^super with: ch1 with: ch2 with: ch3
]

{ #category : #'instance creation' }
String class >> with: ch1
with: ch2
with: ch3
with: ch4 [
	self == String ifFalse: [^super with: ch1 with: ch2 with: ch3 with: ch4].
	ch1 isAnsi ifFalse: [^WideString with: ch1 with: ch2 with: ch3 with: ch4].
	ch2 isAnsi ifFalse: [^WideString with: ch1 with: ch2 with: ch3 with: ch4].
	ch3 isAnsi ifFalse: [^WideString with: ch1 with: ch2 with: ch3 with: ch4].
	ch4 isAnsi ifFalse: [^WideString with: ch1 with: ch2 with: ch3 with: ch4].
	^super with: ch1 with: ch2 with: ch3 with: ch4
]

{ #category : #'instance creation' }
String class >> with: ch1
with: ch2
with: ch3
with: ch4
with: ch5 [
	self == String ifFalse: [
		^super
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5].
	ch1 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5].
	ch2 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5].
	ch3 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5].
	ch4 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5].
	ch5 isAnsi ifFalse: [
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
]

{ #category : #'instance creation' }
String class >> with: ch1
with: ch2
with: ch3
with: ch4
with: ch5
with: ch6 [
	self == String ifFalse: [
		^super
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	ch1 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	ch2 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	ch3 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	ch4 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	ch5 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6].
	ch6 isAnsi ifFalse: [
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
]

{ #category : #'instance creation' }
String class >> with: ch1
with: ch2
with: ch3
with: ch4
with: ch5
with: ch6
with: ch7 [
	self == String ifFalse: [
		^super
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch1 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch2 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch3 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch4 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch5 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch6 isAnsi ifFalse: [
		^WideString
			with: ch1
			with: ch2
			with: ch3
			with: ch4
			with: ch5
			with: ch6
			with: ch7].
	ch7 isAnsi ifFalse: [
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
]

{ #category : #'instance creation' }
String class >> with: ch1 with: ch2 withAll: collection [
	self == String ifFalse: [^super with: ch1 with: ch2 withAll: collection].
	ch1 isAnsi ifFalse: [^WideString with: ch1 with: ch2 withAll: collection].
	ch2 isAnsi ifFalse: [^WideString with: ch1 with: ch2 withAll: collection].
	(collection conform: [:ch | ch isAnsi])
		ifFalse: [^WideString with: ch1 with: ch2 withAll: collection].
	^super with: ch1 with: ch2 withAll: collection
]

{ #category : #'instance creation' }
String class >> with: aCharacter withAll: aCollection [
	self == String ifFalse: [^super with: aCharacter withAll: aCollection].
	aCharacter isAnsi
		ifFalse: [^WideString with: aCharacter withAll: aCollection].
	(aCollection conform: [:ch | ch isAnsi])
		ifFalse: [^WideString with: aCharacter withAll: aCollection].
	^super with: aCharacter withAll: aCollection
]

{ #category : #'instance creation' }
String class >> withAll: aCollection [
	self == String ifFalse: [^super withAll: aCollection].
	(aCollection conform: [:ch | ch isAnsi])
		ifFalse: [^WideString withAll: aCollection].
	^super withAll: aCollection
]

{ #category : #'instance creation' }
String class >> withAll: aCollection with: aCharacter [
	self == String ifFalse: [^super withAll: aCollection with: aCharacter].
	aCharacter isAnsi
		ifFalse: [^WideString withAll: aCollection with: aCharacter].
	(aCollection conform: [:ch | ch isAnsi])
		ifFalse: [^WideString withAll: aCollection with: aCharacter].
	^super withAll: aCollection with: aCharacter
]

{ #category : #'instance creation' }
String class >> withAll: collection with: ch1 with: ch2 [
	self == String ifFalse: [^super withAll: collection with: ch1 with: ch2].
	ch1 isAnsi ifFalse: [^WideString withAll: collection with: ch1 with: ch2].
	ch2 isAnsi ifFalse: [^WideString withAll: collection with: ch1 with: ch2].
	(collection conform: [:ch | ch isAnsi])
		ifFalse: [^WideString withAll: collection with: ch1 with: ch2].
	^super withAll: collection with: ch1 with: ch2
]

{ #category : #operations }
String >> , aString [
	aString isString ifFalse: [^super , aString].
	self isUnicode = aString isUnicode ifTrue: [^super , aString].
	^self asWideString , aString asWideString
]

{ #category : #comparing }
String >> = aString [
	| n |
	(self equals: aString) ifTrue: [^true].
	aString isSymbol ifTrue: [^false].
	aString isString ifFalse: [^false].
	n := self size.
	n = aString size ifFalse: [^false].
	1 to: n do: [:i | (self codeAt: i) = (aString codeAt: i) ifFalse: [^false]].
	^true
]

{ #category : #converting }
String >> ansiz [
	^Ansi current parameterFrom: self
]

{ #category : #converting }
String >> asAnsi [
	^self
]

{ #category : #converting }
String >> asByteArray [
	| array |
	array := ByteArray new: self sizeInBytes.
	^array
		replaceBytesFrom: 1
		to: array size
		with: self
		startingAt: 1
]

{ #category : #converting }
String >> asParameter [
	self ASSERT: false.
	^self
]

{ #category : #converting }
String >> asSymbol [
	^Symbol intern: self
]

{ #category : #converting }
String >> asWideSymbol [
	^WideSymbol intern: self
]

{ #category : #accessing }
String >> at: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger < self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self characterAtValid: anInteger
]

{ #category : #accessing }
String >> at: anInteger put: aCharacter [
	^self basicAt: anInteger put: aCharacter
]

{ #category : #accessing }
String >> at: index putCode: codePoint [
	self byteAt: index put: codePoint
]

{ #category : #accessing }
String >> atValid: anInteger [
	^self characterAtValid: anInteger
]

{ #category : #accessing }
String >> basicAt: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger < self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self characterAtValid: anInteger
]

{ #category : #accessing }
String >> basicAt: anInteger put: aCharacter [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger < self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	aCharacter isCharacter
		ifFalse: [^self
			error: self class name , ' can''t hold ' , aCharacter class name].
	aCharacter isByteCharacter
		ifFalse: [^self
			error: 'Strings cannot hold Unicode characters greater than 255'].
	^self _byteAt: anInteger put: aCharacter asInteger
]

{ #category : #accessing }
String >> basicSize [
	^self _size - 1
]

{ #category : #accessing }
String >> byteAt: anInteger [
	anInteger _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= anInteger and: [anInteger < self _size])
		ifFalse: [^self outOfBoundsIndex: anInteger].
	^self _byteAt: anInteger
]

{ #category : #accessing }
String >> byteAt: position put: asciiValue [
	position _isSmallInteger ifFalse: [^self error: 'Non integer index'].
	(1 <= position and: [position < self _size])
		ifFalse: [^self outOfBoundsIndex: position].
	(0 <= asciiValue and: [asciiValue < 256])
		ifFalse: [^self error: 'invalid character'].
	^self _byteAt: position put: asciiValue
]

{ #category : #converting }
String >> bytes [
	| array |
	array := ByteArray new: self _size.
	^array
		replaceBytesFrom: 1
		to: self sizeInBytes
		with: self
		startingAt: 1
]

{ #category : #accessing }
String >> characterSize [
	^1
]

{ #category : #private }
String >> eol [
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
]

{ #category : #converting }
String >> existingSymbol [
	^Symbol findInterned: self
]

{ #category : #comparing }
String >> goodHash [
	| hash |
	hash := self size.
	self
		do: [:char | hash := (hash * 16r19660D bitAnd: 16rFFFFFFF)
			bitXor: char asInteger].
	^hash
]

{ #category : #inquiries }
String >> indexOf: anObject
between: start
and: end
ifAbsent: aBlock [
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
]

{ #category : #parsing }
String >> indexOfString: aString
from: start
to: stop
td1: anArray [
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
]

{ #category : #accessing }
String >> length [
	^self size
]

{ #category : #services }
String >> normalizeToC [
	"
	do nothing
	"
	
]

{ #category : #converting }
String >> nullTerminated [
	^self class withAll: self with: Character null
]

{ #category : #private }
String >> primitiveReplaceFrom: start to: stop withObject: aCharacter [
	self checkCharacter: aCharacter.
	aCharacter isUnicode
		ifTrue: [self error: 'Strings cannot hold Unicode characters'].
	start to: stop do: [:i | self at: i put: aCharacter].
	^aCharacter

]

{ #category : #printing }
String >> printOn: aStream [
	aStream nextPut: $'.
	self do: [:char | 
		aStream nextPut: char.
		char = $' ifTrue: [aStream nextPut: char]].
	aStream nextPut: $'
]

{ #category : #printing }
String >> printUTF8ChunkOn: aStream from: anInteger [
	| token encoder lf |
	token := $! asInteger.
	encoder := UTF8 current.
	lf := aStream eol = String crlf.
	anInteger to: self size do: [:i | | char |
		char := self at: i.
		encoder encode: char on: aStream.
		char = $!
			ifTrue: [aStream nextBytePut: token]
			ifFalse: [(lf and: [char = Cr]) ifTrue: [aStream
				nextBytePut: Lf asInteger]]].
	aStream nextBytePut: token
]

{ #category : #replacing }
String >> replaceFirst: count with: aCollection [
	^self replaceFrom: 1 to: count with: aCollection startingAt: 1
]

{ #category : #replacing }
String >> replaceFrom: start
to: stop
with: aString
startingAt: position [
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
]

{ #category : #replacing }
String >> replaceFrom: start to: stop withObject: aCharacter [
	start > 0 ifFalse: [
		self
			error: 'Invalid argument in ' , self storeString
				, '>>#replaceFrom:to:withObject:'].
	^self primitiveReplaceFrom: start to: stop withObject: aCharacter
]

{ #category : #accessing }
String >> size [
	^self _size - 1
]

{ #category : #accessing }
String >> sizeInBytes [
	^self size
]

{ #category : #private }
String >> td1 [
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
]

{ #category : #converting }
String >> utf16 [
	^UTF16 current encode: self
]

{ #category : #converting }
String >> utf16z [
	^UTF16 current parameterFrom: self
]

{ #category : #converting }
String >> utf8 [
	"
	(WideString fromBytes: #[16r91 16r21]) utf8
	"
	^self utf8z: false
]

{ #category : #converting }
String >> utf8Bytes [
	^self utf8
]

{ #category : #converting }
String >> utf8z [
	"
	(WideString fromBytes: #[16r91 16r21]) utf8z
	"
	^self utf8z: true
]

{ #category : #converting }
String >> utf8z: aBoolean [
	^aBoolean
		ifTrue: [UTF8 current parameterFrom: self]
		ifFalse: [UTF8 current encode: self]
]

{ #category : #private }
String >> withCrLf [
	| index char |
	index := self indexOf: Cr.
	index = 0 ifTrue: [^self].
	char := self at: index + 1 ifAbsent: [^self copyWith: Lf].
	char = Lf ifTrue: [^self].
	^self replaceAll: String cr with: String crlf
]

{ #category : #copying }
String >> withoutBlanks [
	^self reject: [:c | c = Space]
]

{ #category : #converting }
String >> writeStream [
	^WriteStringStream on: self
]

{ #category : #copying }
String >> zapLfs [
	^self reject: [:c | c isLf]
]

