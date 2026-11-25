'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OReturn category: #IR!
OInstruction subclass: #OReturn
	instanceVariableNames: 'source frame argumentsCount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OReturn commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
argumentsCount
	^argumentsCount
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
argumentsCount: anInteger
	argumentsCount := anInteger
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: name
	^name == #source ifTrue: [source] ifFalse: [frame]
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: name put: instruction
	^name == #source
		ifTrue: [source := instruction]
		ifFalse: [frame := instruction]
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitReturn: self
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^'[ret ' , source primitivePrintString , ']'
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
frame: anInstruction
	frame := anInstruction
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isReturn
	^true
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	aBlock value: source.
	aBlock value: frame
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	^'{ret}'
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^'ret ' , (names at: source ifAbsent: 'missing') , ''
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
source
	^source
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
source: anInstruction
	source := anInstruction
! !

!OReturn methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anInstruction
	^source == anInstruction or: [frame == anInstruction]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OReturn class' category: #IR!
OReturn class
	instanceVariableNames: ''!


