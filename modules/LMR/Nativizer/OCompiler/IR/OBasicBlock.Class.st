'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OBasicBlock category: #IR!
Object subclass: #OBasicBlock
	instanceVariableNames: 'firstInstruction lastInstruction predecessors'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'IR'!
!OBasicBlock commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
activationRecord
	^self firstInstruction
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
add: instruction
	^lastInstruction beforeInsert: instruction
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addFront: instruction
	^firstInstruction afterInsert: instruction
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addPredecessor: aBasicBlock
	predecessors add: aBasicBlock
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
allDominators
	| result all changed |
	result := Dictionary new.
	all := self withSuccessorsPostOrder.
	all do: [:block | result at: block put: (Set with: block)].
	changed := true.
	[changed] whileTrue: [| current |
		changed := false.
		all reverseDo: [:block | | incoming |
			incoming := block predecessors collect: [:pred | result at: pred].
			current := incoming isEmpty ifTrue: [Set new] ifFalse: [
				incoming
					inject: incoming first
					into: [:intersection :doms | doms intersection: intersection]].
			current add: block.
			current size !!= (result at: block) size ifTrue: [
				result at: block put: current.
				changed := true]]].
	^result
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
allLoopHeads
	| loops doms |
	loops := Dictionary new.
	doms := self allDominators.
	self withSuccessorsPostOrder do: [:block | 
		block successors
			do: [:succ | ((doms at: block) includes: succ)
				ifTrue: [loops add: succ -> block]]].
	^loops
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
allLoops
	| result |
	result := Dictionary new.
	self allLoopHeads
		keysAndValuesDo: [:head :tail | result
			at: head
			put: (tail withPredecessorsUntil: head)].
	^result
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
asArray
	^self asReversePostOrderInstructionsCollection asArray
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
asReversePostOrderInstructionsCollection
	| collection |
	collection := OrderedCollection new.
	self
		instructionsWithReversePostOrderSuccessorsDo: [:inst | collection
			add: inst].
	^collection
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
cleanPredecessors
	predecessors := OrderedCollection new
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
computeLiveOutInto: liveOut andLiveInInto: liveIn
	| blocks changed |
	blocks := self withSuccessorsPostOrder.
	blocks reverseDo: [:block | | in out |
		in := OrderedCollection new.
		out := OrderedCollection new.
		liveOut at: block put: out.
		liveIn at: block put: in].
	changed := true.
	[changed] whileTrue: [
		changed := false.
		blocks reverseDo: [:block | | live out size |
			live := block successors gather: [:succ | liveIn at: succ].
			out := liveOut at: block.
			size := out size.
			out := out addAll: live; withoutDuplicates.
			changed := changed or: [out size !!= size].
			block lastInstruction reverseDo: [:instruction | 
				instruction operandsDo: [:argument | 
					live addIfAbsent: argument.
					live removeIfPresent: instruction].
				liveIn at: block put: live]]]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
dissolveIfUnreachable
	predecessors isEmpty ifTrue: [
		self lastValue
			ifNotNil: [:last | last reverseDo: [:instruction | instruction dissolve]]]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
