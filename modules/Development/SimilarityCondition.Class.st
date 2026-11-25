'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #SimilarityCondition category: #Development!
CodeSearchCondition subclass: #SimilarityCondition
	instanceVariableNames: 'tolerance'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Development'!
!SimilarityCondition commentStamp: '<historical>' prior: 0!

	Copyright (c) 2025, Guillermo Amaral, Javier Pimás.
	See (MIT) license in root directory.
!

!SimilarityCondition methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
compare: aString
	^(aString editDistanceTo: text) <= tolerance
! !

!SimilarityCondition methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	tolerance := 3
! !

!SimilarityCondition methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isSimilarity
	^true
! !

!SimilarityCondition methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
proposition
	^'is similar to'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SimilarityCondition class' category: #Development!
SimilarityCondition class
	instanceVariableNames: ''!


SimilarityCondition initialize!

