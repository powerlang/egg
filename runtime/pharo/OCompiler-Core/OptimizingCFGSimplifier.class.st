"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OptimizingCFGSimplifier',
	#superclass : 'Object',
	#instVars : [
		'firstBlock'
	],
	#category : 'OCompiler-Core-Main',
	#package : 'OCompiler-Core',
	#tag : 'Main'
}

{ #category : 'private' }
OptimizingCFGSimplifier >> addPredecessor: predecessor like: middle to: final [
	final phisDo: [:phi | | source |
		source := phi atOperand: middle.
		phi addVariable: source from: predecessor].
	^final
]

{ #category : 'private' }
OptimizingCFGSimplifier >> cleanFrom: aBlock [
	| all |
	firstBlock := aBlock.
	all := firstBlock successorsPostOrder.
	[self simplify] whileTrue: [all do: [:block | block dissolveIfUnreachable]]
]

{ #category : 'private' }
OptimizingCFGSimplifier >> hoistBranchIn: succ to: pred [
	| jump branch condition new target1 target2 |
	jump := pred lastInstruction.
	branch := succ lastInstruction.
	condition := branch variable.
	succ
		phisDo: [:phi | 
			condition := phi atOperand: pred.
			phi removeBlock: pred];
		removePredecessor: pred.
	target1 := self addPredecessor: pred like: succ to: branch target.
	target2 := self addPredecessor: pred like: succ to: branch implicitTarget.
	jump remove.
	new := pred
		endWith: branch class
		to: target1
		skipping: target2
		if: condition.
	jump replaceAllUsesWith: new
]

{ #category : 'private' }
OptimizingCFGSimplifier >> simplify [
	| changed |
	changed := false.
	firstBlock postOrderDo: [:block | 
		changed := (self tryFoldingRedundantBranch: block) or: changed.
		(self tryRemovingEmptyBlock: block) ifTrue: [changed := true] ifFalse: [
			changed := (self tryCombining: block) or: changed.
			changed := (self tryHoistingBranch: block) or: changed]].
	^changed
]

{ #category : 'private' }
OptimizingCFGSimplifier >> tryCombining: block [
	| last following |
	last := block lastInstruction.
	last isUnconditionalJump ifFalse: [^false].
	following := last target.
	following hasMultiplePredecessors ifTrue: [^false].
	following phisDo: [:phi | phi removeIfPossible].
	last dissolve.
	following moveAllTo: block.
	^true
]

{ #category : 'private' }
OptimizingCFGSimplifier >> tryFoldingRedundantBranch: block [
	| last |
	last := block lastInstruction.
	(last isConditionalJump and: [last target == last implicitTarget])
		ifTrue: [| jump |
			jump := OJump to: last target.
			last dissolveReplacingWith: jump.
			^true].
	(last isConditionalJump and: [last variable isConstant]) ifTrue: [
		last replaceWithUnconditional: last variable value in: block.
		^true].
	^false
]

{ #category : 'private' }
OptimizingCFGSimplifier >> tryHoistingBranch: block [
	| last following |
	last := block lastInstruction.
	(last isUnconditionalJump and: [
		following := last target.
		following isEmptyBranch or: [following isEmptyPhiBranch]])
		ifTrue: [
			self hoistBranchIn: following to: block.
			^true].
	^false
]

{ #category : 'private' }
OptimizingCFGSimplifier >> tryRemovingEmptyBlock: block [
	| following |
	block isEmptyJump ifTrue: [
		following := block lastInstruction target.
		following incorporatePhisFrom: block; removePredecessor: block.
		block predecessors do: [:predecessor | 
			predecessor lastInstruction retargetFrom: block to: following.
			following addPredecessor: predecessor].
		^true].
	^false
]
