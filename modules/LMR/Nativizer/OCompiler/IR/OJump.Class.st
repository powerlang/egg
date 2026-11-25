'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OJump category: #IR!
OInstruction subclass: #OJump
	instanceVariableNames: 'target'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OJump commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OJump methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitJump: self
! !

!OJump methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^'[jump to ' , target name , ']'
! !

!OJump methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isJump
	^true
! !

!OJump methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	
! !

!OJump methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	^'{jump}'
! !

!OJump methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^'jump to ' , (names at: target)
! !

!OJump methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
retargetFrom: aBasicBlock to: otherBasicBlock
	target := otherBasicBlock
! !

!OJump methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
target
	^target
! !

!OJump methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
target: aBasicBlock
	target := aBasicBlock
! !

!OJump methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
targets
	^OrderedCollection with: target
! !

!OJump methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anInstruction
	^false
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OJump class' category: #IR!
OJump class
	instanceVariableNames: ''!

!OJump class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
to: aDestination
	^self new target: aDestination
! !


