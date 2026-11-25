'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OJumpConditional category: #IR!
OInstruction subclass: #OJumpConditional
	instanceVariableNames: 'variable target implicitTarget'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OJumpConditional commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: name
	^variable
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
atOperand: name put: instruction
	variable := instruction
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
implicitTarget
	^implicitTarget
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
implicitTarget: aBasicBlock
	implicitTarget := aBasicBlock
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isConditionalJump
	^true
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isJump
	^true
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
operandsDo: aBlock
	aBlock value: variable
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
replaceWithUnconditional: condition in: basicBlock
	| fixed removed jump |
	self isJumpTrue == condition
		ifTrue: [
			fixed := target.
			removed := implicitTarget]
		ifFalse: [
			fixed := implicitTarget.
			removed := target].
	jump := OJump to: fixed.
	self dissolveReplacingWith: jump.
	removed fullyRemovePredecessor: basicBlock
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
retargetFrom: aBasicBlock to: otherBasicBlock
	target == aBasicBlock ifTrue: [target := otherBasicBlock].
	implicitTarget == aBasicBlock ifTrue: [implicitTarget := otherBasicBlock]
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
target
	^target
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
target: aBasicBlock
	target := aBasicBlock
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
targets
	^OrderedCollection with: implicitTarget with: target
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anInstruction
	^variable == anInstruction
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
variable
	^variable
! !

!OJumpConditional methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
variable: operand
	variable := operand
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OJumpConditional class' category: #IR!
OJumpConditional class
	instanceVariableNames: ''!

!OJumpConditional class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
variable: operation target: explicitTarget implicitTarget: implicitTarget
	^self new
		variable: operation;
		target: explicitTarget;
		implicitTarget: implicitTarget
! !


