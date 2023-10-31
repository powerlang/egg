"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Number,
	#superclass : #Magnitude,
	#category : #Kernel
}

{ #category : #'instance creation' }
Number class >> fromString: aString [
	^self fromString: aString decimalSeparator: '.'
]

{ #category : #'instance creation' }
Number class >> fromString: aString decimalSeparator: anotherString [
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
]

{ #category : #constants }
Number class >> multiplicativeIdentity [
	^1
]

{ #category : #constants }
Number class >> nan [
	^Float nan
]

{ #category : #'instance creation' }
Number class >> new [
	^self shouldNotImplement
]

{ #category : #'instance creation' }
Number class >> new: anInteger [
	^self shouldNotImplement
]

{ #category : #constants }
Number class >> zero [
	^0
]

{ #category : #arithmetic }
Number >> - aNumber [
	^self + aNumber negated
]

{ #category : #arithmetic }
Number >> * aNumber [
	self subclassResponsibility
]

{ #category : #arithmetic }
Number >> / aNumber [
	self subclassResponsibility
]

{ #category : #arithmetic }
Number >> // aNumber [
	self subclassResponsibility
]

{ #category : #geometry }
Number >> @ aNumber [
	^Point x: self y: aNumber
]

{ #category : #geometry }
Number >> @- aNumber [
	^Point x: self y: aNumber negated
]

{ #category : #arithmetic }
Number >> \\ aNumber [
	^self - (self // aNumber * aNumber)
]

{ #category : #arithmetic }
Number >> + aNumber [
	self subclassResponsibility
]

{ #category : #comparing }
Number >> <~ aNumber [
	aNumber isFloat ifTrue: [^self asFloat <~ aNumber].
	^[self <= aNumber] on: Error do: [false]
]

{ #category : #comparing }
Number >> >~ aNumber [
	aNumber isFloat ifTrue: [^self asFloat >~ aNumber].
	^[self >= aNumber] on: Error do: [false]
]

{ #category : #arithmetic }
Number >> abs [
	^self < self class zero ifTrue: [self negated] ifFalse: [self]
]

{ #category : #trigonometry }
Number >> arcCos [
	^Float pi / 2.0 - self arcSin
]

{ #category : #trigonometry }
Number >> arcSin [
	| y |
	y := self asFloat.
	(y between: -1.0 and: 1.0) ifFalse: [^self error: 'invalid receiver'].
	y = 1.0 ifTrue: [^Number pi / 2.0].
	y = -1.0 ifTrue: [^Number pi / -2.0].
	^(y / (1.0 - y squared) sqrt) arcTan
]

{ #category : #trigonometry }
Number >> arcTan [
	^self asFloat arcTan
]

{ #category : #converting }
Number >> asInteger [
	^self rounded
]

{ #category : #converting }
Number >> asParameter [
	^self
]

{ #category : #converting }
Number >> asPoint [
	^self @ self
]

{ #category : #converting }
Number >> asScaledDecimal [
	"
	Number pi asScaledDecimal
	"
	^self withPrecision: 8
]

{ #category : #printing }
Number >> canBePrintedAsLiteral [
	^true
]

{ #category : #arithmetic }
Number >> ceiling [
	| integer |
	integer := self floor.
	^integer = self ifTrue: [integer] ifFalse: [integer + 1]
]

{ #category : #trigonometry }
Number >> cos [
	^self asFloat cos
]

{ #category : #copying }
Number >> deepCopy [
	^self
]

{ #category : #trigonometry }
Number >> degreesToRadians [
	^self asFloat degreesToRadians
]

{ #category : #accessing }
Number >> denominator [
	^1
]

{ #category : #testing }
Number >> even [
	^self \\ 2 = 0
]

{ #category : #logarithms }
Number >> exp [
	^self asFloat exp
]

{ #category : #arithmetic }
Number >> floor [
	^self // 1
]

{ #category : #accessing }
Number >> fractionPart [
	^self - self truncated
]

{ #category : #testing }
Number >> isInfinite [
	^false
]

{ #category : #testing }
Number >> isInfinity [
	^false
]

{ #category : #testing }
Number >> isMinusInfinity [
	^false
]

{ #category : #testing }
Number >> isNaN [
	^false
]

{ #category : #testing }
Number >> isNumber [
	^true
]

{ #category : #testing }
Number >> isZero [
	^self = self class zero
]

{ #category : #logarithms }
Number >> ln [
	^self asFloat ln
]

{ #category : #logarithms }
Number >> log [
	^self log: 10
]

{ #category : #logarithms }
Number >> log: aNumber [
	^self ln / aNumber ln
]

{ #category : #arithmetic }
Number >> negated [
	^0 - self
]

{ #category : #testing }
Number >> negative [
	^self < self class zero
]

{ #category : #accessing }
Number >> numerator [
	^self
]

{ #category : #testing }
Number >> odd [
	^self even not
]

{ #category : #testing }
Number >> positive [
	^self >= self class zero
]

{ #category : #printing }
Number >> printDecimals: decimals separatedBy: aString [
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
]

{ #category : #printing }
Number >> printFraction: decimals [
	^self printDecimals: decimals separatedBy: ActiveLocale decimalSeparator
]

{ #category : #printing }
Number >> printOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
Number >> printWithDecimalPlaces: digits [
	| power rounded |
	power := digits <= 9
		ifTrue: [
			#(1 10 100 1000 10000 100000 1000000 10000000 100000000 1000000000)
				at: digits + 1]
		ifFalse: [10 raisedToInteger: digits + 1].
	rounded := self roundTo: power reciprocal.
	^rounded printFraction: digits
]

{ #category : #arithmetic }
Number >> quo: aNumber [
	^(self / aNumber) truncated
]

{ #category : #trigonometry }
Number >> radiansToDegrees [
	^self asFloat radiansToDegrees
]

{ #category : #arithmetic }
Number >> raisedTo: aNumber [
	| n |
	aNumber = 0 ifTrue: [^self raisedToInteger: 0].
	(self = 0 and: [aNumber > 0]) ifTrue: [^0].
	aNumber isInteger ifTrue: [^self raisedToInteger: aNumber].
	self positive ifTrue: [^(aNumber * self abs ln) exp].
	n := aNumber rounded.
	aNumber = n ifTrue: [^(self raisedToInteger: n) asFloat].
	^(ArithmeticError on: #raisedTo:) signalInvalidOperation
]

{ #category : #arithmetic }
Number >> raisedToInteger: anInteger [
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
]

{ #category : #arithmetic }
Number >> rem: aNumber [
	| quo |
	quo := self quo: aNumber.
	^self - (quo * aNumber)
]

{ #category : #arithmetic }
Number >> rounded [
	^self + self + self sign quo: 2
]

{ #category : #arithmetic }
Number >> roundTo: aNumber [
	^self < 0
		ifTrue: [self - (aNumber / 2) truncateTo: aNumber]
		ifFalse: [self + (aNumber / 2) truncateTo: aNumber]
]

{ #category : #copying }
Number >> shallowCopy [
	^self
]

{ #category : #accessing }
Number >> sign [
	self > 0 ifTrue: [^1].
	self < 0 ifTrue: [^-1].
	^0
]

{ #category : #trigonometry }
Number >> sin [
	^self asFloat sin
]

{ #category : #arithmetic }
Number >> sqrt [
	^self asFloat sqrt
]

{ #category : #arithmetic }
Number >> squared [
	^self * self
]

{ #category : #printing }
Number >> storeOn: aStream [
	self printOn: aStream
]

{ #category : #testing }
Number >> strictlyPositive [
	^self > self class zero
]

{ #category : #trigonometry }
Number >> tan [
	^self asFloat tan
]

{ #category : #arithmetic }
Number >> timesTwoPower: anInteger [
	^self asFloat timesTwoPower: anInteger
]

{ #category : #converting }
Number >> to: stop [
	^Interval from: self to: stop
]

{ #category : #converting }
Number >> to: stop by: step [
	^Interval from: self to: stop by: step
]

{ #category : #enumerating }
Number >> to: stop by: step do: aBlock [
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
]

{ #category : #enumerating }
Number >> to: stop do: aBlock [
	| index |
	index := self.
	[index <= stop] whileTrue: [
		aBlock value: index.
		index := index + 1]
]

{ #category : #arithmetic }
Number >> truncated [
	^self truncateTo: 1
]

{ #category : #arithmetic }
Number >> truncateTo: aNumber [
	^(self quo: aNumber) * aNumber
]

{ #category : #converting }
Number >> withPrecision: scale [
	^ScaledDecimal fromNumber: self scale: scale
]

{ #category : #errors }
Number >> zeroDivisorOn: aSymbol [
	^ZeroDivide new operation: aSymbol; dividend: self; signal
]

