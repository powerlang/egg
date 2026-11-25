'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #SmallInteger category: #Kernel!
Integer subclass: #SmallInteger
	instanceVariableNames: ''
	classVariableNames: 'Maximum Minimum'
	poolDictionaries: ''
	category: 'Kernel'!
!SmallInteger commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
- aNumber
	aNumber _isSmallInteger ifFalse: [^(aNumber - self) negated].	
	^(self _smiMinus: aNumber) ifNil: [self asLargeInteger - aNumber]
! !

!SmallInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
!!= aNumber
	^self errorVMSpecific
! !

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
% aNumber
	^self \\ aNumber
! !

!SmallInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
& anInteger
	^self bitAnd: anInteger
! !

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
* aNumber
	^self errorVMSpecific
! !

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
// aNumber
	| result quotient answer |
	aNumber == 0 ifTrue: [^self zeroDivisorOn: #'//'].
	aNumber _isSmallInteger
		ifTrue: [
			result := self _quotientTowardZero: aNumber.
			^(self >= 0 = (aNumber >= 0) or: [result * aNumber = self])
				ifTrue: [result]
				ifFalse: [result - 1]]
		ifFalse: [
			aNumber isInteger
				ifTrue: [^self = 0 | (self positive = aNumber positive)
					ifTrue: [0]
					ifFalse: [-1]].
			quotient := self / aNumber.
			answer := quotient truncated.
			^(quotient < 0 and: [quotient !!= answer])
				ifTrue: [answer - 1]
				ifFalse: [answer]]
! !

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
\\ aNumber
	self errorVMSpecific
! !

!SmallInteger methodsFor:  'underprimitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
_isSmallInteger
	^true
! !

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
| anInteger
	^self bitOr: anInteger
! !

!SmallInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
~= aNumber
	^aNumber ~= self
! !

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
+ aNumber
	self errorVMSpecific
! !

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
< aNumber
	^aNumber _isSmallInteger
		ifTrue: [self _smiLowerThan: aNumber] 
		ifFalse: [aNumber > self]
! !

!SmallInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
<= aNumber
	^aNumber _isSmallInteger
		ifTrue: [self _smiLowerEqualThan: aNumber] 
		ifFalse: [aNumber >= self]
! !

!SmallInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aNumber
	^self errorVMSpecific
! !

!SmallInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
> aNumber
	^self errorVMSpecific
! !

!SmallInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
>= aNumber
	^self errorVMSpecific
! !

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
asLargeInteger
	| result |
	result := (self positive
		ifTrue: [LargePositiveInteger]
		ifFalse: [LargeNegativeInteger])
		new: WordSize.
	^result from: self
! !

!SmallInteger methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asObject
	^self _asObject
! !

!SmallInteger methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index
	index <= 0 ifTrue: [self error: 'non positive index'].
	index > WordSize ifTrue: [^0].
	^self _smallIntegerByteAt: index
! !

!SmallInteger methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index put: anObject
	^self shouldNotImplement
! !

!SmallInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: index
	index <= 0 ifTrue: [self error: 'non positive index'].
	index > WordSize ifTrue: [^0].
	^self _smallIntegerByteAt: index
! !

!SmallInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicHash
	^self
! !

!SmallInteger methodsFor:  'meta accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
behavior: aBehavior
	self shouldNotImplement
! !

!SmallInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitAnd: anInteger
	anInteger _isSmallInteger ifFalse: [^anInteger bitAnd: self].
	^self _smiBitAnd: anInteger
! !

!SmallInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitAt: anInteger
	anInteger < 1 ifTrue: [self error: 'non positive index'].
	self = 0 ifTrue: [^0].
	^super bitAt: anInteger
! !

!SmallInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitOr: anInteger
	anInteger _isSmallInteger ifFalse: [^anInteger bitOr: self].
	^self _smiBitOr: self
! !

!SmallInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitShift: anInteger
	anInteger = 0 ifTrue: [^self].
	^anInteger > 0
		ifTrue: [self bitShiftLeft: anInteger]
		ifFalse: [self bitShiftRight: 0 - anInteger]
! !

!SmallInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitShiftLeft: anInteger
	| result bits total bytes hi lo shift |
	anInteger < (WordSize * 8 - 1) ifTrue: [
		result := self _bitShiftLeft: anInteger.
		result ifNotNil: [^result]].
	self = 0 ifTrue: [^0].
	self < 0 ifTrue: [^(self negated bitShiftLeft: anInteger) negated].
	total := anInteger + self highBit.
	bytes := total + 7 _bitShiftRight: 3.
	bits := anInteger bitAnd: 7.
	bits = 0
		ifTrue: [^LargeInteger
			fromInteger: self
			byteShiftLeft: bytes - self sizeInBytes].
	hi := self _bitShiftRight: 8 - bits.
	lo := (self bitAnd: 0xFF) _bitShiftLeft: bits.
	hi := hi bitOr: (lo at: 2).
	lo := lo bitAnd: 0xFF.
	hi = 0 ifTrue: [^LargeInteger fromInteger: lo byteShiftLeft: bytes - 1].
	shift := bytes - hi sizeInBytes.
	result := LargeInteger fromInteger: hi byteShiftLeft: shift.
	result at: shift put: lo.
	^result
! !

!SmallInteger methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitShiftRight: anInteger
	^anInteger <= (WordSize * 8 - 2)
		ifTrue: [self _bitShiftRight: anInteger]
		ifFalse: [self >= 0 ifTrue: [0] ifFalse: [-1]]
! !

!SmallInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitXor: anInteger
	^anInteger bitXor: self
! !

!SmallInteger methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
byteAt: anInteger
	^self at: anInteger
! !

!SmallInteger methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
byteAt: anInteger put: byte
	^self at: anInteger put: byte
! !

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
gcd: anInteger
	| n m |
	n := self.
	m := anInteger.
	[n = 0] whileFalse: [n := m \\ (m := n)].
	^m abs
! !

!SmallInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^self
! !

!SmallInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashMultiply
	^self hashMultiply: 16r19660D
! !

!SmallInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashMultiply: aNumber
	| low14a high14a low14b high14b |
	(self < 162 and: [aNumber == 16r19660D]) ifTrue: [^self * 16r19660D].
	low14a := self bitAnd: 16r3FFF.
	high14a := (self bitShift: -14) bitAnd: 16r3FFF.
	low14b := aNumber bitAnd: 16r3FFF.
	high14b := (aNumber bitShift: -14) bitAnd: 16r3FFF.
	^16r4000 * (low14b * high14a + (high14b * low14a) bitAnd: 16r3FFF)
		+ (low14b * low14a)
		bitAnd: 16rFFFFFFF
! !

!SmallInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
highBit
	self < 0 ifTrue: [^self error: 'not valid for negative numbers'].
	^(WordSize _bitShiftLeft: 3) - self _leadingZeroBitCount
! !

!SmallInteger methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
highDigit
	| n b |
	n := self sizeInBytes.
	b := self at: n.
	b = 0 ifTrue: [^self at: n - 1].
	^b
! !

!SmallInteger methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
highWideDigit
	| highest |
	highest := self sizeInBytes.
	(highest bitAnd: 1) = 1 ifTrue: [highest := highest + 1].
	^((self at: highest) bitShift: 8) + (self at: highest - 1)
! !

!SmallInteger methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isFixedObject
	^true
! !

!SmallInteger methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isSmallInteger
	^true
! !

!SmallInteger methodsFor:  'bit operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
low32
	^WordSize > 4 ifTrue: [self bitAnd: 0xFFFFFFFF] ifFalse: [self]
! !

!SmallInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
marshalOn: aStream
	aStream _nextNativePut: self
! !

!SmallInteger methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:38'!
negated
	self = Minimum ifTrue: [^Maximum + 1].
	^super negated
! !

!SmallInteger methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	| abs divisor digit |
	abs := self < 0
		ifTrue: [
			aStream nextPut: $-.
			abs := 0 - self]
		ifFalse: [self].
	divisor := 1.
	[divisor > abs] whileFalse: [divisor := divisor * 10].
	[
		divisor := divisor // 10.
		divisor > 1]
		whileTrue: [
			digit := Character digitValue: abs // divisor.
			aStream nextPut: digit.
			abs := abs \\ divisor].
	digit := Character digitValue: abs.
	aStream nextPut: digit
! !

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
quo: aNumber
	| result |
	aNumber == 0 ifTrue: [^self zeroDivisorOn: #quo:].
	aNumber _isSmallInteger
		ifTrue: [^self _quotientTowardZero: aNumber]
		ifFalse: [
			result := self abs // aNumber abs.
			^self sign == aNumber sign ifTrue: [result] ifFalse: [0 - result]]
! !

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
quoRem1: anInteger
	^{self // anInteger. self \\ anInteger}
! !

!SmallInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
rem: aNumber
	^super rem: aNumber
! !

!SmallInteger methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:38'!
requireFinalization
	^self
! !

!SmallInteger methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sizeInBytes
	^self = 0
		ifTrue: [1]
		ifFalse: [WordSize - (self _leadingZeroBitCount _bitShiftRight: 3)]
! !

!SmallInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
wideDigitAt: index
	index <= 0 ifTrue: [self error: 'non positive index'].
	^(self bitShift: 1 - index * LargeInteger digitBits)
		bitAnd: LargeInteger base - 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SmallInteger class' category: #Kernel!
SmallInteger class
	instanceVariableNames: 'Maximum Minimum'!

!SmallInteger class methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
canBeDeleted
	^false
! !

!SmallInteger class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeConstants
	Maximum := (1 bitShift: WordSize * 8 - 2) - 1.
	Minimum := Maximum negated - 1
! !

!SmallInteger class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
maximum
	^Maximum
! !

!SmallInteger class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:27:38'!
minimum
	^Minimum
! !


