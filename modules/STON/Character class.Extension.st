'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Character methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonOn: aSTONWriter
	aSTONWriter writeObject: self listSingleton: self asString
! !

!Character class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: stonReader
	^ stonReader parseListSingleton first
! !


