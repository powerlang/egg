'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingVariableBinder category: #OCompiler!
Object subclass: #OptimizingVariableBinder
	instanceVariableNames: 'definitions currentBlock dominatorTree immediateDominators dominanceFrontiers pendingReads pendingPhis abi'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingVariableBinder commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingVariableBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
abi: anAbi
	abi := anAbi
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
define: value as: name
	self define: value as: name in: currentBlock
! !

!OptimizingVariableBinder methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
define: value as: name in: block
	| here |
	here := definitions at: block ifAbsentPut: [Dictionary new].
	here at: name put: value
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
definitionOf: name
	^self definitionOf: name from: currentBlock
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
definitionOf: name before: block
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
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
definitionOf: name from: block
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
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
definitionOf: name in: block
	definitions
		at: block
		ifPresent: [:here | here at: name ifPresent: [:value | ^value]].
	^nil
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
doBindingFrom: firstBlock
	dominatorTree := firstBlock dominatorTree.
	immediateDominators := dominatorTree allImmediateDominators.
	dominanceFrontiers := firstBlock
		dominanceFrontiersUsing: immediateDominators.
	firstBlock reversePostOrderDo: [:block | 
		currentBlock := block.
		block firstInstruction acceptVisitor: self].
	self resolvePendingReads; rewritePhis
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	definitions := Dictionary new.
	pendingReads := OrderedCollection new.
	pendingPhis := OrderedCollection new
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertPhiOf: name at: block
	| size variables phi |
	(self definitionOf: name in: block) ifNotNil: [^self].
	size := block predecessors size.
	variables := (Array new: size)
		atAllPut: name;
		asOrderedCollection.
	phi := OPhi withAll: variables in: block predecessors.
	block firstInstruction beforeInsert: phi.
	pendingPhis add: phi -> block.
	self define: phi as: name in: block
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructionsForWriting: aWriteVariable
	| binding |
	binding := aWriteVariable binding.
	binding isTemporary
		ifTrue: [^self instructionsForWriting: aWriteVariable toTemporary: binding].
	binding isInstVar
		ifTrue: [^self
			instructionsForWriting: aWriteVariable
			toInstanceVariable: binding].
	binding refersToAssoc
		ifTrue: [^self
			instructionsForWriting: aWriteVariable
			toAssociation: binding].
	self halt
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructionsForWriting: aWriteVariable toAssociation: binding
	| global write |
	global := OLoadConstant valued: binding association.
	write := OTernaryOperation
		receiver: global
		left: 1
		right: aWriteVariable source
		name: #_basicAt:put:.
	global addUse: write at: #receiver.
	aWriteVariable source addUse: write at: #right.
	aWriteVariable beforeInsert: global; dissolveReplacingWith: write
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructionsForWriting: aWriteVariable toInstanceVariable: binding
	| this write |
	this := self definitionOf: #self.
	write := OTernaryOperation
		receiver: this
		left: binding index
		right: aWriteVariable source
		name: #_basicAt:put:.
	this addUse: write at: #receiver.
	aWriteVariable source addUse: write at: #right.
	aWriteVariable dissolveReplacingWith: write
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructionsForWriting: aWriteVariable toTemporary: binding
	self define: aWriteVariable source as: binding name asSymbol.
	aWriteVariable dissolve.
	(dominanceFrontiers at: currentBlock)
		do: [:block | self insertPhiOf: binding name asSymbol at: block]
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
resolve: aReadVariable asArgument: binding
	| source |
	source := self definitionOf: binding name asSymbol.
	aReadVariable replaceAllUsesWith: source; dissolve
! !

!OptimizingVariableBinder methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
resolve: aReadVariable asAssociationValue: binding
	| global read value name load |
	name := binding association key.
	(name == #WordSize or: [name == #WordSizeShift]) ifTrue: [
		value := name == #WordSize
			ifTrue: [abi wordSize]
			ifFalse: [abi wordSizeShift].
		load := OLoadConstant valued: value.
		^aReadVariable dissolveReplacingWith: load].
	binding isPoolVariableBinding
		ifTrue: [
			load := OLoadConstant valued: binding association value.
			aReadVariable dissolveReplacingWith: load]
		ifFalse: [
			global := OLoadConstant valued: binding association.
			read := OBinaryConstantOperation left: global right: 1 name: #_basicAt:.
			global addUse: read at: #left.
			aReadVariable beforeInsert: global; dissolveReplacingWith: read]
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
resolve: aReadVariable asInstanceVar: binding
	| receiver index load |
	receiver := self definitionOf: #self.
	"	index := method classField indexOfSlot: name."
	index := binding index.
	load := OBinaryConstantOperation
		left: receiver
		right: index
		name: #_basicAt:.
	receiver addUse: load at: #left.
	aReadVariable dissolveReplacingWith: load
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
resolve: aReadVariable asLiteral: binding
	| name value constant |
	name := binding name asSymbol.
	value := self valueOfSpecial: name.
	constant := OLoadConstant valued: value.
	aReadVariable dissolveReplacingWith: constant
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
resolve: aReadVariable asTemporary: binding
	| source |
	source := self definitionOf: binding name asSymbol in: currentBlock.
	source
		ifNil: [pendingReads add: aReadVariable -> currentBlock]
		ifNotNil: [aReadVariable replaceAllUsesWith: source; dissolve]
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
resolvePendingReads
	pendingReads do: [:association | | read block source |
		read := association key.
		block := association value.
		source := self definitionOf: read binding name asSymbol before: block.
		read replaceWithCopyOf: source]
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
resolveSelf: aReadVariable
	| receiver |
	receiver := self definitionOf: #self.
	^aReadVariable replaceAllUsesWith: receiver; dissolve
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
rewritePhis
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
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueOfSpecial: name
	name == #true ifTrue: [^true].
	name == #false ifTrue: [^false].
	name == #nil ifTrue: [^nil].
	self halt
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithConstant: instruction
	
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithVariable: instruction
	
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitDefineArgument: instruction
	self define: instruction as: instruction name
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJump: aJumpInstruction
	
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpFalse: aJumpInstruction
	
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpTrue: aJumpInstruction
	
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadConstant: aLoadImplicit
	
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitMessageSend: aMessageSend
	
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitPhi: aPhi
	
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitReadVariable: aReadVariable
	| binding |
	self ASSERT: (aReadVariable binding isKindOf: Binding).
	binding := aReadVariable binding.
	binding isTemporary
		ifTrue: [^self resolve: aReadVariable asTemporary: binding].
	binding isArgument
		ifTrue: [^self resolve: aReadVariable asArgument: binding].
	binding isSelf ifTrue: [^self resolveSelf: aReadVariable].
	binding isLiteral ifTrue: [^self resolve: aReadVariable asLiteral: binding].
	binding isInstVar
		ifTrue: [^self resolve: aReadVariable asInstanceVar: binding].
	binding refersToAssoc
		ifTrue: [^self resolve: aReadVariable asAssociationValue: binding].
	self ASSERT: false
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitReturn: aReturnInstruction
	
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitTernary: instruction
	
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitUnary: instruction
	
! !

!OptimizingVariableBinder methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitWriteVariable: aWriteVariable
	self ASSERT: (aWriteVariable binding isKindOf: Binding).
	self instructionsForWriting: aWriteVariable
! !

!OptimizingVariableBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
wordSize
	^abi wordSize
! !

!OptimizingVariableBinder methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
wordSizeShift
	^abi wordSizeShift
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingVariableBinder class' category: #OCompiler!
OptimizingVariableBinder class
	instanceVariableNames: ''!

!OptimizingVariableBinder class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


OptimizingVariableBinder initialize!

