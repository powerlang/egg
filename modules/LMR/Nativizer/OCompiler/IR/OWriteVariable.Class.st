'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OWriteVariable category: #IR!
OUseVariable subclass: #OWriteVariable
	instanceVariableNames: 'source'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OWriteVariable commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OWriteVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: name put: instruction
	source := instruction
! !

!OWriteVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitWriteVariable: self
! !

!OWriteVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	| sourceString |
	sourceString := source isInstruction
		ifTrue: [source primitivePrintString]
		ifFalse: [self halt].
	^'[write ' , self name printString , ' with ' , sourceString , ' ]'
! !

!OWriteVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isStoreVariable
	^true
! !

!OWriteVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	^binding name
! !

!OWriteVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	aBlock value: source
! !

!OWriteVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	^'{write ' , self name printString , ' }'
! !

!OWriteVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	| sourceString |
	sourceString := source isInstruction
		ifTrue: [names at: source]
		ifFalse: [self halt].
	^'write ' , self name printString , ' with ' , sourceString
! !

!OWriteVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
source
	^source
! !

!OWriteVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
source: operation
	source := operation
! !

!OWriteVariable methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anOperand
	^source == anOperand
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OWriteVariable class' category: #IR!
OWriteVariable class
	instanceVariableNames: ''!

!OWriteVariable class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
binding: aBinding valued: operation
	^self new binding: aBinding; source: operation
! !


