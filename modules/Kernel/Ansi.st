"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Ansi,
	#superclass : #Unicode,
	#category : #Kernel
}

{ #category : #services }
Ansi class >> isAnsi: anInteger [
	anInteger < 128 ifTrue: [^true].
	255 < anInteger ifTrue: [^false].
	^159 < anInteger
]

{ #category : #'encoding / decoding' }
Ansi >> decodeFrom: aStream [
	^self decodeInteger: aStream nextByte
]

{ #category : #'encoding / decoding' }
Ansi >> decodeInteger: anInteger [
	| code |
	anInteger < 128 ifTrue: [^anInteger].
	159 < anInteger ifTrue: [^anInteger].
	code := Character ansiTable at: anInteger - 127.
	^code = 0 ifTrue: [anInteger] ifFalse: [code]
]

{ #category : #'encoding / decoding' }
Ansi >> encode: aCharacter on: aStream [
	| value index |
	value := aCharacter asInteger.
	((value between: 128 and: 159) or: [255 < value]) ifTrue: [
		index := Character ansiTable indexOf: value.
		value := index = 0 ifTrue: [$? asInteger] ifFalse: [index + 127]].
	aStream nextPut: value
]

{ #category : #'encoding / decoding' }
Ansi >> encodeInteger: anInteger [
	| index |
	anInteger < 256 ifTrue: [^anInteger].
	index := Character ansiTable indexOf: anInteger.
	^index = 0 ifTrue: [$? asInteger] ifFalse: [index + 127]
]

{ #category : #services }
Ansi >> parameterFrom: aString [
	| n param |
	n := aString size.
	param := ByteArray new: n + 1.
	1 to: n do: [:i | | cp byte |
		cp := aString codeAt: i.
		byte := self encodeInteger: cp.
		param at: i put: byte].
	param at: n + 1 put: 0.
	^param
]

{ #category : #private }
Ansi >> reduce: aString [
	| bytes |
	bytes := self encode: aString.
	^String fromBytes: bytes
]

{ #category : #services }
Ansi >> sizeOfCharacter: aCharacter [
	^1
]

