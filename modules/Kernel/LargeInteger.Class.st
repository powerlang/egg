'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #LargeInteger category: #Kernel!
Integer subclass: #LargeInteger
	instanceVariableNames: ''
	classVariableNames: 'Base Bits DigitLength'
	poolDictionaries: ''
	category: 'Kernel'!
!LargeInteger commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!LargeInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
- aNumber
	^self + aNumber negated
! !

!LargeInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
& anInteger
	^self bitAnd: anInteger
! !

!LargeInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
* aNumber
	| product |
	aNumber isInteger ifFalse: [^aNumber * self].
	aNumber = 0 ifTrue: [^0].
	product := self abs mult: aNumber abs.
	^self positive == aNumber positive
		ifTrue: [product]
		ifFalse: [product negated]
! !

!LargeInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
/ aNumber
	aNumber isInteger ifFalse: [^(aNumber / self) reciprocal].
	^super / aNumber
! !

!LargeInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
// aNumber
	| data |
	aNumber isZero ifTrue: [^self zeroDivisorOn: #'//'].
	aNumber isFraction ifTrue: [^self * aNumber reciprocal // 1].
	aNumber isFloat ifTrue: [^self asFloat // aNumber].
	aNumber isInteger ifFalse: [
		^self
			error: 'cannot divide ' , self printString , ' by ' , aNumber printString].
	data := self quoRem: aNumber.
	^data at: 1
! !

!LargeInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
\\ aNumber
	| data |
	aNumber isZero ifTrue: [^self zeroDivisorOn: #'\\'].
	aNumber isFraction ifTrue: [^super \\ aNumber].
	aNumber isFloat ifTrue: [^self asFloat \\ aNumber].
	aNumber isInteger ifFalse: [
		^self
			error: 'cannot divide ' , self printString , ' by ' , aNumber printString].
	data := self quoRem: aNumber.
	^data at: 2
! !

!LargeInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
| anInteger
	^self bitOr: anInteger
! !

!LargeInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
+ aNumber
	aNumber isInteger ifFalse: [^aNumber + self].
	aNumber = 0 ifTrue: [^self].
	^self addDigits: aNumber
! !

!LargeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
+= anInteger
	| carry |
	carry := 0.
	1 to: self nbDigits do: [:index | | digit |
		digit := anInteger wideDigitAt: index.
		carry := self adc: digit + carry at: index]
! !

!LargeInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
< aNumber
	| n m |
	aNumber isInteger ifFalse: [^aNumber > self].
	self negative = aNumber negative ifFalse: [^self negative].
	aNumber isSmallInteger ifTrue: [^self negative].
	n := self sizeInBytes.
	m := aNumber sizeInBytes.
	n > m ifTrue: [^self negative].
	n < m ifTrue: [^self positive].
	n // DigitLength to: 1 by: -1 do: [:i | | d e |
		d := self wideDigitAt: i.
		e := aNumber wideDigitAt: i.
		d !!= e ifTrue: [^d < e]].
	^false
! !

!LargeInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
<= aNumber
	| n m |
	aNumber isInteger ifFalse: [^aNumber >= self].
	self negative = aNumber negative ifFalse: [^self negative].
	aNumber isSmallInteger ifTrue: [^self negative].
	n := self sizeInBytes.
	m := aNumber sizeInBytes.
	n > m ifTrue: [^self negative].
	n < m ifTrue: [^self positive].
	n // DigitLength to: 1 by: -1 do: [:i | | d e |
		d := self wideDigitAt: i.
		e := aNumber wideDigitAt: i.
		d = e ifFalse: [^d < e]].
	^true
! !

!LargeInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aNumber
	| n |
	aNumber isInteger ifFalse: [^aNumber = self].
	aNumber isSmallInteger ifTrue: [^false].
	self positive == aNumber positive ifFalse: [^false].
	n := self nbDigits.
	n = (aNumber sizeInBytes + DigitLength - 1 // DigitLength) ifFalse: [^false].
	1
		to: n
		do: [:i | (self wideDigitAt: i) = (aNumber wideDigitAt: i) ifFalse: [^false]].
	^true
! !

!LargeInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
> aNumber
	^(self <= aNumber) not
! !

!LargeInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
>= aNumber
	^(self < aNumber) not
! !

!LargeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
adc: integer at: index
	| s carry |
	s := (self wideDigitAt: index) + integer.
	carry := s >= Base ifTrue: [1] ifFalse: [0].
	self digitAt: index put: (s bitAnd: Base - 1).
	^carry
! !

!LargeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anInteger fromDigit: index
	| integer i shift |
	integer := anInteger.
	i := index.
	shift := Bits negated.
	[integer > 0] whileTrue: [| digit |
		digit := self wideDigitAt: i.
		integer := integer + digit.
		self digitAt: i put: integer.
		integer := integer bitShift: shift.
		i := i + 1]
! !

!LargeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
addDigits: anInteger
	| n integer |
	n := self sizeInBytes max: anInteger sizeInBytes.
	(self positive == anInteger positive
		or: [self positive and: [self highWideDigit highBit = Bits]]
		or: [anInteger highWideDigit highBit = Bits])
		ifTrue: [n := n + DigitLength].
	integer := self copyOfSize: n.
	integer += anInteger.
	((self negative or: [anInteger negative])
		and: [integer highWideDigit highBit = Bits])
		ifTrue: [integer changeClassTo: LargeNegativeInteger].
	^integer reduced
! !

!LargeInteger methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asLargeInteger
	^self
! !

!LargeInteger methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asParameter
	self ASSERT: self sizeInBytes = WordSize.
	^self
! !

!LargeInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitAnd: anInteger
	| n m class s integer |
	anInteger isInteger ifFalse: [^anInteger bitAnd: self].
	anInteger = 0 ifTrue: [^0].
	n := self sizeInBytes.
	m := anInteger sizeInBytes.
	(self negative and: [anInteger negative])
		ifTrue: [
			class := LargeNegativeInteger.
			s := n max: m]
		ifFalse: [
			class := LargePositiveInteger.
			self positive
				ifTrue: [anInteger negative ifTrue: [s := n] ifFalse: [s := n min: m]]
				ifFalse: [s := m]].
	integer := class new: s.
	1 to: integer nbDigits do: [:i | | d e |
		d := self wideDigitAt: i.
		e := anInteger wideDigitAt: i.
		integer digitAt: i put: (d bitAnd: e)].
	^integer reduced
! !

!LargeInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitAt: anInteger
	| i digit |
	i := anInteger - 1 // Bits + 1.
	digit := self wideDigitAt: i.
	i > self nbDigits ifTrue: [^digit bitAnd: 1].
	^digit bitAt: anInteger - 1 \\ Bits + 1
! !

!LargeInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitOr: anInteger
	| n m class s integer |
	anInteger isInteger ifFalse: [^anInteger bitOr: self].
	anInteger = -1 ifTrue: [^-1].
	n := self sizeInBytes.
	m := anInteger sizeInBytes.
	(self positive and: [anInteger positive])
		ifTrue: [
			class := LargePositiveInteger.
			s := n max: m]
		ifFalse: [
			class := LargeNegativeInteger.
			self negative
				ifTrue: [anInteger positive ifTrue: [s := n] ifFalse: [s := n min: m]]
				ifFalse: [s := m].
			s := s + DigitLength].
	integer := class new: s.
	1 to: integer nbDigits do: [:i | | d e |
		d := self wideDigitAt: i.
		e := anInteger wideDigitAt: i.
		integer digitAt: i put: (d bitOr: e)].
	^integer reduced
! !

!LargeInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitShift: delta
	| count bits m result q carry i |
	delta = 0 ifTrue: [^self].
	bits := self nbDigits * Bits + delta.
	bits <= 0 ifTrue: [^0].
	result := self class
		new: bits + 3 // 4 + (Bits / 4) - 1 // (Bits / 4) * DigitLength.
	m := result nbDigits.
	count := delta abs.
	q := count // Bits.
	delta >= 0 ifTrue: [
		carry := 0.
		i := m.
		[i > q] whileTrue: [| d |
			d := self wideDigitAt: i - q.
			result digitAt: i put: d.
			i := i - 1].
		self negative ifTrue: [
			[i > 0] whileTrue: [
				result digitAt: i put: 0.
				i := i - 1]].
		count := count \\ Bits.
		count > 0 ifTrue: [
			1 to: m do: [:j | | d sigma s |
				d := result wideDigitAt: j.
				sigma := d bitShift: count.
				s := (sigma bitAnd: Base - 1) bitOr: carry.
				result digitAt: j put: s.
				carry := d bitShift: count - Bits]].
		^result reduced].
	1 to: m do: [:j | | d |
		d := self wideDigitAt: j + q.
		result digitAt: j put: d].
	count := count \\ Bits.
	count > 0 ifTrue: [
		count := count negated.
		carry := self negative
			ifTrue: [(-1 bitShift: Bits + count) bitAnd: Base - 1]
			ifFalse: [0].
		i := m.
		[i >= 1] whileTrue: [| sigma s |
			sigma := result wideDigitAt: i.
			s := (sigma bitShift: count) bitOr: carry.
			result digitAt: i put: s.
			carry := (sigma bitShift: Bits + count) bitAnd: Base - 1.
			i := i - 1]].
	result := result reduced.
	(self negative and: [result = 0]) ifTrue: [^-1].
	^result
! !

!LargeInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitXor: anInteger
	| n class integer |
	anInteger isInteger ifFalse: [^anInteger bitXor: self].
	n := self sizeInBytes max: anInteger sizeInBytes.
	class := self positive = anInteger positive
		ifTrue: [LargePositiveInteger]
		ifFalse: [LargeNegativeInteger].
	integer := class new: n.
	1 to: integer nbDigits do: [:i | | d e |
		d := self wideDigitAt: i.
		e := anInteger wideDigitAt: i.
		integer digitAt: i put: (d bitXor: e)].
	^integer reduced
! !

!LargeInteger methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
byteAt: i
	^self at: i
! !

!LargeInteger methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
deepCopy
	| copy |
	copy := self class new: self size.
	^copy from: self
! !

!LargeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
digitAt: index put: integer
	| valid |
	valid := integer bitAnd: Base - 1.
	self uShortAtOffset: index - 1 * DigitLength put: valid
! !

!LargeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
digits
	^(1 to: self nbDigits) collect: [:i | (self wideDigitAt: i) hex]
! !

!LargeInteger methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
from: aLargeInteger
	| n |
	n := self sizeInBytes min: aLargeInteger sizeInBytes.
	self replaceFrom: 1 to: n with: aLargeInteger startingAt: 1
! !

!LargeInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	| hash |
	hash := self sizeInBytes.
	1
		to: hash
		do: [:i | hash := (hash hashMultiply: 16r19660D) bitXor: (self at: i)].
	^hash
! !

!LargeInteger methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
highWideDigit
	^self wideDigitAt: self nbDigits
! !

!LargeInteger methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isLargeInteger
	^true
! !

!LargeInteger methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isOnBit: bits
	1 to: bits sizeInBytes + DigitLength - 1 // DigitLength do: [:i | | digit n |
		digit := self wideDigitAt: i.
		n := bits wideDigitAt: i.
		(digit bitAnd: n) = n ifFalse: [^false]].
	^true
! !

!LargeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
nbDigits
	^self sizeInBytes // DigitLength
! !

!LargePositiveInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
outOfBoundsIndex: anInteger
	^self
		error: 'index: ' , anInteger printString
			, ' is outside of large integer bounds'
! !

!LargeInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
negated
	^self bitInvert + 1
! !

!LargeInteger methodsFor:  'replacing' stamp: 'KenD 28/Jun/2026 13:27:38'!
replaceFrom: start to: stop with: aCollection startingAt: position
	^self
		replaceBytesFrom: start
		to: stop
		with: aCollection
		startingAt: position
! !

!LargeInteger methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
shortAtOffset: offset
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 2 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self shortAtValidOffset: offset
! !

!LargeInteger methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
shortAtValidOffset: offset
	| lo hi sign |
	lo := self byteAtValid: offset + 1.
	hi := self byteAtValid: offset + 2.
	sign := hi bitAnd: 16r80.
	hi := hi - (sign * 2).
	^hi * 16r100 + lo
! !

!LargeInteger methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeInBytes
	^self size
! !

!LargeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
uShortAtOffset: offset
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 1 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self uShortAtValidOffset: offset
! !

!LargeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
uShortAtOffset: offset put: anInteger
	offset _isSmallInteger ifFalse: [^self outOfBoundsIndex: offset].
	(0 <= offset and: [offset + 1 <= self _size])
		ifFalse: [^self outOfBoundsIndex: offset].
	^self uShortAtValidOffset: offset put: anInteger
! !

!LargeInteger methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
uShortAtValidOffset: offset
	^(self byteAtValid: offset + 2) * 16r100 + (self byteAtValid: offset + 1)
! !

!LargeInteger methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
uShortAtValidOffset: offset put: anInteger
	anInteger size > 2 ifTrue: [self error: 'does not fit in 16 bits'].
	self _uShortAtOffset: offset put: anInteger.
	^anInteger
! !

!LargeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
wideDigitAt: index
	| offset |
	index <= 0 ifTrue: [self error: 'non positive index'].
	offset := index - 1 * DigitLength.
	^offset + 2 <= self sizeInBytes ifTrue: [self uShortAtOffset: offset]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LargeInteger class' category: #Kernel!
LargeInteger class
	instanceVariableNames: 'Base Bits DigitLength'!

!LargeInteger class methodsFor:  'inspecting' stamp: 'KenD 28/Jun/2026 13:27:38'!
aspects
	^super aspects copyWith: #digits
! !

!LargeInteger class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
base
	^Base
! !

!LargeInteger class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
digitBits
	^Bits
! !

!LargeInteger class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromInteger: anInteger
	| int integer size n large i |
	int := anInteger asInteger.
	integer := int abs.
	size := 0.
	n := self nbDigitsFor: integer.
	i := n.
	[i >= 1 and: [size = 0]] whileTrue: [| digit |
		digit := integer wideDigitAt: i.
		digit > 0 ifTrue: [size := i] ifFalse: [i := i - 1]].
	large := LargePositiveInteger new: size * DigitLength.
	1 to: size do: [:j | | digit |
		digit := integer wideDigitAt: j.
		large digitAt: j put: digit].
	^int >= 0 ifTrue: [large] ifFalse: [large negated]
! !

!LargeInteger class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromInteger: anInteger byteShiftLeft: shift
	| size bytes result start |
	size := anInteger sizeInBytes.
	bytes := size + shift.
	result := anInteger >= 0
		ifTrue: [LargePositiveInteger new: bytes]
		ifFalse: [LargeNegativeInteger new: bytes].
	start := bytes - size.
	1 to: size do: [:i | result at: start + i put: (anInteger at: i)].
	^result
! !

!LargeInteger class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeBase
	Bits := 16.
	Base := 2 raisedToInteger: Bits.
	DigitLength := Bits + 7 // 8
! !

!LargeInteger class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
nbDigitsFor: anInteger
	"
	LargeInteger2 nbDigitsFor: 16r88234567
	"
	^anInteger sizeInBytes + DigitLength - 1 // DigitLength
! !

!LargeInteger class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	^self basicNew: anInteger + DigitLength - 1 // DigitLength * DigitLength
! !


