'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OJumpTrue category: #IR!
OJumpConditional subclass: #OJumpTrue
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OJumpTrue commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OJumpTrue methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitJumpTrue: self
! !

!OJumpTrue methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^'[jump true ' , variable primitivePrintString , ' to ' , target name
		, ' or fall to '
		, implicitTarget name
		, ']'
! !

!OJumpTrue methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isJumpFalse
	^false
! !

!OJumpTrue methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isJumpTrue
	^true
! !

!OJumpTrue methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	^'{jump true}'
! !

!OJumpTrue methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^'jump true ' , (names at: variable) , ' to ' , (names at: target)
		, ' or fall to '
		, (names at: implicitTarget)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OJumpTrue class' category: #IR!
OJumpTrue class
	instanceVariableNames: ''!


