'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!


!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
- aNumber
	<primitive: SMIMinus>
	aNumber _isSmallInteger ifTrue: [^self asLargeInteger - aNumber].
	^(aNumber - self) negated
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
!!= aNumber
	<primitive: SMINotEqual>
	^aNumber !!= self
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
* aNumber
	<primitive: SMITimes>
	aNumber _isSmallInteger ifTrue: [^self asLargeInteger * aNumber].
	^aNumber * self
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
// aNumber
	<primitive: SMIIntDiv>
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
\\ aNumber
	<primitive: SMIIntQuot>
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
+ aNumber
	<primitive: SMIPlus>
	aNumber _isSmallInteger ifTrue: [^self asLargeInteger + aNumber].
	^aNumber + self
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aNumber
	<primitive: SMIEqual>
	^aNumber = self
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
> aNumber
	<primitive: SMIGreaterThan>
	^aNumber < self
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
>= aNumber
	<primitive: SMIGreaterEqualThan>
	^aNumber <= self
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitAnd: anInteger
	| sum |
	<primitive: SMIBitAnd>
	anInteger isInteger ifFalse: [^anInteger bitAnd: self].
	(self < 0 and: [anInteger < 0]) ifTrue: [^anInteger bitAnd: self].
	sum := 0.
	WordSize to: 1 by: -1 do: [:i | | ai si |
		ai := anInteger at: i.
		si := self at: i.
		sum := (sum bitShift: 8) + (si bitAnd: ai)].
	^sum
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitOr: anInteger
	<primitive: SMIBitOr>
	^anInteger bitOr: self
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitXor: anInteger
	<primitive: SMIBitXor>
	^anInteger bitXor: self
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitShift: anInteger
	<primitive: SMIBitShift>
	anInteger = 0 ifTrue: [^self].
	^anInteger > 0
		ifTrue: [self bitShiftLeft: anInteger]
		ifFalse: [self bitShiftRight: 0 - anInteger]
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
highBit
	<primitive: SMIHighBit>
! !

!SmallInteger methodsFor:  '*Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeInBytes
	<primitive: SMISize>
! !


