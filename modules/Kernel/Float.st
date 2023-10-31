"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Float,
	#superclass : #Number,
	#type : #bytes,
	#classVars : [
		'E',
		'Infinity',
		'MinusInfinity',
		'Pi',
		'RadiansPerDegree',
		'Status'
	],
	#category : #Kernel
}

{ #category : #private }
Float class >> basicErrorOn: aSymbol status: status for: aNumber [
	self error: 'Float error ' , aSymbol
]

{ #category : #errors }
Float class >> clearStatusFlags [
	Status at: 1 put: ((Status at: 1) bitAnd: 0xC0).
	self _status: Status
]

{ #category : #constants }
Float class >> e [
	"
	Float e
	"
	^E
]

{ #category : #errors }
Float class >> errorOn: aSymbol status: status for: aNumber [
	| error |
	(self hasZeroDivisorFlag: status)
		ifTrue: [^ZeroDivide new dividend: aNumber; operation: aSymbol; signal].
	error := ArithmeticError on: aSymbol.
	(self hasOverflowFlag: status) ifTrue: [^error signalOverflow].
	(self hasUnderflowFlag: status) ifTrue: [^error signalUnderflow].
	(self hasDenormalizedOperandFlag: status) ifTrue: [^error signalDenormalized].
	(self hasInvalidOperationFlag: status)
		ifTrue: [^error signalInvalidOperation].
	(self hasCoprocessorMissingFlag: status)
		ifTrue: [^error signalCoprocessorMissing].
	(self hasInexactFlag: status) ifTrue: [^error signalInexactOperation].
	^error signalUndefined
]

{ #category : #'instance creation' }
Float class >> from: aNumber [
	^aNumber asFloat
]

{ #category : #'instance creation' }
Float class >> fromByteArray: aByteArray [
	| float size |
	float := self new.
	size := float size.
	float
		replaceBytesFrom: 1
		to: size
		with: aByteArray
		startingAt: 1.
	^float
]

{ #category : #'instance creation' }
Float class >> fromInteger: anInteger [
	| result |
	result := Float new.
	anInteger _isSmallInteger ifTrue: [
		Float clearStatusFlags.
		anInteger _asNative _asFloatInto: result.
		^result].
	anInteger isInteger
		ifTrue: [^(self fromInteger: (anInteger bitShift: -24)) * 16r1000000 asFloat
			+ (self fromInteger: (anInteger bitAnd: 16rFFFFFF))]
		ifFalse: [self error: 'number is not an integer']
]

{ #category : #'instance creation' }
Float class >> fromLocalString: aString [
	| thous dec string currency sign float |
	aString isEmpty ifTrue: [^0.0].
	thous := ActiveLocale thousandsSeparator.
	dec := ActiveLocale decimalSeparator.
	string := thous = dec
		ifTrue: [aString]
		ifFalse: [aString reject: [:c | thous includes: c]].
	currency := ActiveLocale currency first.
	string := string reject: [:c | c = currency].
	string isEmpty ifTrue: [^0.0].
	sign := 1.0.
	(string first = $( and: [string last = $)]) ifTrue: [
		string := string copyFrom: 2 to: string size - 1.
		sign := -1.0].
	float := self fromString: string decimalSeparator: dec.
	^float * sign
]

{ #category : #'instance creation' }
Float class >> fromString: aString decimalSeparator: anotherString [
	^(super fromString: aString decimalSeparator: anotherString) asFloat
]

{ #category : #testing }
Float class >> hasCoprocessorMissingFlag [
	^self hasCoprocessorMissingFlag: self status
]

{ #category : #testing }
Float class >> hasCoprocessorMissingFlag: status [
	^(status bitAnd: 128) ~= 0
]

{ #category : #testing }
Float class >> hasDenormalizedOperandFlag [
	^self hasDenormalizedOperandFlag: self status
]

{ #category : #testing }
Float class >> hasDenormalizedOperandFlag: status [
	^(status bitAnd: 2) != 0
]

{ #category : #testing }
Float class >> hasErrorFlag: status [
	^(status bitAnd: 0x1F) ~= 0
]

{ #category : #testing }
Float class >> hasFixedSize [
	^self hasVariableSize not
]

{ #category : #testing }
Float class >> hasInexactFlag [
	^self hasInexactFlag: self status
]

{ #category : #testing }
Float class >> hasInexactFlag: status [
	^(status bitAnd: 32) ~= 0
]

{ #category : #testing }
Float class >> hasInvalidOperationFlag [
	^self hasInvalidOperationFlag: self status
]

{ #category : #testing }
Float class >> hasInvalidOperationFlag: status [
	^(status bitAnd: 1) ~= 0
]

{ #category : #testing }
Float class >> hasOverflowFlag [
	^self hasOverflowFlag: self status
]

{ #category : #testing }
Float class >> hasOverflowFlag: status [
	^(status bitAnd: 8) ~= 0
]

{ #category : #testing }
Float class >> hasUnderflowFlag [
	^self hasUnderflowFlag: self status
]

{ #category : #testing }
Float class >> hasUnderflowFlag: status [
	^(status bitAnd: 16) ~= 0
]

{ #category : #testing }
Float class >> hasVariableSize [
	^false
]

{ #category : #testing }
Float class >> hasZeroDivisorFlag [
	^self hasZeroDivisorFlag: self status
]

{ #category : #testing }
Float class >> hasZeroDivisorFlag: status [
	^(status bitAnd: 4) ~= 0
]

{ #category : #constants }
Float class >> infinity [
	"
	Float infinity
	"
	^Infinity
]

{ #category : #initialization }
Float class >> initializeConstants [
	"
	Float initializeConstants
	"
	self
		initializeInfinity;
		initializeMinusInfinity;
		initializePi;
		initializeE
]

{ #category : #initialization }
Float class >> initializeE [
	E := self fromByteArray: #[105 87 20 139 10 191 5 64]
]

{ #category : #initialization }
Float class >> initializeInfinity [
	Infinity := self fromByteArray: #[00 00 00 00 00 00 0xF0 0x7F]
]

{ #category : #initialization }
Float class >> initializeMinusInfinity [
	MinusInfinity := self fromByteArray: #[00 00 00 00 00 00 0xF0 0xFF]
]

{ #category : #initialization }
Float class >> initializePi [
	Pi := 3.14159265358979323846264338327950288
]

{ #category : #initialization }
Float class >> initializeRadiansPerDegree [
	RadiansPerDegree := Pi / 180.0
]

{ #category : #initialization }
Float class >> initializeStatus [
	Status isNil ifTrue: [Status := ByteArray new: 4].
	self _readStatusOn: Status
]

{ #category : #constants }
Float class >> maxExponent [
	^309
]

{ #category : #constants }
Float class >> maxForExp [
	self disableCode: [^(10.0 raisedTo: Float maxExponent - 1) ln].
	^self fromByteArray: #[16r5E 16r2A 16rD6 16rD5 16r91 16r29 16r86 16r40]
]

{ #category : #constants }
Float class >> maxNegativeValue [
	"
	Float maxNegativeValue
	"
	^self fromByteArray: #[0 0 0 0 0 0 16 128]
]

{ #category : #constants }
Float class >> maxValue [
	"
	Float maxValue
	"
	^self fromByteArray: #[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rEF 16r7F]
]

{ #category : #constants }
Float class >> minPositiveValue [
	"
	Float minPositiveValue / 2
	"
	^self fromByteArray: #[0 0 0 0 0 0 16 0]
]

{ #category : #constants }
Float class >> minusInfinity [
	"
	Float minusInfinity
	"
	^MinusInfinity
]

{ #category : #constants }
Float class >> minValue [
	"
	Float minValue
	"
	^self fromByteArray: #[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rEF 16rFF]
]

{ #category : #constants }
Float class >> multiplicativeIdentity [
	^1.0
]

{ #category : #constants }
Float class >> nan [
	"
	Float nan
	"
	^self new
		at: 7 put: 248;
		at: 8 put: 127;
		yourself
]

{ #category : #'instance creation' }
Float class >> new [
	^self errorVMSpecific
]

{ #category : #constants }
Float class >> pi [
	"
	Number pi
	"
	^Pi
]

{ #category : #constants }
Float class >> plusInfinity [
	"
	Float plusInfinity
	"
	^Infinity
]

{ #category : #accessing }
Float class >> sizeInBytes [
	^8
]

{ #category : #accessing }
Float class >> startUp [
	self initializeRadiansPerDegree
]

{ #category : #accessing }
Float class >> status [
	^Status uLongAtOffset: 0
]

{ #category : #accessing }
Float class >> statusVar [
	^Status
]

{ #category : #'instance creation' }
Float class >> usingBytes: aByteArray [
	^self fromByteArray: aByteArray
]

{ #category : #constants }
Float class >> zero [
	^0.0
]

{ #category : #arithmetic }
Float >> - aNumber [
	| result status |
	aNumber isFloat ifFalse: [^self - aNumber asFloat].
	result := Float new.
	Float clearStatusFlags.
	self _floatMinus: aNumber into: result.
	status := Float status.
	(Float hasErrorFlag: status) ifFalse: [^result].
	^(Float hasDenormalizedOperandFlag: status)
		ifTrue: [self asNormalized - aNumber asNormalized]
		ifFalse: [self errorOn: #'-' status: status]
]

{ #category : #arithmetic }
Float >> * aNumber [
	| result status |
	aNumber isFloat ifFalse: [^self * aNumber asFloat].
	result := Float new.
	Float clearStatusFlags.
	self _floatMultiply: aNumber into: result.
	status := Float status.
	(Float hasErrorFlag: status) ifFalse: [^result].
	^(Float hasDenormalizedOperandFlag: status)
		ifTrue: [self asNormalized * aNumber asNormalized]
		ifFalse: [self errorOn: #'*' status: status]
]

{ #category : #arithmetic }
Float >> / aNumber [
	| result status |
	aNumber isFloat ifFalse: [^self / aNumber asFloat].
	result := Float new.
	Float clearStatusFlags.
	self _floatQuotient: aNumber into: result.
	status := Float status.
	(Float hasErrorFlag: status) ifFalse: [^result].
	^(Float hasDenormalizedOperandFlag: status)
		ifTrue: [self asNormalized / aNumber asNormalized]
		ifFalse: [self errorOn: #'/' status: status]
]

{ #category : #arithmetic }
Float >> // aNumber [
	| quo q |
	q := self / aNumber.
	quo := q truncated.
	q positive ifTrue: [^quo].
	^quo = q ifTrue: [quo] ifFalse: [quo - 1]
]

{ #category : #comparing }
Float >> ~ aFloat [
	| delta distance |
	aFloat isFloat ifFalse: [^self isCloseTo: aFloat].
	self isSpecialValue ifTrue: [^self = aFloat].
	aFloat isSpecialValue ifTrue: [^false].
	delta := aFloat - self.
	(-0.1e-289 < delta and: [delta < 0.1e-289]) ifTrue: [^true].
	self = 0.0 ifTrue: [^false].
	delta = aFloat ifTrue: [^false].
	distance := delta / self.
	^-1.0e-10 < distance and: [distance < 1.0e-10]
]

{ #category : #arithmetic }
Float >> + aNumber [
	| result status |
	aNumber isFloat ifFalse: [^aNumber addTo: self].
	result := Float new.
	Float clearStatusFlags.
	self _floatPlus: aNumber into: result.
	status := Float status.
	(Float hasErrorFlag: status) ifFalse: [^result].
	^(Float hasDenormalizedOperandFlag: status)
		ifTrue: [self asNormalized + aNumber asNormalized]
		ifFalse: [self errorOn: #'+' status: status]
]

{ #category : #comparing }
Float >> < aNumber [
	| result status |
	aNumber isFloat ifFalse: [^self < aNumber asFloat].
	Float clearStatusFlags.
	result := 0 == (self _floatLessThan: aNumber).
	status := Float status.
	(Float hasErrorFlag: status) ifFalse: [^result].
	(Float hasDenormalizedOperandFlag: status) ifTrue: [^result].
	(self isSpecialValue or: [aNumber isSpecialValue]) ifTrue: [^result].
	self errorOn: #'<' status: status
]

{ #category : #comparing }
Float >> <~ aNumber [
	| float |
	float := aNumber asFloat.
	^(float < self) not or: [self ~ float]
]

{ #category : #comparing }
Float >> <= aNumber [
	^self < aNumber or: [self = aNumber]
]

{ #category : #comparing }
Float >> = aNumber [
	| result status nan equal |
	aNumber isFloat
		ifFalse: [^aNumber isNumber
			ifTrue: [self = aNumber asFloat]
			ifFalse: [false]].
	Float clearStatusFlags.
	result := 0 == (self _floatEquals: aNumber).
	status := Float status.
	(Float hasErrorFlag: status) ifFalse: [^result].
	(Float hasDenormalizedOperandFlag: status) ifTrue: [^result].
	nan := self isNaN.
	equal := nan == aNumber isNaN.
	equal ifFalse: [^false].
	nan ifTrue: [^true].
	self errorOn: #'=' status: status
]

{ #category : #comparing }
Float >> > aNumber [
	^aNumber asFloat < self
]

{ #category : #comparing }
Float >> >~ aNumber [
	| float |
	float := aNumber asFloat.
	^(self < float) not or: [self ~ float]
]

{ #category : #comparing }
Float >> >= aNumber [
	^(self < aNumber asFloat) not
]

{ #category : #arithmetic }
Float >> abs [
	self isNaN ifTrue: [^self].
	^self < 0.0 ifTrue: [^0.0 - self] ifFalse: [self]
]

{ #category : #trigonometry }
Float >> arcTan [
	^Smalltalk os libc atan: self
]

{ #category : #converting }
Float >> asByteArray [
	| array |
	array := ByteArray new: self size.
	array
		replaceBytesFrom: 1
		to: self size
		with: self
		startingAt: 1.
	^array
]

{ #category : #converting }
Float >> asFloat [
	^self
]

{ #category : #converting }
Float >> asFraction [
	^self asTrueFraction
]

{ #category : #converting }
Float >> asNormalized [
	^self isDenormalizedValue ifTrue: [0.0] ifFalse: [self]
]

{ #category : #converting }
Float >> asTrueFraction [
	| high exponent positive low significand fraction exp zeroes numerator denominator |
	self isSpecialValue
		ifTrue: [self
			error: 'cannot represent ' , self printString , ' as a fraction'].
	high := self uLongAtOffset: 4.
	exponent := high bitShift: -20.
	positive := (exponent bitAnd: 16r800) = 0.
	positive ifFalse: [exponent := exponent bitAnd: 16r7FF].
	low := self uLongAtOffset: 0.
	significand := ((high bitAnd: 16rFFFFF) bitShift: 32) + low.
	(exponent = 0 and: [significand = 0]) ifTrue: [^0].
	fraction := exponent = 0
		ifTrue: [significand bitShift: 1]
		ifFalse: [significand bitOr: 16r10000000000000].
	positive ifFalse: [fraction := fraction negated].
	exp := 1075 - exponent.
	exp < 0 ifTrue: [^fraction bitShift: exp negated].
	zeroes := fraction lowBit - 1.
	exp := exp - zeroes.
	exp <= 0 ifTrue: [^fraction bitShift: zeroes negated - exp].
	numerator := fraction bitShift: zeroes negated.
	exp = 0 ifTrue: [^numerator].
	denominator := 1 bitShift: exp.
	^numerator / denominator
]

{ #category : #arithmetic }
Float >> ceiling [
	^self isNaN ifTrue: [self] ifFalse: [super ceiling]
]

{ #category : #private }
Float >> coerce: aNumber [
	^aNumber asFloat
]

{ #category : #trigonometry }
Float >> cos [
	^Smalltalk os libc cos: self
]

{ #category : #trigonometry }
Float >> degreesToRadians [
	^self * RadiansPerDegree
]

{ #category : #errors }
Float >> errorOn: aSymbol status: anInteger [
	^self class errorOn: aSymbol status: anInteger for: self
]

{ #category : #logarithms }
Float >> exp [
	^Smalltalk os libc exp: self
]

{ #category : #accessing }
Float >> exponent [
	| bits |
	bits := (self at: 8) * 256 + (self at: 7).
	bits := bits // 16 bitAnd: 2r11111111111.
	^bits > 0
		ifTrue: [bits < 2047 ifTrue: [bits - 1023] ifFalse: [self]]
		ifFalse: [self asNormalized exponent]
]

{ #category : #copying }
Float >> externalCopy [
	^ExternalMemory fromByteArray: self
]

{ #category : #arithmetic }
Float >> floor [
	^self isNaN ifTrue: [self] ifFalse: [super floor]
]

{ #category : #random }
Float >> fractionPart [
	| fraction status |
	fraction := Float new.
	Float clearStatusFlags.
	self _floatFractionPartInto: fraction.
	status := Float status.
	(Float hasErrorFlag: status) ifFalse: [^fraction].
	^(Float hasDenormalizedOperandFlag: status)
		ifTrue: [self asNormalized fractionPart]
		ifFalse: [self errorOn: #fractionPart status: status]
]

{ #category : #testing }
Float >> hasFixedSize [
	^true
]

{ #category : #comparing }
Float >> hash [
	| hash |
	self isSpecialValue ifFalse: [
		self fractionPart = 0.0 ifTrue: [
			((self
				between: -1073741824.0 "SmallInteger smallestNegative"
				and: 1073741823.0 "SmallInteger largestPositive")
				or: [9007199254740992.0 < self]
				or: [self < -9007199254740992.0 "53 bits of mantissa"])
				ifTrue: [^self truncated hash]]].
	hash := 8.
	1
		to: 8
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (self at: i)].
	^hash
]

{ #category : #testing }
Float >> hasZeroExponent [
	^((self at: 8) bitAnd: 16r7F) = 0 and: [((self at: 7) bitAnd: 16rF0) = 0]
]

{ #category : #testing }
Float >> hasZeroMantissa [
	((self at: 7) bitAnd: 16rF) = 0 ifFalse: [^false].
	(self at: 6) = 0 ifFalse: [^false].
	(self at: 5) = 0 ifFalse: [^false].
	(self at: 4) = 0 ifFalse: [^false].
	(self at: 3) = 0 ifFalse: [^false].
	(self at: 2) = 0 ifFalse: [^false].
	^(self at: 1) = 0
]

{ #category : #testing }
Float >> isDenormalizedValue [
	^self hasZeroExponent and: [self hasZeroMantissa not]
]

{ #category : #testing }
Float >> isFloat [
	^true
]

{ #category : #testing }
Float >> isInfinite [
	^self = Infinity or: [self = MinusInfinity]
]

{ #category : #testing }
Float >> isInfinity [
	^self = Infinity
]

{ #category : #testing }
Float >> isMinusInfinity [
	^self = MinusInfinity
]

{ #category : #testing }
Float >> isNaN [
	^self isSpecialValue and: [self hasZeroMantissa not]
]

{ #category : #testing }
Float >> isSpecialValue [
	^((self uShortAtOffset: 6) bitAnd: 16r7FF0) = 16r7FF0
]

{ #category : #logarithms }
Float >> ln [
	self > 0
		ifFalse: [^self error: 'ln is not defined for ' , self printString].
	^Smalltalk os libc log: self
]

{ #category : #accessing }
Float >> mantissa [
	^self significand
]

{ #category : #errors }
Float >> marshalOn: aStream [
	aStream putBytesFrom: self from: 1 to: 8
]

{ #category : #arithmetic }
Float >> negated [
	^-1.0 * self
]

{ #category : #printing }
Float >> printDecimals: decimals separatedBy: aString [
	| fraction digits |
	self isNaN ifTrue: [^'NAN'].
	(self = 0.0 or: [self exponent + decimals < self class maxExponent])
		ifFalse: [^self asString].
	digits := 10 raisedToInteger: decimals.
	fraction := (self * digits) rounded / digits.
	^fraction printDecimals: decimals separatedBy: aString
]

{ #category : #printing }
Float >> printOn: aStream [
	self printOn: aStream separatedBy: ActiveLocale decimalSeparator
]

{ #category : #printing }
Float >> printOn: aStream separatedBy: separator [
	| number factor scientificThreshold maxDigits digits integer reverse exp |
	self isNaN ifTrue: [^aStream nextPutAll: 'NAN'].
	self = Infinity ifTrue: [^aStream nextPutAll: '+infinite'].
	self = MinusInfinity ifTrue: [^aStream nextPutAll: '-infinite'].
	self < 0.0 ifTrue: [
		aStream nextPut: $-.
		^self negated printOn: aStream separatedBy: separator].
	(self = 0.0 or: [self isDenormalizedValue]) ifTrue: [
		^aStream
			nextPut: $0;
			nextPutAll: separator;
			nextPut: $0].
	number := self.
	factor := 0.5e-14.
	scientificThreshold := 13.
	digits := (number log: 10) truncated.
	number := number / (digits asFloat * 10.0 ln) exp + factor.
	number >= 10.0 ifTrue: [
		number := number / 10.0.
		digits := digits + 1].
	digits = 0 ifFalse: [
		((digits between: scientificThreshold negated and: scientificThreshold)
			and: [
				digits >= 0 or: [| n |
					n := number * ((digits + scientificThreshold) asFloat * 10.0 ln) exp.
					(n fractionPart * (digits negated * 10.0 ln) exp) truncated = 0]])
			ifTrue: [
				number := number * (digits asFloat * 10.0 ln) exp.
				factor := factor * (digits * 10.0 ln) exp.
				digits := 0]].
	exp := digits.
	integer := number truncated.
	number := number fractionPart.
	reverse := String streamContents: [:strm | 
		[integer >= 10] whileTrue: [
			strm nextPut: (Character digitValue: integer \\ 10).
			integer := integer // 10].
		strm nextPut: (Character digitValue: integer)].
	aStream nextPutAll: reverse reversed.
	maxDigits := 15.
	digits := maxDigits - reverse size - 1.
	aStream nextPutAll: separator.
	factor := factor * 2.0.
	[
		number := number * 10.0.
		integer := number truncated.
		number := number fractionPart.
		aStream nextPut: (Character digitValue: integer).
		digits := digits - 1.
		digits positive and: [
			factor := factor * 10.0.
			factor <= number]] whileTrue.
	exp = 0 ifFalse: [
		aStream nextPut: $e.
		exp printOn: aStream]
]

{ #category : #trigonometry }
Float >> radiansToDegrees [
	^self / RadiansPerDegree
]

{ #category : #logarithms }
Float >> raisedTo: aNumber [
	| n base |
	aNumber \\ 1.0 = 0.0 ifTrue: [^self raisedToInteger: aNumber asInteger].
	(self = 0.0 and: [aNumber > 0.0]) ifTrue: [^0.0].
	self positive ifTrue: [
		base := aNumber * self abs ln.
		^base >= self class maxForExp
			ifTrue: [self class infinity]
			ifFalse: [base exp]].
	n := aNumber rounded.
	aNumber = n ifTrue: [^self raisedToInteger: n].
	^(ArithmeticError on: #raisedTo:) signalInvalidOperation
]

{ #category : #logarithms }
Float >> raisedToInteger: anInteger [
	^(super raisedToInteger: anInteger) asFloat
]

{ #category : #arithmetic }
Float >> reciprocal [
	^1.0 / self
]

{ #category : #replacing }
Float >> replaceFrom: start
to: stop
with: anObject
startingAt: position [
	self
		replaceBytesFrom: start
		to: stop
		with: anObject
		startingAt: position
]

{ #category : #arithmetic }
Float >> rounded [
	self isNaN ifTrue: [^self].
	self isInfinite ifTrue: [^self].
	^self fractionPart abs < 0.5
		ifTrue: [self truncated]
		ifFalse: [self truncated + self sign rounded]
]

{ #category : #accessing }
Float >> sign [
	self isNaN ifTrue: [^self].
	^super sign
]

{ #category : #accessing }
Float >> significand [
	| status |
	status := Float status.
	^(Float hasDenormalizedOperandFlag: status)
		ifTrue: [self asNormalized significand]
		ifFalse: [self errorOn: #significand status: status]
]

{ #category : #trigonometry }
Float >> sin [
	^Smalltalk os libc sin: self
]

{ #category : #accessing }
Float >> sizeInBytes [
	^8
]

{ #category : #functions }
Float >> sqrt [
	| result status |
	result := Float new.
	Float clearStatusFlags.
	self _floatSqrtInto: result.
	status := Float status.
	(Float hasErrorFlag: status) ifFalse: [^result].
	^(Float hasDenormalizedOperandFlag: status)
		ifTrue: [self asNormalized sqrt]
		ifFalse: [self errorOn: #sqrt status: status]
]

{ #category : #printing }
Float >> storeOn: aStream [
	self printOn: aStream separatedBy: '.'
]

{ #category : #trigonometry }
Float >> tan [
	^Smalltalk os libc tan: self
]

{ #category : #arithmetic }
Float >> timesTwoPower: anInteger [
	| result status |
	result := self copy.
	result _timesTwoPower: anInteger asFloat.
	status := Float status.
	(Float hasErrorFlag: status) ifFalse: [^result].
	self errorOn: #timesTwoPower status: status
]

{ #category : #arithmetic }
Float >> truncated [
	| result status |
	Float clearStatusFlags.
	result := self _floatTruncated.
	status := Float status.
	((Float hasErrorFlag: status) not
		and: [result = 0 or: [result sign = self sign]])
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

{ #category : #private }
Float >> uLongAtOffset: offset [
	| low high |
	low := self uShortAtOffset: offset.
	high := self uShortAtOffset: offset + 2.
	high := high bitShift: 16.
	^high + low
]

{ #category : #private }
Float >> uShortAtOffset: offset [
	^(self at: offset + 1) + ((self at: offset + 2) bitShift: 8)
]

