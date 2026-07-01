'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OUnaryOperation category: #IR!
OPrimitiveOperation subclass: #OUnaryOperation
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OUnaryOperation commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OUnaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: operandName
	^receiver
! !

!OUnaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: operandName put: instruction
	receiver := instruction
! !

!OUnaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitUnary: self
! !

!OUnaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^'['
		, (receiver isInstruction
			ifTrue: [receiver primitivePrintString]
			ifFalse: [receiver printString]) , ' ' , name , ']'
! !

!OUnaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isUnaryOperation
	^true
! !

!OUnaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	aBlock value: receiver
! !

!OUnaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^(receiver isInstruction
		ifTrue: [names at: receiver]
		ifFalse: [receiver printString]) , ' ' , name
! !

!OUnaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver
	^receiver
! !

!OUnaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver: operation
	receiver := operation
! !

!OUnaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anInstruction
	^receiver == anInstruction
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OUnaryOperation class' category: #IR!
OUnaryOperation class
	instanceVariableNames: ''!

!OUnaryOperation class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver: receiver name: aString
	^self new name: aString; receiver: receiver
! !


