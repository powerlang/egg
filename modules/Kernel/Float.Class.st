'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Float category: #Kernel!
Number subclass: #Float
	instanceVariableNames: ''
	classVariableNames: 'E Infinity MinusInfinity Pi RadiansPerDegree Status'
	poolDictionaries: ''
	category: 'Kernel'!
!Float commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
- aNumber
	^self errorVMSpecific
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
* aNumber
	^self errorVMSpecific
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
/ aNumber
	^self errorVMSpecific
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
// aNumber
	| quo q |
	q := self / aNumber.
	quo := q truncated.
	q positive ifTrue: [^quo].
	^quo = q ifTrue: [quo] ifFalse: [quo - 1]
! !

!Float methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
~ aFloat
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
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
+ aNumber
	^self errorVMSpecific
! !

!Float methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
< aNumber
	^self errorVMSpecific
! !

!Float methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
<~ aNumber
	| float |
	float := aNumber asFloat.
	^(float < self) not or: [self ~ float]
! !

!Float methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
<= aNumber
	^self < aNumber or: [self = aNumber]
! !

!Float methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aNumber
	^self errorVMSpecific
! !

!Float methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
> aNumber
	^aNumber asFloat < self
! !

!Float methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
>~ aNumber
	| float |
	float := aNumber asFloat.
	^(self < float) not or: [self ~ float]
! !

!Float methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
>= aNumber
	^(self < aNumber asFloat) not
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
abs
	self isNaN ifTrue: [^self].
	^self < 0.0 ifTrue: [^0.0 - self] ifFalse: [self]
! !

!Float methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
arcTan
	^Kernel host libc atan: self
! !

!Float methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asByteArray
	| array |
	array := ByteArray new: self size.
	array
		replaceBytesFrom: 1
		to: self size
		with: self
		startingAt: 1.
	^array
! !

!Float methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asFloat
	^self
! !

!Float methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asFraction
	^self asTrueFraction
! !

!Float methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asNormalized
	^self isDenormalizedValue ifTrue: [0.0] ifFalse: [self]
! !

!Float methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asTrueFraction
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
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index
	^self errorVMSpecific
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: index
	^self errorVMSpecific
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
ceiling
	^self isNaN ifTrue: [self] ifFalse: [super ceiling]
! !

!Float methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
coerce: aNumber
	^aNumber asFloat
! !

!Float methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
cos
	^Kernel host libc cos: self
! !

!Float methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
degreesToRadians
	^self * RadiansPerDegree
! !

!Float methodsFor:  'random' stamp: 'KenD 28/Jun/2026 13:27:38'!
errorOn: aSymbol
	^self errorVMSpecific
! !

!Float methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
errorOn: aSymbol status: anInteger
	^self class errorOn: aSymbol status: anInteger for: self
! !

!Float methodsFor:  'logarithms' stamp: 'KenD 28/Jun/2026 13:27:38'!
exp
	^Kernel host libc exp: self
! !

!Float methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
exponent
	| bits |
	bits := (self at: 8) * 256 + (self at: 7).
	bits := bits // 16 bitAnd: 2r11111111111.
	^bits > 0
		ifTrue: [bits < 2047 ifTrue: [bits - 1023] ifFalse: [self]]
		ifFalse: [self asNormalized exponent]
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
floor
	^self isNaN ifTrue: [self] ifFalse: [super floor]
! !

!Float methodsFor:  'random' stamp: 'KenD 28/Jun/2026 13:27:38'!
fractionPart
	^self errorVMSpecific
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasFixedSize
	^true
! !

!Float methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
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
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasZeroExponent
	^((self at: 8) bitAnd: 16r7F) = 0 and: [((self at: 7) bitAnd: 16rF0) = 0]
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasZeroMantissa
	((self at: 7) bitAnd: 16rF) = 0 ifFalse: [^false].
	(self at: 6) = 0 ifFalse: [^false].
	(self at: 5) = 0 ifFalse: [^false].
	(self at: 4) = 0 ifFalse: [^false].
	(self at: 3) = 0 ifFalse: [^false].
	(self at: 2) = 0 ifFalse: [^false].
	^(self at: 1) = 0
! !

