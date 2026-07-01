'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #IncludingCondition category: #Development!
CodeSearchCondition subclass: #IncludingCondition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Development'!
!IncludingCondition commentStamp: '<historical>' prior: 0!

	Copyright (c) 202,5 Quorum Software.
	See (MIT) license in root directory.
!

!IncludingCondition methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
compare: aString
	^aString includesString: text
! !

!IncludingCondition methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
proposition
	^'includes'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IncludingCondition class' category: #Development!
IncludingCondition class
	instanceVariableNames: ''!


