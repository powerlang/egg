"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #SmallInteger }

{ #category : '*Primitives' }
SmallInteger >> - aNumber [
	<primitive: SMIMinus>
	^(aNumber - self) negated
]

{ #category : '*Primitives' }
SmallInteger >> != aNumber [
	<primitive: SMINotEqual>
	^aNumber != self
]

{ #category : '*Primitives' }
SmallInteger >> * aNumber [
	<primitive: SMITimes>
	^aNumber * self
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
	<primitive: SMIBitAnd>
]

{ #category : '*Primitives' }
SmallInteger >> bitOr: anInteger [
	<primitive: SMIBitOr>
]

{ #category : '*Primitives' }
SmallInteger >> bitXor: anInteger [
	<primitive: SMIBitXor>
]

{ #category : '*Primitives' }
SmallInteger >> bitShift: anInteger [
	<primitive: SMIBitShift>
]

{ #category : '*Primitives' }
SmallInteger >> highBit [
	<primitive: SMIHighBit>
]

{ #category : '*Primitives' }
SmallInteger >> sizeInBytes [
	<primitive: SMISize>
]

