"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #UTF16,
	#superclass : #Unicode,
	#category : #Kernel
}

{ #category : #services }
UTF16 class >> decodeFromAddress: externalAddress length: anInteger [
	| stream |
	stream := externalAddress readStream readLimit: anInteger * 2.
	^self current decodeStringFrom: stream length: anInteger
]

{ #category : #accessing }
UTF16 class >> prefix [
	^#[16rFE 16rFF]
]

{ #category : #services }
UTF16 >> characterIndexesOf: aString from: start to: end [
	"
	UTF16 current characterIndexesOf: '𝑎𝑎𝑎x' from: 3 to: 5
	"
	| i e s max n |
	aString isWideString ifFalse: [^start thru: end].
	s := i := self characterIndexOf: aString at: start.
	n := aString size.
	max := end * 2.
	e := start * 2.
	[i < n and: [e <= max]] whileTrue: [| ch len |
		i := i + 1.
		ch := aString at: i.
		len := self sizeOfCharacter: ch.
		e := e + len].
	^s thru: i - 1
]

{ #category : #services }
UTF16 >> characterIndexOf: aString at: anInteger [
	(self isDBS: aString upTo: anInteger - 1) ifTrue: [^anInteger].
	^super characterIndexOf: aString at: anInteger * 2
]

{ #category : #'encoding / decoding' }
UTF16 >> decodeFrom: aStream [
	| b1 b2 hi b3 b4 lo |
	b1 := aStream nextByte.
	b2 := aStream nextByte.
	hi := b1 + (b2 bitShift: 8).
	b2 < 16rD8 ifTrue: [^hi].
	hi := hi - 16rD800.
	hi < 16r400 ifFalse: [^b2 * 256 + b1].
	hi := (hi bitShift: 10) + 16r10000.
	b3 := aStream nextByte.
	b4 := aStream nextByte.
	lo := (b4 bitShift: 8) - 16rDC00 + b3.
	^hi + lo
]


{ #category : #'encoding / decoding' }
UTF16 >> encode: aCharacter on: aStream [
	| code c20 hi lo |
	code := aCharacter codePoint.
	code < 128 ifTrue: [
		aStream nextPut: code; nextPut: 0.
		^self].
	code < 16rD800 ifTrue: [
		aStream
			nextPut: (code bitAnd: 16rFF);
			nextPut: (code bitShift: -8).
		^self].
	code < 16rE000 ifTrue: [self error: 'invalid code point'].
	code < 16r10000 ifTrue: [
		aStream
			nextPut: (code bitAnd: 16rFF);
			nextPut: (code bitShift: -8).
		^self].
	code < 16r110000 ifTrue: [
		c20 := code - 16r10000.
		hi := (c20 bitShift: -10) + 16rD800.
		lo := (c20 bitAnd: 16r3FF) + 16rDC00.
		aStream
			nextPut: (hi bitAnd: 16rFF);
			nextPut: (hi bitShift: -8);
			nextPut: (lo bitAnd: 16rFF);
			nextPut: (lo bitShift: -8).
		^self].
	self error: 'invalid code point'
]

{ #category : #services }
UTF16 >> indexesOf: aString from: start to: end [
	| e stretch delta |
	e := start - 1 max: end - 1.
	(self isDBS: aString upTo: e) ifTrue: [
		delta := end > 0
			ifTrue: [self sizeOfCharacter: (aString at: end)]
			ifFalse: [0].
		^start thru: end - 1 + (delta // 2)].
	stretch := super indexesOf: aString from: start to: end.
	^stretch + 1 // 2
]

{ #category : #services }
UTF16 >> isDBS: aString [
	^self isDBS: aString upTo: aString size
]

{ #category : #services }
UTF16 >> isDBS: aString upTo: anInteger [
	aString isUnicode ifFalse: [^true].
	2
		to: anInteger * 4
		by: 4
		do: [:i | (aString uShortAtOffset: i) = 0 ifFalse: [^false]].
	^true
]

{ #category : #services }
UTF16 >> lengthOf: aString [
	^(self encode: aString) size // 2
]

{ #category : #private }
UTF16 >> minBytesPerChar [
	^2
]

{ #category : #services }
UTF16 >> parameterFrom: aString [
	| strm |
	strm := (ByteArray new: aString size + 1 * 2) writeStream.
	aString isCharacter
		ifTrue: [self encode: aString on: strm]
		ifFalse: [aString do: [:char | self encode: char on: strm]].
	strm nextPut: 0; nextPut: 0.
	^strm contents
]

{ #category : #services }
UTF16 >> sizeInBytesOf: aString [
	aString isWideString ifFalse: [^aString size + 1 * 2].
	^super sizeInBytesOf: aString
]

{ #category : #'encoding / decoding' }
UTF16 >> sizeOfCharacter: aCharacter [
	^aCharacter codePoint < 16r10000 ifTrue: [2] ifFalse: [4]
]
