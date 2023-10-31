"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #InternalWriteStream,
	#superclass : #WriteStream,
	#instVars : [
		'contents',
		'position',
		'limit',
		'eol',
		'size'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
InternalWriteStream class >> with: aCollection [
	^self new with: aCollection
]

{ #category : #services }
InternalWriteStream >> _nextNativePut: anObject [
	| object |
	object := anObject isSmallInteger
		ifTrue: [anObject _asNative]
		ifFalse: [anObject].
	contents _objectAtOffset: position put: object.
	position := position + WordSize
]

{ #category : #writing }
InternalWriteStream >> alignTo: boundary [
	| null |
	null := self collectorOfSize: boundary - (position \\ boundary).
	self nextPutAll: null
]

{ #category : #testing }
InternalWriteStream >> atEnd [
	^limit <= position
]

{ #category : #configuration }
InternalWriteStream >> beUnicode [
	self isUnicode ifTrue: [^self].
	contents := contents asWideString.
	eol := eol asWideString
]

{ #category : #accessing }
InternalWriteStream >> characterSize [
	^contents isString ifTrue: [contents characterSize] ifFalse: [1]
]

{ #category : #accessing }
InternalWriteStream >> collection [
	^contents
]

{ #category : #accessing }
InternalWriteStream >> collectorClass [
	^contents class
]

{ #category : #private }
InternalWriteStream >> collectorOfSize: anInteger [
	| collector |
	collector := contents class new: anInteger.
	collector size < anInteger
		ifTrue: [collector addAll: (Array new: anInteger - collector size)].
	^collector
]

{ #category : #accessing }
InternalWriteStream >> contents [
	^contents copyFrom: 1 to: size
]

{ #category : #private }
InternalWriteStream >> eol [
	eol notNil ifTrue: [^eol].
	^super eol
]

{ #category : #accessing }
InternalWriteStream >> eol: aString [
	eol := aString
]

{ #category : #private }
InternalWriteStream >> grow [
	| min max |
	min := contents size max: 20.
	max := min min: 1000000.
	self grow: max
]

{ #category : #private }
InternalWriteStream >> grow: extra [
	| collection |
	extra <= 0 ifTrue: [^self].
	collection := self collectorOfSize: contents size + extra.
	collection replaceFrom: 1 to: contents size with: contents.
	contents := collection.
	limit := contents size
]

{ #category : #private }
InternalWriteStream >> growAtLeast: extra [
	self grow: (contents size * 2 max: extra) + 10
]

{ #category : #initialization }
InternalWriteStream >> initialize [
	super initialize.
	self useCr
]

{ #category : #testing }
InternalWriteStream >> isBinary [
	^contents isByteArray
]

{ #category : #testing }
InternalWriteStream >> isEmpty [
	^self size = 0
]

{ #category : #testing }
InternalWriteStream >> isUnicode [
	^contents isString and: [contents isUnicode]
]

{ #category : #accessing }
InternalWriteStream >> lineDelimiter [
	^eol first
]

{ #category : #accessing }
InternalWriteStream >> lineDelimiter: aCharacter [
	eol := (aCharacter isCharacter and: [aCharacter isCr])
		ifTrue: [aCharacter , aCharacter class lf]
		ifFalse: [aCharacter asString]
]

{ #category : #accessing }
InternalWriteStream >> lineDelimiters: aString [
	self lineDelimiter: aString
]

{ #category : #marshalling }
InternalWriteStream >> nextBytePut: byte [
	| b |
	b := byte < 0 ifTrue: [byte bitAnd: 16rFF] ifFalse: [byte].
	position = limit ifTrue: [self grow].
	position := position + 1.
	size < position ifTrue: [size := position].
	^contents byteAt: position put: b
]

{ #category : #writing }
InternalWriteStream >> nextPut: token [
	| index |
	index := position + 1.
	index > limit ifTrue: [self grow].
	position := index.
	size < position ifTrue: [size := position].
	^contents at: index put: token
]

{ #category : #writing }
InternalWriteStream >> nextPutAll: aCollection [
	| n stop extra |
	n := aCollection size.
	n = 0 ifTrue: [^aCollection].
	extra := n - (limit - position).
	extra > 0 ifTrue: [self growAtLeast: extra].
	stop := position + n.
	(contents class == String and: [aCollection isUnicodeString])
		ifTrue: [
			self beUnicode.
			contents
				replaceBytesFrom: position * 2 + 1
				to: stop * 2
				with: aCollection
				startingAt: 1]
		ifFalse: [contents
			replaceFrom: position + 1
			to: stop
			with: aCollection
			startingAt: 1].
	position := stop.
	size < position ifTrue: [size := position].
	^aCollection
]

{ #category : #writing }
InternalWriteStream >> nextPutChar: aCharacter [
	(self isUnicode not andNot: [aCharacter isAnsi]) ifTrue: [self beUnicode].
	^self nextPut: aCharacter
]

{ #category : #writing }
InternalWriteStream >> nextPutString: aString [
	self isUnicode ifTrue: [^self nextPutAll: aString asWideString].
	aString isWideString ifTrue: [self beUnicode].
	^self nextPutAll: aString
]

{ #category : #private }
InternalWriteStream >> on: aCollection [
	contents := aCollection.
	position := size := 0.
	limit := contents size
]

{ #category : #accessing }
InternalWriteStream >> peek [
	^self atEnd ifFalse: [contents at: position + 1]
]

{ #category : #accessing }
InternalWriteStream >> peek: anInteger [
	| end |
	end := position + anInteger min: limit.
	^contents copyFrom: position + 1 to: end
]

{ #category : #accessing }
InternalWriteStream >> position [
	^position
]

{ #category : #positioning }
InternalWriteStream >> position: anInteger [
	(0 <= anInteger and: [anInteger <= limit])
		ifFalse: [^self
			error: 'position ' , anInteger asString , ' is out of bounds'].
	position := anInteger
]

{ #category : #services }
InternalWriteStream >> putBytesFrom: aByteArray from: start to: stop [
	| length end s e w |
	aByteArray isNil ifTrue: [^nil].
	length := stop - start + 1.
	contents isUnicodeString
		ifTrue: [
			w := contents characterSize.
			end := length // w + position.
			s := position * w + 1.
			e := position * w + length]
		ifFalse: [
			end := position + length.
			s := position + 1.
			e := end].
	limit < end ifTrue: [self grow: end - limit].
	contents replaceBytesFrom: s to: e with: aByteArray startingAt: start.
	position := end.
	size < position ifTrue: [size := position]
]

{ #category : #services }
InternalWriteStream >> readStream [
	| reader |
	reader := InternalReadStream on: contents.
	reader
		lineDelimiter: eol;
		readLimit: (limit min: size).
	^reader
]

{ #category : #private }
InternalWriteStream >> reserve: amount [
	| extra |
	amount <= limit ifTrue: [^self].
	extra := contents size - limit.
	self grow: extra
]

{ #category : #positioning }
InternalWriteStream >> reset [
	super reset.
	size := 0
]

{ #category : #positioning }
InternalWriteStream >> setToEnd [
	position := size
]

{ #category : #accessing }
InternalWriteStream >> size [
	^size
]

{ #category : #accessing }
InternalWriteStream >> sizeToEnd [
	^limit - position
]

{ #category : #positioning }
InternalWriteStream >> skip: anInteger [
	| end |
	end := position + anInteger.
	limit < end ifTrue: [self grow: end - limit].
	position := position + anInteger max: 0
]

{ #category : #accessing }
InternalWriteStream >> truncate [
	self truncateTo: position
]

{ #category : #accessing }
InternalWriteStream >> truncateTo: anInteger [
	size := anInteger
]

{ #category : #accessing }
InternalWriteStream >> useCr [
	eol := String with: Cr
]

{ #category : #accessing }
InternalWriteStream >> useCrLf [
	eol := String with: Cr with: Lf
]

{ #category : #private }
InternalWriteStream >> with: aCollection [
	self on: aCollection.
	size := position := limit
]

{ #category : #accessing }
InternalWriteStream >> writeLimit: anInteger [
	limit := anInteger
]