dominanceFrontiers
	| idoms |
	idoms := self dominatorTree allImmediateDominators.
	^self dominanceFrontiersUsing: idoms
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
dominanceFrontiersUsing: idoms
	| blocks result |
	blocks := self withSuccessorsPostOrder.
	result := Dictionary new.
	blocks do: [:block | result at: block put: OrderedCollection new].
	blocks do: [:block | 
		block predecessors size > 1 ifTrue: [
			block predecessors do: [:predecessor | | runner end |
				runner := predecessor.
				end := idoms at: block.
				[runner !!= end] whileTrue: [| frontiers |
					frontiers := result at: runner.
					(frontiers includes: block) ifFalse: [frontiers add: block].
					runner := idoms at: runner]]]].
	^result
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
dominatorTree
	| all root idoms indices intersect changed |
	all := self updatePredecessors withSuccessorsPostOrder reversed.
	idoms := Array new: all size.
	idoms at: 1 put: 1.
	root := all first.
	indices := Dictionary new.
	all withIndexDo: [:block :index | indices at: block put: index].
	intersect := [:index1 :index2 | | finger1 finger2 |
		finger1 := index1.
		finger2 := index2.
		[finger1 !!= finger2] whileTrue: [
			finger1 > finger2
				ifTrue: [finger1 := idoms at: finger1]
				ifFalse: [finger2 := idoms at: finger2]].
		finger1].
	changed := true.
	[changed] whileTrue: [
		changed := false.
		(all copyFrom: 2)
			withIndexDo: [:block :index | | processed initial intersection |
				processed := block predecessors select: [:predecessor | | i |
					i := indices at: predecessor.
					(idoms at: i) notNil].
				initial := indices at: processed first.
				intersection := processed
					inject: initial
					into: [:actual :predecessor | | candidate |
						candidate := indices at: predecessor.
						intersect value: actual value: candidate].
				intersection !!= (idoms at: index + 1) ifTrue: [
					idoms at: index + 1 put: intersection.
					changed := true]]].
	^ODominatorTree from: root with: all dominators: idoms
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
endWith: jumpType to: target skipping: skipped if: compare
	| jump |
	jump := jumpType variable: compare target: target implicitTarget: skipped.
	compare addUse: jump at: #variable.
	self lastInstruction afterInsert: jump
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
endWithJumpFalseTo: target skipping: skipped if: condition
	self endWith: OJumpFalse to: target skipping: skipped if: condition
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
endWithJumpTo: target
	| jump |
	jump := OJump to: target.
	self lastInstruction afterInsert: jump
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
endWithJumpTrueTo: target skipping: skipped if: condition
	self endWith: OJumpTrue to: target skipping: skipped if: condition
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstInstruction
	^firstInstruction next
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstNonPhi
	^self firstInstruction firstNonPhi
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
fullyRemovePredecessor: predecessor
	self
		removePredecessor: predecessor;
		phisDo: [:phi | phi removeBlock: predecessor].
	predecessors isEmpty
		ifTrue: [self successors do: [:succ | succ fullyRemovePredecessor: self]]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
ifHasExplicitSuccesor: explicitBlock ifHasImplicitSuccesor: implicitBlock
	| last |
	last := self lastInstruction.
	last isJump ifFalse: [^self].
	explicitBlock value: last target.
	last isConditionalJump ifTrue: [implicitBlock value: last implicitTarget]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
incorporatePhisFrom: predecessor
	| index |
	predecessors size = 1 ifTrue: [^predecessor movePhisTo: self].
	self phisDo: [:phi | | source parents vars |
		index := phi blocks indexOf: predecessor.
		source := phi variables at: index.
		parents := predecessor predecessors.
		vars := (predecessor phis includes: source)
			ifTrue: [source variables copy]
			ifFalse: [OrderedCollection new: parents size withAll: source].
		vars withIndexDo: [:var :i | | pred |
			pred := parents at: i.
			phi addVariable: var from: pred].
		phi removeVariable: source at: index]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
