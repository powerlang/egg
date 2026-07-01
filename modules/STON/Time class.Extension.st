'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Time methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonOn: aSTONWriter
	aSTONWriter writeObject: self listSingleton: self hhmmssms
! !

!Time class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: stonReader
	^self readFromIso8601: stonReader parseListSingleton readStream
! !

!Time class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
readFromIso8601: aStream
	| hhmmss time ms sign hh mm offset ts |
	hhmmss := aStream next: 'hh:mm:ss' size.
	time := Time hhmmss: hhmmss.
	ms := (aStream peekFor: $.)
		ifTrue: [| f |
			f := aStream upToAny: #($+ $-).
			aStream skip: -1.
			(('0.' , f) asNumber * 1000.0) rounded]
		ifFalse: [0].
	time := Time
		hours: time hours
		minutes: time minutes
		seconds: time seconds
		milliseconds: time milliseconds + ms.
	offset := (aStream peekFor: $Z) ifTrue: [0] ifFalse: [
		('+-' includes: aStream peek)
			ifTrue: [
				sign := aStream next = $+ ifTrue: [1] ifFalse: [-1].
				hh := aStream upTo: $:.
				mm := aStream upToEnd.
				hh asInteger * 60 + mm asInteger * sign]
			ifFalse: [Timestamp localOffsetFor: Date today]].
	ts := Timestamp date: Date today time: time.
	ts offset: offset.
	^ts time
! !


