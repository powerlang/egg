"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OptimizingCFGSimplifier,
	#superclass : #Object,
	#instVars : [
		'firstBlock'
	],
	#category : #OCompiler
}

{ #category : #private }
OptimizingCFGSimplifier >> cleanFrom: aBlock [
	| all |
	firstBlock := aBlock.
	all := firstBlock successorsPostOrder.
	[
		firstBlock updatePredecessors.
		self simplify]
		whileTrue: [all do: [:block | block dissolveIfUnreachable]]
]

{ #category : #private }
OptimizingCFGSimplifier >> dissolvePhisOf: aBasicBlock from: predecessor [
	aBasicBlock phis do: [:phi | | value |
		value := phi atOperand: predecessor.
		phi replaceAllUsesWith: value; dissolve]
]

{ #category : #private }
OptimizingCFGSimplifier >> hoistBranchIn: succ to: pred [
	| jump branch condition new |
	jump := pred lastInstruction.
	branch := succ lastInstruction.
	condition := branch variable.
	succ
		phisDo: [:phi | 
			condition := phi atOperand: pred.
			phi removeBlock: pred];
		removePredecessor: pred.
	new := branch class
		variable: condition
		target: branch target
		implicitTarget: branch implicitTarget.
	condition addUse: new at: #variable.
	jump dissolveReplacingWith: new.
	branch passArgumentsTo: new.
	new successorsDo: [:target | self link: pred to: target]
]

{ #category : #private }
OptimizingCFGSimplifier >> link: aBasicBlock to: anotherBasicBlock [
	anotherBasicBlock phisDo: [:phi | phi addEdgeFrom: aBasicBlock]; addPredecessor: aBasicBlock
]

{ #category : #private }
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

{ #category : #private }
OptimizingCFGSimplifier >> tryCombining: block [
	| last following |
	last := block lastInstruction.
	last isUnconditionalJump ifFalse: [^false].
	following := last target.
	following hasMultiplePredecessors ifTrue: [^false].
	self dissolvePhisOf: following from: block.
	following moveAllTo: block after: last.
	last dissolve.
	^true
]

{ #category : #private }
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

{ #category : #private }
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

{ #category : #private }
OptimizingCFGSimplifier >> tryRemovingEmptyBlock: block [
	| following arguments |
	block isEmptyJump ifTrue: [
		following := block lastInstruction target.
		(self wouldDuplicateEdgesOf: block into: following) ifTrue: [^false].
		arguments := block lastInstruction argumentsTo: following.
		following
			phisDo: [:phi | phi forgetEdgeFrom: block];
			removePredecessor: block.
		block predecessors do: [:predecessor | | jump |
			jump := predecessor lastInstruction.
			jump retargetFrom: block to: following.
			jump argumentsTo: following put: arguments copy.
			self link: predecessor to: following].
		^true].
	^false
]

{ #category : #private }
OptimizingCFGSimplifier >> wouldDuplicateEdgesOf: block into: following [
	| predecessors |
	following phis isEmpty ifTrue: [^false].
	predecessors := following predecessors.
	^block predecessors anySatisfy: [:predecessor | predecessors includes: predecessor]
]