indexOf: anInstruction
	| current |
	current := 1.
	self instructionsDo: [:instruction | 
		instruction == anInstruction ifTrue: [^current].
		current := current + 1].
	self error: 'instruction not found'
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	firstInstruction := OInstruction empty.
	lastInstruction := firstInstruction next.
	predecessors := OrderedCollection new
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeWith: anInstruction
	firstInstruction := anInstruction cutPrevious.
	lastInstruction := firstInstruction last next.
	predecessors := OrderedCollection new
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
inline: inlined replacing: aMessageSend
	| returned return join last |
	last := inlined lastBlock.
	return := last lastValue.
	returned := return source.
	aMessageSend replaceAllUsesWith: returned.
	return dissolve.
	inlined successors isEmpty ifFalse: [
		join := self splitAfter: aMessageSend.
		join addPredecessor: last.
		last endWithJumpTo: join].
	aMessageSend dissolveReplacingWithAll: inlined firstInstruction.
	self replaceAsPredecessor: inlined.
	^join ifNil: [self]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertPhiOf: block1 and: block2 replacing: operation
	| value1 value2 |
	value1 := block1 lastValue.
	value2 := block2 lastValue.
	(value1 == nil or: [value2 == nil]) ifTrue: [^operation dissolve].
	self
		insertPhiOf: value1
		at: block1
		and: value2
		at: block2
		replacing: operation
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertPhiOf: value1 at: block1 and: value2 at: block2 replacing: operation
	| phi |
	phi := OPhi with: value1 from: block1 with: value2 from: block2.
	self firstInstruction beforeInsert: phi.
	operation replaceAllUsesWith: phi; dissolve
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertPhiOf: value1 at: block1 and: block2 replacing: operation
	| value2 |
	value2 := block2 lastValue.
	value2 == nil ifTrue: [^operation dissolve].
	self
		insertPhiOf: value1
		at: block1
		and: value2
		at: block2
		replacing: operation
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructionsAfter: first withReversePostOrderSuccessorsDo: aBlock
	first do: aBlock.
	self withSuccessorsPostOrder
		removeLast;
		reverseDo: [:block | block instructionsDo: aBlock]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructionsAsCollection
	| collection |
	collection := OrderedCollection new.
	self instructionsDo: [:inst | collection add: inst].
	^collection
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructionsDo: aBlock
	^firstInstruction do: aBlock
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructionsSelect: condition thenDo: aBlock
	^firstInstruction
		do: [:next | (condition value: next) ifTrue: [aBlock value: next]]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructionsWithPostOrderSuccessorsDo: aBlock
	self postOrderDo: [:block | block instructionsDo: aBlock]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructionsWithReversePostOrderSuccessorsDo: aBlock
	self reversePostOrderDo: [:block | block instructionsDo: aBlock]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
instructionsWithSuccessorsDo: aBlock
	self withSuccessorsDo: [:block | block instructionsDo: aBlock]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isEmptyBranch
	self instructionsDo: [:instruction | ^instruction isConditionalJump]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isEmptyJump
	self instructionsDo: [:instruction | ^instruction isUnconditionalJump]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isEmptyPhiBranch
	self instructionsDo: [:instruction | | empty |
		empty := instruction isPhi and: [| next |
			next := instruction next.
			next isConditionalJump
				and: [next variable == instruction and: [instruction isUsedJustOnce]]].
		^empty]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isOnlyPhiBranch
	| last |
	last := self lastInstruction.
	last isConditionalJump ifFalse: [^false].
	self instructionsDo: [:instruction | 
		instruction = last ifTrue: [^true].
		instruction isPhi ifFalse: [^false]]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isPhiArgument: instruction
	self phisDo: [:phi | (phi variables includes: instruction) ifTrue: [^true]].
	^false
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
iteratedDominanceFrontiersOf: blocks using: frontiers
	| result changed |
	result := (blocks gather: [:block | frontiers at: block]) asSet.
	changed := true.
	[changed] whileTrue: [| size more |
		size := result size.
		more := result gather: [:block | frontiers at: block].
		result addAll: more.
		changed := size !!= result size].
	^result
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
lastBlock
	^self postOrderDo: [:block | ^block]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
lastInstruction
	^lastInstruction prev
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
lastPhi
	^self firstInstruction lastPhi
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
lastValue
	| last |
	last := lastInstruction lastValue.
	^last = firstInstruction
		ifTrue: [predecessors size = 1 ifTrue: [predecessors first lastValue]]
		ifFalse: [last]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
length
	| current |
	current := 0.
	self instructionsDo: [:instruction | current := current + 1].
	^current
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
movePhisTo: otherBlock
	| inst dest |
	inst := self firstInstruction.
	dest := otherBlock firstInstruction prev.
	[inst isPhi] whileTrue: [| next |
		next := inst next.
		dest afterInsert: inst.
		dest := inst.
		inst := next]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	^'#' , self hash printString
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
phis
	| result |
	result := OrderedCollection new.
	self
		instructionsDo: [:instr | instr isPhi
			ifTrue: [result add: instr]
			ifFalse: [^result]]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
phisDo: aBlock
	self
		instructionsDo: [:instr | instr isPhi
			ifTrue: [aBlock value: instr]
			ifFalse: [^self]]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
