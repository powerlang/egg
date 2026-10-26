'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #LMRFloat category: #Kernel!
Float subclass: #LMRFloat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!LMRFloat commentStamp: '<historical>' prior: 0!

	Copyright (c) 2022, Javier Pimás.
	See (MIT) license in root directory.
!

!LMRFloat methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
- aNumber
	| new result |
	aNumber isFloat ifFalse: [^self - aNumber asFloat].
	new := Float new.
	result := self _floatMinus: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'-' status: result
! !

!LMRFloat methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
* aNumber
	| new result |
	aNumber isFloat ifFalse: [^self * aNumber asFloat].
	new := Float new.
	result := self _floatMultiply: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'*' status: result
! !

!LMRFloat methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
/ aNumber
	| new result |
	aNumber isFloat ifFalse: [^self / aNumber asFloat].
	new := Float new.
	result := self _floatQuotient: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'/' status: result
! !

!LMRFloat methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
+ aNumber
	| new result |
	aNumber isFloat ifFalse: [^aNumber addTo: self].
	new := Float new.
	result := self _floatPlus: aNumber into: new.
	result == new ifTrue: [^result].
	^self errorOn: #'+' status: result
! !

!LMRFloat methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
< aNumber
	| result |
	aNumber isFloat ifFalse: [^self < aNumber asFloat].
	result := self _floatLessThan: aNumber.
	result _isSmallInteger ifFalse: [^result].
	^self errorOn: #'<' status: result
! !

!LMRFloat methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aNumber
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
! !

!LMRFloat methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index
	^self basicByteAt: index
! !

!LMRFloat methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: index
	^self basicByteAt: index
! !

!LMRFloat methodsFor:  'random' stamp: 'KenD 28/Jun/2026 13:27:38'!
fractionPart
	| new result |
	new := Float new.
	result := self _floatFractionPartInto: new.
	result == new ifTrue: [^result].
	^self errorOn: #fractionPart status: result
! !

!Float methodsFor:  'random' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeWith: bytes
	bytes _primitiveULargeAtOffset: 0 into: self
! !

!LMRFloat methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
significand
	| result new |
	new := Float new.
	result := self _floatSignificandInto: new.
	result == new ifTrue: [^result].
	^self errorOn: #significand status: result
! !

!LMRFloat methodsFor:  'functions' stamp: 'KenD 28/Jun/2026 13:27:38'!
sqrt
	| sqrt result |
	sqrt := Float new.
	result := self _floatSqrtInto: sqrt.
	"_floatSqrtInto returns error status in result if any, else the result itself"
	result == sqrt ifTrue: [^result].
	^self errorOn: #sqrt status: result
! !

!LMRFloat methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
timesTwoPower: anInteger
	| result status |
	result := self copy.
	status := result _timesTwoPower: anInteger asFloat.
	(Float hasErrorFlag: status) ifFalse: [^result].
	self errorOn: #timesTwoPower status: status
! !

!LMRFloat methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncated
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
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LMRFloat class' category: #Kernel!
LMRFloat class
	instanceVariableNames: ''!

!LMRFloat class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromInteger: anInteger
	| result |
	result := Float new.
	anInteger _isSmallInteger ifTrue: [
		anInteger _asFloatInto: result.
		^result].
	anInteger isInteger
		ifTrue: [^(self fromInteger: (anInteger bitShift: -24)) * 16r1000000 asFloat
			+ (self fromInteger: (anInteger bitAnd: 16rFFFFFF))]
		ifFalse: [self error: 'number is not an integer']
! !

!LMRFloat class methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialControlAndStatusFlags
	"
	FIXME: ONLY X64 SUPPORTED FOR NOW
	We initialize MXCSR with all sticky bits clean (0-5), all exceptions masked (7-12),
	and denormal arguments of operations treated as zero (bit 6).
	We don't flush denormal results to zero (bit 15), but should think about it.
	"
	^0x1FC0
! !

!LMRFloat class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeStatus
	"
	this has to be done fairly early at startup, before
	doing any float operation, because float operations
	try to use this value, which must be already initialized
	to what the OS put in MXCSR (or equivalent) register
	"
	Status isNil ifTrue: [Status := ByteArray new: 4].
	Status uLongAtOffset: 0 put: self status
! !

!LMRFloat class methodsFor:  '*instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self memory newArrayedBytes: instanceBehavior size: 8.
! !


