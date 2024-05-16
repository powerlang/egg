"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : #OJumpConditional,
	#superclass : #OJump,
	#instVars : [
		'variable',
		'implicitTarget'
	],
	#category : #'OCompiler-Core-IR'
}

{ #category : #unclassified }
OJumpConditional class >> variable: operation target: explicitTarget implicitTarget: implicitTarget [
	^self new
		variable: operation;
		target: explicitTarget;
		implicitTarget: implicitTarget
]

{ #category : #unclassified }
OJumpConditional >> atOperand: name [
	^variable
]

{ #category : #unclassified }
OJumpConditional >> atOperand: name put: instruction [
	variable := instruction
]

{ #category : #private }
OJumpConditional >> copyTo: copy with: map [
	super copyTo: copy with: map.
	copy
		target: (target duplicateWith: map);
		implicitTarget: (implicitTarget duplicateWith: map);
		variable: (variable duplicateWith: map)
]

{ #category : #unclassified }
OJumpConditional >> implicitTarget [
	^implicitTarget
]

{ #category : #unclassified }
OJumpConditional >> implicitTarget: aBasicBlock [
	implicitTarget := aBasicBlock
]

{ #category : #unclassified }
OJumpConditional >> isConditionalJump [
	^true
]

{ #category : #unclassified }
OJumpConditional >> operandsDo: aBlock [
	aBlock value: variable
]

{ #category : #unclassified }
OJumpConditional >> replaceWithUnconditional: condition in: basicBlock [
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
]

{ #category : #unclassified }
OJumpConditional >> retargetFrom: aBasicBlock to: otherBasicBlock [
	target == aBasicBlock ifTrue: [target := otherBasicBlock].
	implicitTarget == aBasicBlock ifTrue: [implicitTarget := otherBasicBlock]
]

{ #category : #private }
OJumpConditional >> successorsDo: aBlock [
	aBlock value: target.
	aBlock value: implicitTarget
]

{ #category : #unclassified }
OJumpConditional >> targets [
	^super targets add: implicitTarget; yourself
]

{ #category : #unclassified }
OJumpConditional >> usesResultOf: anInstruction [
	^variable == anInstruction
]

{ #category : #unclassified }
OJumpConditional >> variable [
	^variable
]

{ #category : #private }
OJumpConditional >> variable: operand [
	variable := operand.
	variable addUse: self at: #variable
]
