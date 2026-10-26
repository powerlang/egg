'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OEndInstruction category: #IR!
OInstruction subclass: #OEndInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OEndInstruction commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OEndInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
acceptVisitor: aVisitor
	
! !

!OEndInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addLast: anInstruction
	prev next: anInstruction.
	anInstruction prev: prev.
	anInstruction next: self.
	prev := anInstruction
! !

!OEndInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
detect: aBlock ifNone: absentBlock
	^absentBlock value
! !

!OEndInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
do: aBlock
	
! !

!OEndInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasNext
	^false
! !

!OEndInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isEnd
	^true
! !

!OEndInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
last
	^prev
! !

!OEndInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printForwardOn: aStream
	
! !

!OEndInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printForwardOn: aStream using: names
	
! !

!OEndInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	"
	prev printBackwardOn: aStream
	"
	
! !

!OEndInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
replace: one with: other
	
! !

!OEndInstruction methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
reverseDo: aBlock
	prev reverseDo: aBlock
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OEndInstruction class' category: #IR!
OEndInstruction class
	instanceVariableNames: ''!


