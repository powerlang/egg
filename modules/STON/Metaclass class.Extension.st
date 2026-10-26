'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Metaclass class methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSton: stonReader
	| class |
	class := Smalltalk at: stonReader parseListSingleton.
	^class class
! !

!Metaclass methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonName
	^#Class
! !

!Metaclass methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
stonOn: aSTONWriter
	aSTONWriter writeObject: self listSingleton: self instanceClass symbol
! !


