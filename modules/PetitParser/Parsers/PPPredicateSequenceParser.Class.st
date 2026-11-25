'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPPredicateSequenceParser category: #Parsers!
PPPredicateParser subclass: #PPPredicateSequenceParser
	instanceVariableNames: 'size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPPredicateSequenceParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPPredicateSequenceParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeOn: aBlock message: aString negated: aNegatedBlock message: aNegatedString size: anInteger
	predicate := aBlock.
	predicateMessage := aString.
	negated := aNegatedBlock.
	negatedMessage := aNegatedString.
	size := anInteger
! !

!PPPredicateSequenceParser methodsFor:  'operators' stamp: 'KenD 28/Jun/2026 13:27:39'!
negate
	"Answer a parser that is the negation of the receiving predicate parser."

	^ self class
		on: negated message: negatedMessage
		negated: predicate message: predicateMessage
		size: size
! !

!PPPredicateSequenceParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| position result |
	position := aStream position.
	result := aStream next: size.
	(result size = size and: [predicate value: result]) ifTrue: [^result].
	aStream position: position.
	^PPFailure message: predicateMessage from: aStream
! !

!PPPredicateSequenceParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
size
	"Answer the sequence size of the receiver."

	^ size
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPPredicateSequenceParser class' category: #Parsers!
PPPredicateSequenceParser class
	instanceVariableNames: ''!

!PPPredicateSequenceParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aBlock message: aString negated: aNegatedBlock message: aNegatedString size: anInteger
	^self new
		initializeOn: aBlock
		message: aString
		negated: aNegatedBlock
		message: aNegatedString
		size: anInteger
! !

!PPPredicateSequenceParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aBlock message: aString size: anInteger
	^self
		on: aBlock
		message: aString
		negated: [:each | (aBlock value: each) not]
		message: 'no ' , aString
		size: anInteger
! !


