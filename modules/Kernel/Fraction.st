"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Fraction,
	#superclass : #Number,
	#instVars : [
		'numerator',
		'denominator'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Fraction class >> fromString: aString [
	| parts num den gcd |
	parts := $/ split: aString.
	parts isEmpty ifTrue: [^0].
	num := Number fromString: parts first trimBlanks.
	num = 0 ifTrue: [^0].
	parts size = 1 ifTrue: [^num].
	den := Integer fromString: parts second trimBlanks.
	gcd := num gcd: den.
	^self numerator: num // gcd denominator: den // gcd
]

{ #category : #'instance creation' }
Fraction class >> numerator: anInteger denominator: anotherInteger [
	^self basicNew numerator: anInteger denominator: anotherInteger
]

{ #category : #arithmetic }
Fraction >> - aNumber [
	^self + aNumber negated
]

{ #category : #arithmetic }
Fraction >> * aNumber [
	| d1 d2 |
	aNumber isInteger ifTrue: [
		d2 := aNumber gcd: denominator.
		d2 = denominator ifTrue: [^numerator * (aNumber // d2)].
		^self class
			numerator: numerator * (aNumber // d2)
			denominator: denominator // d2].
	aNumber isFraction ifTrue: [
		d1 := numerator gcd: aNumber denominator.
		d2 := denominator gcd: aNumber numerator.
		(d2 = denominator and: [d1 = aNumber denominator])
			ifTrue: [^numerator // d1 * (aNumber numerator // d2)].
		^self class
			numerator: numerator // d1 * (aNumber numerator // d2)
			denominator: denominator // d2 * (aNumber denominator // d1)].
	^(aNumber coerce: self) * aNumber
]

{ #category : #arithmetic }
Fraction >> / aNumber [
	^self * aNumber reciprocal
]

{ #category : #arithmetic }
Fraction >> // aNumber [
	aNumber isInteger ifTrue: [^numerator // (denominator * aNumber)].
	aNumber isFraction
		ifTrue: [^numerator * aNumber denominator
			// (denominator * aNumber numerator)].
	^(aNumber coerce: self) // aNumber
]

{ #category : #arithmetic }
Fraction >> + aNumber [
	| n d d1 d2 |
	aNumber isInteger ifTrue: [
		^self class
			numerator: numerator + (denominator * aNumber)
			denominator: denominator].
	aNumber isFraction ifTrue: [
		d := denominator gcd: aNumber denominator.
		d1 := aNumber denominator // d.
		d2 := denominator // d.
		n := numerator * d1 + (aNumber numerator * d2).
		d1 := d1 * d2.
		d2 := n gcd: d.
		n := n // d2.
		d := d1 * (d // d2).
		d = 1 ifTrue: [^n].
		^Fraction numerator: n denominator: d].
	^(aNumber coerce: self) + aNumber
]

{ #category : #comparing }
Fraction >> < aNumber [
	aNumber isInteger ifTrue: [^numerator < (denominator * aNumber)].
	aNumber isFraction
		ifTrue: [^numerator * aNumber denominator
			< (denominator * aNumber numerator)].
	^(aNumber coerce: self) < aNumber
]

{ #category : #comparing }
Fraction >> <= aNumber [
	aNumber isInteger ifTrue: [^numerator <= (denominator * aNumber)].
	aNumber isFraction
		ifTrue: [^numerator * aNumber denominator
			<= (denominator * aNumber numerator)].
	^(aNumber coerce: self) <= aNumber
]

{ #category : #comparing }
Fraction >> = aNumber [
	aNumber isNumber ifFalse: [^false].
	aNumber isInteger ifTrue: [^numerator = (denominator * aNumber)].
	aNumber isFraction
		ifTrue: [^numerator * aNumber denominator
			= (denominator * aNumber numerator)].
	^(aNumber coerce: self) = aNumber
]

{ #category : #comparing }
Fraction >> > aNumber [
	aNumber isInteger ifTrue: [^numerator > (denominator * aNumber)].
	aNumber isFraction
		ifTrue: [^numerator * aNumber denominator
			> (denominator * aNumber numerator)].
	^(aNumber coerce: self) > aNumber
]

{ #category : #comparing }
Fraction >> >= aNumber [
	aNumber isInteger ifTrue: [^numerator >= (denominator * aNumber)].
	aNumber isFraction
		ifTrue: [^numerator * aNumber denominator
			>= (denominator * aNumber numerator)].
	^(aNumber coerce: self) >= aNumber
]

{ #category : #converting }
Fraction >> asFloat [
	"
	Answer a Float that closely approximates the value of the receiver.
	This implementation will answer the closest floating point number to the receiver.
	It uses the IEEE 754 round to nearest even mode
	(can happen in case denominator is a power of two)
	Taken from Squeak.
	Modified to throw Underflow instead of answering denormalized floats or 0.0
	"
	| a b q r exponent floatExponent n ha hb hq q1 |
	a := numerator abs.
	b := denominator abs.
	ha := a highBit.
	hb := b highBit.
	("If both numerator and denominator are represented exactly in floating point number,
	then fastest thing to do is to use hardwired float division"
	ha < 54 and: [hb < 54]) ifTrue: [^numerator asFloat / denominator asFloat].
	"Try and obtain a mantissa with 54 bits.
	First guess is rough, we might get one more bit or one less"
	exponent := ha - hb - 54.
	exponent > 0
		ifTrue: [b := b bitShift: exponent]
		ifFalse: [a := a bitShift: exponent negated].
	q := a quo: b.
	r := a - (q * b).
	hq := q highBit.
	"Squeak does gradual underflow. VSE does not use denormalized floats. "
	floatExponent := exponent + hq - 1.
	floatExponent > -1023
		ifFalse: [^(ArithmeticError on: #asFloat) signalUnderflow].
	n := 54.
	hq > n ifTrue: [
		exponent := exponent + hq - n.
		r := (q bitAnd: (1 bitShift: n - hq) - 1) * b + r.
		q := q bitShift: n - hq].
	hq < n ifTrue: [
		exponent := exponent + hq - n.
		q1 := (r bitShift: n - hq) quo: b.
		q := (q bitShift: n - hq) bitAnd: q1.
		r := r - (q1 * b)].
	(("check if we should round upward.
	The case of exact half (q bitAnd: 1) isZero not & (r isZero)
	will be handled by Integer>>asFloat"
	q bitAnd: 1) = 0 or: [r = 0]) ifFalse: [q := q + 1].
	^(self positive ifTrue: [q asFloat] ifFalse: [q asFloat negated])
		timesTwoPower: exponent
]

{ #category : #converting }
Fraction >> asFraction [
	^self
]

{ #category : #converting }
Fraction >> asScaledDecimal [
	| pow2 pow5 q q5 |
	pow2 := denominator lowBit - 1.
	q := denominator bitShift: pow2 negated.
	pow5 := 0.
	[q = 1] whileFalse: [
		q5 := q // 5.
		q - (5 * q5) = 0 ifFalse: [^super asScaledDecimal].
		q := q5.
		pow5 := pow5 + 1].
	^self withPrecision: (pow2 max: pow5)
]

{ #category : #private }
Fraction >> coerce: aNumber [
	^aNumber asFraction
]

{ #category : #accessing }
Fraction >> denominator [
	^denominator
]

{ #category : #comparing }
Fraction >> hash [
	^numerator hashWith: denominator
]

{ #category : #testing }
Fraction >> isFraction [
	^true
]

{ #category : #private }
Fraction >> negate [
	numerator := numerator negated
]

{ #category : #arithmetic }
Fraction >> negated [
	^self class numerator: numerator negated denominator: denominator
]

{ #category : #accessing }
Fraction >> numerator [
	^numerator
]

{ #category : #accessing }
Fraction >> numerator: n denominator: d [
	d = 0 ifTrue: [^self zeroDivisorOn: #numerator:denominator:].
	d negative
		ifTrue: [
			numerator := n negated.
			denominator := d negated]
		ifFalse: [
			numerator := n.
			denominator := d]
]

{ #category : #printing }
Fraction >> printOn: aStream [
	numerator printOn: aStream.
	aStream nextPut: $/.
	denominator printOn: aStream
]

{ #category : #arithmetic }
Fraction >> raisedToInteger: anInteger [
	| num den |
	anInteger = 0 ifTrue: [
		^self isZero
			ifTrue: [(ArithmeticError on: #raisedToInteger:) signalInvalidOperation]
			ifFalse: [1]].
	anInteger < 0 ifTrue: [^self reciprocal raisedToInteger: anInteger negated].
	num := numerator raisedToInteger: anInteger.
	den := denominator raisedToInteger: anInteger.
	^self class numerator: num denominator: den
]

{ #category : #arithmetic }
Fraction >> reciprocal [
	^numerator abs = 1
		ifTrue: [denominator * numerator]
		ifFalse: [self class numerator: denominator denominator: numerator]
]

{ #category : #arithmetic }
Fraction >> sqrt [
	| d n |
	n := numerator sqrt.
	d := denominator sqrt.
	(n isInfinite or: [d isInfinite]) ifTrue: [^self asFloat sqrt].
	^n / d
]

{ #category : #arithmetic }
Fraction >> squared [
	^self class numerator: numerator squared denominator: denominator squared
]

{ #category : #arithmetic }
Fraction >> truncated [
	^numerator quo: denominator
]