phiValuesComingFrom: block
	^self phis collect: [:phi | phi atOperand: block]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
phiWithArgument: instruction
	self phisDo: [:phi | (phi variables includes: instruction) ifTrue: [^phi]].
	self error: 'not found'
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
postOrder: result seen: seen
	seen add: self.
	self
		ifHasExplicitSuccesor: [:next | (seen includes: next)
			ifFalse: [next postOrder: result seen: seen]]
		ifHasImplicitSuccesor: [:next | (seen includes: next)
			ifFalse: [next postOrder: result seen: seen]].
	result add: self
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
postOrderDo: aBlock
	self withSuccessorsPostOrder do: [:block | aBlock value: block]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
predecessors
	^predecessors
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printAll
	| stream |
	stream := '' writeStream.
	self reversePostOrderDo: [:block | 
		block printOn: stream.
		stream cr].
	^stream contents
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printAllNamed
	| stream names vars blocks |
	stream := '' writeStream.
	names := Dictionary new.
	vars := 0.
	blocks := 0.
	self reversePostOrderDo: [:block | 
		block instructionsDo: [:inst | 
			names at: inst put: 'v' , vars printString.
			vars := vars + 1].
		names at: block put: 'B' , blocks printString.
		blocks := blocks + 1].
	self reversePostOrderDo: [:block | 
		block printOn: stream using: names.
		stream cr].
	^stream contents
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream
		nextPutAll: '<=== ' , self name , String cr , firstInstruction asString
			, '===>'
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream using: names
	| string |
	string := names at: self.
	aStream nextPutAll: '<=== ' , string , ' [' , self hash printString , '] \'.
	predecessors size > 0 ifTrue: [
		predecessors allButLast
			do: [:pred | aStream
				nextPutAll: (names at: pred ifAbsent: 'missing') , ' | '].
		aStream nextPutAll: (names at: predecessors last ifAbsent: 'missing')].
	aStream
		nextPutAll: '/' , String cr , (firstInstruction printStringUsing: names)
			, '===>'
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
realInstructionsDo: aBlock
	| current |
	current := self firstInstruction.
	[current isPhi] whileTrue: [current := current next].
	current do: aBlock
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
removePredecessor: aBasicBlock
	predecessors remove: aBasicBlock
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
replaceAsPredecessor: old
	self successors do: [:succ | succ replacePredecessor: old with: self]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
replacePredecessor: old with: new
	self phisDo: [:phi | phi replaceBlock: old with: new].
	predecessors replace: old with: new
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
reversePostOrderDo: aBlock
	self withSuccessorsPostOrder reverseDo: [:block | aBlock value: block]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
sortPhiVariables
	self phisDo: [:phi | phi sortAfter: predecessors]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
split
	^self class new
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
splitAfter: anInstruction
	| next |
	next := self class newStartingWith: anInstruction next.
	lastInstruction := anInstruction cutFollowing.
	next replaceAsPredecessor: self.
	^next
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
splitAllCriticalEdges
	self withSuccessorsPostOrder
		do: [:block | block splitIncomingCriticalEdges]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
splitBefore: anInstruction
	^self splitAfter: anInstruction prev
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
splitEdgeIfCriticalTo: succ
	^(self successors size > 1 and: [succ predecessors size > 1])
		ifTrue: [self splitEdgeTo: succ]
		ifFalse: [succ]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
splitEdgeTo: block
	| middle jump branch |
	middle := self class new.
	jump := OJump to: block.
	middle add: jump.
	branch := self lastInstruction.
	branch target = block
		ifTrue: [branch target: middle]
		ifFalse: [branch implicitTarget: middle].
	middle addPredecessor: self.
	block replacePredecessor: self with: middle.
	^middle
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
splitIncomingCriticalEdges
	predecessors size > 1 ifTrue: [
		predecessors
			do: [:pred | pred successors size > 1 ifTrue: [pred splitEdgeTo: self]]]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
