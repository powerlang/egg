'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Number category: #Kernel!
Magnitude subclass: #Number
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Number commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
- aNumber
	^self + aNumber negated
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
* aNumber
	self subclassResponsibility
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
/ aNumber
	self subclassResponsibility
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
// aNumber
	self subclassResponsibility
! !

!Number methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
@ aNumber
	^Point x: self y: aNumber
! !

!Number methodsFor:  'geometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
@- aNumber
	^Point x: self y: aNumber negated
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
\\ aNumber
	^self - (self // aNumber * aNumber)
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
+ aNumber
	self subclassResponsibility
! !

!Number methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
<~ aNumber
	aNumber isFloat ifTrue: [^self asFloat <~ aNumber].
	^[self <= aNumber] on: Error do: [false]
! !

!Number methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
>~ aNumber
	aNumber isFloat ifTrue: [^self asFloat >~ aNumber].
	^[self >= aNumber] on: Error do: [false]
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
abs
	^self < self class zero ifTrue: [self negated] ifFalse: [self]
! !

!Number methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
arcCos
	^Float pi / 2.0 - self arcSin
! !

!Number methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
arcSin
	| y |
	y := self asFloat.
	(y between: -1.0 and: 1.0) ifFalse: [^self error: 'invalid receiver'].
	y = 1.0 ifTrue: [^Number pi / 2.0].
	y = -1.0 ifTrue: [^Number pi / -2.0].
	^(y / (1.0 - y squared) sqrt) arcTan
! !

!Number methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
arcTan
	^self asFloat arcTan
! !

!Number methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asInteger
	^self rounded
! !

!Number methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asParameter
	^self
! !

!Number methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asPoint
	^self @ self
! !

!Number methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asScaledDecimal
	"
	Number pi asScaledDecimal
	"
	^self withPrecision: 8
! !

!Number methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBePrintedAsLiteral
	^true
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
ceiling
	| integer |
	integer := self floor.
	^integer = self ifTrue: [integer] ifFalse: [integer + 1]
! !

!Number methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
cos
	^self asFloat cos
! !

!Number methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
deepCopy
	^self
! !

!Number methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
degreesToRadians
	^self asFloat degreesToRadians
! !

!Number methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
denominator
	^1
! !

!Number methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
even
	^self \\ 2 = 0
! !

!Number methodsFor:  'logarithms' stamp: 'KenD 28/Jun/2026 13:27:38'!
exp
	^self asFloat exp
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
floor
	^self // 1
! !

!Number methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
fractionPart
	^self - self truncated
! !

!Number methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isInfinite
	^false
! !

!Number methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isInfinity
	^false
! !

!Number methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isMinusInfinity
	^false
! !

!Number methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isNaN
	^false
! !

!Number methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isNumber
	^true
! !

!Number methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isZero
	^self = self class zero
! !

!Number methodsFor:  'logarithms' stamp: 'KenD 28/Jun/2026 13:27:38'!
ln
	^self asFloat ln
! !

!Number methodsFor:  'logarithms' stamp: 'KenD 28/Jun/2026 13:27:38'!
log
	^self log: 10
! !

!Number methodsFor:  'logarithms' stamp: 'KenD 28/Jun/2026 13:27:38'!
log: aNumber
	^self ln / aNumber ln
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
negated
	^0 - self
! !

!Number methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
negative
	^self < self class zero
! !

!Number methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
numerator
	^self
! !

!Number methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
odd
	^self even not
! !

!Number methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
positive
	^self >= self class zero
! !

!Number methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printDecimals: decimals separatedBy: aString
	| writer fraction integer |
	decimals < 0 ifTrue: [self error: 'invalid number of digits'].
	writer := '' writeStream.
	integer := self truncated.
	self > -1 & (self < 0)
		ifTrue: [writer nextPutAll: '-0']
		ifFalse: [integer printOn: writer].
	decimals > 0 ifTrue: [writer nextPutAll: aString].
	fraction := (self - integer) abs.
	integer := 0.
	decimals timesRepeat: [| digit |
		fraction := fraction - integer * 10.
		integer := fraction // 1.
		digit := Character digitValue: integer.
		writer nextPut: digit].
	^writer contents
! !

!Number methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printFraction: decimals
	^self printDecimals: decimals separatedBy: ActiveLocale decimalSeparator
! !

!Number methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	self subclassResponsibility
! !

!Number methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printWithDecimalPlaces: digits
	| power rounded |
	power := digits <= 9
		ifTrue: [
			#(1 10 100 1000 10000 100000 1000000 10000000 100000000 1000000000)
				at: digits + 1]
		ifFalse: [10 raisedToInteger: digits + 1].
	rounded := self roundTo: power reciprocal.
	^rounded printFraction: digits
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
quo: aNumber
	^(self / aNumber) truncated
! !

!Number methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
radiansToDegrees
	^self asFloat radiansToDegrees
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
raisedTo: aNumber
	| n |
	aNumber = 0 ifTrue: [^self raisedToInteger: 0].
	(self = 0 and: [aNumber > 0]) ifTrue: [^0].
	aNumber isInteger ifTrue: [^self raisedToInteger: aNumber].
	self positive ifTrue: [^(aNumber * self abs ln) exp].
	n := aNumber rounded.
	aNumber = n ifTrue: [^(self raisedToInteger: n) asFloat].
	^(ArithmeticError on: #raisedTo:) signalInvalidOperation
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
raisedToInteger: anInteger
	| answer multiplier binary |
	self = 1 ifTrue: [^self].
	anInteger isInteger ifFalse: [
		anInteger isInfinity ifTrue: [
			^self > 1 ifTrue: [anInteger] ifFalse: [
				self >= 0
					ifTrue: [self class zero]
					ifFalse: [self error: 'receiver is not positive']]].
		anInteger isMinusInfinity ifTrue: [
			^self > 1 ifTrue: [self class zero] ifFalse: [
				self >= 0
					ifTrue: [anInteger negated]
					ifFalse: [self error: 'receiver is not positive']]].
		self error: 'argument is not integer'].
	anInteger < 0 ifTrue: [^(self raisedToInteger: 0 - anInteger) reciprocal].
	answer := self class multiplicativeIdentity.
	anInteger = 0 ifTrue: [
		^self = 0
			ifTrue: [(ArithmeticError on: #raisedToInteger:) signalInvalidOperation]
			ifFalse: [1]].
	multiplier := self.
	anInteger = 1 ifTrue: [^multiplier].
	anInteger = 2 ifTrue: [^multiplier squared].
	binary := anInteger.
	[
		(binary bitAnd: 1) = 1 ifTrue: [answer := answer * multiplier].
		binary := binary bitShift: -1.
		binary > 0]
		whileTrue: [multiplier := multiplier squared].
	^answer
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
rem: aNumber
	| quo |
	quo := self quo: aNumber.
	^self - (quo * aNumber)
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
rounded
	^self + self + self sign quo: 2
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
roundTo: aNumber
	^self < 0
		ifTrue: [self - (aNumber / 2) truncateTo: aNumber]
		ifFalse: [self + (aNumber / 2) truncateTo: aNumber]
! !

!Number methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
shallowCopy
	^self
! !

!Number methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sign
	self > 0 ifTrue: [^1].
	self < 0 ifTrue: [^-1].
	^0
! !

!Number methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
sin
	^self asFloat sin
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
sqrt
	^self asFloat sqrt
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
squared
	^self * self
! !

!Number methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storeOn: aStream
	self printOn: aStream
! !

!Number methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
strictlyPositive
	^self > self class zero
! !

!Number methodsFor:  'trigonometry' stamp: 'KenD 28/Jun/2026 13:27:38'!
tan
	^self asFloat tan
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
timesTwoPower: anInteger
	^self asFloat timesTwoPower: anInteger
! !

!Number methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
to: stop
	^Interval from: self to: stop
! !

!Number methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
to: stop by: step
	^Interval from: self to: stop by: step
! !

!Number methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
to: stop by: step do: aBlock
	| index |
	step = 0 ifTrue: [self error: 'step cannot be zero'].
	index := self.
	step > 0
		ifTrue: [
			[index <= stop] whileTrue: [
				aBlock value: index.
				index := index + step]]
		ifFalse: [
			[stop <= index] whileTrue: [
				aBlock value: index.
				index := index + step]]
! !

!Number methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
to: stop do: aBlock
	| index |
	index := self.
	[index <= stop] whileTrue: [
		aBlock value: index.
		index := index + 1]
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncated
	^self truncateTo: 1
! !

!Number methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncateTo: aNumber
	^(self quo: aNumber) * aNumber
! !

!Number methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
withPrecision: scale
	^ScaledDecimal fromNumber: self scale: scale
! !

!Number methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
zeroDivisorOn: aSymbol
	^ZeroDivide new operation: aSymbol; dividend: self; signal
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Number class' category: #Kernel!
Number class
	instanceVariableNames: ''!

!Number class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromString: aString
	^self fromString: aString decimalSeparator: '.'
! !

!Number class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromString: aString decimalSeparator: anotherString
	| string special |
	string := (aString includes: $.)
		ifTrue: [aString]
		ifFalse: [aString replaceAll: anotherString with: '.'].
	(string notEmpty and: [string first = $.]) ifTrue: [string := '0' , string].
	special := string
		reverseDetect: [:c | c = $.
			or: [c = $/]
			or: [c = $e]
			or: [c = $E]
			or: [c = $s]]
		ifNone: nil.
	special = $/ ifTrue: [^Fraction fromString: string].
	^NumberParser new on: string; nextValue
! !

!Number class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
multiplicativeIdentity
	^1
! !

!Number class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
nan
	^Float nan
! !

!Number class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new
	^self shouldNotImplement
! !

!Number class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	^self shouldNotImplement
! !

!Number class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
zero
	^0
! !


