"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Locale,
	#superclass : #Object,
	#instVars : [
		'collator',
		'currency',
		'date',
		'number',
		'time'
	],
	#category : #Kernel
}

{ #category : #execution }
Locale class >> startUp [
	self namespace at: #ActiveLocale put: self new initialize
]

{ #category : #times }
Locale >> amSymbol [
	^time amSymbol
]

{ #category : #currency }
Locale >> currency [
	^currency currency
]

{ #category : #currency }
Locale >> currencyDigits [
	^currency decimalPlaces
]

{ #category : #currency }
Locale >> currencyFormat [
	^currency positiveFormat
]

{ #category : #numbers }
Locale >> dataSeparator [
	^self listSeparator
]

{ #category : #dates }
Locale >> dateFormat [
	^date shortFormat
]

{ #category : #dates }
Locale >> dateFrom: aString [
	| stream |
	stream := aString isString ifTrue: [aString readStream] ifFalse: [aString].
	^date dateFromStream: stream
]

{ #category : #dates }
Locale >> dateSeparator [
	^date separator
]

{ #category : #dates }
Locale >> dayNames [
	^date dayNames
]

{ #category : #numbers }
Locale >> decimalPlaces [
	^number decimalPlaces
]

{ #category : #numbers }
Locale >> decimalSeparator [
	^self decimalSymbol
]

{ #category : #numbers }
Locale >> decimalSymbol [
	^number decimalSymbol
]

{ #category : #currency }
Locale >> formatCurrency: aString [
	^currency format: aString
]

{ #category : #currency }
Locale >> formatNegativeCurrency: aString [
	^currency formatNegative: aString
]

{ #category : #dates }
Locale >> indexOfMonth: aString [
	^date indexOfMonth: aString
]

{ #category : #initialization }
Locale >> initialize [
	collator := Smalltalk os characterCollator new.
	currency := Smalltalk os currencyFormat default.
	date := Smalltalk os dateFormat default.
	number := Smalltalk os numberFormat default.
	time := Smalltalk os timeFormat default
]

{ #category : #strings }
Locale >> isAlphanumeric: aCharacter [
	^collator isAlphanumeric: aCharacter
]

{ #category : #strings }
Locale >> isCharacter: char1 greaterThan: char2 [
	^collator isCharacter: char1 greaterThan: char2
]

{ #category : #strings }
Locale >> isCharacter: char1 greaterThanOrEqualTo: char2 [
	^collator isCharacter: char1 greaterThanOrEqualTo: char2
]

{ #category : #strings }
Locale >> isCharacter: char1 lessThan: char2 [
	^collator isCharacter: char1 lessThan: char2
]

{ #category : #strings }
Locale >> isCharacter: char1 lessThanOrEqualTo: char2 [
	^collator isCharacter: char1 lessThanOrEqualTo: char2
]

{ #category : #numbers }
Locale >> isLetter: aCharacter [
	^collator isLetter: aCharacter
]

{ #category : #strings }
Locale >> isLowercase: aCharacter [
	^collator isLowercase: aCharacter
]

{ #category : #numbers }
Locale >> isNumeric: aCharacter [
	^collator isNumeric: aCharacter
]

{ #category : #times }
Locale >> isTimeFormat12Hour [
	^time is12hr
]

{ #category : #strings }
Locale >> isUppercase: aCharacter [
	^collator isUppercase: aCharacter
]

{ #category : #language }
Locale >> language [
	^date language
]

{ #category : #numbers }
Locale >> listSeparator [
	^number listSeparator
]

{ #category : #dates }
Locale >> longDateFormat [
	^date longFormat
]

{ #category : #strings }
Locale >> lowercaseOf: aCharacter [
	^collator lowercaseOf: aCharacter
]

{ #category : #dates }
Locale >> monthNames [
	^date monthNames
]

{ #category : #dates }
Locale >> nameOfDay: anInteger [
	^date nameOfDay: anInteger
]

{ #category : #dates }
Locale >> nameOfMonth: anInteger [
	^date nameOfMonth: anInteger
]

{ #category : #currency }
Locale >> negativeCurrencyFormat [
	^currency negativeFormat
]

{ #category : #times }
Locale >> pmSymbol [
	^time pmSymbol
]

{ #category : #dates }
Locale >> printShortDate: aDate on: aStream [
	date printShort: aDate on: aStream
]

{ #category : #dates }
Locale >> shortDateFormat [
	^date shortFormat
]

{ #category : #dates }
Locale >> shortDayNames [
	^date shortDayNames
]

{ #category : #dates }
Locale >> shortMonthNames [
	^date shortMonthNames
]

{ #category : #dates }
Locale >> shortNameOfDay: anInteger [
	^date shortNameOfDay: anInteger
]

{ #category : #dates }
Locale >> shortNameOfMonth: anInteger [
	^date shortNameOfMonth: anInteger
]

{ #category : #numbers }
Locale >> thousandsSeparator [
	^number groupingSymbol
]

{ #category : #times }
Locale >> timeSeparator [
	^time separator
]

{ #category : #strings }
Locale >> uppercaseOf: aCharacter [
	^collator uppercaseOf: aCharacter
]

