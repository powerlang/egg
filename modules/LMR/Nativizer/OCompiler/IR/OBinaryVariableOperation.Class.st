'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OBinaryVariableOperation category: #IR!
OBinaryOperation subclass: #OBinaryVariableOperation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OBinaryVariableOperation commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OBinaryVariableOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitBinaryWithVariable: self
! !

!OBinaryVariableOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^'[' , left primitivePrintString , ' ' , name , ' '
		, right primitivePrintString
		, ']'
! !

!OBinaryVariableOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isBinaryVariableOperation
	^true
! !

!OBinaryVariableOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	aBlock value: left.
	aBlock value: right
! !

!OBinaryVariableOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^(names at: left ifAbsent: 'missing') , ' ' , name , ' ' , (names at: right)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OBinaryVariableOperation class' category: #IR!
OBinaryVariableOperation class
	instanceVariableNames: ''!


