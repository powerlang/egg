"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #SmallInteger }

{ #category : '*Primitives' }
SmallInteger >> + aNumber [
	<primitive: #SMIPlus>
]

{ #category : '*Primitives' }
SmallInteger >> - aNumber [
	<primitive: #SMIMinus>
]

{ #category : '*Primitives' }
SmallInteger >> * aNumber [
	<primitive: #SMITimes>
]

{ #category : '*Primitives' }
SmallInteger >> // aNumber [
	<primitive: #SMIIntDiv>
]

{ #category : '*Primitives' }
SmallInteger >> \\ aNumber [
	<primitive: #SMIIntQuot>
]

{ #category : '*Primitives' }
SmallInteger >> bitAnd: anInteger [
	<primitive: #SMIBitAnd>
]

{ #category : '*Primitives' }
SmallInteger >> bitOr: anInteger [
	<primitive: #SMIBitOr>
]

{ #category : '*Primitives' }
SmallInteger >> bitXor: anInteger [
	<primitive: #SMIBitXor>
]

{ #category : '*Primitives' }
SmallInteger >> bitShift: anInteger [
	<primitive: #SMIBitShift>
]

{ #category : '*Primitives' }
SmallInteger >> highBit [
	<primitive: #SMIHighBit>
]

{ #category : '*Primitives' }
SmallInteger >> > aNumber [
	<primitive: #SMIGreaterThan>
]

{ #category : '*Primitives' }
SmallInteger >> >= aNumber [
	<primitive: #SMIGreaterEqualThan>
]

{ #category : '*Primitives' }
SmallInteger >> = aNumber [
	<primitive: #SMIEqual>
]

{ #category : '*Primitives' }
SmallInteger >> sizeInBytes [
	<primitive: #SMISize>
]

