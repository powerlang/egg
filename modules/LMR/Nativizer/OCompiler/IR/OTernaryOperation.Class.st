'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OTernaryOperation category: #IR!
OPrimitiveOperation subclass: #OTernaryOperation
	instanceVariableNames: 'receiver left right'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OTernaryOperation commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: named
	^named == #receiver
		ifTrue: [receiver]
		ifFalse: [named == #left ifTrue: [left] ifFalse: [right]]
! !

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: operandName put: instruction
	operandName = #receiver ifTrue: [receiver := instruction] ifFalse: [
		operandName = #left
			ifTrue: [left := instruction]
			ifFalse: [right := instruction]]
! !

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitTernary: self
! !

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	^'['
		, (receiver isInstruction
			ifTrue: [receiver primitivePrintString]
			ifFalse: [receiver printString]) , ' ' , name , ' '
		, left primitivePrintString
		, ', '
		, right primitivePrintString
		, ']'
! !

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isTernaryOperation
	^true
! !

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
left
	^left
! !

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
left: value
	left := value
! !

!OTernaryOperation methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	aBlock value: receiver.
	left isInstruction ifTrue: [aBlock value: left].
	aBlock value: right
! !

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	^(receiver isInstruction
		ifTrue: [names at: receiver]
		ifFalse: [receiver printString]) , ' ' , name , ' '
		, (left isInstruction ifTrue: [names at: left] ifFalse: [left printString])
		, ', '
		, (right isInstruction
			ifTrue: [names at: right]
			ifFalse: [right printString])
! !

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver
	^receiver
! !

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver: value
	receiver := value
! !

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
right
	^right
! !

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
right: value
	right := value
! !

!OTernaryOperation methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anInstruction
	^receiver == anInstruction
		or: [left == anInstruction or: [right == anInstruction]]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OTernaryOperation class' category: #IR!
OTernaryOperation class
	instanceVariableNames: ''!

!OTernaryOperation class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver: receiver left: left right: right name: selector
	^self new
		receiver: receiver;
		left: left;
		right: right;
		name: selector
! !


