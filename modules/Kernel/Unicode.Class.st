'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Unicode category: #Kernel!
Object subclass: #Unicode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Unicode commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
characterIndexOf: aString at: anInteger
	| index s |
	index := 0.
	s := 0.
	[s < anInteger] whileTrue: [| ch len |
		index := index + 1.
		ch := aString at: index.
		len := self sizeOfCharacter: ch.
		s := s + len].
	^index
! !

!Unicode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
compareStringiW: aString1 with: aString2
	^UTF16 current compareStringiW: aString1 with: aString2
! !

!Unicode methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
decode: aByteArray
	^self decodeStringFrom: aByteArray readStream
! !

!Unicode methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
decodeFrom: aStream
	self subclassResponsibility
! !

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
decodeStringFrom: aStream
	^self
		decodeStringFrom: aStream
		length: aStream size // self minBytesPerChar
! !

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
decodeStringFrom: aStream length: anInteger
	| string |
	string := String new: anInteger.
	^self decodeStringFrom: aStream on: string
! !

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
decodeStringFrom: aStream on: buffer
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
! !

!Unicode methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
encode: aString
	^ByteArray
		streamContents: [:strm | aString do: [:ch | self encode: ch on: strm]]
! !

!Unicode methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
encode: aCharacter on: aStream
	self subclassResponsibility
! !

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
externalCopyOf: aString
	| bytes |
	aString isNil ifTrue: [^nil].
	bytes := self parameterFrom: aString.
	^bytes externalCopy
! !

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexesOf: aString from: start to: end
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
! !

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
isString: s1 greaterThan: s2
	^(self compareStringiW: s1 with: s2) > 0
! !

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
isString: s1 greaterThanOrEqualTo: s2
	^(self compareStringiW: s1 with: s2) >= 0
! !

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
isString: s1 lessThan: s2
	^(self compareStringiW: s1 with: s2) < 0
! !

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
isString: s1 lessThanOrEqualTo: s2
	^(self compareStringiW: s1 with: s2) <= 0
! !

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
lowercaseOf: aString
	^UTF16 current lowercaseOf: aString
! !

!Unicode methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
minBytesPerChar
	^1
! !

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeInBytesOf: aString
	| size |
	size := self sizeOfCharacter: Character null.
	1 to: aString size do: [:i | | ch s |
		ch := aString at: i.
		s := self sizeOfCharacter: ch.
		size := size + s].
	^size
! !

!Unicode methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
uppercaseOf: aString
	^UTF16 current uppercaseOf: aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Unicode class' category: #Kernel!
Unicode class
	instanceVariableNames: ''!

!Unicode class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
decode: aByteArray
	^self current decode: aByteArray
! !

!Unicode class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
decodeBytes: aByteArray
	| decoder stream |
	stream := aByteArray readStream.
	decoder := self decoderFor: stream.
	^decoder decode: stream upToEnd
! !

!Unicode class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
decodeFromAddress: externalAddress length: anInteger
	^self current
		decodeStringFrom: externalAddress readStream
		length: anInteger
! !

!Unicode class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
decoderFor: aStream
	(aStream peekForAll: UTF32 prefix) ifTrue: [^UTF32].
	(aStream peekForAll: UTF16 prefix) ifTrue: [^UTF16].
	^UTF8
! !


