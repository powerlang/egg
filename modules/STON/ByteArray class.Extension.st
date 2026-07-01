'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!ByteArray methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
readHexFrom: aStream
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
! !

!ByteArray methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonOn: aSTONWriter
	aSTONWriter writeObject: self listSingleton: self hexString
! !

!ByteArray class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: stonReader
	^self readHexFrom: stonReader parseListSingleton
! !

!ByteArray class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
readHexFrom: aString
	self ASSERT: aString size even.
	^(self new: aString size // 2) readHexFrom: aString readStream
! !


