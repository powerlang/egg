'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Date methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonOn: stonWriter
	stonWriter writeObject: self listSingleton: self yyyymmdd
! !

!Date class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: stonReader
	^self yyyymmdd: stonReader parseListSingleton
! !


