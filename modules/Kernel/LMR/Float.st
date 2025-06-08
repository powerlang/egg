"
	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #LMRFloat,
	#superclass : #Float,
	#category : #Kernel
}


{ #category : #'instance creation' }
LMRFloat class >> fromInteger: anInteger [
	| result |
	result := Float new.
	anInteger _isSmallInteger ifTrue: [
		anInteger _asFloatInto: result.
		^result].
	anInteger isInteger
		ifTrue: [^(self fromInteger: (anInteger bitShift: -24)) * 16r1000000 asFloat
			+ (self fromInteger: (anInteger bitAnd: 16rFFFFFF))]
		ifFalse: [self error: 'number is not an integer']
]

{ #category : #errors }
LMRFloat class >> initialControlAndStatusFlags [
	"
	FIXME: ONLY X64 SUPPORTED FOR NOW
	We initialize MXCSR with all sticky bits clean (0-5), all exceptions masked (7-12),
	and denormal arguments of operations treated as zero (bit 6).
	We don't flush denormal results to zero (bit 15), but should think about it.
	"
	^0x1FC0
]

{ #category : #initialization }
LMRFloat class >> initializeStatus [
	"
	this has to be done fairly early at startup, before
	doing any float operation, because float operations
	try to use this value, which must be already initialized
	to what the OS put in MXCSR (or equivalent) register
	"
	Status isNil ifTrue: [Status := ByteArray new: 4].
	Status uLongAtOffset: 0 put: self status
]

{ #category : #'*instance creation' }
LMRFloat class >> new [
	^self memory newArrayedBytes: instanceBehavior size: 8.
]

{ #category : #arithmetic }
LMRFloat >> - aNumber [
	| new result |
	aNumber isFloat ifFalse: [^self - aNumber asFloat].
	new := Float new.
	result := self _floatMinus: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'-' status: result
]

{ #category : #arithmetic }
LMRFloat >> * aNumber [
	| new result |
	aNumber isFloat ifFalse: [^self * aNumber asFloat].
	new := Float new.
	result := self _floatMultiply: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'*' status: result
]

{ #category : #arithmetic }
LMRFloat >> / aNumber [
	| new result |
	aNumber isFloat ifFalse: [^self / aNumber asFloat].
	new := Float new.
	result := self _floatQuotient: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'/' status: result
]

{ #category : #arithmetic }
LMRFloat >> + aNumber [
	| new result |
	aNumber isFloat ifFalse: [^aNumber addTo: self].
	new := Float new.
	result := self _floatPlus: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'+' status: result
]

{ #category : #comparing }
LMRFloat >> < aNumber [
	| result |
	aNumber isFloat ifFalse: [^self < aNumber asFloat].
	result := self _floatLessThan: aNumber.
	result _isSmallInteger ifFalse: [^result].
	^self errorOn: #'<' status: result
]

{ #category : #comparing }
LMRFloat >> = aNumber [
	| result nan equal |
	aNumber isFloat
		ifFalse: [^aNumber isNumber
			ifTrue: [self = aNumber asFloat]
			ifFalse: [false]].
	result := self _floatEquals: aNumber.
	result _isSmallInteger ifFalse: [^result].
	nan := self isNaN.
	equal := nan == aNumber isNaN.
	equal ifFalse: [^false].
	nan ifTrue: [^true].
	^self errorOn: #'=' status: result
]

{ #category : #testing }
LMRFloat >> at: index [
	^self basicByteAt: index
]

{ #category : #testing }
LMRFloat >> basicAt: index [
	^self basicByteAt: index
]

{ #category : #random }
LMRFloat >> fractionPart [
	| new result |>
	new := Float new.
	result := self _floatFractionPartInto: new.
	result == new ifTrue: [^result].
	^self errorOn: #fractionPart status: result
]

{ #category : #random }
Float >> initializeWith: bytes [
	bytes _primitiveULargeAtOffset: 0 into: self
]

{ #category : #accessing }
LMRFloat >> significand [
	| result new |
	new := Float new.
	result := self _floatSignificandInto: new.
	result == new ifTrue: [^result].
	^self errorOn: #significand status: result
]

{ #category : #functions }
LMRFloat >> sqrt [
	| sqrt result |
	sqrt := Float new.
	result := self _floatSqrtInto: sqrt.
	"_floatSqrtInto returns error status in result if any, else the result itself"
	result == sqrt ifTrue: [^result].
	^self errorOn: #sqrt status: result
]

{ #category : #arithmetic }
LMRFloat >> timesTwoPower: anInteger [
	| result status |
	result := self copy.
	status := result _timesTwoPower: anInteger asFloat.
	(Float hasErrorFlag: status) ifFalse: [^result].
	self errorOn: #timesTwoPower status: status
]

{ #category : #arithmetic }
LMRFloat >> truncated [
	| result |
	result := self _floatTruncated.
	(result notNil and: [result = 0 or: [result sign = self sign]])
		ifTrue: [^result].
	self isSpecialValue ifTrue: [^self].
	^self abs < 2.0e16
		ifTrue: [| q r |
			q := self quo: 536870912.0.
			"((SmallInteger largestPositive bitShift: -1) + 1) asFloat"
			r := self - (q asFloat * 536870912.0).
			q * 536870912 + r truncated]
		ifFalse: [self asTrueFraction]
]

