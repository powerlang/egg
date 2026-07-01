'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OOperand category: #IR!
Object subclass: #OOperand
	instanceVariableNames: 'instruction name nextUse'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OOperand commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addUse: anOperand
	self DENY: self == anOperand.
	nextUse ifNil: [nextUse := anOperand] ifNotNil: [nextUse addUse: anOperand]
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
asOperand
	self halt
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
definition
	^instruction atOperand: name
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
disolveReplacingWith: otherInstruction
	self definition removeUse: instruction.
	instruction atOperand: name put: otherInstruction.
	otherInstruction addUse: instruction at: name
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instruction
	^instruction
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instruction: anInstruction
	instruction := anInstruction
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	^name
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
name: operandName
	name := operandName
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextUse
	^nextUse
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream
		nextPutAll: '[op #' , name printString , '@' , instruction printString
			, ']'
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeUse: anInstruction
	nextUse instruction == anInstruction
		ifTrue: [nextUse := nextUse nextUse]
		ifFalse: [nextUse removeUse: anInstruction]
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeUse: anInstruction at: aName
	(nextUse instruction == anInstruction and: [nextUse name = aName])
		ifTrue: [nextUse := nextUse nextUse]
		ifFalse: [nextUse removeUse: anInstruction at: aName]
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
replaceAllUsesWith: otherInstruction
	self replaceUseWith: otherInstruction.
	nextUse ifNotNil: [nextUse replaceAllUsesWith: otherInstruction]
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
replaceUseWith: otherInstruction
	self DENY: otherInstruction class == OOperand.
	instruction atOperand: name put: otherInstruction
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
user
	^instruction
! !

!OOperand methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesDo: aBlock
	aBlock value: self.
	nextUse ifNotNil: [nextUse usesDo: aBlock]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOperand class' category: #IR!
OOperand class
	instanceVariableNames: ''!

!OOperand class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: anInstruction named: operandName
	^self new instruction: anInstruction; name: operandName
! !

!OOperand class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
valued: anInstruction
	^self new value: anInstruction
! !

!OOperand class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
valued: anInstruction in: containingInstruction
	^self new value: anInstruction; instruction: containingInstruction
! !


