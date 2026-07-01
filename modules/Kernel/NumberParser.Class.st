'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #NumberParser category: #Kernel!
Object subclass: #NumberParser
	instanceVariableNames: 'stream error return'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!NumberParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
checkNumberEnd: position
	| char |
	stream atEnd ifTrue: [^self].
	char := stream peek.
	char = $. ifFalse: [^self].
	stream skip: 1.
	stream atEnd
		ifFalse: [stream peek isDigit
			ifTrue: [self error: 'invalid number' at: position]].
	stream skip: -1
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
completeFloat: anInteger
	| tenth |
	tenth := 10 raisedToInteger: self nextExponent.
	^(anInteger * tenth) asFloat
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
completeNumber: anInteger after: aCharacter
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
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
completeNumber: anInteger at: start
	| number |
	stream atEnd ifTrue: [^anInteger].
	number := anInteger.
	number := self completeNumber: anInteger after: stream next.
	self checkNumberEnd: start.
	^number
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
digitFromChar: char base: radix
	| c |
	char isDigit ifTrue: [^char digitValue].
	char = $r ifTrue: [^nil].
	char = $x ifTrue: [^nil].
	char = $X ifTrue: [^nil].
	c := char asUppercase.
	(c asInteger between: $A asInteger and: $Z asInteger) ifFalse: [^nil].
	(c !!= $E and: [radix <= c digitValue]) ifTrue: [^nil].
	(c = $E and: [radix = 10]) ifTrue: [^nil].
	^c digitValue
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
endToken
	self error: 'end of stream' at: stream position
! !

!NumberParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
error
	^error
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
error: aString at: position
	error := aString -> position.
	return value: nil
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
negativeNumber
	| position |
	stream atEnd ifTrue: [^nil].
	stream peek isDigit ifFalse: [^nil].
	position := stream position.
	^self next key negated -> position
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
next
	| char |
	return isNil ifTrue: [return := [:value | ^value]].
	char := self nextChar.
	char isNil ifTrue: [^self endToken].
	char = $- ifTrue: [^self negativeNumber].
	char = $+ ifTrue: [^self positiveNumber].
	char isDigit ifTrue: [^self nextNumber: char].
	^nil
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextChar
	^stream skipWhitespace atEnd ifFalse: [stream next]
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextDigit: radix
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
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextExponent
	| negated exp |
	negated := false.
	(stream peekFor: $+) ifFalse: [negated := stream peekFor: $-].
	exp := self nextIntegerRadix: 10.
	negated ifTrue: [exp := exp negated].
	^exp
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextFloat: aNumber
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
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextIntegerRadix: radix
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
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextNumber: aCharacter
	| start number digit |
	start := stream position.
	number := aCharacter digitValue.
	[
		digit := self nextDigit: 10.
		digit isNil]
		whileFalse: [number := number * 10 + digit].
	number := self completeNumber: number at: start.
	^number -> (start thru: stream position)
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextScaledFrom: aNumber fractionDigits: digits
	| scale denominator sd |
	scale := (stream atEnd not and: [stream peek isDigit])
		ifTrue: [self nextIntegerRadix: 10].
	denominator := 10 raisedToInteger: digits.
	sd := ScaledDecimal
		numerator: aNumber
		denominator: denominator
		scale: scale.
	^sd reduced
! !

!NumberParser methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextValue
	^self next ifNil: [0] ifNotNil: [:assoc | assoc key]
! !

!NumberParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aString
	stream := aString readStream.
	return := nil
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
positiveNumber
	| position |
	stream peek isDigit ifFalse: [^nil].
	position := stream position.
	^self next key -> position
! !

!NumberParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
reset
	stream reset.
	return := nil
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NumberParser class' category: #Kernel!
NumberParser class
	instanceVariableNames: ''!


