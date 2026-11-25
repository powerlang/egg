'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OLoadConstant category: #IR!
OInstruction subclass: #OLoadConstant
	instanceVariableNames: 'constant'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OLoadConstant commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OLoadConstant methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitLoadConstant: self
! !

!OLoadConstant methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^'[load cst ' , constant printString , ']'
! !

!OLoadConstant methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isConstant
	^true
! !

!OLoadConstant methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
newCopy
	^self class valued: constant
! !

!OLoadConstant methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	constant isInstruction ifTrue: [
		self halt.
		aBlock value: constant]
! !

!OLoadConstant methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	^'{' , constant printString , '}'
! !

!OLoadConstant methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^'load cst ' , constant printString
! !

!OLoadConstant methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anInstruction
	^false
! !

!OLoadConstant methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
value
	^constant
! !

!OLoadConstant methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
value: value
	constant := value
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OLoadConstant class' category: #IR!
OLoadConstant class
	instanceVariableNames: ''!

!OLoadConstant class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
valued: value
	^self new value: value
! !


