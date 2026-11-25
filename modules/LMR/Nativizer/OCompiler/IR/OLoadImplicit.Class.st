'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OLoadImplicit category: #IR!
OInstruction subclass: #OLoadImplicit
	instanceVariableNames: 'name source'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OLoadImplicit commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OLoadImplicit methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: operandName put: instruction
	source := instruction
! !

!OLoadImplicit methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitLoadImplicit: self
! !

!OLoadImplicit methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^'[load implicit #' , name printString , ']'
! !

!OLoadImplicit methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isLoadImplicit
	^true
! !

!OLoadImplicit methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	^name
! !

!OLoadImplicit methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
name: aSymbol
	name := aSymbol
! !

!OLoadImplicit methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	source isInstruction ifTrue: [aBlock value: source]
! !

!OLoadImplicit methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	"
	^'<#' , source value printString , '>'
	"
	^'{#' , name printString , '}'
! !

!OLoadImplicit methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^'#' , name printString
! !

!OLoadImplicit methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
source
	^source
! !

!OLoadImplicit methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
source: operand
	source := operand
! !

!OLoadImplicit methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anInstruction
	^false
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OLoadImplicit class' category: #IR!
OLoadImplicit class
	instanceVariableNames: ''!

!OLoadImplicit class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
named: aSymbol
	^self new name: aSymbol
! !

!OLoadImplicit class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
self
	^self new name: #self
! !


