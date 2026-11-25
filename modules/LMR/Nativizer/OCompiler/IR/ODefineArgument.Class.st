'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #ODefineArgument category: #IR!
OInstruction subclass: #ODefineArgument
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!ODefineArgument commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!ODefineArgument methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitDefineArgument: self
! !

!ODefineArgument methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^'[define arg ' , name , ']'
! !

!ODefineArgument methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isDefineArgument
	^true
! !

!ODefineArgument methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	^name
! !

!ODefineArgument methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
name: aSymbol
	name := aSymbol
! !

!ODefineArgument methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	
! !

!ODefineArgument methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	^'{' , name , '}'
! !

!ODefineArgument methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^'define arg ' , name
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ODefineArgument class' category: #IR!
ODefineArgument class
	instanceVariableNames: ''!

!ODefineArgument class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
named: aSymbol
	^self new name: aSymbol
! !


