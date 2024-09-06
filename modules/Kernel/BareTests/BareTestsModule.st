"
    Copyright (c) 2022, Javier Pimás. 
    See (MIT) license in root directory.
"

Class {
	#name : #BareTestsModule,
	#superclass : #Module,
	#instVars : [],
	#category : #'Powerlang-Core'
}

{ #category : #tests }
BareTestsModule >> test001SendYourself [
	^true yourself
]

{ #category : #tests }
BareTestsModule >> test010SendEqualsEquals [
	^5 == 5
]

{ #category : #tests }
BareTestsModule >> test020SendPlus [
	^3 + 4 == 7
]

{ #category : #tests }
BareTestsModule >> test025SendQuotient [
	^20 // 5 == 4
]

{ #category : #tests }
BareTestsModule >> test0 [
	^(false ifTrue: [1]) == nil
]

{ #category : #tests }
BareTestsModule >> test031SendIfFalseToTrue [
	^(true ifFalse: [1]) == nil
]

{ #category : #tests }
BareTestsModule >> test032SendIfTrueToTrue [
	^(true ifTrue: [5]) == 5
]

{ #category : #tests }
BareTestsModule >> test040SendIfNotNil [
	^5 ifNotNil: [true]
]

{ #category : #tests }
BareTestsModule >> test041SendIfNotNilWithArgs [
	^true ifNotNil: [:a | a isString ifFalse: [a]]
]

{ #category : #tests }
BareTestsModule >> test042SendIfNotNilWithNonEvaluableArg [
	^true ifNotNil: [:a | a isString ifFalse: a]
]

{ #category : #tests }
BareTestsModule >> test030UseTemporary [
	| temp |
	temp := true.
	^temp
]

{ #category : #tests }
BareTestsModule >> test031UseManyTemporaries [
	| temp1 temp2 temp3 |
	temp2 := 3.
	temp1 := 4.
	temp3 := temp1 + temp2.
	^temp3 == 7
]

{ #category : #private }
BareTestsModule >> useArg: foo [
	^foo + 1
]

{ #category : #tests }
BareTestsModule >> test040UseArg [
	^(self useArg: 3) == 4
]

{ #category : #tests }
BareTestsModule >> useArgsToDivide: anInteger by: anotherInteger [
	^anInteger // anotherInteger
]

{ #category : #tests }
BareTestsModule >> test041UseArgsInOrder [
	^(self useArgsToDivide: 20 by: 5) == 4
]

{ #category : #tests }
BareTestsModule >> test042IntegerOperations [
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
]

{ #category : #tests }
BareTestsModule >> test043HashMultiply [
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

]

{ #category : #tests }
BareTestsModule >> test049HashSymbol [
	^true "^#asSymbol stringHash == 174482412"
]


{ #category : #tests }
BareTestsModule >> test100EvaluateClosure [
	^[true] value
]

{ #category : #tests }
BareTestsModule >> test100SendWhileTrue [
	| a |
	a := true.
	[a] whileTrue: [a := false].
	^a not
]

{ #category : #tests }
BareTestsModule >> test110SendToDo [
	| a |
	a := 0.
	3 to: 4 do: [:i | a := a + i].
	^a = 7
]

{ #category : #tests }
BareTestsModule >> test120SendTimesRepeat [
	| a |
	a := 0.
	5 timesRepeat: [a := a + 1].
	^a = 5
]

{ #category : #tests }
BareTestsModule >> test121SendTimesRepeatInsideBlock [
	 | a b c d e |
	a := 0.
	[10 timesRepeat: [a := a + 1]] value.
	^a = 10
]

{ #category : #tests }
BareTestsModule >> test130EvaluateClosureWithArgs [
	| result |
	result := [:a :b | a + b] value: 3 value: 4.
	^result = 7
]

{ #category : #tests }
BareTestsModule >> test131EvaluateClosureWithArgsAndTemps [
	| result |
	result := [:a :b | | t | t := a + b. t] value: 3 value: 4.
	^result = 7
]

{ #category : #tests }
BareTestsModule >> test132EvaluateClosureWithArgsAndMethodTemps [
	| result t |
	result := [:a :b | t := a + b. t] value: 3 value: 4.
	^result = 7
]

{ #category : #tests }
BareTestsModule >> test133EvaluateClosureWithArgsAndMultipleTemps [
	| s result |
	s := 3.
	result := [:a | | t | 
		t := a.
		t := t + s.
		t] value: 4.
	^result = 7
]

{ #category : #tests }
BareTestsModule >> test140EvaluateClosureNonLocalReturn [
	| s |
	[s := 3. ^true] value.
	s := 4.
	^false
]

{ #category : #tests }
BareTestsModule >> test150EvaluateNestedClosure [
	^[ [ true ] value ] value
]

{ #category : #tests }
BareTestsModule >> test151EvaluateNestedClosureWithArgs [
	| result |
	result := [:a | [:b | a + b ] value: 4 ] value: 3.
	^result = 7
]

{ #category : #tests }
BareTestsModule >> test152EvaluateNestedClosureWithTemps [
	| a result |
	a := 2.
	result := [ | b |
		b := 3.
		[ | c |
		c := 4.
		a + b + c ] value] value.
	^result = 9
]

{ #category : #tests }
BareTestsModule >> test153EvaluateInlinedClosureInClosureWithMethodTemps [
	| a result |
	a := 3.
	[ true ifTrue: [ result := a + 4 ] ] value.
	^result = 7
]

{ #category : #tests }
BareTestsModule >> test160ConcatenateStrings [
	^'ABC', 'DE' = 'ABCDE'
]

{ #category : #tests }
BareTestsModule >> test161CreateDictionary [
	| t |
	t := 'Character' asSymbol.
	"(Kernel namespace at: 'Dictionary' asSymbol) new."
	^true
]

{ #category : #tests }
BareTestsModule >> test162AddAssociationToDictionary [
	"| dict |
	dict := (Kernel namespace at: 'Dictionary' asSymbol) new.
	dict add: #yourself -> true.
	^dict at: #yourself"
	^true
]

{ #category : #tests }
BareTestsModule >> test170SmallIntegerPrintString [
	| result |
	result := 16r1000 printString.
	^result = '4096'
]

{ #category : #tests }
BareTestsModule >> test171LargeIntegerPrintString [
	| result |
	result := 4611686018427387903 printString.
	^result = '4611686018427387903'
]

{ #category : #tests }
BareTestsModule >> test172NegativeIntegerPrintString [
	| result |
	result := -4.
	^result printString = '-4'
]

{ #category : #tests }
BareTestsModule >> test180FallbackToLargeNegativeInteger [
	| result |
	result := (16r100000000 * -16r100000000) printString.
	^result = '-18446744073709551616'
]

{ #category : #tests }
BareTestsModule >> test181FallbackToLargePositiveInteger [
	| result |
	result := 1.
	18 timesRepeat: [result := result * 10].
	^result printString = '1000000000000000000'
]