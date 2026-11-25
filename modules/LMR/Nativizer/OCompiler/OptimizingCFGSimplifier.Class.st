'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingCFGSimplifier category: #OCompiler!
Object subclass: #OptimizingCFGSimplifier
	instanceVariableNames: 'firstBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingCFGSimplifier commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingCFGSimplifier methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
addPredecessor: predecessor like: middle to: final
	final phisDo: [:phi | | source |
		source := phi atOperand: middle.
		phi addVariable: source from: predecessor].
	final addPredecessor: predecessor.
	^final
! !

!OptimizingCFGSimplifier methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
cleanFrom: aBlock
	| all |
	firstBlock := aBlock.
	all := firstBlock successorsPostOrder.
	[
		firstBlock updatePredecessors.
		self simplify]
		whileTrue: [all do: [:block | block dissolveIfUnreachable]]
! !

!OptimizingCFGSimplifier methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
hoistBranchIn: succ to: pred
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
	new := branch class
		variable: condition
		target: target1
		implicitTarget: target2.
	condition addUse: new at: #variable.
	jump dissolveReplacingWith: new
! !

!OptimizingCFGSimplifier methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
simplify
	| changed |
	changed := false.
	firstBlock postOrderDo: [:block | 
		changed := (self tryFoldingRedundantBranch: block) or: changed.
		(self tryRemovingEmptyBlock: block) ifTrue: [changed := true] ifFalse: [
			changed := (self tryCombining: block) or: changed.
			changed := (self tryHoistingBranch: block) or: changed]].
	^changed
! !

!OptimizingCFGSimplifier methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
tryCombining: block
	| last following |
	last := block lastInstruction.
	(last isUnconditionalJump and: [
		following := last target.
		following predecessors size = 1])
		ifTrue: [
			following successors do: [:successor | 
				successor
					addPredecessor: block;
					removePredecessor: following;
					phisDo: [:phi | phi replaceBlock: following with: block]].
			last afterInsertAll: following firstInstruction; dissolve.
			^true].
	^false
! !

!OptimizingCFGSimplifier methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
tryFoldingRedundantBranch: block
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
! !

!OptimizingCFGSimplifier methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
tryHoistingBranch: block
	| last following |
	last := block lastInstruction.
	(last isUnconditionalJump and: [
		following := last target.
		following isEmptyBranch or: [following isEmptyPhiBranch]])
		ifTrue: [
			self hoistBranchIn: following to: block.
			^true].
	^false
! !

!OptimizingCFGSimplifier methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
tryRemovingEmptyBlock: block
	| following |
	block isEmptyJump ifTrue: [
		following := block lastInstruction target.
		following incorporatePhisFrom: block; removePredecessor: block.
		block predecessors do: [:predecessor | 
			predecessor lastInstruction retargetFrom: block to: following.
			following addPredecessor: predecessor].
		^true].
	^false
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingCFGSimplifier class' category: #OCompiler!
OptimizingCFGSimplifier class
	instanceVariableNames: ''!


