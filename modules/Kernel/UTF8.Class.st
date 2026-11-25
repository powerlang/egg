'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #UTF8 category: #Kernel!
Unicode subclass: #UTF8
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!UTF8 commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!UTF8 methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
accepts: aByteArray
	| stream |
	stream := aByteArray readStream.
	[stream atEnd] whileFalse: [| s |
		s := self sizeOfEncoding: stream next.
		s = 0 ifTrue: [^false].
		s - 1 timesRepeat: [
			stream atEnd ifTrue: [^false].
			(stream next bitAnd: 0xC0) = 0x80 ifFalse: [^false]]].
	^true
! !

!UTF8 methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
decode: aByteArray
	aByteArray isExternalMemory
		ifTrue: [^self class decodeMemory: aByteArray length: aByteArray length].
	1
		to: aByteArray size
		do: [:i | (aByteArray at: i) asInteger > 127
			ifTrue: [^super decode: aByteArray]].
	^aByteArray asString
! !

!UTF8 methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
decodeFrom: aStream
	| b1 flags count bytes b2 b3 b4 |
	b1 := aStream nextByte.
	b1 < 128 ifTrue: [^b1].
	flags := b1 bitAnd: 16rF8.
	count := self trailing: flags.
	count isNil ifTrue: [^b1].
	bytes := aStream peek: count.
	bytes size < count ifTrue: [^b1].
	1
		to: count
		do: [:i | ((bytes byteAt: i) bitAnd: 16rC0) = 16r80 ifFalse: [^b1]].
	aStream skip: count.
	count = 1 ifTrue: [
		b2 := bytes byteAt: 1.
		b1 := b1 bitAnd: 16r1F.
		^(b1 bitShift: 6) + (b2 bitAnd: 16r3F)].
	count = 2 ifTrue: [
		b2 := (bytes byteAt: 1) bitAnd: 16r3F.
		b3 := (bytes byteAt: 2) bitAnd: 16r3F.
		b1 := b1 bitAnd: 16rF.
		^(b1 bitShift: 12) + (b2 bitShift: 6) + b3].
	b2 := (bytes byteAt: 1) bitAnd: 16r3F.
	b3 := (bytes byteAt: 2) bitAnd: 16r3F.
	b4 := (bytes byteAt: 3) bitAnd: 16r3F.
	b1 := b1 bitAnd: 7.
	^(b1 bitShift: 18) + (b2 bitShift: 12) + (b3 bitShift: 6) + b4
! !

!UTF8 methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
encode: aString
	aString class = String ifTrue: [
		1
			to: aString size
			do: [:i | (aString codeAt: i) < 128 ifFalse: [^super encode: aString]].
		^aString asByteArray].
	^super encode: aString
! !

!UTF8 methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
encode: aCharacter on: aStream
	| code b1 b2 b3 b4 |
	code := aCharacter codePoint.
	code < 128 ifTrue: [
		aStream nextBytePut: code.
		^self].
	code < 16r800 ifTrue: [
		b1 := code bitShift: -6.
		b1 := b1 bitOr: 16rC0.
		b2 := code bitAnd: 16r3F.
		b2 := b2 bitOr: 16r80.
		aStream nextBytePut: b1; nextBytePut: b2.
		^self].
	code < 16r10000 ifTrue: [
		b1 := code bitShift: -12.
		b1 := b1 bitOr: 16rE0.
		b2 := code bitShift: -6.
		b2 := b2 bitAnd: 16r3F.
		b2 := b2 bitOr: 16r80.
		b3 := code bitAnd: 16r3F.
		b3 := b3 bitOr: 16r80.
		aStream
			nextBytePut: b1;
			nextBytePut: b2;
			nextBytePut: b3.
		^self].
	b1 := code bitShift: -18.
	b1 := b1 bitOr: 16rF0.
	b2 := code bitShift: -12.
	b2 := b2 bitAnd: 16r3F.
	b2 := b2 bitOr: 16r80.
	b3 := code bitShift: -6.
	b3 := b3 bitAnd: 16r3F.
	b3 := b3 bitOr: 16r80.
	b4 := code bitAnd: 16r3F.
	b4 := b4 bitOr: 16r80.
	aStream
		nextBytePut: b1;
		nextBytePut: b2;
		nextBytePut: b3;
		nextBytePut: b4
! !

!UTF8 methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
encodeCharacter: aCharacter
	| code b1 b2 b3 b4 |
	code := aCharacter codePoint.
	code < 128 ifTrue: [^ByteArray with: code].
	code < 16r800 ifTrue: [
		b1 := code bitShift: -6.
		b1 := b1 bitOr: 16rC0.
		b2 := code bitAnd: 16r3F.
		b2 := b2 bitOr: 16r80.
		^ByteArray with: b1 with: b2].
	code < 16r10000 ifTrue: [
		b1 := code bitShift: -12.
		b1 := b1 bitOr: 16rE0.
		b2 := code bitShift: -6.
		b2 := b2 bitAnd: 16r3F.
		b2 := b2 bitOr: 16r80.
		b3 := code bitAnd: 16r3F.
		b3 := b3 bitOr: 16r80.
		^ByteArray with: b1 with: b2 with: b3].
	b1 := code bitShift: -18.
	b1 := b1 bitOr: 16rF0.
	b2 := code bitShift: -12.
	b2 := b2 bitAnd: 16r3F.
	b2 := b2 bitOr: 16r80.
	b3 := code bitShift: -6.
	b3 := b3 bitAnd: 16r3F.
	b3 := b3 bitOr: 16r80.
	b4 := code bitAnd: 16r3F.
	b4 := b4 bitOr: 16r80.
	^ByteArray with: b1 with: b2 with: b3 with: b4
! !

!UTF8 methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
parameterFrom: aString
	| strm |
	strm := (ByteArray new: aString size + 1) writeStream.
	aString isCharacter
		ifTrue: [self encode: aString on: strm]
		ifFalse: [aString do: [:char | self encode: char on: strm]].
	strm nextPut: 0.
	^strm contents
! !

!UTF8 methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeOfCharacter: aCharacter
	| code |
	code := aCharacter codePoint.
	code < 128 ifTrue: [^1].
	code < 16r800 ifTrue: [^2].
	code < 16r10000 ifTrue: [^3].
	^4
! !

!UTF8 methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeOfEncoding: code
	code < 0x80 ifTrue: [^1].
	code < 0xC0 ifTrue: [^0].
	code < 0xE0 ifTrue: [^2].
	code < 0xF0 ifTrue: [^3].
	code < 0xF8 ifTrue: [^4].
	^0
! !

!UTF8 methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
trailing: byte
	(byte bitAnd: 2r11100000) = 2r11000000 ifTrue: [^1].
	(byte bitAnd: 2r11110000) = 2r11100000 ifTrue: [^2].
	(byte bitAnd: 2r11111000) = 2r11110000 ifTrue: [^3].
	^nil
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'UTF8 class' category: #Kernel!
UTF8 class
	instanceVariableNames: ''!

!UTF8 class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
accepts: aByteArray
	^self current accepts: aByteArray
! !

!UTF8 class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
decodeMemory: anExternalMemory length: anInteger
	^Smalltalk os utf8ToWide: anExternalMemory length: anInteger
! !

!UTF8 class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
encodeMemory: anExternalMemory length: anInteger
	"
	UTF8 encodeMemory: '→' externalCopy length: 2
	"
	Smalltalk os wideToUtf8: anExternalMemory length: anInteger
! !

!UTF8 class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
prefix
	^#[16rEF 16rBB 16rBF]
! !


