'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OReadVariable category: #IR!
OUseVariable subclass: #OReadVariable
	instanceVariableNames: 'source'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OReadVariable commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OReadVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: name put: instruction
	source := instruction
! !

!OReadVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitReadVariable: self
! !

!OReadVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^'[read var #' , (binding ifNil: ['#error'] ifNotNil: [binding name]) , ']'
! !

!OReadVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	source ifNotNil: [aBlock value: source]
! !

!OReadVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	^'{#' , (binding ifNil: ['#error'] ifNotNil: [binding name]) , ' read}'
! !

!OReadVariable methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^self basicPrintString
! !

!OReadVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
source
	^source
! !

!OReadVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
source: anInstruction
	source := anInstruction
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OReadVariable class' category: #IR!
OReadVariable class
	instanceVariableNames: ''!

!OReadVariable class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
binding: binding
	^self new binding: binding
! !

!OReadVariable class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
source: identifier
	^self new source: identifier
! !


