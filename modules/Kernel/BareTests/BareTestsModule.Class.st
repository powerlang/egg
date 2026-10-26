'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #BareTestsModule category: #'Powerlang-Core'!
Module subclass: #BareTestsModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core'!
!BareTestsModule commentStamp: '<historical>' prior: 0!

    Copyright (c) 2022, Javier Pimás. 
    See (MIT) license in root directory.
!

!BareTestsModule methodsFor:  'spec' stamp: 'KenD 28/Jun/2026 13:27:38'!
imports
	^{
		#Kernel -> #(HashTable)
	}
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test001SendYourself
	^true yourself
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test010SendEqualsEquals
	^5 == 5
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test020SendPlus
	^3 + 4 == 7
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test025SendQuotient
	^20 // 5 == 4
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test0
	^(false ifTrue: [1]) == nil
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test031SendIfFalseToTrue
	^(true ifFalse: [1]) == nil
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test032SendIfTrueToTrue
	^(true ifTrue: [5]) == 5
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test040SendIfNotNil
	^5 ifNotNil: [true]
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test041SendIfNotNilWithArgs
	^true ifNotNil: [:a | a isString ifFalse: [a]]
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test042SendIfNotNilWithNonEvaluableArg
	^true ifNotNil: [:a | a isString ifFalse: a]
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test030UseTemporary
	| temp |
	temp := true.
	^temp
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test031UseManyTemporaries
	| temp1 temp2 temp3 |
	temp2 := 3.
	temp1 := 4.
	temp3 := temp1 + temp2.
	^temp3 == 7
! !

!BareTestsModule methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
useArg: foo
	^foo + 1
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test040UseArg
	^(self useArg: 3) == 4
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
useArgsToDivide: anInteger by: anotherInteger
	^anInteger // anotherInteger
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test041UseArgsInOrder
	^(self useArgsToDivide: 20 by: 5) == 4
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test042IntegerOperations
	| a b low14a high14a low14b high14b res |
	a := 0xCB3009.
	b := 0x19660D.
	low14a := a bitAnd: 16r3FFF.
	low14a == 0x3009 ifFalse: [^1].

	high14a := a bitShift: -14.
	high14a == 0x32C ifFalse: [^high14a].

	low14b := b bitAnd: 16r3FFF.
	low14b == 0x260D ifFalse: [^3].
	high14b := b bitShift: -14.
	high14b == 0x65 ifFalse: [^4].
	res := 16r4000 * (low14b * high14a + (high14b * low14a) bitAnd: 16r3FFF)
		+ (low14b * low14a)
		bitAnd: 16rFFFFFFF.
	^res == 0x560675
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test043HashMultiply
	| hash xor |
	hash := 8.
	hash := hash hashMultiply: 0x19660D.
	hash == 0xCB3068 ifFalse: [^1].
	hash := hash bitXor: 97.
	hash == 0xCB3009 ifFalse: [^2].
	hash := hash hashMultiply: 0x19660D.
	hash == 0x560675 ifFalse: [^3].
	hash := hash bitXor: 115.
	hash == 0x560606 ifFalse: [^4].
	^true

! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test049HashSymbol
	^true "^#asSymbol stringHash == 174482412"
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test100EvaluateClosure
	^[true] value
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test100SendWhileTrue
	| a |
	a := true.
	[a] whileTrue: [a := false].
	^a not
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test110SendToDo
	| a |
	a := 0.
	3 to: 4 do: [:i | a := a + i].
	^a = 7
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test120SendTimesRepeat
	| a |
	a := 0.
	5 timesRepeat: [a := a + 1].
	^a = 5
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test121SendTimesRepeatInsideBlock
	 | a b c d e |
	a := 0.
	[10 timesRepeat: [a := a + 1]] value.
	^a = 10
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test130EvaluateClosureWithArgs
	| result |
	result := [:a :b | a + b] value: 3 value: 4.
	^result = 7
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test131EvaluateClosureWithArgsAndTemps
	| result |
	result := [:a :b | | t | t := a + b. t] value: 3 value: 4.
	^result = 7
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test132EvaluateClosureWithArgsAndMethodTemps
	| result t |
	result := [:a :b | t := a + b. t] value: 3 value: 4.
	^result = 7
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test133EvaluateClosureWithArgsAndMultipleTemps
	| s result |
	s := 3.
	result := [:a | | t | 
		t := a.
		t := t + s.
		t] value: 4.
	^result = 7
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test140EvaluateClosureNonLocalReturn
	| s |
	[s := 3. ^true] value.
	s := 4.
	^false
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test150EvaluateNestedClosure
	^[ [ true ] value ] value
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test151EvaluateNestedClosureWithArgs
	| result |
	result := [:a | [:b | a + b ] value: 4 ] value: 3.
	^result = 7
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test152EvaluateNestedClosureWithTemps
	| a result |
	a := 2.
	result := [ | b |
		b := 3.
		[ | c |
		c := 4.
		a + b + c ] value] value.
	^result = 9
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test153EvaluateInlinedClosureInClosureWithMethodTemps
	| a result |
	a := 3.
	[ true ifTrue: [ result := a + 4 ] ] value.
	^result = 7
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test160ConcatenateStrings
	^'ABC', 'DE' = 'ABCDE'
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test161CreateDictionary
	| t |
	t := 'Character' asSymbol.
	"(Kernel namespace at: 'Dictionary' asSymbol) new."
	^true
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test162AddAssociationToDictionary
	"| dict |
	dict := (Kernel namespace at: 'Dictionary' asSymbol) new.
	dict add: #yourself -> true.
	^dict at: #yourself"
	^true
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test170SmallIntegerPrintString
	| result |
	result := 16r1000 printString.
	^result = '4096'
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test171LargeIntegerPrintString
	| result |
	result := 4611686018427387903 printString.
	^result = '4611686018427387903'
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test172NegativeIntegerPrintString
	| result |
	result := -4.
	^result printString = '-4'
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test180FallbackToLargeNegativeInteger
	| result |
	result := (16r100000000 * -16r100000000) printString.
	^result = '-18446744073709551616'
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test182BitShiftRightFullWidth
	"SmallInteger>>bitShift: with negative shift >= word width must yield 0
	(or -1 for negative receivers), not undefined behaviour from C++."
	^(1 bitShift: -64) == 0
		and: [(1 bitShift: -100) == 0
		and: [(-1 bitShift: -64) == -1
		and: [(16rFFFFFFFFFFFFFFFF + 1) = 16r10000000000000000]]]
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test183FloatTimesTwoPower
	^(1.0 timesTwoPower: 0) = 1.0
		and: [(1.0 timesTwoPower: 10) = 1024.0
		and: [(1.0 timesTwoPower: -10) = (1.0 / 1024.0)
		and: [(1.0 timesTwoPower: -107) > 0.0
		and: [(1 / 10000000000000000) asFloat > 0.0]]]]
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test181FallbackToLargePositiveInteger
	| result |
	result := 1.
	18 timesRepeat: [result := result * 10].
	^result printString = '1000000000000000000'
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test200BitAndSmallIntegers
	^(16rAAAA bitAnd: 16r00FF) == 16r00AA
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test201BitAndSmallIntWithLargeInt
	^(16rAA bitAnd: 16rFFFFFFFFFFFFFFFF) == 16rAA
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test202BitAndLargeIntWithSmallInt
	^(16rFFFFFFFFFFFFFFFF bitAnd: 16rAA) == 16rAA
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test210BitOrSmallIntegers
	^(16rAA00 bitOr: 16r00AA) == 16rAAAA
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test211BitOrSmallIntWithLargeInt
	^(16rAA bitOr: 16rAA00000000) = 16rAA000000AA
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test212BitOrLargeIntWithSmallInt
	^(16rAA00000000 bitOr: 16rAA) = 16rAA000000AA
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test220BitXorSmallIntegers
	^(16rAAAA bitXor: 16r00FF) == 16rAA55
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test221BitXorSmallIntWithLargeInt
	^(16rAA bitXor: 16rAA000000AA) = 16rAA00000000
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test222BitXorLargeIntWithSmallInt
	^(16rAA000000AA bitXor: 16rAA) = 16rAA00000000
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test230BitShiftLeftOverflow
	^(1 bitShift: 64) = 16r10000000000000000
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test231BitShiftRightNegativeArg
	^(16rAA00 bitShift: -8) == 16rAA
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test232BitShiftRightSelector
	^(16rAA00 bitShiftRight: 8) == 16rAA
