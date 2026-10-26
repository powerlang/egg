'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OMessageSend category: #IR!
OInstruction subclass: #OMessageSend
	instanceVariableNames: 'receiver selector arguments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OMessageSend commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
arguments
	^arguments
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
arguments: operands
	arguments := operands
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: named
	^named == #receiver ifTrue: [receiver] ifFalse: [arguments at: named]
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: name put: instruction
	name = #receiver
		ifTrue: [receiver := instruction]
		ifFalse: [arguments at: name put: instruction]
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicAcceptVisitor: aVisitor
	^aVisitor visitMessageSend: self
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
basicPrintString
	| string |
	string := arguments size > 0
		ifTrue: [' with: '
			, (arguments gather: [:arg | arg primitivePrintString , ' '])]
		ifFalse: [''].
	^'[send #' , selector , ' to ' , receiver primitivePrintString
		, string trimTrailingBlanks
		, ']'
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isMessageSend
	^true
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	aBlock value: receiver.
	arguments do: aBlock
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
primitivePrintString
	^'{#' , selector , '}'
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printStringUsing: names
	| string |
	string := arguments size > 0
		ifTrue: [' with: '
			, (arguments gather: [:arg | (names at: arg ifAbsent: ['missing']) , ' '])]
		ifFalse: [''].
	^'send #' , selector , ' to ' , (names at: receiver ifAbsent: ['missing'])
		, string trimTrailingBlanks
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver
	^receiver
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver: operand
	receiver := operand
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
selector
	^selector
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
selector: aSymbol
	selector := aSymbol
! !

!OMessageSend methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anInstruction
	^receiver == anInstruction
		or: [arguments anySatisfy: [:argument | argument == anInstruction]]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OMessageSend class' category: #IR!
OMessageSend class
	instanceVariableNames: ''!

!OMessageSend class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
receiver: receiver selector: selector arguments: arguments
	^self new
		receiver: receiver;
		selector: selector;
		arguments: arguments;
		yourself
! !

!OMessageSend class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
selector: selector
	^self new selector: selector
! !


