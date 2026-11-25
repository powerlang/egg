'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PatternCondition category: #Development!
CodeSearchCondition subclass: #PatternCondition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Development'!
!PatternCondition commentStamp: '<historical>' prior: 0!

	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
!

!PatternCondition methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
compare: aString
	^text match: aString
! !

!PatternCondition methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
proposition
	^'matches'
! !

!PatternCondition methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
text: aString
	| string |
	string := aString trimBlanks.
	string := matchCase ifTrue: [aString] ifFalse: [aString asLowercase].
	string first !!= $* ifTrue: [string := '*' , string].
	string last !!= $* ifTrue: [string := string , '*'].
	super text: string
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PatternCondition class' category: #Development!
PatternCondition class
	instanceVariableNames: ''!


