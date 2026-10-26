'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OJumpFalse category: #IR!
OJumpConditional subclass: #OJumpFalse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OJumpFalse commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OJumpFalse methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitJumpFalse: self
! !

!OJumpFalse methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^'[jump false ' , variable primitivePrintString , ' to ' , target name
		, ' or fall to '
		, implicitTarget name
		, ']'
! !

!OJumpFalse methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isJumpFalse
	^true
! !

!OJumpFalse methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isJumpTrue
	^false
! !

!OJumpFalse methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	^'{jump false}'
! !

!OJumpFalse methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^'jump false ' , (names at: variable ifAbsent: ['missing']) , ' to '
		, (names at: target ifAbsent: 'missing')
		, ' or fall to '
		, (names at: implicitTarget ifAbsent: 'missing')
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OJumpFalse class' category: #IR!
OJumpFalse class
	instanceVariableNames: ''!


