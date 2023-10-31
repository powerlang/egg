"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #InternalReadStream,
	#superclass : #ReadStream,
	#instVars : [
		'contents',
		'position',
		'limit',
		'eol'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
InternalReadStream class >> on: aCollection from: anInteger to: anotherInteger [
	^self new on: aCollection from: anInteger to: anotherInteger
]

{ #category : #converting }
InternalReadStream >> asPetitStream [
	^contents asPetitStream
]

{ #category : #testing }
InternalReadStream >> atEnd [
	^limit <= position
]

{ #category : #configuration }
InternalReadStream >> beUnicode [
	self isUnicode ifTrue: [^self].
	contents := contents asWideString.
	eol := eol asWideString
]

{ #category : #accessing }
InternalReadStream >> characterSize [
	^contents isString ifTrue: [contents characterSize] ifFalse: [1]
]

{ #category : #accessing }
InternalReadStream >> collection [
	^contents
]

{ #category : #accessing }
InternalReadStream >> collectorClass [
	^contents class
]

{ #category : #private }
InternalReadStream >> collectorOfSize: anInteger [
	| collector |
	collector := contents class new: anInteger.
	collector size < anInteger
		ifTrue: [collector addAll: (Array new: anInteger - collector size)].
	^collector
]

{ #category : #accessing }
InternalReadStream >> contents [
	^contents
]

{ #category : #private }
InternalReadStream >> eol [
	^eol
]

{ #category : #accessing }
InternalReadStream >> eol: aString [
	eol := aString
]

{ #category : #initialization }
InternalReadStream >> initialize [
	super initialize.
	eol := '
'
]

{ #category : #testing }
InternalReadStream >> isBinary [
	^contents isByteArray
]

{ #category : #testing }
InternalReadStream >> isEmpty [
	^self size = 0
]

{ #category : #testing }
InternalReadStream >> isUnicode [
	^contents isString and: [contents isUnicode]
]

{ #category : #accessing }
InternalReadStream >> lineDelimiter [
	^eol first
]

{ #category : #accessing }
InternalReadStream >> lineDelimiter: aCharacter [
	eol := (aCharacter isCharacter and: [aCharacter isCr])
		ifTrue: [aCharacter , aCharacter class lf]
		ifFalse: [aCharacter asString]
]

{ #category : #accessing }
InternalReadStream >> lineDelimiters: aString [
	self lineDelimiter: aString
]

{ #category : #reading }
InternalReadStream >> next [
	limit notNil ifTrue: [
		position < limit ifFalse: [self readingError].
		position := position + 1.
		^contents at: position].
	position := position + 1.
	^contents at: position ifAbsent: [
		position := position - 1.
		self readingError]
]

{ #category : #reading }
InternalReadStream >> next: n [
	| end result |
	end := position + n.
	^end > limit
		ifTrue: [
			position := limit.
			self readingError]
		ifFalse: [
			result := contents copyFrom: position + 1 to: end.
			position := end.
			result]
]

{ #category : #reading }
InternalReadStream >> nextByte [
	self atEnd ifTrue: [self readingError].
	position := position + 1.
	^contents byteAt: position
]

{ #category : #reading }
InternalReadStream >> nextLine [
	| delimiter line |
	delimiter := eol first.
	line := self upTo: delimiter.
	delimiter = Cr ifTrue: [self peekFor: Lf].
	^line
]

{ #category : #reading }
InternalReadStream >> nextOrNil [
	^self atEnd ifFalse: [
		position := position + 1.
		contents at: position]
]

{ #category : #marshalling }
InternalReadStream >> nextULong [
	(self isBinary or: [contents class == String]) ifTrue: [
		position := position + 4.
		position > limit ifTrue: [
			position := limit.
			self readingError].
		^contents uLongAtOffset: position - 4].
	^super nextULong
]

{ #category : #private }
InternalReadStream >> on: aCollection [
	contents := aCollection.
	position := 0.
	limit := contents size.
	aCollection isString ifTrue: [self updateEol]
]

{ #category : #private }
InternalReadStream >> on: aCollection from: anInteger to: anotherInteger [
	| n |
	contents := aCollection.
	n := contents size.
	limit := anotherInteger min: n.
	position := anInteger <= 1 ifTrue: [0] ifFalse: [anInteger - 1]
]

{ #category : #peeking }
InternalReadStream >> peek [
	^self atEnd ifFalse: [contents at: position + 1]
]

{ #category : #peeking }
InternalReadStream >> peekFor: token [
	^self peek = token ifTrue: [position := position + 1]; yourself
]

{ #category : #accessing }
InternalReadStream >> position [
	^position
]

{ #category : #positioning }
InternalReadStream >> position: anInteger [
	position := anInteger
]

{ #category : #services }
InternalReadStream >> readInto: aByteArray from: start to: stop [
	| end |
	end := position + stop - start + 1.
	end > limit ifTrue: [^self readingError].
	aByteArray
		replaceBytesFrom: start
		to: stop
		with: contents
		startingAt: position + 1.
	position := end.
	^aByteArray
]

{ #category : #accessing }
InternalReadStream >> readLimit: anInteger [
	limit := anInteger
]

{ #category : #positioning }
InternalReadStream >> setToEnd [
	limit := contents size.
	position := self size
]

{ #category : #accessing }
InternalReadStream >> size [
	^limit
]

{ #category : #positioning }
InternalReadStream >> skipTo: token [
	| index |
	index := contents
		indexOf: token
		startingAt: position + 1
		ifAbsent: [^super skipTo: token].
	self skip: index - position.
	^true
]

{ #category : #private }
InternalReadStream >> updateEol [
	eol := contents eol ifNil: [String with: Cr]
]

{ #category : #reading }
InternalReadStream >> upTo: token [
	| pos found offset |
	pos := position.
	found := self skipTo: token.
	offset := found ifTrue: [1] ifFalse: [0].
	^contents copyFrom: pos + 1 to: position - offset
]

{ #category : #parsing }
InternalReadStream >> upToAll: aCollection [
	"
	(InternalReadStream on: 'Smalltalk') upToAll: 'al'
	"
	aCollection size > 1
		ifTrue: [^self upToAll: aCollection td1: aCollection td1].
	aCollection size = 0 ifTrue: [^self upToEnd].
	^self upTo: aCollection first
]

{ #category : #parsing }
InternalReadStream >> upToAll: aCollection td1: td1 [
	"
	'hola' readStream upToAll: 'ol' td1: 'ol' td1
	"
	| index string |
	index := contents
		indexOfSubcollection: aCollection
		from: position + 1
		to: limit
		td1: td1.
	index = 0 ifTrue: [^self upToEnd].
	string := self next: index - position - 1.
	self skip: aCollection size.
	^string
]

{ #category : #reading }
InternalReadStream >> upToSeparator [
	| writer ch |
	writer := InternalWriteStream on: self newCollector.
	[
		self atEnd or: [
			ch := self next.
			ch isBlank]]
		whileFalse: [writer nextPut: ch].
	^writer contents
]

