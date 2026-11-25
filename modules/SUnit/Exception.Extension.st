'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!


!Exception methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasNextHandler
	| next |
	next := self nextHandler.
	^next notNil andNot: [next isSUnitHandler]
! !

!Exception methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
sunitExitWith: aValue
	self return: aValue
! !

!Exception class methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
sunitSignalWith: aString
	self signal: aString
! !


