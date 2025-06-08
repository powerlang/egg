"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Extension { #name : #Float }

{ #category : #'instance creation' }
Float class >> fromInteger: anInteger [
	<primitive: FloatNewFromInteger>
]

{ #category : '*Primitives' }
Float class >> new [
	<primitive: FloatNew>
]

{ #category : '*Primitives' }
Float class >> status [
	" Returns the processor's float status register of the last primitive operation "
	<primitive: FloatStatus>
]

{ #category : #arithmetic }
Float >> - aNumber [
	<primitive: FloatMinus>
	^aNumber isFloat
		ifTrue: [self errorOn: #'-']
		ifFalse: [self - aNumber asFloat]
]

{ #category : #arithmetic }
Float >> * aNumber [
	<primitive: FloatMultiply>
	^aNumber isFloat
		ifTrue: [self errorOn: #'*']
		ifFalse: [self * aNumber asFloat]

]

{ #category : #arithmetic }
Float >> / aNumber [
	<primitive: FloatDiv>
	^aNumber isFloat
		ifTrue: [self errorOn: #'/']
		ifFalse: [self / aNumber asFloat]
]

{ #category : #arithmetic }
Float >> + aNumber [
	<primitive: FloatPlus>
	^aNumber isFloat
		ifTrue: [ self errorOn: #'+']
		ifFalse: [aNumber addTo: self]
]

{ #category : #comparing }
Float >> < aNumber [
	<primitive: FloatLess>
	^aNumber isFloat
		ifTrue: [self errorOn: #'<']
		ifFalse: [self < aNumber asFloat]
]

{ #category : #comparing }
Float >> = aNumber [
	| nan status |
	<primitive: FloatEqual>
	status := Float status.
	^aNumber isFloat
		ifTrue: [
			nan := self isNaN.
			(nan and: [aNumber isNaN]) ifTrue: [^true].
			(nan or: [aNumber isNaN]) ifTrue: [^false].
			self errorOn: #'=' status: status]
		ifFalse: [aNumber isNumber
			ifTrue: [self = aNumber asFloat]
			ifFalse: [false]]
]

{ #category : #testing }
Float >> at: index [
	<primitive: At>
	^self primitiveFailed
]

{ #category : #testing }
Float >> basicAt: index [
	<primitive: At>
	^self primitiveFailed
]

{ #category : #errors }
Float >> errorOn: aSymbol [
	^self errorOn: aSymbol status: Float status
]

{ #category : #random }
Float >> fractionPart [
	<primitive: FloatFractionPart>
	self errorOn: #fractionPart
]

{ #category : #random }
Float >> initializeWith: bytes [
	self replaceBytesFrom: 1 to: 8 with: bytes startingAt: 1
]

{ #category : #accessing }
Float >> significand [
	<primitive: FloatSignificand>
	^self errorOn: #significand
]

{ #category : #functions }
Float >> sqrt [
	<primitive: FloatSqrt>
	^self errorOn: #sqrt status: status
]

{ #category : #arithmetic }
Float >> timesTwoPower: anInteger [
	<primitive: FloatTimesTwoPower>
	^self errorOn: #timesTwoPower status: 0
]

{ #category : #arithmetic }
Float >> truncated [
	<primitive: FloatTruncated>
	^self errorOn: #truncated status: 0
]