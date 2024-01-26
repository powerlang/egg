"
	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
"

Extension {#name : #'ByteArray class'}

{#category : '*STON'}
ByteArray class >> fromSton: stonReader [
	^self readHexFrom: stonReader parseListSingleton
]

{#category : '*STON'}
ByteArray class >> readHexFrom: aString [
	self ASSERT: aString size even.
	^(self new: aString size // 2) readHexFrom: aString readStream
]

{#category : '*STON'}
ByteArray >> readHexFrom: aStream [
	| map |
	map := '0123456789abcdef'.
	1 to: self size do: [:i | | hi lo |
		hi := map
			indexOf: aStream next asLowercase
			ifAbsent: [^self error: 'Hex digit expected'].
		hi := hi - 1 bitShift: 4.
		lo := map
			indexOf: aStream next asLowercase
			ifAbsent: [^self error: 'Hex digit expected'].
		self at: i put: hi + lo - 1]
]

{#category : '*STON'}
ByteArray >> stonOn: aSTONWriter [
	aSTONWriter writeObject: self listSingleton: self hexString
]

