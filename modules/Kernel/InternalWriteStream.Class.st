'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #InternalWriteStream category: #Kernel!
WriteStream subclass: #InternalWriteStream
	instanceVariableNames: 'contents position limit eol size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!InternalWriteStream commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!InternalWriteStream methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
_nextNativePut: anObject
	| object |
	object := anObject isSmallInteger
		ifTrue: [anObject _asNative]
		ifFalse: [anObject].
	contents _objectAtOffset: position put: object.
	position := position + WordSize
! !

!InternalWriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
alignTo: boundary
	| null |
	null := self collectorOfSize: boundary - (position \\ boundary).
	self nextPutAll: null
! !

!InternalWriteStream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
atEnd
	^limit <= position
! !

!InternalWriteStream methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:27:38'!
beWide
	self isWide ifTrue: [^self].
	contents := contents asWideString.
	eol := eol asWideString
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
characterSize
	^contents isString ifTrue: [contents characterSize] ifFalse: [1]
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
collection
	^contents
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
collectorClass
	^contents class
! !

!InternalWriteStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
collectorOfSize: anInteger
	| collector |
	collector := contents class new: anInteger.
	collector size < anInteger
		ifTrue: [collector addAll: (Array new: anInteger - collector size)].
	^collector
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
contents
	^contents copyFrom: 1 to: size
! !

!InternalWriteStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
eol
	eol notNil ifTrue: [^eol].
	^super eol
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
eol: aString
	eol := aString
! !

!InternalWriteStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
grow
	| min max |
	min := contents size max: 20.
	max := min min: 1000000.
	self grow: max
! !

!InternalWriteStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
grow: extra
	| collection |
	extra <= 0 ifTrue: [^self].
	collection := self collectorOfSize: contents size + extra.
	collection replaceFrom: 1 to: contents size with: contents.
	contents := collection.
	limit := contents size
! !

!InternalWriteStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
growAtLeast: extra
	self grow: (contents size * 2 max: extra) + 10
! !

!InternalWriteStream methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	self useCr
! !

!InternalWriteStream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBinary
	^contents isByteArray
! !

!InternalWriteStream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isEmpty
	^self size = 0
! !

!InternalWriteStream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isWide
	^contents isString and: [contents isWide]
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
lineDelimiter
	^eol first
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
lineDelimiter: aCharacter
	eol := (aCharacter isCharacter and: [aCharacter isCr])
		ifTrue: [aCharacter , aCharacter class lf]
		ifFalse: [aCharacter asString]
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
lineDelimiters: aString
	self lineDelimiter: aString
! !

!InternalWriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextBytePut: byte
	| b |
	b := byte < 0 ifTrue: [byte bitAnd: 16rFF] ifFalse: [byte].
	position = limit ifTrue: [self grow].
	position := position + 1.
	size < position ifTrue: [size := position].
	^contents byteAt: position put: b
! !

!InternalWriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextPut: token
	| index |
	index := position + 1.
	index > limit ifTrue: [self grow].
	position := index.
	size < position ifTrue: [size := position].
	^contents at: index put: token
! !

!InternalWriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextPutAll: aCollection
	| n stop extra |
	n := aCollection size.
	n = 0 ifTrue: [^aCollection].
	extra := n - (limit - position).
	extra > 0 ifTrue: [self growAtLeast: extra].
	stop := position + n.
	(contents class == String and: [aCollection isWideString])
		ifTrue: [
			self beWide.
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
! !

!InternalWriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextPutChar: aCharacter
	(self isWide not andNot: [aCharacter isByteCharacter]) ifTrue: [self beWide].
	^self nextPut: aCharacter
! !

!InternalWriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextPutString: aString
	self isWide ifTrue: [^self nextPutAll: aString asWideString].
	aString isWideString ifTrue: [self beWide].
	^self nextPutAll: aString
! !

!InternalWriteStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aCollection
	contents := aCollection.
	position := size := 0.
	limit := contents size
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
peek
	^self atEnd ifFalse: [contents at: position + 1]
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
peek: anInteger
	| end |
	end := position + anInteger min: limit.
	^contents copyFrom: position + 1 to: end
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
position
	^position
! !

!InternalWriteStream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
position: anInteger
	(0 <= anInteger and: [anInteger <= limit])
		ifFalse: [^self
			error: 'position ' , anInteger asString , ' is out of bounds'].
	position := anInteger
! !

!InternalWriteStream methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
putBytesFrom: aByteArray from: start to: stop
	| length end s e w |
	aByteArray isNil ifTrue: [^nil].
	length := stop - start + 1.
	contents isWideString
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
! !

!InternalWriteStream methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
readStream
	| reader |
	reader := InternalReadStream on: contents.
	reader
		lineDelimiter: eol;
		readLimit: (limit min: size).
	^reader
! !

!InternalWriteStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
reserve: amount
	| extra |
	amount <= limit ifTrue: [^self].
	extra := contents size - limit.
	self grow: extra
! !

!InternalWriteStream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
reset
	super reset.
	size := 0
! !

!InternalWriteStream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
setToEnd
	position := size
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	^size
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeToEnd
	^limit - position
! !

!InternalWriteStream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
skip: anInteger
	| end |
	end := position + anInteger.
	limit < end ifTrue: [self grow: end - limit].
	position := position + anInteger max: 0
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncate
	self truncateTo: position
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncateTo: anInteger
	size := anInteger
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
useCr
	eol := String with: Cr
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
useCrLf
	eol := String with: Cr with: Lf
! !

!InternalWriteStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: aCollection
	self on: aCollection.
	size := position := limit
! !

!InternalWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
writeLimit: anInteger
	limit := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternalWriteStream class' category: #Kernel!
InternalWriteStream class
	instanceVariableNames: ''!

!InternalWriteStream class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: aCollection
	^self new with: aCollection
! !


InternalWriteStream initialize!

