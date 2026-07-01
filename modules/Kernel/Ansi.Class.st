'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Ansi category: #Kernel!
Unicode subclass: #Ansi
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Ansi commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Ansi methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
decodeFrom: aStream
	^self decodeInteger: aStream nextByte
! !

!Ansi methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
decodeInteger: anInteger
	| code |
	anInteger < 128 ifTrue: [^anInteger].
	159 < anInteger ifTrue: [^anInteger].
	code := Character ansiTable at: anInteger - 127.
	^code = 0 ifTrue: [anInteger] ifFalse: [code]
! !

!Ansi methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
encode: aCharacter on: aStream
	| value index |
	value := aCharacter asInteger.
	((value between: 128 and: 159) or: [255 < value]) ifTrue: [
		index := Character ansiTable indexOf: value.
		value := index = 0 ifTrue: [$? asInteger] ifFalse: [index + 127]].
	aStream nextPut: value
! !

!Ansi methodsFor:  'encoding / decoding' stamp: 'KenD 28/Jun/2026 13:27:38'!
encodeInteger: anInteger
	| index |
	anInteger < 256 ifTrue: [^anInteger].
	index := Character ansiTable indexOf: anInteger.
	^index = 0 ifTrue: [$? asInteger] ifFalse: [index + 127]
! !

!Ansi methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
parameterFrom: aString
	| n param |
	n := aString size.
	param := ByteArray new: n + 1.
	1 to: n do: [:i | | cp byte |
		cp := aString codeAt: i.
		byte := self encodeInteger: cp.
		param at: i put: byte].
	param at: n + 1 put: 0.
	^param
! !

!Ansi methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
reduce: aString
	| bytes |
	bytes := self encode: aString.
	^String fromBytes: bytes
! !

!Ansi methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeOfCharacter: aCharacter
	^1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ansi class' category: #Kernel!
Ansi class
	instanceVariableNames: ''!

!Ansi class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
isAnsi: anInteger
	anInteger < 128 ifTrue: [^true].
	255 < anInteger ifTrue: [^false].
	^159 < anInteger
! !