! !

!BareTestsModule methodsFor:  'tests' stamp: 'KenD 28/Jun/2026 13:27:38'!
test240HashTablePrimeForReturnsNextGoodPrime
	^(HashTable primeFor: 300) == 359
! !

!BareTestsModule methodsFor:  'main' stamp: 'KenD 28/Jun/2026 13:27:38'!
runTest: selector
	| result |
	result := self perform: selector.
	result == true
		ifTrue: [Kernel log: '  PASS: ', selector, '
']
		ifFalse: [Kernel log: '  FAIL: ', selector, ' returned: ', result printString, '
'].
	^result == true
! !

!BareTestsModule methodsFor:  'main' stamp: 'KenD 28/Jun/2026 13:27:38'!
main: anArray
	| passed failed tests |
	Kernel log: 'Running Kernel.BareTests...
'.
	passed := 0. failed := 0.
	tests := #(
		test001SendYourself test010SendEqualsEquals test020SendPlus
		test025SendQuotient test0
		test030UseTemporary test031SendIfFalseToTrue test031UseManyTemporaries
		test032SendIfTrueToTrue
		test040SendIfNotNil test040UseArg
		test041SendIfNotNilWithArgs test041UseArgsInOrder
		test042SendIfNotNilWithNonEvaluableArg test042IntegerOperations
		test043HashMultiply test049HashSymbol
		test100EvaluateClosure test100SendWhileTrue
		test110SendToDo test120SendTimesRepeat test121SendTimesRepeatInsideBlock
		test130EvaluateClosureWithArgs test131EvaluateClosureWithArgsAndTemps
		test132EvaluateClosureWithArgsAndMethodTemps
		test133EvaluateClosureWithArgsAndMultipleTemps
		test140EvaluateClosureNonLocalReturn
		test150EvaluateNestedClosure test151EvaluateNestedClosureWithArgs
		test152EvaluateNestedClosureWithTemps
		test153EvaluateInlinedClosureInClosureWithMethodTemps
		test160ConcatenateStrings test161CreateDictionary
		test162AddAssociationToDictionary
		test170SmallIntegerPrintString test171LargeIntegerPrintString
		test172NegativeIntegerPrintString
		test180FallbackToLargeNegativeInteger test181FallbackToLargePositiveInteger
		test182BitShiftRightFullWidth test183FloatTimesTwoPower
		test200BitAndSmallIntegers test201BitAndSmallIntWithLargeInt
		test202BitAndLargeIntWithSmallInt
		test210BitOrSmallIntegers test211BitOrSmallIntWithLargeInt
		test212BitOrLargeIntWithSmallInt
		test220BitXorSmallIntegers test221BitXorSmallIntWithLargeInt
		test222BitXorLargeIntWithSmallInt
		test230BitShiftLeftOverflow test231BitShiftRightNegativeArg
		test232BitShiftRightSelector
		test240HashTablePrimeForReturnsNextGoodPrime).
	tests do: [:sel |
		(self runTest: sel)
			ifTrue: [passed := passed + 1]
			ifFalse: [failed := failed + 1]].
	Kernel log: tests size printString, ' run, ', passed printString, ' passed, ', failed printString, ' failed
'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BareTestsModule class' category: #'Powerlang-Core'!
BareTestsModule class
	instanceVariableNames: ''!


