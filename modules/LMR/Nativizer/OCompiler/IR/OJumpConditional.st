"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OJumpConditional,
	#superclass : #OJump,
	#instVars : [
		'variable',
		'implicitTarget',
		'implicitArguments'
	],
	#category : #IR
}

{ #category : #unclassified }
OJumpConditional class >> variable: operation target: explicitTarget implicitTarget: implicitTarget [
	^self new
		variable: operation;
		target: explicitTarget;
		implicitTarget: implicitTarget
]

{ #category : #'jump arguments' }
OJumpConditional >> argumentsTo: aBasicBlock [
	aBasicBlock == target ifTrue: [^arguments].
	aBasicBlock == implicitTarget ifTrue: [^implicitArguments].
	^self error: 'not a target of the jump'
]

{ #category : #'jump arguments' }
OJumpConditional >> argumentsTo: aBasicBlock put: aCollection [
	aBasicBlock == target ifTrue: [^arguments := aCollection].
	aBasicBlock == implicitTarget ifTrue: [^implicitArguments := aCollection].
	^self error: 'not a target of the jump'
]

{ #category : #unclassified }
OJumpConditional >> atOperand: name [
	^variable
]

{ #category : #unclassified }
OJumpConditional >> atOperand: name put: instruction [
	variable := instruction
]

{ #category : #unclassified }
OJumpConditional >> implicitTarget [
	^implicitTarget
]

{ #category : #unclassified }
OJumpConditional >> implicitTarget: aBasicBlock [
	implicitTarget == aBasicBlock ifFalse: [implicitArguments := aBasicBlock newArguments].
	implicitTarget := aBasicBlock
]

{ #category : #initialization }
OJumpConditional >> initialize [
	super initialize.
	implicitArguments := OrderedCollection new
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
	removed fullyRemovePredecessor: basicBlock.
	jump := OJump to: fixed.
	self dissolveReplacingWith: jump
]

{ #category : #unclassified }
OJumpConditional >> retargetFrom: aBasicBlock to: otherBasicBlock [
	target == aBasicBlock ifTrue: [self target: otherBasicBlock].
	implicitTarget == aBasicBlock ifTrue: [self implicitTarget: otherBasicBlock]
]

{ #category : #private }
OJumpConditional >> successorsDo: aBlock [
	aBlock value: target.
	aBlock value: implicitTarget
]

{ #category : #unclassified }
OJumpConditional >> targets [
	^OrderedCollection with: implicitTarget with: target
]

{ #category : #unclassified }
OJumpConditional >> usesResultOf: anInstruction [
	^variable == anInstruction
]

{ #category : #unclassified }
OJumpConditional >> variable [
	^variable
]

{ #category : #unclassified }
OJumpConditional >> variable: operand [
	variable := operand
]

