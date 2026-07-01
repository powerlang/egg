'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Interval methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: aSTONReader
	aSTONReader parseNamedInstVarsFor: self
! !

!Interval methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonOn: aSTONWriter
	aSTONWriter writeObject: self
! !

!Interval class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: stonReader
	^self new fromSton: stonReader; yourself
! !


