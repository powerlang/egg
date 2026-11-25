'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #InternalReadStream category: #Kernel!
ReadStream subclass: #InternalReadStream
	instanceVariableNames: 'contents position limit eol'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!InternalReadStream commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!InternalReadStream methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asPetitStream
	^contents asPetitStream
! !

!InternalReadStream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
atEnd
	^limit <= position
! !

!InternalReadStream methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:27:38'!
beWide
	self isWide ifTrue: [^self].
	contents := contents asWideString.
	eol := eol asWideString
! !

!InternalReadStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
characterSize
	^contents isString ifTrue: [contents characterSize] ifFalse: [1]
! !

!InternalReadStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
collection
	^contents
! !

!InternalReadStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
collectorClass
	^contents class
! !

!InternalReadStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
collectorOfSize: anInteger
	| collector |
	collector := contents class new: anInteger.
	collector size < anInteger
		ifTrue: [collector addAll: (Array new: anInteger - collector size)].
	^collector
! !

!InternalReadStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
contents
	^contents
! !

!InternalReadStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
eol
	^eol
! !

!InternalReadStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
eol: aString
	eol := aString
! !

!InternalReadStream methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	eol := '
'
! !

!InternalReadStream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBinary
	^contents isByteArray
! !

!InternalReadStream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isEmpty
	^self size = 0
! !

!InternalReadStream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isWide
	^contents isString and: [contents isWideString]
! !

!InternalReadStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
lineDelimiter
	^eol first
! !

!InternalReadStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
lineDelimiter: aCharacter
	eol := (aCharacter isCharacter and: [aCharacter isCr])
		ifTrue: [aCharacter , aCharacter class lf]
		ifFalse: [aCharacter asString]
! !

!InternalReadStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
lineDelimiters: aString
	self lineDelimiter: aString
! !

!InternalReadStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
next
	limit notNil ifTrue: [
		position < limit ifFalse: [self readingError].
		position := position + 1.
		^contents at: position].
	position := position + 1.
	^contents at: position ifAbsent: [
		position := position - 1.
		self readingError]
! !

!InternalReadStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
next: n
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
! !

!InternalReadStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextByte
	self atEnd ifTrue: [self readingError].
	position := position + 1.
	^contents byteAt: position
! !

!InternalReadStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextLine
	| delimiter line |
	delimiter := eol first.
	line := self upTo: delimiter.
	delimiter = Cr ifTrue: [self peekFor: Lf].
	^line
! !

!InternalReadStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextOrNil
	^self atEnd ifFalse: [
		position := position + 1.
		contents at: position]
! !

!InternalReadStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextULong
	(self isBinary or: [contents class == String]) ifTrue: [
		position := position + 4.
		position > limit ifTrue: [
			position := limit.
			self readingError].
		^contents uLongAtOffset: position - 4].
	^super nextULong
! !

!InternalReadStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aCollection
	contents := aCollection.
	position := 0.
	limit := contents size.
	aCollection isString ifTrue: [self updateEol]
! !

!InternalReadStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aCollection from: anInteger to: anotherInteger
	| n |
	contents := aCollection.
	n := contents size.
	limit := anotherInteger min: n.
	position := anInteger <= 1 ifTrue: [0] ifFalse: [anInteger - 1]
! !

!InternalReadStream methodsFor:  'peeking' stamp: 'KenD 28/Jun/2026 13:27:38'!
peek
	^self atEnd ifFalse: [contents at: position + 1]
! !

!InternalReadStream methodsFor:  'peeking' stamp: 'KenD 28/Jun/2026 13:27:38'!
peekFor: token
	| found |
	found := self peek = token.
	found ifTrue: [position := position + 1].
	^found
! !

!InternalReadStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
position
	^position
! !

!InternalReadStream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
position: anInteger
	position := anInteger
! !

!InternalReadStream methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
readInto: aByteArray from: start to: stop
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
! !

!InternalReadStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
readLimit: anInteger
	limit := anInteger
! !

!InternalReadStream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
setToEnd
	limit := contents size.
	position := self size
! !

!InternalReadStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	^limit
! !

!InternalReadStream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
skipTo: token
	| index |
	index := contents
		indexOf: token
		startingAt: position + 1
		ifAbsent: [^super skipTo: token].
	self skip: index - position.
	^true
! !

!InternalReadStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
updateEol
	eol := contents eol ifNil: [String with: Cr]
! !

!InternalReadStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
upTo: token
	| pos found offset |
	pos := position.
	found := self skipTo: token.
	offset := found ifTrue: [1] ifFalse: [0].
	^contents copyFrom: pos + 1 to: position - offset
! !

!InternalReadStream methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
upToAll: aCollection
	"
	(InternalReadStream on: 'Smalltalk') upToAll: 'al'
	"
	aCollection size > 1
		ifTrue: [^self upToAll: aCollection td1: aCollection td1].
	aCollection size = 0 ifTrue: [^self upToEnd].
	^self upTo: aCollection first
! !

!InternalReadStream methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
upToAll: aCollection td1: td1
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
! !

!InternalReadStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
upToSeparator
	| writer ch |
	writer := InternalWriteStream on: self newCollector.
	[
		self atEnd or: [
			ch := self next.
			ch isBlank]]
		whileFalse: [writer nextPut: ch].
	^writer contents
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternalReadStream class' category: #Kernel!
InternalReadStream class
	instanceVariableNames: ''!

!InternalReadStream class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aCollection from: anInteger to: anotherInteger
	^self new on: aCollection from: anInteger to: anotherInteger
! !


InternalReadStream initialize!

