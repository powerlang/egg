'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #ExactMatchCondition category: #Development!
CodeSearchCondition subclass: #ExactMatchCondition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Development'!
!ExactMatchCondition commentStamp: '<historical>' prior: 0!

	Copyright (c) 202, Quorum Software.
	See (MIT) license in root directory.
!

!ExactMatchCondition methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
compare: aString
	^aString = text
! !

!ExactMatchCondition methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isExactMatch
	^true
! !

!ExactMatchCondition methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
proposition
	^'equals'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExactMatchCondition class' category: #Development!
ExactMatchCondition class
	instanceVariableNames: ''!


