"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #LargePositiveInteger,
	#superclass : #LargeInteger,
	#type : #bytes,
	#category : #Kernel
}

{ #category : #arithmetic }
LargePositiveInteger >> abs [
	^self
]

{ #category : #accessing }
LargePositiveInteger >> at: index [
	(index _isSmallInteger and: [index >= 1])
		ifFalse: [^self outOfBoundsIndex: index].
	index > self _size ifTrue: [^0].
	^self byteAtValid: index
]

{ #category : #bits }
LargePositiveInteger >> bitAnd: anInteger [
	(anInteger isSmallInteger and: [anInteger > 0])
		ifTrue: [^anInteger bitAnd: self].
	^super bitAnd: anInteger
]

{ #category : #bits }
LargePositiveInteger >> bitInvert [
	| n integer mask |
	n := self highWideDigit highBit = Bits
		ifTrue: [self sizeInBytes + DigitLength]
		ifFalse: [self sizeInBytes].
	integer := LargeNegativeInteger new: n.
	mask := Base - 1.
	1 to: self nbDigits do: [:i | | digit |
		digit := self wideDigitAt: i.
		integer digitAt: i put: (digit bitXor: mask)].
	^integer
]

{ #category : #private }
LargePositiveInteger >> computeQuoRem: divisor [
	| u v n m shift quo qhat a0 b a2 j k t aux qr |
	self sizeInBytes < divisor sizeInBytes ifTrue: [^{0. self}].
	divisor < Base ifTrue: [^self fastQuoRem: divisor].
	shift := Bits - divisor highWideDigit highBit.
	u := self bitShift: shift.
	v := divisor bitShift: shift.
	n := v sizeInBytes + DigitLength - 1 // DigitLength * DigitLength.
	m := u sizeInBytes - n + DigitLength.
	quo := self class new: m.
	b := v highWideDigit.
	j := m // DigitLength.
	n := n // DigitLength.
	aux := self class new: DigitLength * 2.
	qr := Array new: 2.
	[j >= 1] whileTrue: [| a1 rhat |
		k := j + n.
		a0 := u wideDigitAt: k.
		a0 = b ifTrue: [qhat := Base - 1] ifFalse: [
			a1 := u wideDigitAt: k - 1.
			t := a0 < 16r4000 ifTrue: [(a0 bitShift: Bits) + a1] ifFalse: [
				aux
					digitAt: 1 put: a1;
					digitAt: 2 put: a0].
			t isSmallInteger
				ifTrue: [
					qhat := t // b.
					rhat := t - (qhat * b)]
				ifFalse: [
					t twoDigitsQuoRem: b on: qr.
					qhat := qr at: 1.
					rhat := qr at: 2].
			a2 := u wideDigitAt: k - 2.
			qhat > 0 ifTrue: [
				[| s s2 |
					s := qhat * (v wideDigitAt: n - 1).
					s2 := s wideDigitAt: 2.
					s2 > rhat or: [rhat = s2 and: [(s wideDigitAt: 1) > a2]]]
					whileTrue: [
						qhat := qhat - 1.
						rhat := rhat + b]]].
		t := u - (v * (qhat bitShift: j - 1 * Bits)).
		t negative
			ifTrue: [
				u := u - (v * (qhat - 1 bitShift: j - 1 * Bits)).
				quo digitAt: j put: qhat - 1]
			ifFalse: [
				u := t.
				quo digitAt: j put: qhat].
		u = 0 ifTrue: [^{quo reduced. 0}].
		j := j - 1].
	u := u bitShift: shift negated.
	^{quo reduced. u reduced}
]

{ #category : #private }
LargePositiveInteger >> copyOfSize: n [
	| copy |
	copy := LargePositiveInteger new: n.
	copy from: self.
	^copy
]

{ #category : #private }
LargePositiveInteger >> fastQuoRem: divisor [
	| quo u j qr aux |
	quo := self class new: self sizeInBytes.
	u := 0.
	j := self nbDigits.
	qr := Array new: 2.
	aux := self class new: DigitLength * 2.
	[j >= 1] whileTrue: [| b qhat a1 |
		a1 := self wideDigitAt: j.
		b := u < 16r4000 ifTrue: [(u bitShift: Bits) + a1] ifFalse: [
			aux
				digitAt: 1 put: a1;
				digitAt: 2 put: u].
		b isSmallInteger
			ifTrue: [
				qhat := b // divisor.
				u := b \\ divisor]
			ifFalse: [
				b twoDigitsQuoRem: divisor on: qr.
				qhat := qr at: 1.
				u := qr at: 2].
		quo digitAt: j put: qhat.
		j := j - 1].
	self negative ifTrue: [u := u negated].
	^{quo reduced. u}
]

{ #category : #comparing }
LargePositiveInteger >> hash [
	self <= 16r20000000000000 ifTrue: [^self asFloat hash].
	^super hash
]

{ #category : #bits }
LargePositiveInteger >> highBit [
	"
	Taken from Squeak
	"
	| n last |
	n := self nbDigits.
	[(last := self wideDigitAt: n) = 0]
		whileTrue: [(n := n - 1) = 0 ifTrue: [^0]].
	^last highBit + (Bits * (n - 1))
]

{ #category : #private }
LargePositiveInteger >> mult: aNumber [
	| m integer n result |
	m := self nbDigits.
	integer := aNumber.
	n := self class nbDigitsFor: integer.
	result := LargePositiveInteger new: n + m * DigitLength.
	0 to: m - 1 do: [:i | | digit |
		digit := self wideDigitAt: i + 1.
		1 to: n do: [:j | | d |
			d := integer wideDigitAt: j.
			result add: digit * d fromDigit: i + j]].
	^result reduced
]

{ #category : #testing }
LargePositiveInteger >> negative [
	^false
]

{ #category : #testing }
LargePositiveInteger >> positive [
	^true
]

{ #category : #printing }
LargePositiveInteger >> printOn: aStream [
	| digits index quotient |
	digits := OrderedCollection new.
	index := 1.
	quotient := self.
	[quotient isSmallInteger] whileFalse: [| data |
		data := quotient quoRem: 100.
		digits add: (data at: 2).
		quotient := data at: 1.
		index := index + 1].
	quotient printOn: aStream.
	index - 1 to: 1 by: -1 do: [:i | 
		aStream nextPut: (Character value: (digits at: i) // 10 + 48).
		aStream nextPut: (Character value: (digits at: i) \\ 10 + 48)]
]

{ #category : #arithmetic }
LargePositiveInteger >> quo: divisor [
	| data quo rem |
	divisor isFloat ifTrue: [^self asFloat quo: divisor].
	divisor isFraction ifTrue: [^(divisor reciprocal * self) truncated].
	divisor isInteger ifFalse: [^self error: 'cannot divide'].
	divisor = 0 ifTrue: [^self zeroDivisorOn: #quo].
	data := self quoRem: divisor.
	quo := data at: 1.
	rem := data at: 2.
	^rem negative ifTrue: [quo + 1] ifFalse: [quo]
]

{ #category : #private }
LargePositiveInteger >> quoRem: divisor [
	| data quo rem s |
	divisor positive ifTrue: [self < divisor ifTrue: [^{0. self}]] ifFalse: [
		s := self + divisor.
		s < 0 ifTrue: [^{-1. s}]].
	data := self computeQuoRem: divisor abs.
	divisor positive ifTrue: [^data].
	quo := data at: 1.
	rem := data at: 2.
	rem = 0 ifTrue: [^data at: 1 put: quo negated; yourself].
	^data
		at: 1 put: (quo + 1) negated;
		at: 2 put: rem + divisor;
		yourself
]

{ #category : #private }
LargePositiveInteger >> reduced [
	| n result integer |
	n := self nbDigits.
	result := (self wideDigitAt: n) != 0 ifTrue: [self] ifFalse: [
		[
			n > 1 and: [
				n := n - 1.
				(self wideDigitAt: n) = 0]] whileTrue.
		self reducedTo: n].
	result isSmallInteger ifTrue: [^result].
	(result size > WordSize or: [(result at: WordSize) > 63]) ifTrue: [^result].
	integer := 0.
	1
		to: result size // DigitLength
		do: [:i | integer := ((result wideDigitAt: i) bitShift: i - 1 * Bits)
			+ integer].
	^integer
]

{ #category : #private }
LargePositiveInteger >> reducedTo: n [
	| hi result integer |
	hi := self wideDigitAt: n.
	(n > 4 or: [n = 4 and: [hi >= 0x4000]]) ifTrue: [
		integer := self class new: n * DigitLength.
		^integer replaceFrom: 1 to: n * DigitLength with: self startingAt: 1].
	n = 1 ifTrue: [^hi].
	result := (hi _bitShiftLeft: Bits) + (self wideDigitAt: n - 1).
	n = 2 ifTrue: [^result].
	result := (result _bitShiftLeft: Bits) + (self wideDigitAt: n - 2).
	n = 3 ifTrue: [^result].
	^(result _bitShiftLeft: Bits) + (self wideDigitAt: n - 3)
]

{ #category : #accessing }
LargePositiveInteger >> sign [
	^1
]

{ #category : #testing }
LargePositiveInteger >> strictlyPositive [
	^true
]

{ #category : #enumerating }
LargePositiveInteger >> timesRepeat: aBlock [
	| max n |
	max := SmallInteger maximum.
	n := self // max.
	[n > 0] whileTrue: [
		max timesRepeat: aBlock.
		n := n - 1].
	self \\ max timesRepeat: aBlock
]

{ #category : #private }
LargePositiveInteger >> twoDigitDivisionBits [
	true ifTrue: [^2].
	^Bits - (WordSize * 4) + (WordSize * 8 - SmallInteger maximum highBit // 2) * 2
]

{ #category : #private }
LargePositiveInteger >> twoDigitsQuoRem: d on: array [
	| k a d1 s c q1 b rem |
	k := self twoDigitDivisionBits.
	a := self wideDigitAt: 2.
	d1 := d bitShift: k negated.
	s := d bitAnd: (1 bitShift: k) - 1.
	c := a bitShift: Bits - k.
	q1 := c // d1.
	b := self wideDigitAt: 1.
	rem := (c \\ d1 bitShift: k) - (s * q1) + b.
	array
		at: 1 put: rem // d + q1;
		at: 2 put: rem \\ d
]

{ #category : #private }
LargePositiveInteger >> wideDigitAt: index [
	^(super wideDigitAt: index) ifNil: 0
]

