'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OBeginInstruction category: #IR!
OInstruction subclass: #OBeginInstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OBeginInstruction commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OBeginInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	
! !

!OBeginInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
do: aBlock
	next do: aBlock
! !

!OBeginInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasPrev
	^false
! !

!OBeginInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printBackwardOn: aStream
	
! !

!OBeginInstruction methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: '[' , self basicHash printString , '] '.
	next printForwardOn: aStream
! !

!OBeginInstruction methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream using: names
	aStream nextPutAll: '[' , self basicHash printString , '] '.
	next printForwardOn: aStream using: names
! !

!OBeginInstruction methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	| stream |
	stream := '' writeStream.
	next printForwardOn: stream using: names.
	^stream contents
! !

!OBeginInstruction methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
realReverseDo: aBlock
	
! !

!OBeginInstruction methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:39'!
reverseDo: aBlock
	
! !

!OBeginInstruction methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anInstruction
	^false
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OBeginInstruction class' category: #IR!
OBeginInstruction class
	instanceVariableNames: ''!


