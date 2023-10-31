"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Integer,
	#superclass : #Number,
	#category : #Kernel
}

{ #category : #inspecting }
Integer class >> aspects [
	^#(#hex #bin #oct)
]

{ #category : #'instance creation' }
Integer class >> fromString: aString [
	^self readFrom: aString readStream
]

{ #category : #'instance creation' }
Integer class >> readFrom: aStream [
	| pos value string |
	pos := aStream position.
	value := NumberParser new on: aStream; nextValue.
	value isInteger ifTrue: [^value].
	aStream position: pos.
	string := aStream throughAll: '.'.
	(string endsWith: '.') ifTrue: [aStream skip: -1].
	^NumberParser new on: string; nextValue
]

{ #category : #'instance creation' }
Integer class >> readFrom: aStream radix: radix [
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
]

{ #category : #arithmetic }
Integer >> / aNumber [
	| gcd |
	aNumber isInteger ifFalse: [^aNumber reciprocal * self].
	gcd := self gcd: aNumber.
	^gcd = aNumber abs
		ifTrue: [self // aNumber]
		ifFalse: [Fraction numerator: self // gcd denominator: aNumber // gcd]
]

{ #category : #bits }
Integer >> << bits [
	bits < 0 ifTrue: [self error: 'negative arg'].
	^self bitShift: bits
]

{ #category : #bits }
Integer >> >> bits [
	bits < 0 ifTrue: [self error: 'negative arg'].
	^self bitShift: 0 - bits
]

{ #category : #arithmetic }
Integer >> alignedTo: anInteger [
	^self + anInteger - 1 // anInteger * anInteger
]

{ #category : #testing }
Integer >> anyMask: bits [
	^(self bitAnd: bits) != 0
]

{ #category : #converting }
Integer >> asBoolean [
	^self != 0
]

{ #category : #converting }
Integer >> asByteArray [
	| size array |
	size := self sizeInBytes.
	array := ByteArray new: size.
	^array replaceFrom: 1 to: size with: self startingAt: 1
]

{ #category : #converting }
Integer >> asCharacter [
	^Character value: self
]

{ #category : #converting }
Integer >> asFloat [
	^Float fromInteger: self
]

{ #category : #converting }
Integer >> asFraction [
	^self
]

{ #category : #converting }
Integer >> asInteger [
	^self
]

{ #category : #converting }
Integer >> asLong [
	^ByteArray fromBytes: self length: 4
]

{ #category : #converting }
Integer >> asScaledDecimal [
	"
	17 asScaledDecimal
	"
	^ScaledDecimal fromNumber: self scale: 0
]

{ #category : #converting }
Integer >> asShort [
	| ushort |
	ushort := self bitAnd: 16rFFFF.
	ushort > 16r7FFF ifTrue: [ushort := ushort - 16r10000].
	^ushort
]

{ #category : #converting }
Integer >> asUnsigned [
	^self positive
		ifTrue: [self]
		ifFalse: [self asExternalPointer asUnsignedInteger]
]

{ #category : #arithmetic }
Integer >> benchFibonacci [
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
]

{ #category : #benchmarking }
Integer >> benchSieve [
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
]

{ #category : #bits }
Integer >> bitAt: anInteger [
	^self >= 0
		ifTrue: [1 bitAnd: (self bitShift: 1 - anInteger)]
		ifFalse: [1 - (1 bitAnd: (self bitInvert bitShift: 1 - anInteger))]
]

{ #category : #bits }
Integer >> bitClear: mask [
	"
	(2r111100110 bitClear: 2r111100) = 2r111000010
	"
	^self bitAnd: mask bitInvert
]

{ #category : #bits }
Integer >> bitInvert [
	^-1 - self
]

{ #category : #bits }
Integer >> bitsAt: aStretch [
	"
	(2r001101010 bitField: (3 thru: 6)) bin = '1010'
	(-16r40000000 bitField: (29 thru: 31)) bin = '100'
	"
	| shifted mask |
	shifted := self bitShiftRight: aStretch start - 1.
	mask := 1 bitShift: aStretch length.
	^shifted bitAnd: mask - 1
]

{ #category : #bits }
Integer >> bitsAt: aStretch put: anInteger [
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
]

{ #category : #bits }
Integer >> bitsClear: aStretch [
	"
	(2r111100110 bitsClear: (3 thru: 6)) = 2r111000010
	"
	| mask |
	mask := (1 bitShift: aStretch end) - (1 bitShift: aStretch start - 1).
	^self bitAnd: mask bitInvert
]

{ #category : #bits }
Integer >> bitShift: anInteger [
	| factor |
	factor := 2 raisedToInteger: anInteger abs.
	^anInteger positive ifTrue: [self * factor] ifFalse: [self // factor]
]

{ #category : #bits }
Integer >> bitShiftRight: anInteger [
	^self bitShift: 0 - anInteger
]

{ #category : #arithmetic }
Integer >> ceiling [
	^self
]

{ #category : #private }
Integer >> coerce: aNumber [
	^aNumber asInteger
]

{ #category : #private }
Integer >> digitsBase: anInteger [
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
]

{ #category : #services }
Integer >> externalBytes [
	^ExternalMemory allocate: self
]

{ #category : #services }
Integer >> externalCharacters [
	^ExternalMemory allocate: self + 1 * 2
]

{ #category : #arithmetic }
Integer >> factorial [
	self > 1 ifTrue: [^(self - 1) factorial * self].
	self < 0 ifTrue: [^self error: 'not valid for negative numbers'].
	^1
]

{ #category : #arithmetic }
Integer >> floor [
	^self
]

{ #category : #converting }
Integer >> gbytes [
	^self mbytes * 1024
]

{ #category : #arithmetic }
Integer >> gcd: anInteger [
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
]

{ #category : #private }
Integer >> hashMultiply [
	^(self bitAnd: 16rFFFFFFF) hashMultiply
]

{ #category : #accessing }
Integer >> highWord [
	^(self bitAnd: 16rFFFFFFFF) bitShift: -16
]

{ #category : #testing }
Integer >> isInteger [
	^true
]

{ #category : #testing }
Integer >> isOnBit: n [
	^(self bitAnd: n) = n
]

{ #category : #converting }
Integer >> kbytes [
	^self * 1024
]

{ #category : #arithmetic }
Integer >> lcm: anInteger [
	| gcd |
	gcd := self gcd: anInteger.
	^gcd = 0 ifTrue: [1] ifFalse: [(self // gcd * anInteger) abs]
]

{ #category : #'bit operations' }
Integer >> low32 [
	^self bitAnd: 0xFFFFFFFF
]

{ #category : #bits }
Integer >> lowBit [
	| count mask |
	self = 0 ifTrue: [^nil].
	count := mask := 1.
	[self isOnBit: mask] whileFalse: [
		mask := mask bitShift: 1.
		count := count + 1].
	^count
]

{ #category : #accessing }
Integer >> lowWord [
	^self bitAnd: 16rFFFF
]

{ #category : #converting }
Integer >> mbytes [
	^self kbytes * 1024
]

{ #category : #printing }
Integer >> oct [
	"
	255 oct
	"
	^self radix: 8
]

{ #category : #converting }
Integer >> pointedMemory [
	^ExternalMemory at: self
]

{ #category : #printing }
Integer >> printDigitsOn: aStream base: anInteger [
	self printDigitsOn: aStream base: anInteger paddedTo: 0 with: $0
]

{ #category : #printing }
Integer >> printDigitsOn: aStream
base: bInteger
paddedTo: dInteger
with: aCharacter [
	| digits |
	self < 0 ifTrue: [
		aStream nextPut: $-.
		^self negated printOn: aStream base: bInteger].
	digits := self digitsBase: bInteger.
	(dInteger - digits size max: 0) timesRepeat: [aStream nextPut: aCharacter].
	digits do: [:char | aStream nextPut: char]
]

{ #category : #printing }
Integer >> printOn: aStream base: anInteger [
	self printOn: aStream base: anInteger paddedTo: 0
]

{ #category : #printing }
Integer >> printOn: aStream base: bInteger paddedTo: dInteger [
	self printOn: aStream base: bInteger paddedTo: dInteger with: $0
]

{ #category : #printing }
Integer >> printOn: aStream
base: bInteger
paddedTo: dInteger
with: aCharacter [
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
]

{ #category : #printing }
Integer >> printPaddedTo: anInteger [
	^self printPaddedWith: $  to: anInteger base: 10
]

{ #category : #printing }
Integer >> printPaddedWith: aCharacter to: anInteger [
	"
	0 printPaddedWith: $0 to: 2
	"
	^self
		printPaddedWith: aCharacter
		to: anInteger
		base: 10
]

{ #category : #printing }
Integer >> printPaddedWith: aCharacter to: anInteger base: radix [
	^String
		streamContents: [:strm | self
			printDigitsOn: strm
			base: radix
			paddedTo: anInteger
			with: aCharacter]
]

{ #category : #printing }
Integer >> radix: anInteger [
	| digits |
	digits := self digitsBase: anInteger.
	^String withAll: digits
]

{ #category : #arithmetic }
Integer >> reciprocal [
	^1 / self
]

{ #category : #private }
Integer >> reduced [
	^self
]

{ #category : #arithmetic }
Integer >> rem: aNumber [
	aNumber = 0 ifTrue: [^self zeroDivisorOn: #rem:].
	^super rem: aNumber
]

{ #category : #arithmetic }
Integer >> rounded [
	^self
]

{ #category : #arithmetic }
Integer >> sqrt [
	| float guess |
	float := self asFloat sqrt.
	float isInfinite ifFalse: [
		guess := float truncated.
		guess squared = self ifTrue: [^guess]].
	^float
]

{ #category : #arithmetic }
Integer >> sqrtFloor [
	| guess square delta |
	guess := 1 bitShift: self highBit + 1 // 2.
	[
		square := guess * guess.
		delta := square - self // (guess bitShift: 1).
		delta = 0]
		whileFalse: [guess := guess - delta].
	square = self ifFalse: [guess := guess - 1].
	^guess
]

{ #category : #testing }
Integer >> strictlyPositive [
	^self > 0
]

{ #category : #converting }
Integer >> thru: anInteger [
	^Stretch from: self thru: anInteger
]

{ #category : #enumerating }
Integer >> timesRepeat: aBlock [
	| n |
	n := 1.
	[n <= self] whileTrue: [
		aBlock value.
		n := n + 1]
]

{ #category : #arithmetic }
Integer >> truncated [
	^self
]

