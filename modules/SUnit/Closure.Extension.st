'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!


!Closure methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
sunitEnsure: terminationBlock
	^self ensure: terminationBlock
! !

!Closure methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
sunitOn: exception do: handlerBlock
	^self on: exception do: handlerBlock
! !

!Closure methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
sunitOn: exception1 do: handlerBlock1 on: exception2 do: handlerBlock2
	^self sunitOn: exception1 , exception2 do: [:ex | 
		(ex isKindOf: exception1)
			ifTrue: [handlerBlock1 evaluateWith: ex]
			ifFalse: [handlerBlock2 evaluateWith: ex]]
! !

!Closure methodsFor:  '*SUnit' stamp: 'KenD 28/Jun/2026 13:27:37'!
sunitOn: exception1 do: handlerBlock1 on: exception2 do: handlerBlock2 on: exception3 do: handlerBlock3
	^self sunitOn: exception1 , exception2 , exception3 do: [:exception | 
		(exception isKindOf: exception1)
			ifTrue: [handlerBlock1 evaluateWith: exception]
			ifFalse: [
				(exception isKindOf: exception2)
					ifTrue: [handlerBlock2 evaluateWith: exception]
					ifFalse: [handlerBlock3 evaluateWith: exception]]]
! !