!Float methodsFor:  'random' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeWith: bytes
	self errorVMSpecific
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isDenormalizedValue
	^self hasZeroExponent and: [self hasZeroMantissa not]
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFloat
	^true
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isInfinite
	^self = Infinity or: [self = MinusInfinity]
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isInfinity
	^self = Infinity
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isMinusInfinity
	^self = MinusInfinity
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isNaN
	^self isSpecialValue and: [self hasZeroMantissa not]
! !

!Float methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isSpecialValue
	^((self uShortAtOffset: 6) bitAnd: 16r7FF0) = 16r7FF0
! !

!Float methodsFor:  'logarithms' stamp: 'KenD 28/Jun/2026 13:27:38'!
ln
	self > 0
		ifFalse: [^self error: 'ln is not defined for ' , self printString].
	^Kernel host libc log: self
! !

!Float methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
mantissa
	^self significand
! !

!Float methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
marshalOn: aStream
	aStream putBytesFrom: self from: 1 to: 8
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
negated
	^-1.0 * self
! !

!Float methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printDecimals: decimals separatedBy: aString
	| fraction digits |
	self isNaN ifTrue: [^'NAN'].
	(self = 0.0 or: [self exponent + decimals < self class maxExponent])
		ifFalse: [^self asString].
	digits := 10 raisedToInteger: decimals.
	fraction := (self * digits) rounded / digits.
	^fraction printDecimals: decimals separatedBy: aString
! !

!Float methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	self printOn: aStream separatedBy: ActiveLocale decimalSeparator
! !

!Float methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream separatedBy: separator
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
! !

!Float methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
radiansToDegrees
	^self / RadiansPerDegree
! !

!Float methodsFor:  'logarithms' stamp: 'KenD 28/Jun/2026 13:27:38'!
raisedTo: aNumber
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
! !

!Float methodsFor:  'logarithms' stamp: 'KenD 28/Jun/2026 13:27:38'!
raisedToInteger: anInteger
	^(super raisedToInteger: anInteger) asFloat
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
reciprocal
	^1.0 / self
! !

!Float methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFrom: start to: stop with: anObject startingAt: position
	self
		replaceBytesFrom: start
		to: stop
		with: anObject
		startingAt: position
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
rounded
	self isNaN ifTrue: [^self].
	self isInfinite ifTrue: [^self].
	^self fractionPart abs < 0.5
		ifTrue: [self truncated]
		ifFalse: [self truncated + self sign rounded]
! !

!Float methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sign
	self isNaN ifTrue: [^self].
	^super sign
! !

!Float methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
significand
	^self errorVMSpecific
! !

!Float methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
sin
	^Kernel host libc sin: self
! !

!Float methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeInBytes
	^8
! !

!Float methodsFor:  'functions' stamp: 'KenD 28/Jun/2026 13:27:38'!
sqrt
	^self errorVMSpecific
! !

!Float methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storeOn: aStream
	self printOn: aStream separatedBy: '.'
! !

!Float methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
tan
	^Kernel host libc tan: self
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
timesTwoPower: anInteger
	^self errorVMSpecific
! !

!Float methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncated
	^self errorVMSpecific
! !

!Float methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
uLongAtOffset: offset
	| low high |
	low := self uShortAtOffset: offset.
	high := self uShortAtOffset: offset + 2.
	high := high bitShift: 16.
	^high + low
! !

!Float methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
uShortAtOffset: offset
	^(self at: offset + 1) + ((self at: offset + 2) bitShift: 8)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Float class' category: #Kernel!
Float class
	instanceVariableNames: 'E Infinity MinusInfinity Pi RadiansPerDegree Status'!

!Float class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicErrorOn: aSymbol status: status for: aNumber
	self error: 'Float error ' , aSymbol.
	#FloatPlus. #FloatMinus. #FloatMultiply. #FloatDiv. #FloatLess. #FloatEqual.
	#FloatFractionPart. #FloatSignificand. #FloatSqrt. #FloatTimesTwoPower. #FloatTruncated "hack to get the symbols interned in kernel"
! !

!Float class methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
clearStatusFlags
	Status at: 1 put: ((Status at: 1) bitAnd: 0xC0).
	self _status: Status
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
e
	"
	Float e
	"
	^E
! !

!Float class methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
errorOn: aSymbol status: status for: aNumber
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
! !

!Float class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
from: aNumber
	^aNumber asFloat
! !

!Float class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromByteArray: aByteArray
	^self new initializeWith: aByteArray
