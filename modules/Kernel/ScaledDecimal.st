"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ScaledDecimal,
	#superclass : #Fraction,
	#instVars : [
		'scale'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
ScaledDecimal class >> fromNumber: aNumber scale: anInteger [
	| fraction |
	fraction := aNumber asFraction.
	^self
		numerator: fraction numerator
		denominator: fraction denominator
		scale: anInteger
]

{ #category : #'instance creation' }
ScaledDecimal class >> fromString: aString [
	| value i n num den |
	value := super fromString: aString.
	value class == self ifTrue: [^value].
	i := aString indexOf: $..
	i = 0 ifTrue: [^self fromNumber: value scale: 0].
	n := aString size - i.
	num := (aString copyWithout: $.) asInteger.
	den := 10 raisedToInteger: n.
	^self fromNumber: num / den scale: n
]

{ #category : #'instance creation' }
ScaledDecimal class >> numerator: numerator denominator: denominator scale: scale [
	"
	ScaledDecimal numerator: 1 denominator: 3 scale: 2
	"
	^(self numerator: numerator denominator: denominator) scale: scale
]

{ #category : #arithmetic }
ScaledDecimal >> - aNumber [
	^aNumber class == self class
		ifTrue: [aNumber subtractFromScaledDecimal: self]
		ifFalse: [self retry: #'-' with: aNumber]
]

{ #category : #arithmetic }
ScaledDecimal >> * aNumber [
	^aNumber class == self class
		ifTrue: [aNumber multiplyScaledDecimal: self]
		ifFalse: [self retry: #'*' with: aNumber]
]

{ #category : #arithmetic }
ScaledDecimal >> / aNumber [
	^aNumber class == self class
		ifTrue: [aNumber divideIntoScaledDecimal: self]
		ifFalse: [self retry: #'/' with: aNumber]
]

{ #category : #arithmetic }
ScaledDecimal >> // aNumber [
	| q quo |
	q := self / aNumber.
	quo := q floor.
	^(q negative andNot: [q = quo]) ifTrue: [quo] ifFalse: [quo - 1]
]

{ #category : #arithmetic }
ScaledDecimal >> + aNumber [
	^aNumber class == self class
		ifTrue: [aNumber addToScaledDecimal: self]
		ifFalse: [self retry: #'+' with: aNumber]
]

{ #category : #comparing }
ScaledDecimal >> < aNumber [
	aNumber = 0 ifTrue: [^numerator < 0].
	^self - aNumber < 0
]

{ #category : #comparing }
ScaledDecimal >> <= aNumber [
	^self < aNumber or: [self = aNumber]
]

{ #category : #comparing }
ScaledDecimal >> = aNumber [
	self class == aNumber class ifTrue: [^self asFraction = aNumber asFraction].
	^self asFraction = aNumber
]

{ #category : #comparing }
ScaledDecimal >> > aNumber [
	aNumber = 0 ifTrue: [^numerator > 0].
	^self - aNumber > 0
]

{ #category : #comparing }
ScaledDecimal >> >= aNumber [
	^self > aNumber or: [self = aNumber]
]

{ #category : #private }
ScaledDecimal >> addToScaledDecimal: aScaledDecimal [
	| s den fraction |
	s := self scale max: aScaledDecimal scale.
	den := aScaledDecimal denominator.
	fraction := denominator = den
		ifTrue: [
			self class
				numerator: numerator + aScaledDecimal numerator
				denominator: denominator]
		ifFalse: [
			self class
				numerator: numerator * den + (aScaledDecimal numerator * denominator)
				denominator: denominator * den].
	^fraction scale: s; reduced
]

{ #category : #converting }
ScaledDecimal >> asFloat [
	^numerator asFloat / denominator
]

{ #category : #converting }
ScaledDecimal >> asFraction [
	^Fraction numerator: numerator denominator: denominator
]

{ #category : #private }
ScaledDecimal >> coerce: aNumber [
	^self class fromNumber: aNumber scale: scale
]

{ #category : #private }
ScaledDecimal >> divideIntoScaledDecimal: aScaledDecimal [
	| s fraction |
	s := scale max: aScaledDecimal scale.
	fraction := self class
		numerator: aScaledDecimal numerator * denominator
		denominator: aScaledDecimal denominator * numerator.
	^fraction scale: s; reduced
]

{ #category : #testing }
ScaledDecimal >> isFraction [
	^false
]

{ #category : #private }
ScaledDecimal >> multiplyScaledDecimal: aScaledDecimal [
	| s fraction |
	s := scale max: aScaledDecimal scale.
	fraction := self class
		numerator: aScaledDecimal numerator * numerator
		denominator: aScaledDecimal denominator * denominator.
	^fraction scale: s; reduced
]

{ #category : #arithmetic }
ScaledDecimal >> negated [
	^self class fromNumber: self asFraction negated scale: scale
]

{ #category : #printing }
ScaledDecimal >> printOn: aStream [
	| scaler scaled quo rem |
	scaler := 10 raisedToInteger: scale.
	scaled := numerator * scaler + (denominator bitShift: -1) // denominator.
	numerator < 0 ifTrue: [
		aStream nextPut: $-.
		scaled := scaled negated].
	quo := scaled // scaler.
	rem := scaled \\ scaler.
	quo printOn: aStream.
	scale > 0 ifTrue: [aStream nextPut: $.].
	scale timesRepeat: [
		rem := rem * 10.
		aStream nextPut: (Character digitValue: rem // scaler).
		rem := rem \\ scaler].
	aStream nextPut: $s; nextPutAll: scale asString
]

{ #category : #arithmetic }
ScaledDecimal >> raisedTo: aNumber [
	| fraction |
	fraction := super raisedTo: aNumber.
	^self class fromNumber: fraction scale: scale
]

{ #category : #arithmetic }
ScaledDecimal >> raisedToInteger: aNumber [
	| fraction |
	fraction := super raisedToInteger: aNumber.
	^self class fromNumber: fraction scale: scale
]

{ #category : #arithmetic }
ScaledDecimal >> reciprocal [
	^self class fromNumber: self asFraction reciprocal scale: scale
]

{ #category : #private }
ScaledDecimal >> reduced [
	| gcd |
	gcd := numerator gcd: denominator.
	gcd = 1 ifTrue: [^self].
	^self class
		numerator: numerator // gcd
		denominator: denominator // gcd
		scale: self scale
]

{ #category : #private }
ScaledDecimal >> retry: selector with: argument [
	^argument isFloat
		ifTrue: [(argument coerce: self) perform: selector with: argument]
		ifFalse: [self perform: selector with: (self coerce: argument)]
]

{ #category : #accessing }
ScaledDecimal >> scale [
	^scale
]

{ #category : #accessing }
ScaledDecimal >> scale: anInteger [
	scale := anInteger
]

{ #category : #private }
ScaledDecimal >> setNumerator: num denominator: den scale: s [
	den = 0 ifTrue: [^self zeroDivisorOn: #setNumerator:denominator:scale:].
	denominator := den truncated abs.
	den negative ifTrue: [numerator := numerator negated].
	numerator := num truncated.
	scale := s truncated
]

{ #category : #arithmetic }
ScaledDecimal >> sqrt [
	| sqrt |
	sqrt := self asFraction sqrt.
	^sqrt isFloat
		ifTrue: [sqrt]
		ifFalse: [ScaledDecimal fromNumber: sqrt scale: scale]
]

{ #category : #arithmetic }
ScaledDecimal >> squared [
	^super squared scale: scale
]

{ #category : #printing }
ScaledDecimal >> storeOn: aStream [
	(denominator = 1 or: [(10 raisedTo: scale) \\ denominator = 0])
		ifTrue: [^self printOn: aStream].
	numerator storeOn: aStream.
	aStream nextPut: $/.
	denominator storeOn: aStream.
	aStream nextPut: $s; nextPutAll: scale asString
]

{ #category : #private }
ScaledDecimal >> subtractFromScaledDecimal: aScaledDecimal [
	| s den fraction |
	s := scale max: aScaledDecimal scale.
	den := aScaledDecimal denominator.
	fraction := denominator = den
		ifTrue: [
			self class
				numerator: aScaledDecimal numerator - numerator
				denominator: denominator]
		ifFalse: [
			self class
				numerator: aScaledDecimal numerator * denominator - (numerator * den)
				denominator: denominator * den].
	^fraction scale: s; reduced
]

