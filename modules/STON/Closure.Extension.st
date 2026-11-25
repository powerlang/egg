'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!


!Closure methodsFor:  '*STON' stamp: 'KenD 28/Jun/2026 13:27:39'!
cull: a cull: b
	^self argumentCount < 2
		ifTrue: [self cull: a]
		ifFalse: [self value: a value: b]
! !