! !

!Float class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromBytes: anObject
	| float |
	^anObject isByteArray ifTrue: [self fromByteArray: anObject] ifFalse: [
		float := self new.
		float replaceBytesFrom: 1 to: 8 with: anObject startingAt: 1.
		^float]
! !

!Float class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromInteger: anInteger
	^self errorVMSpecific
! !

!Float class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromLocalString: aString
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
! !

!Float class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromString: aString decimalSeparator: anotherString
	^(super fromString: aString decimalSeparator: anotherString) asFloat
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasCoprocessorMissingFlag
	^self hasCoprocessorMissingFlag: self status
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasCoprocessorMissingFlag: status
	^(status bitAnd: 128) ~= 0
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasDenormalizedOperandFlag
	^self hasDenormalizedOperandFlag: self status
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasDenormalizedOperandFlag: status
	^(status bitAnd: 2) !!= 0
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasErrorFlag: status
	^(status bitAnd: 0x1F) !!= 0
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasFixedSize
	^self hasVariableSize not
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasInexactFlag
	^self hasInexactFlag: self status
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasInexactFlag: status
	^(status bitAnd: 32) ~= 0
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasInvalidOperationFlag
	^self hasInvalidOperationFlag: self status
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasInvalidOperationFlag: status
	^(status bitAnd: 1) ~= 0
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasOverflowFlag
	^self hasOverflowFlag: self status
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasOverflowFlag: status
	^(status bitAnd: 8) ~= 0
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasUnderflowFlag
	^self hasUnderflowFlag: self status
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasUnderflowFlag: status
	^(status bitAnd: 16) ~= 0
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasVariableSize
	^false
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasZeroDivisorFlag
	^self hasZeroDivisorFlag: self status
! !

!Float class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasZeroDivisorFlag: status
	^(status bitAnd: 4) ~= 0
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
infinity
	"
	Float infinity
	"
	^Infinity
! !

!Float class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeConstants
	"
	Float initializeConstants
	"
	self
		initializeInfinity;
		initializeMinusInfinity;
		initializePi;
		initializeE
! !

!Float class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeE
	E := self fromByteArray: #[105 87 20 139 10 191 5 64]
! !

!Float class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeInfinity
	Infinity := self fromByteArray: #[00 00 00 00 00 00 0xF0 0x7F]
! !

!Float class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeMinusInfinity
	MinusInfinity := self fromByteArray: #[00 00 00 00 00 00 0xF0 0xFF]
! !

!Float class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializePi
	Pi := 3.14159265358979323846264338327950288
! !

!Float class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeRadiansPerDegree
	RadiansPerDegree := Pi / 180.0
! !

!Float class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeStatus
	Status isNil ifTrue: [Status := ByteArray new: 4].
	self _readStatusOn: Status
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxExponent
	^309
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxForExp
	self disableCode: [^(10.0 raisedTo: Float maxExponent - 1) ln].
	^self fromByteArray: #[16r5E 16r2A 16rD6 16rD5 16r91 16r29 16r86 16r40]
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxNegativeValue
	"
	Float maxNegativeValue
	"
	^self fromByteArray: #[0 0 0 0 0 0 16 128]
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
maxValue
	"
	Float maxValue
	"
	^self fromByteArray: #[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rEF 16r7F]
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
minPositiveValue
	"
	Float minPositiveValue / 2
	"
	^self fromByteArray: #[0 0 0 0 0 0 16 0]
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
minusInfinity
	"
	Float minusInfinity
	"
	^MinusInfinity
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
minValue
	"
	Float minValue
	"
	^self fromByteArray: #[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rEF 16rFF]
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
multiplicativeIdentity
	^1.0
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
nan
	"
	Float nan
	"
	^self new
		at: 7 put: 248;
		at: 8 put: 127;
		yourself
! !

!Float class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self errorVMSpecific
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
pi
	"
	Number pi
	"
	^Pi
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
plusInfinity
	"
	Float plusInfinity
	"
	^Infinity
! !

!Float class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeInBytes
	^8
! !

!Float class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
startUp
	self initializeRadiansPerDegree
! !

!Float class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
status
	^Status uLongAtOffset: 0
! !

!Float class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
statusVar
	^Status
! !

!Float class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
usingBytes: aByteArray
	^self new initializeWith: aByteArray
! !

!Float class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
zero
	^0.0
! !


