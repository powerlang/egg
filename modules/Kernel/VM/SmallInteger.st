"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #SmallInteger }

{ #category : '*Primitives' }
SmallInteger >> - aNumber [
	<primitive: SMIMinus>
	aNumber _isSmallInteger ifTrue: [^self asLargeInteger - aNumber].
	^(aNumber - self) negated
]

{ #category : '*Primitives' }
SmallInteger >> != aNumber [
	<primitive: SMINotEqual>
	^aNumber != self
]

{ #category : '*Primitives' }
SmallInteger >> * aNumber [
	| mult |
	<primitive: SMITimes>
	aNumber _isSmallInteger ifFalse: [^aNumber * self].
	mult := self abs asLargeInteger mult: aNumber abs.
	^self positive = aNumber positive ifTrue: [mult] ifFalse: [mult negated]
]

{ #category : '*Primitives' }
SmallInteger >> // aNumber [
	<primitive: SMIIntDiv>
]

{ #category : '*Primitives' }
SmallInteger >> \\ aNumber [
	<primitive: SMIIntQuot>
]

{ #category : '*Primitives' }
SmallInteger >> + aNumber [
	<primitive: SMIPlus>
	aNumber _isSmallInteger ifTrue: [^self asLargeInteger + aNumber].
	^aNumber + self
]

{ #category : '*Primitives' }
SmallInteger >> = aNumber [
	<primitive: SMIEqual>
	^aNumber = self
]

{ #category : '*Primitives' }
SmallInteger >> > aNumber [
	<primitive: SMIGreaterThan>
	^aNumber < self
]

{ #category : '*Primitives' }
SmallInteger >> >= aNumber [
	<primitive: SMIGreaterEqualThan>
	^aNumber <= self
]

{ #category : '*Primitives' }
SmallInteger >> bitAnd: anInteger [
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
]

{ #category : '*Primitives' }
SmallInteger >> bitOr: anInteger [
	<primitive: SMIBitOr>
	^anInteger bitOr: self
]

{ #category : '*Primitives' }
SmallInteger >> bitXor: anInteger [
	<primitive: SMIBitXor>
	^anInteger bitXor: self
]

{ #category : '*Primitives' }
SmallInteger >> bitShift: anInteger [
	<primitive: SMIBitShift>
	anInteger = 0 ifTrue: [^self].
	^anInteger > 0
		ifTrue: [self bitShiftLeft: anInteger]
		ifFalse: [self bitShiftRight: 0 - anInteger]
]

{ #category : '*Primitives' }
SmallInteger >> highBit [
	<primitive: SMIHighBit>
]

{ #category : '*Primitives' }
SmallInteger >> sizeInBytes [
	<primitive: SMISize>
]

