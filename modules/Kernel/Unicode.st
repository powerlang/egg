"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Unicode,
	#superclass : #Object,
	#classInstVars : [
		'current'
	],
	#category : #Kernel
}

{ #category : #accessing }
Unicode class >> current [
	^current
]

{ #category : #services }
Unicode class >> decode: aByteArray [
	^self current decode: aByteArray
]

{ #category : #services }
Unicode class >> decodeBytes: aByteArray [
	| decoder stream |
	stream := aByteArray readStream.
	decoder := self decoderFor: stream.
	^decoder decode: stream upToEnd
]

{ #category : #services }
Unicode class >> decodeFromAddress: externalAddress length: anInteger [
	^self current
		decodeStringFrom: externalAddress readStream
		length: anInteger
]

{ #category : #services }
Unicode class >> decoderFor: aStream [
	(aStream peekForAll: UTF32 prefix) ifTrue: [^UTF32].
	(aStream peekForAll: UTF16 prefix) ifTrue: [^UTF16].
	^UTF8
]

{ #category : #initialization }
Unicode class >> initializeCurrent [
	current := self == Unicode ifFalse: [self new]
]

{ #category : #services }
Unicode >> characterIndexOf: aString at: anInteger [
	| index s |
	index := 0.
	s := 0.
	[s < anInteger] whileTrue: [| ch len |
		index := index + 1.
		ch := aString at: index.
		len := self sizeOfCharacter: ch.
		s := s + len].
	^index
]

{ #category : #private }
Unicode >> compareStringiW: aString1 with: aString2 [
	^UTF16 current compareStringiW: aString1 with: aString2
]

{ #category : #'encoding / decoding' }
Unicode >> decode: aByteArray [
	^self decodeStringFrom: aByteArray readStream
]

{ #category : #'encoding / decoding' }
Unicode >> decodeFrom: aStream [
	self subclassResponsibility
]

{ #category : #services }
Unicode >> decodeStringFrom: aStream [
	^self
		decodeStringFrom: aStream
		length: aStream size // self minBytesPerChar
]

{ #category : #services }
Unicode >> decodeStringFrom: aStream length: anInteger [
	| string |
	string := String new: anInteger.
	^self decodeStringFrom: aStream on: string
]

{ #category : #services }
Unicode >> decodeStringFrom: aStream on: buffer [
	| bytes code string index n |
	bytes := true.
	index := 0.
	code := nil.
	string := buffer.
	n := string size.
	[aStream atEnd or: [code = 0] or: [index >= n]] whileFalse: [
		code := self decodeFrom: aStream.
		(bytes andNot: [Ansi isAnsi: code]) ifTrue: [
			bytes := false.
			string := string asWideString].
		code = 0 ifFalse: [
			index := index + 1.
			string at: index putCode: code]].
	^index < string size ifTrue: [string copyTo: index] ifFalse: [string]
]

{ #category : #'encoding / decoding' }
Unicode >> encode: aString [
	^ByteArray
		streamContents: [:strm | aString do: [:ch | self encode: ch on: strm]]
]

{ #category : #'encoding / decoding' }
Unicode >> encode: aCharacter on: aStream [
	self subclassResponsibility
]

{ #category : #services }
Unicode >> externalCopyOf: aString [
	| bytes |
	aString isNil ifTrue: [^nil].
	bytes := self parameterFrom: aString.
	^bytes externalCopy
]

{ #category : #services }
Unicode >> indexesOf: aString from: start to: end [
	"
	UTF16 current indexesOf: (WideString with: $𝑎 with: $_ with: $𝑎 with: $→) from: 2 to: 3
	"
	| s e |
	s := 1.
	1 to: start - 1 do: [:i | | ch len |
		ch := aString at: i.
		len := self sizeOfCharacter: ch.
		s := s + len].
	e := s - 1.
	start to: end do: [:i | | ch len |
		ch := aString at: i.
		len := self sizeOfCharacter: ch.
		e := e + len].
	^s thru: e
]

{ #category : #services }
Unicode >> isString: s1 greaterThan: s2 [
	^(self compareStringiW: s1 with: s2) > 0
]

{ #category : #services }
Unicode >> isString: s1 greaterThanOrEqualTo: s2 [
	^(self compareStringiW: s1 with: s2) >= 0
]

{ #category : #services }
Unicode >> isString: s1 lessThan: s2 [
	^(self compareStringiW: s1 with: s2) < 0
]

{ #category : #services }
Unicode >> isString: s1 lessThanOrEqualTo: s2 [
	^(self compareStringiW: s1 with: s2) <= 0
]

{ #category : #services }
Unicode >> lowercaseOf: aString [
	^UTF16 current lowercaseOf: aString
]

{ #category : #private }
Unicode >> minBytesPerChar [
	^1
]

{ #category : #services }
Unicode >> sizeInBytesOf: aString [
	| size |
	size := self sizeOfCharacter: Character null.
	1 to: aString size do: [:i | | ch s |
		ch := aString at: i.
		s := self sizeOfCharacter: ch.
		size := size + s].
	^size
]

{ #category : #services }
Unicode >> uppercaseOf: aString [
	^UTF16 current uppercaseOf: aString
]

