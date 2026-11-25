'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OBinaryConstantOperation category: #IR!
OBinaryOperation subclass: #OBinaryConstantOperation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OBinaryConstantOperation commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OBinaryConstantOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitBinaryWithConstant: self
! !

!OBinaryConstantOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^'[' , left primitivePrintString , ' ' , name , ' '
		, right primitivePrintString
		, ']'
! !

!OBinaryConstantOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isBinaryConstantOperation
	^true
! !

!OBinaryConstantOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	aBlock value: left
! !

!OBinaryConstantOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^(names at: left ifAbsent: 'missing') , ' ' , name , ' ' , right printString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OBinaryConstantOperation class' category: #IR!
OBinaryConstantOperation class
	instanceVariableNames: ''!


