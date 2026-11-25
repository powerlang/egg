'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OPrimitiveOperation category: #IR!
OInstruction subclass: #OPrimitiveOperation
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OPrimitiveOperation commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OPrimitiveOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^self primitivePrintString
! !

!OPrimitiveOperation methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isPrimitiveOperation
	^true
! !

!OPrimitiveOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	^name
! !

!OPrimitiveOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
name: selector
	name := selector
! !

!OPrimitiveOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	^'{#' , name , '}'
! !

!OPrimitiveOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^self primitivePrintString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OPrimitiveOperation class' category: #IR!
OPrimitiveOperation class
	instanceVariableNames: ''!


