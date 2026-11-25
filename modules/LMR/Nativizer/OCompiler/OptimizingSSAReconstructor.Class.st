'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingSSAReconstructor category: #OCompiler!
Object subclass: #OptimizingSSAReconstructor
	instanceVariableNames: 'firstBlock variable reloads idoms iteratedFrontiers insertedPhis blocks'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingSSAReconstructor commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingSSAReconstructor methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
definitionInBlockFrom: instruction
	instruction
		reverseDo: [:current | (variable == current
			or: [reloads includes: current])
			ifTrue: [^current]].
	^nil
! !

!OptimizingSSAReconstructor methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstBlock: block
	firstBlock := block.
	idoms := firstBlock dominatorTree allImmediateDominators
! !

!OptimizingSSAReconstructor methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertPhiAt: block
	^insertedPhis at: block ifAbsentPut: [| arguments phi predecessors |
		predecessors := block predecessors.
		arguments := predecessors collect: [:pred | | search |
			search := pred lastInstruction.
			self reachingDefinitionFrom: search at: pred].
		phi := OPhi withAll: arguments in: predecessors.
		arguments with: predecessors do: [:var :pred | var addUse: phi at: pred].
		block addFront: phi.
		phi]
! !

!OptimizingSSAReconstructor methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
reachingDefinitionFrom: instruction at: block
	| current search |
	current := block.
	search := instruction.
	[| def |
		def := self definitionInBlockFrom: search.
		def ifNotNil: [^def].
		(iteratedFrontiers includes: current) ifTrue: [^self insertPhiAt: current].
		current := idoms at: current.
		search := current lastInstruction] repeat
! !

!OptimizingSSAReconstructor methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
reconstructSSA
	| frontiers reloadBlocks uses |
	frontiers := firstBlock dominanceFrontiersUsing: idoms.
	reloadBlocks := reloads collect: [:reload | blocks at: reload].
	iteratedFrontiers := firstBlock
		iteratedDominanceFrontiersOf: reloadBlocks
		using: frontiers.
	uses := variable allUses.
	uses do: [:use | | search block def user |
		user := use user.
		user isPhi
			ifTrue: [
				block := use name.
				search := use name lastInstruction]
			ifFalse: [
				block := blocks at: user.
				search := user prev].
		def := self reachingDefinitionFrom: search at: block.
		use disolveReplacingWith: def]
! !

!OptimizingSSAReconstructor methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
setupFor: anInstruction with: redefinitions
	| users |
	insertedPhis := Dictionary new.
	variable := anInstruction.
	reloads := redefinitions.
	blocks := Dictionary new.
	users := variable allUses collect: #user.
	firstBlock withSuccessorsDo: [:block | 
		block instructionsDo: [:instr | 
			((reloads includes: instr) or: [users includes: instr])
				ifTrue: [blocks at: instr put: block]]]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingSSAReconstructor class' category: #OCompiler!
OptimizingSSAReconstructor class
	instanceVariableNames: ''!


