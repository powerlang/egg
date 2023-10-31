"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ReadStream,
	#superclass : #Stream,
	#category : #Kernel
}

{ #category : #writing }
ReadStream >> alignTo: boundary [
	| n |
	n := boundary - (self position \\ boundary) \\ boundary.
	self skip: n
]

{ #category : #testing }
ReadStream >> atBeginning [
	^self position = 0
]

{ #category : #parsing }
ReadStream >> back [
	self skip: -1
]

{ #category : #parsing }
ReadStream >> backToAny: aCollection [
	"
	'Smalltalk' readStream position: 'Smallta' size; backToAny: 'ml'
	"
	[self position = 0] whileFalse: [| token |
		token := self prev.
		(aCollection includes: token) ifTrue: [^self]]
]

{ #category : #parsing }
ReadStream >> backToOpen: open [
	"
	'--|things||some|-}blah' readStream next: '--|things||some' size; backToOpen: $|; yourself
	"
	| start |
	start := self position.
	[self position > 0] whileTrue: [
		self prev = open ifTrue: [
			self position = 0 ifTrue: [^self].
			self prev = open ifFalse: [^self next; yourself]]].
	self position: start
]

{ #category : #parsing }
ReadStream >> backToOpen: close with: open [
	"
	'-{things{some}-}blah' readStream position: '-{things{some}-}' size - 1; backToOpen: ${ with: $}
	"
	| start tokens count |
	open = close ifTrue: [^self backToOpen: close].
	start := self position.
	tokens := {open. close}.
	count := -1.
	[self position = 0 or: [count = 0]] whileFalse: [| token |
		self backToAny: tokens.
		token := self peek.
		token = open ifTrue: [count := count + 1].
		token = close ifTrue: [count := count - 1]].
	count = 0 ifFalse: [self position: start]
]

{ #category : #parsing }
ReadStream >> basicNextChunk [
	| token bulk |
	token := self isBinary ifTrue: [$! asInteger] ifFalse: [$!].
	bulk := self upTo: token.
	[self atEnd orNot: [self peekFor: token]] whileFalse: [
		bulk := bulk copyWith: token.
		bulk := bulk , (self upTo: token)].
	^bulk
]

{ #category : #converting }
ReadStream >> binaryReadStream [
	self isBinary ifTrue: [^self].
	^self copy beBinary
]

{ #category : #reading }
ReadStream >> collectionTailOf: anInteger [
	| start tail first |
	start := self size - anInteger + 1 max: 1.
	tail := self copyFrom: start to: self size.
	first := tail findFirst: [:byte | byte < 128] ifAbsent: 1.
	first > 1 ifTrue: [
		start := start + first - 1.
		tail := tail allButFirst: first - 1].
	^UTF8 decode: tail
]

{ #category : #private }
ReadStream >> collectorOfSize: anInteger [
	^self subclassResponsibility
]

{ #category : #reading }
ReadStream >> copyFrom: start to: stop [
	| pos result |
	pos := self position.
	self position: start - 1.
	result := self next: stop - start + 1.
	self position: pos.
	^result
]

{ #category : #parsing }
ReadStream >> countBlanks [
	| count tab space |
	count := 0.
	tab := Character tab.
	space := $ .
	[self atEnd] whileFalse: [| char |
		char := self next.
		char = space ifTrue: [count := count + 1] ifFalse: [
			char = tab ifTrue: [count := count + 4] ifFalse: [
				self skip: -1.
				^count]]].
	^count
]

{ #category : #reading }
ReadStream >> getBytesFor: aByteArray [
	self readInto: aByteArray from: 1 to: aByteArray sizeInBytes
]

{ #category : #marshalling }
ReadStream >> getInteger [
	| byte |
	byte := self nextByte.
	^128 <= byte ifTrue: [self getInteger * 128 + byte - 128] ifFalse: [byte]
]

{ #category : #testing }
ReadStream >> isBinary [
	^false
]

{ #category : #testing }
ReadStream >> isEmpty [
	^self size = 0
]

{ #category : #private }
ReadStream >> newCollector [
	^self collectorOfSize: 0
]

{ #category : #reading }
ReadStream >> next [
	self subclassResponsibility
]

{ #category : #reading }
ReadStream >> next: anInteger [
	self subclassResponsibility
]

{ #category : #reading }
ReadStream >> nextByte [
	^self next asInteger
]

{ #category : #parsing }
ReadStream >> nextChunk [
	| bulk index n m bytes cr chunk |
	bulk := self basicNextChunk.
	index := 1.
	n := bulk size.
	[
		index <= n and: [| cp |
			cp := bulk byteAt: index.
			cp <= 32]]
		whileTrue: [index := index + 1].
	m := n - index + 1.
	m = 0 ifTrue: [^''].
	bytes := ByteArray new: m.
	bytes replaceFrom: 1 to: m with: bulk startingAt: index.
	cr := self eol includes: Cr.
	1 to: m do: [:i | | byte |
		byte := bytes at: i.
		(byte > 127 or: [byte = 10]) ifTrue: [
			chunk := UTF8 current decode: bytes.
			^cr
				ifTrue: [chunk copyWithout: Lf]
				ifFalse: [chunk replaceAll: self eol with: String cr]]].
	chunk := bytes asString.
	^self eol = String cr
		ifTrue: [chunk]
		ifFalse: [chunk replaceAll: self eol with: String cr]
]

{ #category : #reading }
ReadStream >> nextFloat [
	| float |
	float := Float new.
	self getBytesFor: float.
	^float
]

{ #category : #marshalling }
ReadStream >> nextInteger [
	^Integer readFrom: self
]

{ #category : #parsing }
ReadStream >> nextLine [
	| delimiter line |
	delimiter := self lineDelimiter.
	line := self upTo: delimiter.
	delimiter = Cr ifTrue: [self peekFor: Lf].
	^line
]

{ #category : #reading }
ReadStream >> nextLong [
	| bytes |
	bytes := ByteArray new: 4.
	self getBytesFor: bytes.
	^bytes longAtOffset: 0
]

{ #category : #reading }
ReadStream >> nextNoFail: anInteger [
	| n |
	n := anInteger min: self size - self position.
	^self next: n
]

{ #category : #services }
ReadStream >> nextString [
	| size |
	size := self nextULong.
	^(self next: size) asString
]

{ #category : #parsing }
ReadStream >> nextSubstring [
	| start |
	[
		self atEnd ifTrue: [^''].
		self next isAlphaNumericOrUnderscore] whileFalse.
	start := self position.
	[self atEnd not and: [self peek isAlphaNumericOrUnderscore]]
		whileTrue: [self next].
	^self copyFrom: start to: self position
]

{ #category : #parsing }
ReadStream >> nextSubstringOrNumber [
	| c numeric token writer |
	[
		self atEnd ifTrue: [^''].
		c := self next.
		c isAlphanumeric] whileFalse.
	numeric := c isDigit.
	writer := self newCollector writeStream.
	writer nextPut: c.
	[
		self atEnd not and: [
			c := self next.
			numeric ifTrue: [c isDigit] ifFalse: [c isAlphanumeric]]]
		whileTrue: [writer nextPut: c].
	token := writer contents.
	(numeric and: [c isLetter]) ifTrue: [self skip: -1].
	^token first isDigit ifTrue: [token asInteger] ifFalse: [token]
]

{ #category : #marshalling }
ReadStream >> nextULong [
	| a0 a1 a2 a3 |
	a0 := self nextByte.
	a1 := self nextByte bitShift: 8.
	a2 := self nextByte bitShift: 16.
	a3 := self nextByte bitShift: 24.
	^a3 + a2 + a1 + a0
]

{ #category : #marshalling }
ReadStream >> nextUShort [
	| a0 a1 |
	a0 := self nextByte.
	a1 := self nextByte bitShift: 8.
	^a1 + a0
]

{ #category : #reading }
ReadStream >> nextUTF8 [
	^Character value: self nextUTF8Code
]

{ #category : #reading }
ReadStream >> nextUTF8Code [
	^UTF8 current decodeFrom: self
]

{ #category : #parsing }
ReadStream >> nextUTF8Line [
	self position = 0 ifTrue: [self peekForAll: UTF8 prefix asString].
	^UTF8 decode: self nextLine asByteArray
]

{ #category : #parsing }
ReadStream >> nextWhile: aBlock [
	| write |
	write := self newCollector writeStream.
	[self atEnd not and: [aBlock evaluateWith: self peek]]
		whileTrue: [write nextPut: self next].
	^write contents
]

{ #category : #testing }
ReadStream >> notEmpty [
	^self isEmpty not
]

{ #category : #peeking }
ReadStream >> peek [
	self shouldNotImplement
]

{ #category : #peeking }
ReadStream >> peek: n [
	| pos safe data |
	pos := self position.
	safe := n min: self sizeToEnd.
	data := self next: safe.
	self position: pos.
	^data
]

{ #category : #peeking }
ReadStream >> peekFor: token [
	^self peek = token ifTrue: [self skip]; yourself
]

{ #category : #peeking }
ReadStream >> peekForAll: aCollection [
	| n |
	n := aCollection size.
	^((self peek: n) equalsTo: aCollection)
		ifTrue: [self skip: n];
		yourself
]

{ #category : #'reverse reading' }
ReadStream >> prev [
	^self position > 0
		ifTrue: [self position: self position - 1; peek]
		ifFalse: [self error: 'read beyond start of stream']
]

{ #category : #'reverse reading' }
ReadStream >> prevChunk [
	| bulk token index n m bytes chunk |
	token := self isBinary ifTrue: [$! asInteger] ifFalse: [$!].
	bulk := self reverseUpTo: token.
	[self atBeginning orNot: [self reversePeekFor: token]]
		whileFalse: [bulk := (self reverseUpTo: token) , '!' , bulk].
	index := 1.
	n := bulk size.
	[
		index <= n and: [| char |
			char := bulk at: index.
			char asInteger <= 32]]
		whileTrue: [index := index + 1].
	m := n - index + 1.
	m = 0 ifTrue: [^''].
	bytes := ByteArray new: m.
	bytes isEmpty ifTrue: [^''].
	bytes replaceFrom: 1 to: m with: bulk startingAt: index.
	chunk := UTF8 current decode: bytes.
	^chunk copyWithout: Lf
]

{ #category : #errors }
ReadStream >> readingError [
	EndOfStream signal
]

{ #category : #reading }
ReadStream >> readInto: aByteArray from: start to: stop [
	| data |
	data := self next: stop - start + 1.
	aByteArray replaceBytesFrom: start to: stop with: data startingAt: 1
]

{ #category : #converting }
ReadStream >> readStream [
	^self
]

{ #category : #'reverse reading' }
ReadStream >> reversePeekFor: token [
	| prev |
	self atBeginning ifTrue: [^false].
	prev := self prev.
	token = prev ifTrue: [^true].
	self position: self position + 1.
	^false
]

{ #category : #'reverse reading' }
ReadStream >> reverseSkipTo: token [
	[self atBeginning] whileFalse: [self prev = token ifTrue: [^true]].
	^false
]

{ #category : #'reverse reading' }
ReadStream >> reverseUpTo: token [
	| offset pos found |
	pos := self position.
	found := self reverseSkipTo: token.
	offset := found ifTrue: [1] ifFalse: [0].
	^self copyFrom: self position + offset + 1 to: pos
]

{ #category : #parsing }
ReadStream >> skipLine [
	| delimiter found |
	delimiter := self lineDelimiter.
	found := self skipTo: delimiter.
	delimiter = Cr ifTrue: [self peekFor: Lf].
	^found
]

{ #category : #parsing }
ReadStream >> skipSeparators [
	[self atEnd] whileFalse: [
		self peek isBlank ifFalse: [^self].
		self next]
]

{ #category : #positioning }
ReadStream >> skipTo: token [
	[self atEnd] whileFalse: [self next = token ifTrue: [^true]].
	^false
]

{ #category : #wb }
ReadStream >> skipWhitespace [
	[self atEnd orNot: [self peek isBlank]] whileFalse: [self next]
]

{ #category : #parsing }
ReadStream >> throughAll: aCollection [
	"
	(InternalReadStream on: 'Smalltalk') throughAll: 'll'
	"
	| collection pos |
	pos := self position.
	collection := self upToAll: aCollection.
	^self atEnd
		ifTrue: [self position: pos; upToEnd]
		ifFalse: [collection , aCollection]
]

{ #category : #parsing }
ReadStream >> untilAnySatisfying: aBlock [
	| write |
	write := self newCollector writeStream.
	[self atEnd or: [aBlock evaluateWith: self peek]]
		whileFalse: [write nextPut: self next].
	^write contents
]

{ #category : #parsing }
ReadStream >> upTo: token [
	| write c |
	write := self newCollector writeStream.
	[
		self atEnd not and: [
			c := self next.
			c ~= token]]
		whileTrue: [write nextPut: c].
	^write contents
]

{ #category : #parsing }
ReadStream >> upToAll: aCollection [
	"
	(InternalReadStream on: 'Smalltalk') upToAll: 'al'
	"
	| pattern result next aux |
	pattern := InternalReadStream on: aCollection.
	result := InternalWriteStream on: self newCollector.
	aux := InternalWriteStream on: self newCollector.
	[self atEnd or: [pattern atEnd]] whileFalse: [
		next := self next.
		next = pattern next ifTrue: [aux nextPut: next] ifFalse: [
			self position: self position - aux size.
			result nextPutAll: aux contents; nextPut: next.
			pattern reset.
			aux reset]].
	^result contents
]

{ #category : #parsing }
ReadStream >> upToAny: aCollection [
	| write c |
	write := self newCollector writeStream.
	[
		self atEnd not and: [
			c := self next.
			(aCollection includes: c) not]]
		whileTrue: [write nextPut: c].
	^write contents
]

{ #category : #parsing }
ReadStream >> upToAnySatisfying: aBlock [
	| write c |
	write := self newCollector writeStream.
	[
		self atEnd not and: [
			c := self next.
			(aBlock evaluateWith: c) not]]
		whileTrue: [write nextPut: c].
	^write contents
]

{ #category : #parsing }
ReadStream >> upToClosing: open [
	"
	'|things||some|-}blah' readStream next; upToClosing: $|
	"
	| start end result |
	start := self position.
	[
		self upTo: open.
		self prev = open ifFalse: [
			self position: start.
			^nil].
		self skip: 1.
		self peek = open ifTrue: [self next]; yourself] whileTrue.
	end := self position.
	self position: start.
	result := self next: end - start - 1.
	self skip: 1.
	^result
]

{ #category : #parsing }
ReadStream >> upToClosing: open with: close [
	"
	'{things{some}-}blah' readStream next; upToClosing: ${ with: $}; next
	"
	| start tokens count pos collection |
	open = close ifTrue: [^self upToClosing: open].
	start := self position.
	tokens := {open. close}.
	count := 1.
	[self atEnd or: [count = 0]] whileFalse: [| token |
		self upToAny: tokens.
		token := self skip: -1; next.
		pos := self position.
		token = open ifTrue: [count := count + 1].
		token = close ifTrue: [count := count - 1]].
	count = 0 ifFalse: [
		self position: start.
		^nil].
	self position: start.
	collection := self next: pos - 1 - start.
	self skip: 1.
	^collection
]

{ #category : #reading }
ReadStream >> upToEnd [
	^self next: self sizeToEnd
]

{ #category : #parsing }
ReadStream >> upToLast: token [
	"
	'{things{some}-}blah' readStream next; upToLast: $}
	"
	| start pos collection |
	start := self position.
	[self atEnd] whileFalse: [
		self upTo: token.
		(self skip: -1; next) = token ifTrue: [pos := self position]].
	self position: start.
	pos isNil ifTrue: [^self upToEnd].
	collection := self next: pos - start - 1.
	self skip: 1.
	^collection
]

{ #category : #parsing }
ReadStream >> upToWhitespace [
	^self upToAnySatisfying: [:c | c isBlank]
]

{ #category : #reading }
ReadStream >> utf8Trailing: byte [
	(byte bitAnd: 2r11100000) = 2r11000000 ifTrue: [^1].
	(byte bitAnd: 2r11110000) = 2r11100000 ifTrue: [^2].
	(byte bitAnd: 2r11111000) = 2r11110000 ifTrue: [^3].
	^nil
]

