'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ScaledDecimal category: #Kernel!
Fraction subclass: #ScaledDecimal
	instanceVariableNames: 'scale'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ScaledDecimal commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!ScaledDecimal methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
- aNumber
	^aNumber class == self class
		ifTrue: [aNumber subtractFromScaledDecimal: self]
		ifFalse: [self retry: #'-' with: aNumber]
! !

!ScaledDecimal methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
* aNumber
	^aNumber class == self class
		ifTrue: [aNumber multiplyScaledDecimal: self]
		ifFalse: [self retry: #'*' with: aNumber]
! !

!ScaledDecimal methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
/ aNumber
	^aNumber class == self class
		ifTrue: [aNumber divideIntoScaledDecimal: self]
		ifFalse: [self retry: #'/' with: aNumber]
! !

!ScaledDecimal methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
// aNumber
	| q quo |
	q := self / aNumber.
	quo := q floor.
	^(q negative andNot: [q = quo]) ifTrue: [quo] ifFalse: [quo - 1]
! !

!ScaledDecimal methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
+ aNumber
	^aNumber class == self class
		ifTrue: [aNumber addToScaledDecimal: self]
		ifFalse: [self retry: #'+' with: aNumber]
! !

!ScaledDecimal methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
< aNumber
	aNumber = 0 ifTrue: [^numerator < 0].
	^self - aNumber < 0
! !

!ScaledDecimal methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
<= aNumber
	^self < aNumber or: [self = aNumber]
! !

!ScaledDecimal methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aNumber
	self class == aNumber class ifTrue: [^self asFraction = aNumber asFraction].
	^self asFraction = aNumber
! !

!ScaledDecimal methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
> aNumber
	aNumber = 0 ifTrue: [^numerator > 0].
	^self - aNumber > 0
! !

!ScaledDecimal methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
>= aNumber
	^self > aNumber or: [self = aNumber]
! !

!ScaledDecimal methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
addToScaledDecimal: aScaledDecimal
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
! !

!ScaledDecimal methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asFloat
	^numerator asFloat / denominator
! !

!ScaledDecimal methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asFraction
	^Fraction numerator: numerator denominator: denominator
! !

!ScaledDecimal methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
coerce: aNumber
	^self class fromNumber: aNumber scale: scale
! !

!ScaledDecimal methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
divideIntoScaledDecimal: aScaledDecimal
	| s fraction |
	s := scale max: aScaledDecimal scale.
	fraction := self class
		numerator: aScaledDecimal numerator * denominator
		denominator: aScaledDecimal denominator * numerator.
	^fraction scale: s; reduced
! !

!ScaledDecimal methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFraction
	^false
! !

!ScaledDecimal methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
multiplyScaledDecimal: aScaledDecimal
	| s fraction |
	s := scale max: aScaledDecimal scale.
	fraction := self class
		numerator: aScaledDecimal numerator * numerator
		denominator: aScaledDecimal denominator * denominator.
	^fraction scale: s; reduced
! !

!ScaledDecimal methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
negated
	^self class fromNumber: self asFraction negated scale: scale
! !

!ScaledDecimal methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
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
! !

!ScaledDecimal methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
raisedTo: aNumber
	| fraction |
	fraction := super raisedTo: aNumber.
	^self class fromNumber: fraction scale: scale
! !

!ScaledDecimal methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
raisedToInteger: aNumber
	| fraction |
	fraction := super raisedToInteger: aNumber.
	^self class fromNumber: fraction scale: scale
! !

!ScaledDecimal methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
reciprocal
	^self class fromNumber: self asFraction reciprocal scale: scale
! !

!ScaledDecimal methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
reduced
	| gcd |
	gcd := numerator gcd: denominator.
	gcd = 1 ifTrue: [^self].
	^self class
		numerator: numerator // gcd
		denominator: denominator // gcd
		scale: self scale
! !

!ScaledDecimal methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
retry: selector with: argument
	^argument isFloat
		ifTrue: [(argument coerce: self) perform: selector with: argument]
		ifFalse: [self perform: selector with: (self coerce: argument)]
! !

!ScaledDecimal methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
scale
	^scale
! !

!ScaledDecimal methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
scale: anInteger
	scale := anInteger
! !

!ScaledDecimal methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
setNumerator: num denominator: den scale: s
	den = 0 ifTrue: [^self zeroDivisorOn: #setNumerator:denominator:scale:].
	denominator := den truncated abs.
	den negative ifTrue: [numerator := numerator negated].
	numerator := num truncated.
	scale := s truncated
! !

!ScaledDecimal methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
sqrt
	| sqrt |
	sqrt := self asFraction sqrt.
	^sqrt isFloat
		ifTrue: [sqrt]
		ifFalse: [ScaledDecimal fromNumber: sqrt scale: scale]
! !

!ScaledDecimal methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
squared
	^super squared scale: scale
! !

!ScaledDecimal methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storeOn: aStream
	(denominator = 1 or: [(10 raisedTo: scale) \\ denominator = 0])
		ifTrue: [^self printOn: aStream].
	numerator storeOn: aStream.
	aStream nextPut: $/.
	denominator storeOn: aStream.
	aStream nextPut: $s; nextPutAll: scale asString
! !

!ScaledDecimal methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
subtractFromScaledDecimal: aScaledDecimal
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
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ScaledDecimal class' category: #Kernel!
ScaledDecimal class
	instanceVariableNames: ''!

!ScaledDecimal class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromNumber: aNumber scale: anInteger
	| fraction |
	fraction := aNumber asFraction.
	^self
		numerator: fraction numerator
		denominator: fraction denominator
		scale: anInteger
! !

!ScaledDecimal class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromString: aString
	| value i n num den |
	value := super fromString: aString.
	value class == self ifTrue: [^value].
	i := aString indexOf: $..
	i = 0 ifTrue: [^self fromNumber: value scale: 0].
	n := aString size - i.
	num := (aString copyWithout: $.) asInteger.
	den := 10 raisedToInteger: n.
	^self fromNumber: num / den scale: n
! !

!ScaledDecimal class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
numerator: numerator denominator: denominator scale: scale
	"
	ScaledDecimal numerator: 1 denominator: 3 scale: 2
	"
	^(self numerator: numerator denominator: denominator) scale: scale
! !


