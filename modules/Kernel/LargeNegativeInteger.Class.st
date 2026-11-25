'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #LargeNegativeInteger category: #Kernel!
LargeInteger subclass: #LargeNegativeInteger
	instanceVariableNames: ''
	classVariableNames: 'LeftLimit'
	poolDictionaries: ''
	category: 'Kernel'!
!LargeNegativeInteger commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!LargeNegativeInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
abs
	^self negated
! !

!LargeNegativeInteger methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asFloat
	^self negated asFloat negated
! !

!LargeNegativeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index
	(index _isSmallInteger and: [index >= 1])
		ifFalse: [^self outOfBoundsIndex: index].
	index > self _size ifTrue: [^16rFF].
	^self byteAtValid: index
! !

!LargeNegativeInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitInvert
	| mask integer |
	mask := Base - 1.
	integer := LargePositiveInteger new: self sizeInBytes.
	1 to: self nbDigits do: [:i | | digit |
		digit := self wideDigitAt: i.
		integer digitAt: i put: (digit bitXor: mask)].
	^integer reduced
! !

!LargeNegativeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyOfSize: n
	| copy |
	copy := LargePositiveInteger new: n.
	self nbDigits + 1 to: copy nbDigits do: [:i | copy digitAt: i put: -1].
	copy from: self.
	^copy
! !

!LargeNegativeInteger methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	-16r20000000000000 <= self ifTrue: [^self asFloat hash].
	^super hash
! !

!LargeNegativeInteger methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
highBit
	"
	Taken from Squeak
	"
	^self error: 'not valid for negative numbers'
! !

!LargeNegativeInteger methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
negative
	^true
! !

!LargeNegativeInteger methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
positive
	^false
! !

!LargeNegativeInteger methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream nextPut: $-.
	self negated printOn: aStream
! !

!LargeNegativeInteger methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
quo: divisor
	| data quo rem |
	divisor isFloat ifTrue: [^self asFloat quo: divisor].
	divisor isFraction ifTrue: [^(divisor reciprocal * self) truncated].
	divisor isInteger ifFalse: [^self error: 'cannot divide'].
	divisor = 0 ifTrue: [^self zeroDivisorOn: #quo].
	data := self quoRem: divisor.
	quo := data at: 1.
	divisor negative ifTrue: [^quo].
	rem := data at: 2.
	^rem = 0 ifTrue: [quo] ifFalse: [quo + 1]
! !

!LargeNegativeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
quoRem: divisor
	| data quo rem s |
	divisor positive
		ifTrue: [
			s := divisor + self.
			s > 0 ifTrue: [^{-1. s}]]
		ifFalse: [self > divisor ifTrue: [^{0. self}]].
	data := self abs computeQuoRem: divisor abs.
	quo := data at: 1.
	rem := data at: 2.
	rem = 0 ifTrue: [
		divisor positive ifTrue: [data at: 1 put: quo negated].
		^data].
	divisor positive ifTrue: [
		^data
			at: 1 put: (quo + 1) negated;
			at: 2 put: divisor - rem;
			yourself].
	^data at: 2 put: rem negated; yourself
! !

!LargeNegativeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
reduced
	| n mask |
	self = LeftLimit ifTrue: [^SmallInteger minimum].
	n := self nbDigits.
	mask := Base - 1.
	[
		n > 1
			and: [(self wideDigitAt: n) = mask]
			and: [(self wideDigitAt: n - 1) highBit = Bits]]
		whileTrue: [n := n - 1].
	^self reducedTo: n
! !

!LargeNegativeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
reducedTo: n
	| hi sign result integer |
	hi := self wideDigitAt: n.
	(n > 4 or: [n = 4 and: [hi < 0xC000]]) ifTrue: [
		integer := self class new: n * DigitLength.
		^integer replaceFrom: 1 to: n * DigitLength with: self startingAt: 1].
	sign := hi bitAnd: 0x8000.
	result := hi - (sign * 2).
	n = 1 ifTrue: [^result].
	result := (result _bitShiftLeft: Bits) + (self wideDigitAt: n - 1).
	n = 2 ifTrue: [^result].
	result := (result _bitShiftLeft: Bits) + (self wideDigitAt: n - 2).
	n = 3 ifTrue: [^result].
	^(result _bitShiftLeft: Bits) + (self wideDigitAt: n - 3)
! !

!LargeNegativeInteger methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sign
	^-1
! !

!LargeNegativeInteger methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
strictlyPositive
	^false
! !

!LargeNegativeInteger methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
wideDigitAt: index
	^(super wideDigitAt: index) ifNil: [Base - 1]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LargeNegativeInteger class' category: #Kernel!
LargeNegativeInteger class
	instanceVariableNames: 'LeftLimit'!

!LargeNegativeInteger class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeConstants
	LeftLimit := self basicNew: WordSize.
	LeftLimit at: WordSize put: 16rC0
! !

!LargeNegativeInteger class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
leftLimit
	^LeftLimit
! !

!LargeNegativeInteger class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	| large |
	large := super new: anInteger.
	1 to: large nbDigits do: [:i | large digitAt: i put: Base - 1].
	^large
! !


