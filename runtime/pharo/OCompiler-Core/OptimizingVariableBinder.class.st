"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OptimizingVariableBinder',
	#superclass : 'Object',
	#instVars : [
		'definitions',
		'currentBlock',
		'dominatorTree',
		'immediateDominators',
		'dominanceFrontiers',
		'pendingReads',
		'pendingPhis',
		'abi'
	],
	#category : 'OCompiler-Core-Main',
	#package : 'OCompiler-Core',
	#tag : 'Main'
}

{ #category : 'accessing' }
OptimizingVariableBinder >> abi: anAbi [
	abi := anAbi
]

{ #category : 'private' }
OptimizingVariableBinder >> define: value as: name [
	self define: value as: name in: currentBlock
]

{ #category : 'private' }
OptimizingVariableBinder >> define: value as: name in: block [
	| here |
	here := definitions at: block ifAbsentPut: [Dictionary new].
	here at: name put: value
]

{ #category : 'accessing' }
OptimizingVariableBinder >> definitionOf: name [
	^self definitionOf: name from: currentBlock
]

{ #category : 'accessing' }
OptimizingVariableBinder >> definitionOf: name before: block [
	| instruction current |
	instruction := block firstInstruction.
	[instruction isPhi] whileTrue: [
		instruction variables first = name ifTrue: [^instruction].
		instruction := instruction next].
	current := block.
	[
		current := immediateDominators
			at: current
			ifAbsent: [self error: 'undefined variable <' , name , '>'].
		current notNil]
		whileTrue: [
			definitions
				at: current
				ifPresent: [:here | here at: name ifPresent: [:value | ^value]]]
]

{ #category : 'accessing' }
OptimizingVariableBinder >> definitionOf: name from: block [
	| current |
	current := block.
	[current notNil] whileTrue: [
		definitions
			at: current
			ifPresent: [:here | here at: name ifPresent: [:value | ^value]].
		current := immediateDominators
			at: current
			ifAbsent: [^block lastValue
			"BMNullaryOperation
				name: 'nop'
				self error: 'undefined variable <' , name , '>'"]]
]

{ #category : 'accessing' }
OptimizingVariableBinder >> definitionOf: name in: block [
	definitions
		at: block
		ifPresent: [:here | here at: name ifPresent: [:value | ^value]].
	^nil
]

{ #category : 'private' }
OptimizingVariableBinder >> doBindingFrom: firstBlock [
	dominatorTree := firstBlock dominatorTree.
	immediateDominators := dominatorTree allImmediateDominators.
	dominanceFrontiers := firstBlock
		dominanceFrontiersUsing: immediateDominators.
	firstBlock reversePostOrderDo: [:block | 
		currentBlock := block.
		block firstInstruction acceptVisitor: self].
	self resolvePendingReads; rewritePhis
]

{ #category : 'initialization' }
OptimizingVariableBinder >> initialize [
	definitions := Dictionary new.
	pendingReads := OrderedCollection new.
	pendingPhis := OrderedCollection new
]

{ #category : 'private' }
OptimizingVariableBinder >> insertPhiOf: name at: block [
	| size variables phi |
	(self definitionOf: name in: block) ifNotNil: [^self].
	size := block predecessors size.
	variables := (Array new: size)
		atAllPut: name;
		asOrderedCollection.
	phi := OPhi new basicVariables: variables blocks: block predecessors.
	block afterInsert: phi.
	pendingPhis add: phi -> block.
	self define: phi as: name in: block
]

{ #category : 'private' }
OptimizingVariableBinder >> instructionsForWriting: aWriteVariable toTemporary: binding [
	self define: aWriteVariable source as: binding name asSymbol.
	aWriteVariable dissolve.
	(dominanceFrontiers at: currentBlock)
		do: [:block | self insertPhiOf: binding name asSymbol at: block]
]

{ #category : 'private' }
OptimizingVariableBinder >> resolve: aReadVariable asTemporary: binding [
	| source |
	source := self definitionOf: binding name asSymbol in: currentBlock.
	source
		ifNil: [pendingReads add: aReadVariable -> currentBlock]
		ifNotNil: [aReadVariable replaceAllUsesWith: source; dissolve]
]

{ #category : 'private' }
OptimizingVariableBinder >> resolvePendingReads [
	pendingReads do: [:association | | read block source |
		read := association key.
		block := association value.
		source := self definitionOf: read binding name asSymbol before: block.
		read replaceWithCopyOf: source]
]

{ #category : 'private' }
OptimizingVariableBinder >> rewritePhis [
	pendingPhis do: [:association | | phi block |
		phi := association key.
		block := association value.
		(phi livesAfter: phi orOutOf: block)
			ifTrue: [
				block predecessors withIndexDo: [:predecessor :i | | name source |
					name := phi variables at: i.
					source := self definitionOf: name from: predecessor.
					phi variables at: i put: source.
					source addUse: phi at: predecessor]]
			ifFalse: [phi clearVariables; dissolve]]
]

{ #category : 'visitor protocol' }
OptimizingVariableBinder >> visitBinaryWithConstant: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingVariableBinder >> visitBinaryWithVariable: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingVariableBinder >> visitJump: aJumpInstruction [
	
]

{ #category : 'visitor protocol' }
OptimizingVariableBinder >> visitJumpFalse: aJumpInstruction [
	
]

{ #category : 'visitor protocol' }
OptimizingVariableBinder >> visitJumpTrue: aJumpInstruction [
	
]

{ #category : 'visitor protocol' }
OptimizingVariableBinder >> visitLoad: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingVariableBinder >> visitLoadConstant: aLoadImplicit [
	
]

{ #category : 'visitor protocol' }
OptimizingVariableBinder >> visitMessageSend: aMessageSend [
	
]

{ #category : 'visitor protocol' }
OptimizingVariableBinder >> visitPhi: aPhi [
	
]

{ #category : 'visitor protocol' }
OptimizingVariableBinder >> visitReturn: aReturnInstruction [
	
]

{ #category : 'visitor protocol' }
OptimizingVariableBinder >> visitStore: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingVariableBinder >> visitUnary: instruction [
	
]
