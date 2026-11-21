"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OBasicBlock,
	#superclass : #OBeginInstruction,
	#instVars : [
		'end',
		'predecessors',
		'immediateDominator'
	],
	#category : #IR
}

{ #category : #unclassified }
OBasicBlock class >> new [
	^self basicNew initialize
]

{ #category : #unclassified }
OBasicBlock >> activationRecord [
	^self firstInstruction
]

{ #category : #unclassified }
OBasicBlock >> add: instruction [
	^end beforeInsert: instruction
]

{ #category : #unclassified }
OBasicBlock >> addFront: instruction [
	^self afterInsert: instruction
]

{ #category : #unclassified }
OBasicBlock >> addPredecessor: aBasicBlock [
	predecessors add: aBasicBlock
]

{ #category : #unclassified }
OBasicBlock >> allDominators [
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
			current size != (result at: block) size ifTrue: [
				result at: block put: current.
				changed := true]]].
	^result
]

{ #category : #unclassified }
OBasicBlock >> allLoopHeads [
	| loops doms |
	loops := Dictionary new.
	doms := self allDominators.
	self withSuccessorsPostOrder do: [:block | 
		block
			successorsDo: [:succ | ((doms at: block) includes: succ)
				ifTrue: [loops add: succ -> block]]].
	^loops
]

{ #category : #unclassified }
OBasicBlock >> allLoops [
	| result |
	result := Dictionary new.
	self allLoopHeads
		keysAndValuesDo: [:head :tail | result
			at: head
			put: (tail withPredecessorsUntil: head)].
	^result
]

{ #category : #unclassified }
OBasicBlock >> asArray [
	^self asReversePostOrderInstructionsCollection asArray
]

{ #category : #unclassified }
OBasicBlock >> asReversePostOrderInstructionsCollection [
	| collection |
	collection := OrderedCollection new.
	self
		instructionsWithReversePostOrderSuccessorsDo: [:inst | collection
			add: inst].
	^collection
]

{ #category : #accessing }
OBasicBlock >> basicBlock [
	^self
]

{ #category : #unclassified }
OBasicBlock >> beforeInsert: anInstruction [
	self error: 'cannot insert instructions before the start of a basic block'
]

{ #category : #unclassified }
OBasicBlock >> cleanPredecessors [
	predecessors := OrderedCollection new
]

{ #category : #unclassified }
OBasicBlock >> computeDominance [
	| all idoms indices intersect changed |
	all := self updatePredecessors withSuccessorsPostOrder reversed.
	idoms := Array new: all size.
	idoms at: 1 put: 1.
	indices := Dictionary new.
	all withIndexDo: [:block :index | indices at: block put: index].
	intersect := [:index1 :index2 | | finger1 finger2 |
		finger1 := index1.
		finger2 := index2.
		[finger1 != finger2] whileTrue: [
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
				intersection != (idoms at: index + 1) ifTrue: [
					idoms at: index + 1 put: intersection.
					changed := true]]].
	2 to: all size do: [:i | | index dominator |
		index := idoms at: i.
		dominator := all at: index.
		(all at: i) immediateDominator: dominator]
]

{ #category : #unclassified }
OBasicBlock >> computeLiveOutInto: liveOut andLiveInInto: liveIn [
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
			changed := changed or: [out size != size].
			block lastInstruction reverseDo: [:instruction | 
				instruction operandsDo: [:argument | 
					live addIfAbsent: argument.
					live removeIfPresent: instruction].
				liveIn at: block put: live]]]
]

{ #category : #unclassified }
OBasicBlock >> dissolveIfUnreachable [
	predecessors isEmpty ifTrue: [
		self lastValue
			ifNotNil: [:last | last reverseDo: [:instruction | instruction dissolve]]]
]

{ #category : #unclassified }
OBasicBlock >> dominanceFrontiers [
	| blocks result |
	blocks := self withSuccessorsPostOrder.
	result := Dictionary new.
	blocks do: [:block | result at: block put: OrderedCollection new].
	blocks do: [:block | 
		block hasMultiplePredecessors ifTrue: [
			block predecessors do: [:predecessor | | runner end |
				runner := predecessor.
				end := block immediateDominator.
				[runner != end] whileTrue: [| frontiers |
					frontiers := result at: runner.
					(frontiers includes: block) ifFalse: [frontiers add: block].
					runner := runner immediateDominator]]]].
	^result
]

{ #category : #unclassified }
OBasicBlock >> endWith: jumpType
to: target
skipping: skipped
if: compare [
	| jump |
	jump := jumpType variable: compare target: target implicitTarget: skipped.
	compare addUse: jump at: #variable.
	self lastInstruction afterInsert: jump
]

{ #category : #unclassified }
OBasicBlock >> endWithJumpFalseTo: target skipping: skipped if: condition [
	self endWith: OJumpFalse to: target skipping: skipped if: condition
]

{ #category : #unclassified }
OBasicBlock >> endWithJumpTo: target [
	| jump |
	jump := OJump to: target.
	self lastInstruction afterInsert: jump
]

{ #category : #unclassified }
OBasicBlock >> endWithJumpTrueTo: target skipping: skipped if: condition [
	self endWith: OJumpTrue to: target skipping: skipped if: condition
]

{ #category : #unclassified }
OBasicBlock >> firstInstruction [
	^next
]

{ #category : #unclassified }
OBasicBlock >> fullyRemovePredecessor: predecessor [
	self
		removePredecessor: predecessor;
		parametersDo: [:parameter | parameter removeBlock: predecessor].
	predecessors isEmpty
		ifTrue: [self successorsDo: [:succ | succ fullyRemovePredecessor: self]]
]

{ #category : #unclassified }
OBasicBlock >> hasMultiplePredecessors [
	^predecessors size > 1
]

{ #category : #unclassified }
OBasicBlock >> hasMultipleSuccessors [
	^self lastInstruction isConditionalJump
]

{ #category : #unclassified }
OBasicBlock >> hasSuccessors [
	^self lastInstruction isJump
]

{ #category : #accessing }
OBasicBlock >> immediateDominator [
	^immediateDominator
]

{ #category : #accessing }
OBasicBlock >> immediateDominator: aBasicBlock [
	immediateDominator := aBasicBlock
]

{ #category : #'block parameters' }
OBasicBlock >> incomingJumps [
	| jumps |
	jumps := predecessors collect: [:block | block lastInstruction].
	^jumps withoutDuplicates
]

{ #category : #unclassified }
OBasicBlock >> indexOf: anInstruction [
	| current |
	current := 1.
	self instructionsDo: [:instruction | 
		instruction == anInstruction ifTrue: [^current].
		current := current + 1].
	self error: 'instruction not found'
]

{ #category : #'block parameters' }
OBasicBlock >> indexOfParameter: aParameter [
	^self parameters indexOf: aParameter
]

{ #category : #unclassified }
OBasicBlock >> initialize [
	next := OEndInstruction new prev: self.
	end := next.
	predecessors := OrderedCollection new
]

{ #category : #unclassified }
OBasicBlock >> inline: inlined replacing: aMessageSend [
	| returned return join last |
	last := inlined lastBlock.
	return := last lastValue.
	returned := return source.
	aMessageSend replaceAllUsesWith: returned.
	return dissolve.
	inlined hasSuccessors ifTrue: [
		join := self splitAfter: aMessageSend.
		join addPredecessor: last.
		last endWithJumpTo: join].
	inlined moveAllTo: self after: aMessageSend.
	aMessageSend dissolve.
	^join ifNil: [self]
]

{ #category : #'block parameters' }
OBasicBlock >> insertParameter: aParameter [
	self incomingJumps do: [:jump | (jump argumentsTo: self) addFirst: nil].
	self addFront: aParameter
]

{ #category : #unclassified }
OBasicBlock >> insertPhiOf: block1 and: block2 replacing: operation [
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
]

{ #category : #unclassified }
OBasicBlock >> insertPhiOf: value1
at: block1
and: value2
at: block2
replacing: operation [
	| parameter |
	parameter := OBlockParameter new.
	self insertParameter: parameter.
	parameter addVariable: value1 from: block1; addVariable: value2 from: block2.
	operation replaceAllUsesWith: parameter; dissolve
]

{ #category : #unclassified }
OBasicBlock >> insertPhiOf: value1
at: block1
and: block2
replacing: operation [
	| value2 |
	value2 := block2 lastValue.
	value2 == nil ifTrue: [^operation dissolve].
	self
		insertPhiOf: value1
		at: block1
		and: value2
		at: block2
		replacing: operation
]

{ #category : #unclassified }
OBasicBlock >> instructionsAfter: first withReversePostOrderSuccessorsDo: aBlock [
	first do: aBlock.
	self withSuccessorsPostOrder
		removeLast;
		reverseDo: [:block | block instructionsDo: aBlock]
]

{ #category : #unclassified }
OBasicBlock >> instructionsAsCollection [
	| collection |
	collection := OrderedCollection new.
	self instructionsDo: [:inst | collection add: inst].
	^collection
]

{ #category : #unclassified }
OBasicBlock >> instructionsDo: aBlock [
	^next do: aBlock
]

{ #category : #unclassified }
OBasicBlock >> instructionsSelect: condition thenDo: aBlock [
	^next
		do: [:instruction | (condition value: instruction) ifTrue: [aBlock value: instruction]]
]

{ #category : #unclassified }
OBasicBlock >> instructionsWithPostOrderSuccessorsDo: aBlock [
	self postOrderDo: [:block | block instructionsDo: aBlock]
]

{ #category : #unclassified }
OBasicBlock >> instructionsWithReversePostOrderSuccessorsDo: aBlock [
	self reversePostOrderDo: [:block | block instructionsDo: aBlock]
]

{ #category : #unclassified }
OBasicBlock >> instructionsWithSuccessorsDo: aBlock [
	self withSuccessorsDo: [:block | block instructionsDo: aBlock]
]

{ #category : #unclassified }
OBasicBlock >> isEmptyBranch [
	self instructionsDo: [:instruction | ^instruction isConditionalJump]
]

{ #category : #unclassified }
OBasicBlock >> isEmptyJump [
	self instructionsDo: [:instruction | ^instruction isUnconditionalJump]
]

{ #category : #unclassified }
OBasicBlock >> isEmptyPhiBranch [
	self instructionsDo: [:instruction | | empty |
		empty := instruction isBlockParameter and: [| next |
			next := instruction next.
			next isConditionalJump
				and: [next variable == instruction and: [instruction isUsedJustOnce]]].
		^empty]
]

{ #category : #unclassified }
OBasicBlock >> iteratedDominanceFrontiersOf: blocks using: frontiers [
	| result changed |
	result := (blocks gather: [:block | frontiers at: block]) asSet.
	changed := true.
	[changed] whileTrue: [| size more |
		size := result size.
		more := result gather: [:block | frontiers at: block].
		result addAll: more.
		changed := size != result size].
	^result
]

{ #category : #unclassified }
OBasicBlock >> lastBlock [
	^self postOrderDo: [:block | ^block]
]

{ #category : #unclassified }
OBasicBlock >> lastInstruction [
	^end prev
]

{ #category : #unclassified }
OBasicBlock >> lastValue [
	| last |
	last := end lastValue.
	^last = self
		ifTrue: [predecessors size = 1 ifTrue: [predecessors first lastValue]]
		ifFalse: [last]
]

{ #category : #unclassified }
OBasicBlock >> length [
	| current |
	current := 0.
	self instructionsDo: [:instruction | current := current + 1].
	^current
]

{ #category : #unclassified }
OBasicBlock >> moveAllTo: block after: instruction [
	| last |
	next == end ifTrue: [^self].
	last := end prev.
	last afterConnect: instruction next.
	instruction afterConnect: next.
	self afterConnect: end.
	last successorsDo: [:succ | succ replacePredecessor: self with: block]
]

{ #category : #unclassified }
OBasicBlock >> name [
	^'#' , self hash printString
]

{ #category : #'block parameters' }
OBasicBlock >> newArguments [
	^OrderedCollection new: self parameters size withAll: nil
]

{ #category : #unclassified }
OBasicBlock >> parameters [
	| result |
	result := OrderedCollection new.
	self
		instructionsDo: [:instr | instr isBlockParameter
			ifTrue: [result add: instr]
			ifFalse: [^result]]
]

{ #category : #unclassified }
OBasicBlock >> parametersDo: aBlock [
	self
		instructionsDo: [:instr | instr isBlockParameter
			ifTrue: [aBlock value: instr]
			ifFalse: [^self]]
]

{ #category : #unclassified }
OBasicBlock >> postOrder: result seen: seen [
	seen add: self.
	self
		successorsDo: [:succ | (seen includes: succ)
			ifFalse: [succ postOrder: result seen: seen]].
	result add: self
]

{ #category : #unclassified }
OBasicBlock >> postOrderDo: aBlock [
	self withSuccessorsPostOrder do: [:block | aBlock value: block]
]

{ #category : #unclassified }
OBasicBlock >> predecessors [
	^predecessors
]

{ #category : #unclassified }
OBasicBlock >> prev: anInstruction [
	self error: 'cannot insert instructions before the start of a basic block'
]

{ #category : #unclassified }
OBasicBlock >> printAll [
	| stream |
	stream := '' writeStream.
	self reversePostOrderDo: [:block | 
		block printOn: stream.
		stream cr].
	^stream contents
]

{ #category : #unclassified }
OBasicBlock >> printAllNamed [
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
]

{ #category : #unclassified }
OBasicBlock >> printOn: aStream [
	aStream nextPutAll: '<=== ' , self name , String cr.
	super printOn: aStream.
	aStream nextPutAll: '===>'
]

{ #category : #unclassified }
OBasicBlock >> printOn: aStream using: names [
	| string |
	string := names at: self.
	aStream nextPutAll: '<=== ' , string , ' [' , self hash printString , '] \'.
	predecessors size > 0 ifTrue: [
		predecessors allButLast
			do: [:pred | aStream
				nextPutAll: (names at: pred ifAbsent: 'missing') , ' | '].
		aStream nextPutAll: (names at: predecessors last ifAbsent: 'missing')].
	aStream
		nextPutAll: '/' , String cr , (self printStringUsing: names)
			, '===>'
]

{ #category : #'block parameters' }
OBasicBlock >> removeParameter: aParameter [
	| index |
	index := self indexOfParameter: aParameter.
	self incomingJumps do: [:jump | (jump argumentsTo: self) removeIndex: index]
]

{ #category : #unclassified }
OBasicBlock >> removePredecessor: aBasicBlock [
	predecessors remove: aBasicBlock
]

{ #category : #unclassified }
OBasicBlock >> replacePredecessor: old with: new [
	self parametersDo: [:parameter | parameter replaceBlock: old with: new].
	predecessors replace: old with: new
]

{ #category : #unclassified }
OBasicBlock >> reversePostOrderDo: aBlock [
	self withSuccessorsPostOrder reverseDo: [:block | aBlock value: block]
]

{ #category : #unclassified }
OBasicBlock >> sortPhiVariables [
	self parametersDo: [:parameter | parameter sortAfter: predecessors]
]

{ #category : #unclassified }
OBasicBlock >> split [
	^self class new
]

{ #category : #unclassified }
OBasicBlock >> splitAfter: anInstruction [
	| block start last |
	block := self class new.
	start := anInstruction next.
	start isEnd ifTrue: [^block].
	last := end prev.
	block afterInsert: start to: last.
	anInstruction afterConnect: end.
	last successorsDo: [:succ | succ replacePredecessor: self with: block].
	^block
]

{ #category : #unclassified }
OBasicBlock >> splitAllCriticalEdges [
	self withSuccessorsPostOrder
		do: [:block | block splitIncomingCriticalEdges]
]

{ #category : #unclassified }
OBasicBlock >> splitBefore: anInstruction [
	^self splitAfter: anInstruction prev
]

{ #category : #unclassified }
OBasicBlock >> splitEdgeIfCriticalTo: succ [
	^(self hasMultipleSuccessors and: [succ hasMultiplePredecessors])
		ifTrue: [self splitEdgeTo: succ]
		ifFalse: [succ]
]

{ #category : #unclassified }
OBasicBlock >> splitEdgeTo: block [
	| middle jump branch |
	middle := self class new.
	jump := OJump to: block.
	middle add: jump.
	branch := self lastInstruction.
	branch moveArgumentsTo: jump for: block.
	branch target = block
		ifTrue: [branch target: middle]
		ifFalse: [branch implicitTarget: middle].
	middle addPredecessor: self.
	block replacePredecessor: self with: middle.
	^middle
]

{ #category : #unclassified }
OBasicBlock >> splitIncomingCriticalEdges [
	(self hasMultiplePredecessors or: [self firstInstruction isBlockParameter]) ifTrue: [
		predecessors
			do: [:pred | pred hasMultipleSuccessors ifTrue: [pred splitEdgeTo: self]]]
]

{ #category : #unclassified }
OBasicBlock >> successors [
	^end prev targets
]

{ #category : #unclassified }
OBasicBlock >> successorsDo: aBlock [
	next == end ifFalse: [self lastInstruction successorsDo: aBlock]
]

{ #category : #unclassified }
OBasicBlock >> successorsPostOrder [
	| seen result |
	seen := Set new.
	result := OrderedCollection new: 10.
	self
		successorsDo: [:succ | (seen includes: succ)
			ifFalse: [succ postOrder: result seen: seen]].
	^result
]

{ #category : #unclassified }
OBasicBlock >> unifyReturns [
	| all last extra ret prev end jump parameter |
	all := self withSuccessorsPostOrder.
	last := all removeFirst.
	extra := OrderedCollection new.
	all do: [:block | | potential |
		potential := block lastInstruction prev.
		potential class = OReturn ifTrue: [extra add: potential -> block]].
	extra size = 0 ifTrue: [^self].
	ret := last lastInstruction.
	prev := ret prev.
	(prev isBlockParameter and: prev = last firstInstruction)
		ifTrue: [
			end := last.
			parameter := prev]
		ifFalse: [
			end := last splitAfter: prev.
			end addPredecessor: last.
			jump := OJump to: end.
			prev afterInsert: jump.
			parameter := OBlockParameter new.
			end insertParameter: parameter.
			parameter
				addVariable: ret source from: last;
				addUse: ret at: #source.
			ret source removeUse: ret at: #source.
			ret source: parameter].
	extra do: [:assoc | | tail block old |
		tail := assoc key.
		block := assoc value.
		end addPredecessor: block.
		jump := tail next.
		old := jump target.
		old removePredecessor: block; parametersDo: [:each | each removeBlock: block].
		jump target: end.
		parameter addVariable: tail source from: block.
		tail dissolve]
]

{ #category : #unclassified }
OBasicBlock >> updatePredecessors [
	self
		postOrderDo: [:block | block cleanPredecessors];
		postOrderDo: [:block | block
			successorsDo: [:successor | successor addPredecessor: block]];
		postOrderDo: [:block | block sortPhiVariables]
]

{ #category : #unclassified }
OBasicBlock >> usesResultOf: anInstruction [
	next
		detect: [:instruction | instruction usesResultOf: anInstruction]
		ifNone: [^false].
	^true
]

{ #category : #unclassified }
OBasicBlock >> verifyAllInstructionsSanity [
	self withSuccessorsDo: [:block | | forward current backwards |
		forward := OrderedCollection new.
		current := block.
		[current == nil] whileFalse: [
			forward add: current.
			current := current next].
		backwards := OrderedCollection new.
		current := forward last.
		[current == nil] whileFalse: [
			backwards add: current.
			current := current prev].
		self ASSERT: forward = backwards reversed]
]

{ #category : #unclassified }
OBasicBlock >> verifyAllPredecessorsSanity [
	self withSuccessorsDo: [:block | 
		block
			successorsDo: [:successor | self ASSERT: (successor predecessors includes: block)].
		block predecessors
			do: [:predecessor | self ASSERT: (predecessor successors includes: block)]]
]

{ #category : #unclassified }
OBasicBlock >> withPredecessors [
	| result incoming |
	result := OrderedCollection new.
	incoming := OrderedCollection with: self.
	[
		result addAll: incoming.
		incoming := incoming gather: #predecessors.
		incoming removeAllSuchThat: [:pred | result includes: pred].
		incoming isEmpty] whileFalse.
	^result
]

{ #category : #unclassified }
OBasicBlock >> withPredecessorsUntil: block [
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
]

{ #category : #unclassified }
OBasicBlock >> withSuccessorsDo: aBlock [
	| done remaining |
	done := Set new.
	remaining := OrderedCollection new: 10.
	remaining add: self.
	[remaining notEmpty] whileTrue: [| block |
		block := remaining removeFirst.
		aBlock value: block.
		done add: block.
		block successorsDo: [:succ |
			((done includes: succ) or: [remaining includes: succ])
				ifFalse: [remaining add: succ]]]
]

{ #category : #unclassified }
OBasicBlock >> withSuccessorsPostOrder [
	| seen result |
	seen := Set new.
	result := OrderedCollection new: 10.
	self postOrder: result seen: seen.
	^result
]

