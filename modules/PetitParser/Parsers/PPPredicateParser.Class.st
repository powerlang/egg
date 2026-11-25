'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPPredicateParser category: #Parsers!
PPParser subclass: #PPPredicateParser
	instanceVariableNames: 'predicate predicateMessage negated negatedMessage'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPPredicateParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPPredicateParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
block
	"Answer the predicate block of the receiver."

	^ predicate
! !

!PPPredicateParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
message
	"Answer the failure message."

	^ predicateMessage
! !

!PPPredicateParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printNameOn: aStream
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: predicateMessage
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPPredicateParser class' category: #Parsers!
PPPredicateParser class
	instanceVariableNames: ''!


