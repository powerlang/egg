'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Locale category: #Kernel!
Object subclass: #Locale
	instanceVariableNames: 'currency date number time'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Locale commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Locale methodsFor:  'times' stamp: 'KenD 28/Jun/2026 13:27:38'!
amSymbol
	^time amSymbol
! !

!Locale methodsFor:  'currency' stamp: 'KenD 28/Jun/2026 13:27:38'!
currency
	^currency currency
! !

!Locale methodsFor:  'currency' stamp: 'KenD 28/Jun/2026 13:27:38'!
currencyDigits
	^currency decimalPlaces
! !

!Locale methodsFor:  'currency' stamp: 'KenD 28/Jun/2026 13:27:38'!
currencyFormat
	^currency positiveFormat
! !

!Locale methodsFor:  'numbers' stamp: 'KenD 28/Jun/2026 13:27:38'!
dataSeparator
	^self listSeparator
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
dateFormat
	^date shortFormat
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
dateFrom: aString
	| stream |
	stream := aString isString ifTrue: [aString readStream] ifFalse: [aString].
	^date dateFromStream: stream
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
dateSeparator
	^date separator
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
dayNames
	^date dayNames
! !

!Locale methodsFor:  'numbers' stamp: 'KenD 28/Jun/2026 13:27:38'!
decimalPlaces
	^number decimalPlaces
! !

!Locale methodsFor:  'numbers' stamp: 'KenD 28/Jun/2026 13:27:38'!
decimalSeparator
	^self decimalSymbol
! !

!Locale methodsFor:  'numbers' stamp: 'KenD 28/Jun/2026 13:27:38'!
decimalSymbol
	^number decimalSymbol
! !

!Locale methodsFor:  'currency' stamp: 'KenD 28/Jun/2026 13:27:38'!
formatCurrency: aString
	^currency format: aString
! !

!Locale methodsFor:  'currency' stamp: 'KenD 28/Jun/2026 13:27:38'!
formatNegativeCurrency: aString
	^currency formatNegative: aString
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOfMonth: aString
	^date indexOfMonth: aString
! !

!Locale methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	"Pending....
	currency := Smalltalk os currencyFormat default.
	date := Smalltalk os dateFormat default.
	number := Smalltalk os numberFormat default.
	time := Smalltalk os timeFormat default"
! !

!Locale methodsFor:  'times' stamp: 'KenD 28/Jun/2026 13:27:38'!
isTimeFormat12Hour
	^time is12hr
! !

!Locale methodsFor:  'language' stamp: 'KenD 28/Jun/2026 13:27:38'!
language
	^date language
! !

!Locale methodsFor:  'numbers' stamp: 'KenD 28/Jun/2026 13:27:38'!
listSeparator
	^number listSeparator
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
longDateFormat
	^date longFormat
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
monthNames
	^date monthNames
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
nameOfDay: anInteger
	^date nameOfDay: anInteger
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
nameOfMonth: anInteger
	^date nameOfMonth: anInteger
! !

!Locale methodsFor:  'currency' stamp: 'KenD 28/Jun/2026 13:27:38'!
negativeCurrencyFormat
	^currency negativeFormat
! !

!Locale methodsFor:  'times' stamp: 'KenD 28/Jun/2026 13:27:38'!
pmSymbol
	^time pmSymbol
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
printShortDate: aDate on: aStream
	date printShort: aDate on: aStream
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
shortDateFormat
	^date shortFormat
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
shortDayNames
	^date shortDayNames
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
shortMonthNames
	^date shortMonthNames
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
shortNameOfDay: anInteger
	^date shortNameOfDay: anInteger
! !

!Locale methodsFor:  'dates' stamp: 'KenD 28/Jun/2026 13:27:38'!
shortNameOfMonth: anInteger
	^date shortNameOfMonth: anInteger
! !

!Locale methodsFor:  'numbers' stamp: 'KenD 28/Jun/2026 13:27:38'!
thousandsSeparator
	^number groupingSymbol
! !

!Locale methodsFor:  'times' stamp: 'KenD 28/Jun/2026 13:27:38'!
timeSeparator
	^time separator
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Locale class' category: #Kernel!
Locale class
	instanceVariableNames: ''!

!Locale class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
startUp
	self module namespace at: #ActiveLocale put: self new
! !


Locale initialize!

