'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OBinaryOperation category: #IR!
OPrimitiveOperation subclass: #OBinaryOperation
	instanceVariableNames: 'left right'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OBinaryOperation commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OBinaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: named
	^named == #left ifTrue: [left] ifFalse: [right]
! !

!OBinaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: operandName put: instruction
	operandName = #left
		ifTrue: [left := instruction]
		ifFalse: [right := instruction]
! !

!OBinaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
invertOperation
	name == #'<' ifTrue: [^name := #'>'].
	name == #'<=' ifTrue: [^name := #'>='].
	name == #'>' ifTrue: [^name := #'<'].
	name == #'>=' ifTrue: [^name := #'<='].
	name == #'==' ifTrue: [^name].
	self halt
! !

!OBinaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
left
	^left
! !

!OBinaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
left: anInstruction
	left := anInstruction
! !

!OBinaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
negateOperation
	name == #'<' ifTrue: [^name := #'>='].
	name == #'<=' ifTrue: [^name := #'>'].
	name == #'>' ifTrue: [^name := #'<='].
	name == #'>=' ifTrue: [name := #'<']
! !

!OBinaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
right
	^right
! !

!OBinaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
right: anInstruction
	right := anInstruction
! !

!OBinaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
swapOperands
	| temp |
	left removeUse: self.
	right removeUse: self.
	temp := left.
	left := right.
	right := temp.
	left addUse: self at: #left.
	right addUse: self at: #right
! !

!OBinaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anInstruction
	^left == anInstruction or: [right == anInstruction]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OBinaryOperation class' category: #IR!
OBinaryOperation class
	instanceVariableNames: ''!

!OBinaryOperation class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
left: left right: right name: selector
	^self new
		left: left;
		right: right;
		name: selector
! !


