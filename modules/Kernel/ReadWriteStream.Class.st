'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ReadWriteStream category: #Kernel!
InternalWriteStream subclass: #ReadWriteStream
	instanceVariableNames: 'reader'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ReadWriteStream commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ReadWriteStream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
atEnd
	^size <= position
! !

!ReadWriteStream methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:27:38'!
beWide
	| pos delimiter |
	self isWide ifTrue: [^self].
	super beWide.
	pos := reader position.
	delimiter := reader eol asWideString.
	reader := InternalReadStream on: contents.
	reader eol: delimiter; position: pos
! !

!ReadWriteStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyFrom: start to: stop
	| result |
	result := reader copyFrom: start to: stop.
	reader position: position.
	^result
! !

!ReadWriteStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
doReading: aBlock
	| next |
	reader position: position.
	next := aBlock value.
	position := reader position.
	^next
! !

!ReadWriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
getInteger
	^self doReading: [reader getInteger]
! !

!ReadWriteStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
grow: extra
	super grow: extra.
	reader on: contents; position: position
! !

!ReadWriteStream methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	reader := InternalReadStream on: contents.
	size := contents size
! !

!ReadWriteStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
next
	^self doReading: [reader next]
! !

!ReadWriteStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
next: anInteger
	^self doReading: [reader next: anInteger]
! !

!ReadWriteStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextByte
	^self doReading: [reader nextByte]
! !

!ReadWriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextBytePut: byte
	| b |
	b := super nextBytePut: byte.
	size < position ifTrue: [size := position].
	^b
! !

!ReadWriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextInteger
	^self doReading: [reader nextInteger]
! !

!ReadWriteStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextLine
	^self doReading: [reader nextLine]
! !

!ReadWriteStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextNoFail: anInteger
	^self doReading: [reader nextNoFail: anInteger]
! !

!ReadWriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextPut: token
	| t |
	t := super nextPut: token.
	size < position ifTrue: [size := position].
	^t
! !

!ReadWriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextPutAll: aCollection
	| c |
	c := super nextPutAll: aCollection.
	size < position ifTrue: [size := position].
	^c
! !

!ReadWriteStream methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextSubstring
	^self doReading: [reader nextSubstring]
! !

!ReadWriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextULong
	^self doReading: [reader nextULong]
! !

!ReadWriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextUShort
	^self doReading: [reader nextUShort]
! !

!ReadWriteStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aCollection
	super on: aCollection.
	reader on: contents; position: position.
	limit := aCollection size.
	size := 0
! !

!ReadWriteStream methodsFor:  'peeking' stamp: 'KenD 28/Jun/2026 13:27:38'!
peek
	reader position: position.
	^reader peek
! !

!ReadWriteStream methodsFor:  'peeking' stamp: 'KenD 28/Jun/2026 13:27:38'!
peek: anInteger
	reader position: position.
	^reader peek: anInteger
! !

!ReadWriteStream methodsFor:  'peeking' stamp: 'KenD 28/Jun/2026 13:27:38'!
peekFor: token
	| found |
	reader position: position.
	found := reader peekFor: token.
	found ifTrue: [self position: reader position].
	^found
! !

!ReadWriteStream methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
putBytesFrom: aByteArray from: start to: stop
	super putBytesFrom: aByteArray from: start to: stop.
	size < position ifTrue: [size := position]
! !

!ReadWriteStream methodsFor:  'positioning' stamp: 'KenD 28/Jun/2026 13:27:38'!
reset
	self position: 0
! !

!ReadWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeToEnd
	^size - position
! !

!ReadWriteStream methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
skipSeparators
	self doReading: [reader skipSeparators]
! !

!ReadWriteStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
skipTo: token
	^self doReading: [reader skipTo: token]
! !

!ReadWriteStream methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
throughAll: aCollection
	^self doReading: [reader throughAll: aCollection]
! !

!ReadWriteStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncate
	limit := size := position
! !

!ReadWriteStream methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
untilAnySatisfying: aBlock
	^self doReading: [reader untilAnySatisfying: aBlock]
! !

!ReadWriteStream methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
upTo: token
	^self doReading: [reader upTo: token]
! !

!ReadWriteStream methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
upToAll: aCollection
	^self doReading: [reader upToAll: aCollection]
! !

!ReadWriteStream methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
upToAny: aCollection
	^self doReading: [reader upToAny: aCollection]
! !

!ReadWriteStream methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
upToAnySatisfying: aBlock
	^self doReading: [reader upToAnySatisfying: aBlock]
! !

!ReadWriteStream methodsFor:  'reading' stamp: 'KenD 28/Jun/2026 13:27:38'!
upToEnd
	^self doReading: [reader next: self sizeToEnd]
! !

!ReadWriteStream methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:38'!
upToWhitespace
	^self doReading: [reader upToWhitespace]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ReadWriteStream class' category: #Kernel!
ReadWriteStream class
	instanceVariableNames: ''!


ReadWriteStream initialize!

