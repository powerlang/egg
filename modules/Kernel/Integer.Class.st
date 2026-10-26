'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Integer category: #Kernel!
Number subclass: #Integer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Integer commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
/ aNumber
	| gcd |
	aNumber isInteger ifFalse: [^aNumber reciprocal * self].
	gcd := self gcd: aNumber.
	^gcd = aNumber abs
		ifTrue: [self // aNumber]
		ifFalse: [Fraction numerator: self // gcd denominator: aNumber // gcd]
! !

!Integer methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
<< bits
	bits < 0 ifTrue: [self error: 'negative arg'].
	^self bitShift: bits
! !

!Integer methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
>> bits
	bits < 0 ifTrue: [self error: 'negative arg'].
	^self bitShift: 0 - bits
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
alignedTo: anInteger
	^self + anInteger - 1 // anInteger * anInteger
! !

!Integer methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
anyMask: bits
	^(self bitAnd: bits) !!= 0
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asBoolean
	^self !!= 0
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asByteArray
	| size array |
	size := self sizeInBytes.
	array := ByteArray new: size.
	^array replaceFrom: 1 to: size with: self startingAt: 1
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asCharacter
	^Character value: self
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asFloat
	^Float fromInteger: self
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asFraction
	^self
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asInteger
	^self
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asLong
	^ByteArray fromBytes: self length: 4
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asScaledDecimal
	"
	17 asScaledDecimal
	"
	^ScaledDecimal fromNumber: self scale: 0
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asShort
	| ushort |
	ushort := self bitAnd: 16rFFFF.
	ushort > 16r7FFF ifTrue: [ushort := ushort - 16r10000].
	^ushort
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asUnsigned
	^self positive
		ifTrue: [self]
		ifFalse: [self asExternalPointer asUnsignedInteger]
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
benchFibonacci
	"
	Handy send-heavy benchmark
	(result // seconds to run) = approx calls per second
	| r t |
	t := Time millisecondsToRun: [r := 26 benchFib].
	(r * 1000) // t
	138000 on a Mac 8100/100
	"
	^self < 2
		ifTrue: [1]
		ifFalse: [(self - 1) benchFibonacci + (self - 2) benchFibonacci + 1]
! !

!Integer methodsFor:  'benchmarking' stamp: 'KenD 28/Jun/2026 13:27:38'!
benchSieve
	"
	Bytecode heavy benchmark
	(500000 // time to run) = approx bytecodes per second
	5000000 // (Time millisecondsToRun: [10 benchSieve]) * 1000
	3059000 on a Mac 8100/100
	"
	| size flags prime k count |
	size := 8190.
	1 to: self do: [:iter |
		count := 0.
		flags := (Array new: size) atAllPut: true.
		1 to: size do: [:i |
			(flags at: i) ifTrue: [
				prime := i + 1.
				k := i + prime.
				[k <= size] whileTrue: [
					flags at: k put: false.
					k := k + prime].
				count := count + 1]]].
	^count
! !

!Integer methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitAt: anInteger
	^self >= 0
		ifTrue: [1 bitAnd: (self bitShift: 1 - anInteger)]
		ifFalse: [1 - (1 bitAnd: (self bitInvert bitShift: 1 - anInteger))]
! !

!Integer methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitClear: mask
	"
	(2r111100110 bitClear: 2r111100) = 2r111000010
	"
	^self bitAnd: mask bitInvert
! !

!Integer methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitInvert
	^-1 - self
! !

!Integer methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitsAt: aStretch
	"
	(2r001101010 bitField: (3 thru: 6)) bin = '1010'
	(-16r40000000 bitField: (29 thru: 31)) bin = '100'
	"
	| shifted mask |
	shifted := self bitShiftRight: aStretch start - 1.
	mask := 1 bitShift: aStretch length.
	^shifted bitAnd: mask - 1
! !

!Integer methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitsAt: aStretch put: anInteger
	"
	((2r001101100 bitsAt: (3 thru: 6) put: 2r1101) bitField: (3 thru: 6)) bin = '1101'
	((2r100 bitsAt: (29 thru: 31) put: 2r101) bitField: (29 thru: 31)) bin = '101'
	((2r100 bitsAt: (29 thru: 31) put: 2r101) bitField: (1 thru: 3)) bin = '100'
	"
	| shifted max |
	shifted := anInteger bitShift: aStretch start - 1.
	max := 1 bitShift: aStretch length.
	anInteger < max ifFalse: [self error: 'invalid argument'].
	^(self bitsClear: aStretch) bitOr: shifted
! !

!Integer methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitsClear: aStretch
	"
	(2r111100110 bitsClear: (3 thru: 6)) = 2r111000010
	"
	| mask |
	mask := (1 bitShift: aStretch end) - (1 bitShift: aStretch start - 1).
	^self bitAnd: mask bitInvert
! !

!Integer methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitShift: anInteger
	| factor |
	factor := 2 raisedToInteger: anInteger abs.
	^anInteger positive ifTrue: [self * factor] ifFalse: [self // factor]
! !

!Integer methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
bitShiftRight: anInteger
	^self bitShift: 0 - anInteger
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
ceiling
	^self
! !

!Integer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
coerce: aNumber
	^aNumber asInteger
! !

!Integer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
digitsBase: anInteger
	"
	12345 digitsBase: 1
	"
	| remainders quo char n digits |
	remainders := OrderedCollection new: 20.
	quo := self abs.
	[anInteger <= quo] whileTrue: [
		char := Character digitValue: quo \\ anInteger.
		remainders add: char.
		quo := quo // anInteger].
	char := Character digitValue: quo.
	remainders add: char.
	n := remainders size.
	digits := Array new: n.
	1 to: n do: [:i | digits at: i put: (remainders at: n - i + 1)].
	^digits
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
factorial
	self > 1 ifTrue: [^(self - 1) factorial * self].
	self < 0 ifTrue: [^self error: 'not valid for negative numbers'].
	^1
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
floor
	^self
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
gbytes
	^self mbytes * 1024
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
gcd: anInteger
	"
	See Knuth, Vol 2, 4.5.2, Algorithm L
	"
	| higher u v k uHat vHat a b c d vPrime vPrimePrime q t |
	higher := SmallInteger maximum highBit.
	u := self abs max: (v := anInteger abs).
	v := self abs min: v.
	[v class == SmallInteger] whileFalse: [
		(uHat := u bitShift: (k := higher - u highBit)) class == SmallInteger
			ifFalse: [
				k := k - 1.
				uHat := uHat bitShift: -1].
		vHat := v bitShift: k.
		a := d := 1.
		b := c := 0.
		[
			(vPrime := vHat + d) ~= 0 and: [
				(vPrimePrime := vHat + c) ~= 0
					and: [(q := uHat + a // vPrimePrime) = (uHat + b // vPrime)]]]
			whileTrue: [
				c := a - (q * (a := c)).
				d := b - (q * (b := d)).
				vHat := uHat - (q * (uHat := vHat))].
		b = 0 ifTrue: [v := u rem: (u := v)] ifFalse: [
			t := u * a + (v * b).
			v := u * c + (v * d).
			u := t]].
	^v gcd: u
! !

!Integer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashMultiply
	^(self bitAnd: 16rFFFFFFF) hashMultiply
! !

!Integer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
highWord
	^(self bitAnd: 16rFFFFFFFF) bitShift: -16
! !

!Integer methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isInteger
	^true
! !

!Integer methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isOnBit: n
	^(self bitAnd: n) = n
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
kbytes
	^self * 1024
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
lcm: anInteger
	| gcd |
	gcd := self gcd: anInteger.
	^gcd = 0 ifTrue: [1] ifFalse: [(self // gcd * anInteger) abs]
! !

!Integer methodsFor:  'bit operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
low32
	^self bitAnd: 0xFFFFFFFF
! !

!Integer methodsFor:  'bits' stamp: 'KenD 28/Jun/2026 13:27:38'!
lowBit
	| count mask |
	self = 0 ifTrue: [^nil].
	count := mask := 1.
	[self isOnBit: mask] whileFalse: [
		mask := mask bitShift: 1.
		count := count + 1].
	^count
! !

!Integer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
lowWord
	^self bitAnd: 16rFFFF
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
mbytes
	^self kbytes * 1024
! !

!Integer methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
oct
	"
	255 oct
	"
	^self radix: 8
! !

!Integer methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printDigitsOn: aStream base: anInteger
	self printDigitsOn: aStream base: anInteger paddedTo: 0 with: $0
! !

!Integer methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printDigitsOn: aStream base: bInteger paddedTo: dInteger with: aCharacter
	| digits |
	self < 0 ifTrue: [
		aStream nextPut: $-.
		^self negated printOn: aStream base: bInteger].
	digits := self digitsBase: bInteger.
	(dInteger - digits size max: 0) timesRepeat: [aStream nextPut: aCharacter].
	digits do: [:char | aStream nextPut: char]
! !

!Integer methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream base: anInteger
	self printOn: aStream base: anInteger paddedTo: 0
! !

!Integer methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream base: bInteger paddedTo: dInteger
	self printOn: aStream base: bInteger paddedTo: dInteger with: $0
! !

!Integer methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream base: bInteger paddedTo: dInteger with: aCharacter
	self < 0 ifTrue: [
		aStream nextPut: $-.
		^self negated printOn: aStream base: bInteger].
	bInteger = 10 ifFalse: [
		bInteger = 16 ifTrue: [aStream nextPutAll: '0x'] ifFalse: [
			bInteger printDigitsOn: aStream base: 10.
			aStream nextPut: $r]].
	self
		printDigitsOn: aStream
		base: bInteger
		paddedTo: dInteger
		with: aCharacter
! !

!Integer methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printPaddedTo: anInteger
	^self printPaddedWith: $  to: anInteger base: 10
! !

!Integer methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printPaddedWith: aCharacter to: anInteger
	"
	0 printPaddedWith: $0 to: 2
	"
	^self
		printPaddedWith: aCharacter
		to: anInteger
		base: 10
! !

!Integer methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printPaddedWith: aCharacter to: anInteger base: radix
	^String
		streamContents: [:strm | self
			printDigitsOn: strm
			base: radix
			paddedTo: anInteger
			with: aCharacter]
! !

!Integer methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
radix: anInteger
	| digits |
	digits := self digitsBase: anInteger.
	^String withAll: digits
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
reciprocal
	^1 / self
! !

!Integer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
reduced
	^self
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
rem: aNumber
	aNumber = 0 ifTrue: [^self zeroDivisorOn: #rem:].
	^super rem: aNumber
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
rounded
	^self
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
sqrt
	| float guess |
	float := self asFloat sqrt.
	float isInfinite ifFalse: [
		guess := float truncated.
		guess squared = self ifTrue: [^guess]].
	^float
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
sqrtFloor
	| guess square delta |
	guess := 1 bitShift: self highBit + 1 // 2.
	[
		square := guess * guess.
		delta := square - self // (guess bitShift: 1).
		delta = 0]
		whileFalse: [guess := guess - delta].
	square = self ifFalse: [guess := guess - 1].
	^guess
! !

!Integer methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
strictlyPositive
	^self > 0
! !

!Integer methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
thru: anInteger
	^Stretch from: self thru: anInteger
! !

!Integer methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
timesRepeat: aBlock
	| n |
	n := 1.
	[n <= self] whileTrue: [
		aBlock value.
		n := n + 1]
! !

!Integer methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
truncated
	^self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Integer class' category: #Kernel!
Integer class
	instanceVariableNames: ''!

!Integer class methodsFor:  'inspecting' stamp: 'KenD 28/Jun/2026 13:27:38'!
aspects
	^#(#hex #bin #oct)
! !

!Integer class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
fromString: aString
	^self readFrom: aString readStream
! !

!Integer class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
readFrom: aStream
	| pos value string |
	pos := aStream position.
	value := NumberParser new on: aStream; nextValue.
	value isInteger ifTrue: [^value].
	aStream position: pos.
	string := aStream throughAll: '.'.
	(string endsWith: '.') ifTrue: [aStream skip: -1].
	^NumberParser new on: string; nextValue
! !

!Integer class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
readFrom: aStream radix: radix
	| integer positive digit |
	integer := 0.
	positive := aStream peekFor: $+.
	positive ifFalse: [positive := (aStream peekFor: $-) not].
	[| char |
		char := aStream peek.
		char notNil and: [
			(char isDigit or: [char isLetter]) and: [
				digit := char digitValue.
				digit < radix]]]
		whileTrue: [
			integer := integer * radix + digit.
			aStream next].
	^positive ifTrue: [integer] ifFalse: [integer negated]
! !