successors
	^lastInstruction prev targets
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
successorsPostOrder
	| seen result |
	seen := Set new.
	result := OrderedCollection new: 10.
	self
		ifHasExplicitSuccesor: [:next | (seen includes: next)
			ifFalse: [next postOrder: result seen: seen]]
		ifHasImplicitSuccesor: [:next | (seen includes: next)
			ifFalse: [next postOrder: result seen: seen]].
	^result
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
unifyReturns
	| all last extra ret prev end jump phi |
	all := self withSuccessorsPostOrder.
	last := all removeFirst.
	extra := OrderedCollection new.
	all do: [:block | | potential |
		potential := block lastInstruction prev.
		potential class = OReturn ifTrue: [extra add: potential -> block]].
	extra size = 0 ifTrue: [^self].
	ret := last lastInstruction.
	prev := ret prev.
	(prev isPhi and: prev = last firstInstruction)
		ifTrue: [
			end := last.
			phi := prev]
		ifFalse: [
			end := last splitAfter: prev.
			end addPredecessor: last.
			jump := OJump to: end.
			prev afterInsert: jump.
			phi := OPhi new.
			phi
				addVariable: ret source from: last;
				addUse: ret at: #source.
			ret source removeUse: ret at: #source.
			ret source: phi; beforeInsert: phi].
	extra do: [:assoc | | tail block |
		tail := assoc key.
		block := assoc value.
		phi addVariable: tail source from: block.
		end addPredecessor: block.
		jump := tail next.
		jump target removePredecessor: block.
		jump target: end.
		tail dissolve]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
updatePredecessors
	self
		postOrderDo: [:block | block cleanPredecessors];
		postOrderDo: [:block | block successors
			do: [:successor | successor addPredecessor: block]];
		postOrderDo: [:block | block sortPhiVariables]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usesResultOf: anInstruction
	firstInstruction
		detect: [:instruction | instruction usesResultOf: anInstruction]
		ifNone: [^false].
	^true
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
verifyAllInstructionsSanity
	self withSuccessorsDo: [:block | | forward current backwards |
		forward := OrderedCollection new.
		current := block instVarNamed: #firstInstruction.
		[current == nil] whileFalse: [
			forward add: current.
			current := current next].
		backwards := OrderedCollection new.
		current := forward last.
		[current == nil] whileFalse: [
			backwards add: current.
			current := current prev].
		self ASSERT: forward = backwards reversed]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
verifyAllPredecessorsSanity
	self withSuccessorsDo: [:block | 
		block successors
			do: [:successor | self ASSERT: (successor predecessors includes: block)].
		block predecessors
			do: [:predecessor | self ASSERT: (predecessor successors includes: block)]]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
withPredecessors
	| result incoming |
	result := OrderedCollection new.
	incoming := OrderedCollection with: self.
	[
		result addAll: incoming.
		incoming := incoming gather: #predecessors.
		incoming removeAllSuchThat: [:pred | result includes: pred].
		incoming isEmpty] whileFalse.
	^result
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
withPredecessorsUntil: block
	| result incoming |
	result := OrderedCollection new.
	incoming := OrderedCollection with: self.
	[
		result addAll: incoming.
		incoming := incoming gather: #predecessors.
		incoming
			removeAllSuchThat: [:pred | pred == block or: [result includes: pred]].
		incoming isEmpty] whileFalse.
	^result
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
withSuccessorsDo: aBlock
	| done remaining |
	done := Set new.
	remaining := OrderedCollection new: 10.
	remaining add: self.
	[remaining notEmpty] whileTrue: [| block more |
		block := remaining removeFirst.
		aBlock value: block.
		done add: block.
		more := block successors
			reject: [:succesor | (done includes: succesor)
				or: [remaining includes: succesor]].
		remaining addAll: more]
! !

!OBasicBlock methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
withSuccessorsPostOrder
	| seen result |
	seen := Set new.
	result := OrderedCollection new: 10.
	self postOrder: result seen: seen.
	^result
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OBasicBlock class' category: #IR!
OBasicBlock class
	instanceVariableNames: ''!

!OBasicBlock class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !

!OBasicBlock class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
newStartingWith: anInstruction
	^self basicNew initializeWith: anInstruction
! !


OBasicBlock initialize!

