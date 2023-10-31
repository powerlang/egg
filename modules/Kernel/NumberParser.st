"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #NumberParser,
	#superclass : #Object,
	#instVars : [
		'stream',
		'error',
		'return'
	],
	#category : #Kernel
}

{ #category : #private }
NumberParser >> checkNumberEnd: position [
	| char |
	stream atEnd ifTrue: [^self].
	char := stream peek.
	char = $. ifFalse: [^self].
	stream skip: 1.
	stream atEnd
		ifFalse: [stream peek isDigit
			ifTrue: [self error: 'invalid number' at: position]].
	stream skip: -1
]

{ #category : #private }
NumberParser >> completeFloat: anInteger [
	| tenth |
	tenth := 10 raisedToInteger: self nextExponent.
	^(anInteger * tenth) asFloat
]

{ #category : #private }
NumberParser >> completeNumber: anInteger after: aCharacter [
	aCharacter = $. ifTrue: [
		^(stream peekFor: $s)
			ifTrue: [self nextScaledFrom: anInteger fractionDigits: 0]
			ifFalse: [self nextFloat: anInteger]].
	(aCharacter = $e or: [aCharacter = $E])
		ifTrue: [^self completeFloat: anInteger].
	aCharacter = $r ifTrue: [^self nextIntegerRadix: anInteger].
	aCharacter = $s ifTrue: [^self nextScaledFrom: anInteger fractionDigits: 0].
	(anInteger = 0 and: [aCharacter = $x or: [aCharacter = $X]])
		ifTrue: [^self nextIntegerRadix: 16].
	stream skip: -1.
	^anInteger
]

{ #category : #private }
NumberParser >> completeNumber: anInteger at: start [
	| number |
	stream atEnd ifTrue: [^anInteger].
	number := anInteger.
	number := self completeNumber: anInteger after: stream next.
	self checkNumberEnd: start.
	^number
]

{ #category : #private }
NumberParser >> digitFromChar: char base: radix [
	| c |
	char isDigit ifTrue: [^char digitValue].
	char = $r ifTrue: [^nil].
	char = $x ifTrue: [^nil].
	char = $X ifTrue: [^nil].
	c := char asUppercase.
	(c asInteger between: $A asInteger and: $Z asInteger) ifFalse: [^nil].
	(c != $E and: [radix <= c digitValue]) ifTrue: [^nil].
	(c = $E and: [radix = 10]) ifTrue: [^nil].
	^c digitValue
]

{ #category : #private }
NumberParser >> endToken [
	self error: 'end of stream' at: stream position
]

{ #category : #accessing }
NumberParser >> error [
	^error
]

{ #category : #private }
NumberParser >> error: aString at: position [
	error := aString -> position.
	return value: nil
]

{ #category : #private }
NumberParser >> negativeNumber [
	| position |
	stream atEnd ifTrue: [^nil].
	stream peek isDigit ifFalse: [^nil].
	position := stream position.
	^self next key negated -> position
]

{ #category : #private }
NumberParser >> next [
	| char |
	return isNil ifTrue: [return := [:value | ^value]].
	char := self nextChar.
	char isNil ifTrue: [^self endToken].
	char = $- ifTrue: [^self negativeNumber].
	char = $+ ifTrue: [^self positiveNumber].
	char isDigit ifTrue: [^self nextNumber: char].
	^nil
]

{ #category : #private }
NumberParser >> nextChar [
	^stream skipWhitespace atEnd ifFalse: [stream next]
]

{ #category : #private }
NumberParser >> nextDigit: radix [
	| char digit |
	stream atEnd ifTrue: [^nil].
	char := stream next.
	digit := self digitFromChar: char base: radix.
	digit isNil ifTrue: [
		stream skip: -1.
		^nil].
	radix <= digit
		ifTrue: [self error: 'digit greater than radix' at: stream position].
	^digit
]

{ #category : #private }
NumberParser >> nextExponent [
	| negated exp |
	negated := false.
	(stream peekFor: $+) ifFalse: [negated := stream peekFor: $-].
	exp := self nextIntegerRadix: 10.
	negated ifTrue: [exp := exp negated].
	^exp
]

{ #category : #private }
NumberParser >> nextFloat: aNumber [
	| base digit e exp |
	digit := self nextDigit: 10.
	digit isNil ifTrue: [
		stream skip: -1.
		^aNumber].
	e := 1.
	base := aNumber * 10 + digit.
	[
		digit := self nextDigit: 10.
		digit isNil]
		whileFalse: [
			base := base * 10 + digit.
			e := e + 1].
	((stream peekFor: $E) or: [stream peekFor: $e]) ifTrue: [
		exp := self nextExponent.
		^(base * (10 raisedToInteger: exp - e)) asFloat].
	(stream peekFor: $s) ifTrue: [^self nextScaledFrom: base fractionDigits: e].
	^(base * (10 raisedToInteger: e negated)) asFloat
]

{ #category : #private }
NumberParser >> nextIntegerRadix: radix [
	| value valid digit |
	value := 0.
	valid := false.
	[
		digit := self nextDigit: radix.
		digit isNil]
		whileFalse: [
			valid := true.
			value := value * radix + digit].
	valid ifFalse: [self error: 'digit missing' at: stream position + 1].
	^value
]

{ #category : #private }
NumberParser >> nextNumber: aCharacter [
	| start number digit |
	start := stream position.
	number := aCharacter digitValue.
	[
		digit := self nextDigit: 10.
		digit isNil]
		whileFalse: [number := number * 10 + digit].
	number := self completeNumber: number at: start.
	^number -> (start thru: stream position)
]

{ #category : #private }
NumberParser >> nextScaledFrom: aNumber fractionDigits: digits [
	| scale denominator sd |
	scale := (stream atEnd not and: [stream peek isDigit])
		ifTrue: [self nextIntegerRadix: 10].
	denominator := 10 raisedToInteger: digits.
	sd := ScaledDecimal
		numerator: aNumber
		denominator: denominator
		scale: scale.
	^sd reduced
]

{ #category : #services }
NumberParser >> nextValue [
	^self next ifNil: [0] ifNotNil: [:assoc | assoc key]
]

{ #category : #accessing }
NumberParser >> on: aString [
	stream := aString readStream.
	return := nil
]

{ #category : #private }
NumberParser >> positiveNumber [
	| position |
	stream peek isDigit ifFalse: [^nil].
	position := stream position.
	^self next key -> position
]

{ #category : #private }
NumberParser >> reset [
	stream reset.
	return := nil
]

