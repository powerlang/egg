"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OptimizingSSAReconstructor,
	#superclass : #Object,
	#instVars : [
		'firstBlock',
		'variable',
		'reloads',
		'iteratedFrontiers',
		'insertedParameters',
		'blocks'
	],
	#category : #OCompiler
}

{ #category : #initialization }
OptimizingSSAReconstructor >> definitionInBlockFrom: instruction [
	instruction
		reverseDo: [:current | (variable == current
			or: [reloads includes: current])
			ifTrue: [^current]].
	^nil
]

{ #category : #initialization }
OptimizingSSAReconstructor >> firstBlock: block [
	firstBlock := block.
	block computeDominance
]

{ #category : #initialization }
OptimizingSSAReconstructor >> insertParameterAt: block [
	^insertedParameters at: block ifAbsentPut: [| arguments parameter predecessors |
		predecessors := block predecessors.
		arguments := predecessors collect: [:pred | | search |
			search := pred lastInstruction.
			self reachingDefinitionFrom: search at: pred].
		parameter := OBlockParameter new.
		block insertParameter: parameter.
		arguments with: predecessors do: [:var :pred | parameter addVariable: var from: pred].
		parameter]
]

{ #category : #initialization }
OptimizingSSAReconstructor >> reachingDefinitionFrom: instruction at: block [
	| current search |
	current := block.
	search := instruction.
	[| def |
		def := self definitionInBlockFrom: search.
		def ifNotNil: [^def].
		(iteratedFrontiers includes: current) ifTrue: [^self insertParameterAt: current].
		current := current immediateDominator.
		search := current lastInstruction] repeat
]

{ #category : #initialization }
OptimizingSSAReconstructor >> reconstructSSA [
	| frontiers reloadBlocks uses |
	frontiers := firstBlock dominanceFrontiers.
	reloadBlocks := reloads collect: [:reload | blocks at: reload].
	iteratedFrontiers := firstBlock
		iteratedDominanceFrontiersOf: reloadBlocks
		using: frontiers.
	uses := variable allUses.
	uses do: [:use | | search block def user |
		user := use user.
		user isBlockParameter
			ifTrue: [
				block := use name.
				search := use name lastInstruction]
			ifFalse: [
				block := blocks at: user.
				search := user prev].
		def := self reachingDefinitionFrom: search at: block.
		use transferUseTo: def]
]

{ #category : #initialization }
OptimizingSSAReconstructor >> setupFor: anInstruction with: redefinitions [
	| users |
	insertedParameters := Dictionary new.
	variable := anInstruction.
	reloads := redefinitions.
	blocks := Dictionary new.
	users := variable allUses collect: #user.
	firstBlock withSuccessorsDo: [:block | 
		block instructionsDo: [:instr | 
			((reloads includes: instr) or: [users includes: instr])
				ifTrue: [blocks at: instr put: block]]]
]

