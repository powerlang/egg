"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ReadWriteStream,
	#superclass : #InternalWriteStream,
	#instVars : [
		'reader'
	],
	#category : #Kernel
}

{ #category : #testing }
ReadWriteStream >> atEnd [
	^size <= position
]

{ #category : #configuration }
ReadWriteStream >> beUnicode [
	| pos delimiter |
	self isUnicode ifTrue: [^self].
	super beUnicode.
	pos := reader position.
	delimiter := reader eol asWideString.
	reader := InternalReadStream on: contents.
	reader eol: delimiter; position: pos
]

{ #category : #reading }
ReadWriteStream >> copyFrom: start to: stop [
	| result |
	result := reader copyFrom: start to: stop.
	reader position: position.
	^result
]

{ #category : #private }
ReadWriteStream >> doReading: aBlock [
	| next |
	reader position: position.
	next := aBlock value.
	position := reader position.
	^next
]

{ #category : #marshalling }
ReadWriteStream >> getInteger [
	^self doReading: [reader getInteger]
]

{ #category : #private }
ReadWriteStream >> grow: extra [
	super grow: extra.
	reader on: contents; position: position
]

{ #category : #initialization }
ReadWriteStream >> initialize [
	super initialize.
	reader := InternalReadStream on: contents.
	size := contents size
]

{ #category : #reading }
ReadWriteStream >> next [
	^self doReading: [reader next]
]

{ #category : #reading }
ReadWriteStream >> next: anInteger [
	^self doReading: [reader next: anInteger]
]

{ #category : #reading }
ReadWriteStream >> nextByte [
	^self doReading: [reader nextByte]
]

{ #category : #marshalling }
ReadWriteStream >> nextBytePut: byte [
	| b |
	b := super nextBytePut: byte.
	size < position ifTrue: [size := position].
	^b
]

{ #category : #marshalling }
ReadWriteStream >> nextInteger [
	^self doReading: [reader nextInteger]
]

{ #category : #reading }
ReadWriteStream >> nextLine [
	^self doReading: [reader nextLine]
]

{ #category : #reading }
ReadWriteStream >> nextNoFail: anInteger [
	^self doReading: [reader nextNoFail: anInteger]
]

{ #category : #writing }
ReadWriteStream >> nextPut: token [
	| t |
	t := super nextPut: token.
	size < position ifTrue: [size := position].
	^t
]

{ #category : #writing }
ReadWriteStream >> nextPutAll: aCollection [
	| c |
	c := super nextPutAll: aCollection.
	size < position ifTrue: [size := position].
	^c
]

{ #category : #parsing }
ReadWriteStream >> nextSubstring [
	^self doReading: [reader nextSubstring]
]

{ #category : #marshalling }
ReadWriteStream >> nextULong [
	^self doReading: [reader nextULong]
]

{ #category : #marshalling }
ReadWriteStream >> nextUShort [
	^self doReading: [reader nextUShort]
]

{ #category : #private }
ReadWriteStream >> on: aCollection [
	super on: aCollection.
	reader on: contents; position: position.
	limit := aCollection size.
	size := 0
]

{ #category : #peeking }
ReadWriteStream >> peek [
	reader position: position.
	^reader peek
]

{ #category : #peeking }
ReadWriteStream >> peek: anInteger [
	reader position: position.
	^reader peek: anInteger
]

{ #category : #peeking }
ReadWriteStream >> peekFor: token [
	| found |
	reader position: position.
	found := reader peekFor: token.
	found ifTrue: [self position: reader position].
	^found
]

{ #category : #services }
ReadWriteStream >> putBytesFrom: aByteArray from: start to: stop [
	super putBytesFrom: aByteArray from: start to: stop.
	size < position ifTrue: [size := position]
]

{ #category : #positioning }
ReadWriteStream >> reset [
	self position: 0
]

{ #category : #accessing }
ReadWriteStream >> sizeToEnd [
	^size - position
]

{ #category : #parsing }
ReadWriteStream >> skipSeparators [
	self doReading: [reader skipSeparators]
]

{ #category : #reading }
ReadWriteStream >> skipTo: token [
	^self doReading: [reader skipTo: token]
]

{ #category : #parsing }
ReadWriteStream >> throughAll: aCollection [
	^self doReading: [reader throughAll: aCollection]
]

{ #category : #accessing }
ReadWriteStream >> truncate [
	limit := size := position
]

{ #category : #parsing }
ReadWriteStream >> untilAnySatisfying: aBlock [
	^self doReading: [reader untilAnySatisfying: aBlock]
]

{ #category : #parsing }
ReadWriteStream >> upTo: token [
	^self doReading: [reader upTo: token]
]

{ #category : #parsing }
ReadWriteStream >> upToAll: aCollection [
	^self doReading: [reader upToAll: aCollection]
]

{ #category : #parsing }
ReadWriteStream >> upToAny: aCollection [
	^self doReading: [reader upToAny: aCollection]
]

{ #category : #parsing }
ReadWriteStream >> upToAnySatisfying: aBlock [
	^self doReading: [reader upToAnySatisfying: aBlock]
]

{ #category : #reading }
ReadWriteStream >> upToEnd [
	^self doReading: [reader next: self sizeToEnd]
]

{ #category : #parsing }
ReadWriteStream >> upToWhitespace [
	^self doReading: [reader upToWhitespace]
]

