'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Timestamp methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonOn: aSTONWriter
	aSTONWriter writeObject: self listSingleton: self iso8601
! !

!Timestamp class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: stonReader
	^self readFromIso8601: stonReader parseListSingleton readStream
! !

!Timestamp class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
year: yyyy month: m day: dd hour: hh minute: mm second: ss offset: h
	^self
		newDay: dd
		month: m
		year: yyyy
		hours: hh
		minutes: mm
		seconds: ss
		milliseconds: 0
		offset: h * 60
! !


