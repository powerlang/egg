'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #BeginningCondition category: #Development!
CodeSearchCondition subclass: #BeginningCondition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Development'!
!BeginningCondition commentStamp: '<historical>' prior: 0!

	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
!

!BeginningCondition methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
compare: aString
	^aString beginsWith: text
! !

!BeginningCondition methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
proposition
	^'begins with'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BeginningCondition class' category: #Development!
BeginningCondition class
	instanceVariableNames: ''!


