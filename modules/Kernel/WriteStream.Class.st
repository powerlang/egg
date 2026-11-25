'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #WriteStream category: #Kernel!
Stream subclass: #WriteStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!WriteStream commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!WriteStream methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
<< anObject
	| string |
	string := anObject isString
		ifTrue: [anObject]
		ifFalse: [anObject printString].
	self nextPutAll: string
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
alignTo: boundary
	| null |
	null := self
		collectorOfSize: boundary - (self position \\ boundary) \\ boundary.
	self nextPutAll: null
! !

!WriteStream methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
collectorOfSize: anInteger
	self subclassResponsibility
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
cr
	self nextPutAll: self eol
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
crlf
	self nextPutAll: String crlf
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
crtab
	self crtab: 1
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
crtab: n
	self cr; tab: n
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
flush
	
! !

!WriteStream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isBinary
	^false
! !

!WriteStream methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isOpen
	^true
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
next: anInteger put: anObject
	anInteger timesRepeat: [self nextPut: anObject].
	^anObject
! !

!WriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextBytePut: byte
	| token |
	(byte between: 0 and: 255) ifFalse: [self error: 'ilegal number'].
	token := self isBinary ifTrue: [byte] ifFalse: [byte asCharacter].
	self nextPut: token.
	^byte
! !

!WriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextBytesPut: aByteArray
	| token |
	token := self isBinary
		ifTrue: [aByteArray]
		ifFalse: [aByteArray asByteArray asString].
	self putBytesFrom: token.
	^aByteArray
! !

!WriteStream methodsFor:  'chunk format' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextChunkPut: aString
	aString printChunkOn: self
! !

!WriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextFloatPut: aFloat
	^self nextPutAll: aFloat asByteArray
! !

!WriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextInt64Put: anInteger
	| n |
	(anInteger < -16r8000000000000000 or: [ anInteger >= 16r8000000000000000 ])
		ifTrue: [ self error: 'outside 64-bit integer range' ].
	n := anInteger < 0
		ifTrue: [ 16r10000000000000000 + anInteger ]
		ifFalse: [ anInteger ].
	8 to: 1 by: -1 do: [:i | self nextPut: (n byteAt: i)]
! !

!WriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextLongPut: anInteger
	| bytes |
	bytes := ByteArray new: 4.
	bytes longAtOffset: 0 put: anInteger.
	self putBytesFrom: bytes
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextPut: anObject
	self subclassResponsibility
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextPutAll: aCollection
	aCollection do: [:element | self nextPut: element]
! !

!WriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextStringPut: aString
	self nextULongPut: aString size; nextPutAll: aString
! !

!WriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextULargePut: anInteger
	self isBinary
		ifTrue: [
			1 to: 8 do: [:i | | bi |
				bi := anInteger at: i.
				self nextPut: bi]]
		ifFalse: [
			1 to: 8 do: [:i | | bi |
				bi := anInteger at: i.
				self nextPut: bi asCharacter]]
! !

!WriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextULongPut: anInteger
	self isBinary
		ifTrue: [
			1 to: 4 do: [:i | | bi |
				bi := anInteger at: i.
				self nextPut: bi]]
		ifFalse: [
			1 to: 4 do: [:i | | bi |
				bi := anInteger at: i.
				self nextPut: bi asCharacter]]
! !

!WriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextUShortPut: anInteger
	| bytes |
	bytes := ByteArray new: 2.
	bytes uShortAtOffset: 0 put: anInteger.
	self putBytesFrom: bytes
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextUTF8Put: aString
	aString do: [:ch | ch storeUTF8On: self]
! !

!WriteStream methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
print: anObject
	anObject isString ifTrue: [^self nextPutAll: anObject].
	anObject isCharacter ifTrue: [^self nextPut: anObject].
	anObject printOn: self
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
putBytesFrom: aByteArray
	self putBytesFrom: aByteArray from: 1 to: aByteArray sizeInBytes
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
putBytesFrom: aByteArray from: start to: stop
	self subclassResponsibility
! !

!WriteStream methodsFor:  'marshalling' stamp: 'KenD 28/Jun/2026 13:27:38'!
putInteger: anInteger
	anInteger < 128
		ifTrue: [self nextBytePut: anInteger]
		ifFalse: [self
			nextBytePut: anInteger \\ 128 + 128;
			putInteger: anInteger // 128]
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
show: aString
	self nextPutAll: aString
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
space
	self nextPut: Space
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
tab
	self nextPut: Tab
! !

!WriteStream methodsFor:  'writing' stamp: 'KenD 28/Jun/2026 13:27:38'!
tab: n
	n timesRepeat: [self tab]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WriteStream class' category: #Kernel!
WriteStream class
	instanceVariableNames: ''!


