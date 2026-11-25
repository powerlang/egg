'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!


!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
fromMemory: anExternalMemory
	| length |
	length := 1.
	[(anExternalMemory at: length) = 0] whileFalse: [length := length + 1].
	^self fromMemory: anExternalMemory length: length - 1
! !

!String class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:37'!
fromMemory: anExternalMemory length: anInteger
	| string |
	string := self new: anInteger.
	string replaceFrom: 1 to: anInteger with: anExternalMemory startingAt: 1.
	^string
! !


