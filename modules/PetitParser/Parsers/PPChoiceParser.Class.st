'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPChoiceParser category: #Parsers!
PPListParser subclass: #PPChoiceParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPChoiceParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPChoiceParser methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:39'!
/ aRule
	^ self copyWith: aRule
! !

!PPChoiceParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| element |
	1 to: parsers size do: [:index | 
		element := (parsers at: index) parseOn: aStream.
		element isPetitFailure ifFalse: [^element]].
	^element
! !

!PPChoiceParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	parsers
		do: [:p | p printSmalltalkReceiverOn: rtf]
		separatedBy: [rtf nextPutAll: ' / ']
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPChoiceParser class' category: #Parsers!
PPChoiceParser class
	instanceVariableNames: ''!


