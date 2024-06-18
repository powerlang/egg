"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OBasicBlock',
	#superclass : 'OBeginInstruction',
	#instVars : [
		'end',
		'predecessors'
	],
	#category : 'OCompiler-Core-IR',
	#package : 'OCompiler-Core',
	#tag : 'IR'
}

{ #category : 'private' }
OBasicBlock class >> decorator [
	^Smalltalk at: #CollectionDecorator
]

{ #category : 'unclassified' }
OBasicBlock >> activationRecord [
	^next
]

{ #category : 'unclassified' }
OBasicBlock >> add: instruction [
	^end beforeInsert: instruction
]

{ #category : 'adding / removing' }
OBasicBlock >> addFrom: first to: last [
	end prev afterInsert: first to: last
]

{ #category : 'unclassified' }
OBasicBlock >> addFront: instruction [
	^self afterInsert: instruction
]

{ #category : 'unclassified' }
OBasicBlock >> addPredecessor: aBasicBlock [
	predecessors add: aBasicBlock
]

{ #category : 'unclassified' }
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

{ #category : 'unclassified' }
OBasicBlock >> allLoopHeads [
	| loops doms |
	loops := Dictionary new.
	doms := self allDominators.
	self withSuccessorsPostOrder do: [:block | 
		block successors
			do: [:succ | ((doms at: block) includes: succ)
				ifTrue: [loops add: succ -> block]]].
	^loops
]

{ #category : 'unclassified' }
OBasicBlock >> allLoops [
	| result |
	result := Dictionary new.
	self allLoopHeads
		keysAndValuesDo: [:head :tail | result
			at: head
			put: (tail withPredecessorsUntil: head)].
	^result
]

{ #category : 'private' }
OBasicBlock >> allReturnsWithBlocks [
	"
	last block ends in a return, but other blocks are the result of inlining,
	hence they end in a jump to the next block, and the return is the instruction
	before that jump
	"
	| result blocks last |
	result := OrderedCollection new.
	blocks := self withSuccessorsPostOrder.
	last := blocks removeFirst.
	result add: last lastInstruction -> last.
	blocks do: [:block | | potential |
		self _ASSERT: block lastInstruction isReturn not.
		potential := block lastInstruction prev.
		potential isReturn ifTrue: [result add: potential -> block]].
	^result
]

{ #category : 'unclassified' }
OBasicBlock >> asArray [
	^self asReversePostOrderInstructionsCollection asArray
]

{ #category : 'private' }
OBasicBlock >> asOrderedCollection [
	^OrderedCollection withAll: self
]

{ #category : 'unclassified' }
OBasicBlock >> asReversePostOrderInstructionsCollection [
	| collection |
	collection := OrderedCollection new.
	self
		instructionsWithReversePostOrderSuccessorsDo: [:inst | collection
			add: inst].
	^collection
]

{ #category : 'unclassified' }
OBasicBlock >> cleanPredecessors [
	predecessors := OrderedCollection new
]

{ #category : 'private' }
OBasicBlock >> collect: aBlock in: aCollection [
	self do: [:inst | | collected |
		collected := aBlock value: inst.
		aCollection add: collected].
	^aCollection
]

{ #category : 'unclassified' }
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

{ #category : 'private' }
OBasicBlock >> copyTo: copy with: map [
	| copyend |
	copy afterConnect: (next duplicateWith: map).
	copyend := map at: end.
	(end prev duplicateWith: map) afterConnect: copyend.
	copy predecessors: (predecessors collect: [:pred | pred duplicateWith: map])
]

{ #category : 'private' }
OBasicBlock >> dissolveAllInstructions [
	| value |
	[
		value := self lastValue.
		value notNil]
		whileTrue: [value dissolveDeep]
]

{ #category : 'private' }
OBasicBlock >> dissolveIfUnreachable [
	predecessors isEmpty ifTrue: [self dissolveAllInstructions]
]

{ #category : 'unclassified' }
OBasicBlock >> dominanceFrontiers [
	| idoms |
	idoms := self dominatorTree allImmediateDominators.
	^self dominanceFrontiersUsing: idoms
]

{ #category : 'unclassified' }
OBasicBlock >> dominanceFrontiersUsing: idoms [
	| blocks result |
	blocks := self withSuccessorsPostOrder.
	result := Dictionary new.
	blocks do: [:block | result at: block put: OrderedCollection new].
	blocks do: [:block | 
		block predecessors size > 1 ifTrue: [
			block predecessors do: [:predecessor | | runner end |
				runner := predecessor.
				end := idoms at: block.
				[runner != end] whileTrue: [| frontiers |
					frontiers := result at: runner.
					(frontiers includes: block) ifFalse: [frontiers add: block].
					runner := idoms at: runner]]]].
	^result
]

{ #category : 'unclassified' }
OBasicBlock >> dominatorTree [
	| all root idoms indices intersect changed |
	all := self withSuccessorsPostOrder reversed.
	idoms := Array new: all size.
	idoms at: 1 put: 1.
	root := all first.
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
	^ODominatorTree from: root with: all dominators: idoms
]

{ #category : 'private' }
OBasicBlock >> duplicate [
	^self duplicateWith: IdentityDictionary new
]

{ #category : 'private' }
OBasicBlock >> duplicateWith: map [
	| copy |
	map at: self ifPresent: [:c | ^c].
	copy := self class new.
	map
		at: self put: copy;
		at: end put: copy next.
	prev ifNotNil: [copy prev: (prev duplicateWith: map)].
	next ifNotNil: [copy next: (next duplicateWith: map)].
	self copyTo: copy with: map.
	^copy
]

{ #category : 'private' }
OBasicBlock >> endWith: jumpType
to: target
skipping: skipped
if: compare [
	| jump |
	jump := jumpType variable: compare target: target implicitTarget: skipped.
	end beforeInsert: jump.
	target addPredecessor: self.
	skipped addPredecessor: self.
	^jump
]

{ #category : 'unclassified' }
OBasicBlock >> endWithJumpFalseTo: target skipping: skipped if: condition [
	self endWith: OJumpFalse to: target skipping: skipped if: condition
]

{ #category : 'private' }
OBasicBlock >> endWithJumpTo: target [
	| jump |
	jump := OJump to: target.
	end beforeInsert: jump.
	target addPredecessor: self
]

{ #category : 'unclassified' }
OBasicBlock >> endWithJumpTrueTo: target skipping: skipped if: condition [
	self endWith: OJumpTrue to: target skipping: skipped if: condition
]

{ #category : 'unclassified' }
OBasicBlock >> firstInstruction [
	^next
]

{ #category : 'unclassified' }
OBasicBlock >> firstNonPhi [
	^next firstNonPhi
]

{ #category : 'unclassified' }
OBasicBlock >> fullyRemovePredecessor: predecessor [
	self
		removePredecessor: predecessor;
		phisDo: [:phi | phi removeBlock: predecessor].
	predecessors isEmpty
		ifTrue: [self successors do: [:succ | succ fullyRemovePredecessor: self]]
]

{ #category : 'unclassified' }
OBasicBlock >> hasMultiplePredecessors [
	^predecessors size > 1
]

{ #category : 'unclassified' }
OBasicBlock >> hasMultipleSuccessors [
	^self lastInstruction isConditionalJump
]

{ #category : 'unclassified' }
OBasicBlock >> hasSuccessors [
	^self lastInstruction isJump
]

{ #category : 'unclassified' }
OBasicBlock >> incorporatePhisFrom: predecessor [
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
]

{ #category : 'unclassified' }
OBasicBlock >> indexOf: anInstruction [
	| current |
	current := 1.
	self instructionsDo: [:instruction | 
		instruction == anInstruction ifTrue: [^current].
		current := current + 1].
	self error: 'instruction not found'
]

{ #category : 'unclassified' }
OBasicBlock >> initialize [
	next := OEndInstruction new prev: self.
	end := next.
	predecessors := OrderedCollection new
]

{ #category : 'unclassified' }
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

{ #category : 'unclassified' }
OBasicBlock >> insertPhiOf: value1
at: block1
and: value2
at: block2
replacing: operation [
	| phi |
	phi := OPhi with: value1 from: block1 with: value2 from: block2.
	self afterInsert: phi.
	operation replaceAllUsesWith: phi; dissolve
]

{ #category : 'unclassified' }
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

{ #category : 'unclassified' }
OBasicBlock >> instructionsAfter: first withReversePostOrderSuccessorsDo: aBlock [
	first do: aBlock.
	self withSuccessorsPostOrder
		removeLast;
		reverseDo: [:block | block instructionsDo: aBlock]
]

{ #category : 'unclassified' }
OBasicBlock >> instructionsAsCollection [
	| collection |
	collection := OrderedCollection new.
	self instructionsDo: [:inst | collection add: inst].
	^collection
]

{ #category : 'unclassified' }
OBasicBlock >> instructionsDo: aBlock [
	^next do: aBlock
]

{ #category : 'unclassified' }
OBasicBlock >> instructionsReverseDo: aBlock [
	^end reverseDo: aBlock
]

{ #category : 'unclassified' }
OBasicBlock >> instructionsWithPostOrderSuccessorsDo: aBlock [
	self postOrderDo: [:block | block instructionsDo: aBlock]
]

{ #category : 'unclassified' }
OBasicBlock >> instructionsWithReversePostOrderSuccessorsDo: aBlock [
	self reversePostOrderDo: [:block | block instructionsDo: aBlock]
]

{ #category : 'unclassified' }
OBasicBlock >> instructionsWithSuccessorsDo: aBlock [
	self withSuccessorsDo: [:block | block instructionsDo: aBlock]
]

{ #category : 'unclassified' }
OBasicBlock >> isEmptyBranch [
	self instructionsDo: [:instruction | ^instruction isConditionalJump]
]

{ #category : 'unclassified' }
OBasicBlock >> isEmptyJump [
	self instructionsDo: [:instruction | ^instruction isUnconditionalJump]
]

{ #category : 'unclassified' }
OBasicBlock >> isEmptyPhiBranch [
	self instructionsDo: [:instruction | | empty |
		empty := instruction isPhi and: [| next |
			next := instruction next.
			next isConditionalJump
				and: [next variable == instruction and: [instruction isUsedJustOnce]]].
		^empty]
]

{ #category : 'unclassified' }
OBasicBlock >> isOnlyPhiBranch [
	| last |
	last := self lastInstruction.
	last isConditionalJump ifFalse: [^false].
	self instructionsDo: [:instruction | 
		instruction = last ifTrue: [^true].
		instruction isPhi ifFalse: [^false]]
]

{ #category : 'unclassified' }
OBasicBlock >> isPhiArgument: instruction [
	self phisDo: [:phi | (phi variables includes: instruction) ifTrue: [^true]].
	^false
]

{ #category : 'testing' }
OBasicBlock >> isReachableFrom: aBasicBlock [
	| seen work |
	seen := Set withAll: predecessors.
	work := OrderedCollection withAll: predecessors.
	[work isEmpty] whileFalse: [| block |
		block := work removeFirst.
		block == aBasicBlock ifTrue: [^true].
		block predecessors do: [:p | 
			(seen includes: p) ifFalse: [
				seen add: p.
				work add: p]]].
	^false
]

{ #category : 'unclassified' }
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

{ #category : 'unclassified' }
OBasicBlock >> lastBlock [
	^self postOrderDo: [:block | ^block]
]

{ #category : 'unclassified' }
OBasicBlock >> lastInstruction [
	^end prev
]

{ #category : 'unclassified' }
OBasicBlock >> lastValue [
	| last |
	last := end lastValue.
	^last = self
		ifTrue: [predecessors size = 1 ifTrue: [predecessors first lastValue]]
		ifFalse: [last]
]

{ #category : 'unclassified' }
OBasicBlock >> length [
	| current |
	current := 0.
	self instructionsDo: [:instruction | current := current + 1].
	^current
]

{ #category : 'unclassified' }
OBasicBlock >> moveAllTo: block [
	self moveAllTo: block after: block lastInstruction
]

{ #category : 'unclassified' }
OBasicBlock >> moveAllTo: block after: instruction [
	block replace: self asPredecessorIn: self successors.
	next == end ifTrue: [^self].
	end prev afterConnect: instruction next.
	instruction afterConnect: next.
	self afterConnect: end
]

{ #category : 'unclassified' }
OBasicBlock >> movePhisTo: otherBlock [
	| inst dest |
	inst := next.
	dest := otherBlock.
	[inst isPhi] whileTrue: [| next |
		next := inst next.
		dest afterInsert: inst.
		dest := inst.
		inst := next]
]

{ #category : 'unclassified' }
OBasicBlock >> name [
	^'#' , self hash printString
]

{ #category : 'unclassified' }
OBasicBlock >> nilUnitializedTemporaries [
	| stack uninitialized nilval |
	stack := self activationRecord.
	stack hasFrame ifFalse: [^nil].
	uninitialized := stack uninitializedTemporariesIn: self.
	uninitialized isEmpty ifTrue: [^nil].
	nilval := OLoadConstant valued: nil.
	stack next afterInsert: nilval.
	uninitialized do: [:index | | store |
		store := OStoreOperation base: stack slotAtImm: index put: nilval.
		nilval afterInsert: store].
	^nilval
]

{ #category : 'private' }
OBasicBlock >> nodesSelect: aBlock [
	| seen work result visit |
	seen := IdentitySet with: self.
	work := OrderedCollection with: self.
	result := OrderedCollection new.
	visit := [:inst | 
		(seen includes: inst) ifFalse: [
			seen add: inst.
			work add: inst]].
	[work isEmpty] whileFalse: [| node |
		node := work removeLast.
		(aBlock value: node) ifTrue: [result add: node].
		node class = OBlockClosure ifTrue: [visit value: node firstBlock].
		node class = OBasicBlock ifTrue: [
			node do: [:inst | visit value: inst].
			node successors do: [:succ | visit value: succ]].
		node operandsDo: [:input | visit value: input]].
	^result
]

{ #category : 'unclassified' }
OBasicBlock >> operandsDo: aBlock [
	
]

{ #category : 'unclassified' }
OBasicBlock >> phiValuesComingFrom: block [
	^self phis collect: [:phi | phi atOperand: block]
]

{ #category : 'unclassified' }
OBasicBlock >> phiWithArgument: instruction [
	self phisDo: [:phi | (phi variables includes: instruction) ifTrue: [^phi]].
	self error: 'not found'
]

{ #category : 'unclassified' }
OBasicBlock >> phis [
	| result |
	result := OrderedCollection new.
	self
		instructionsDo: [:instr | instr isPhi
			ifTrue: [result add: instr]
			ifFalse: [^result]]
]

{ #category : 'unclassified' }
OBasicBlock >> phisDo: aBlock [
	self
		instructionsDo: [:instr | instr isPhi
			ifTrue: [aBlock value: instr]
			ifFalse: [^self]]
]

{ #category : 'private' }
OBasicBlock >> postOrder: result seen: seen [
	seen add: self.
	self
		successorsDo: [:succ | (seen includes: succ)
			ifFalse: [succ postOrder: result seen: seen]].
	result add: self
]

{ #category : 'unclassified' }
OBasicBlock >> postOrderDo: aBlock [
	self withSuccessorsPostOrder do: [:block | aBlock value: block]
]

{ #category : 'unclassified' }
OBasicBlock >> predecessors [
	^predecessors
]

{ #category : 'private' }
OBasicBlock >> predecessors: aCollection [
	predecessors := aCollection
]

{ #category : 'private' }
OBasicBlock >> primitivePrintOn: aStream [
	aStream nextPutAll: '<=== '; print: self name; cr.
	next printForwardOn: aStream.
	aStream nextPutAll: '===>'
]

{ #category : 'printing' }
OBasicBlock >> printAll [
	| stream |
	stream := '' writeStream.
	self reversePostOrderDo: [:block | 
		block printOn: stream.
		stream cr].
	^stream contents
]

{ #category : 'printing' }
OBasicBlock >> printAllNamed [
	^String streamContents: [:s | self printAllNamedOn: s]
]

{ #category : 'printing' }
OBasicBlock >> printAllNamedOn: aStream [
	| names vars blocks |

	names := Dictionary new.
	vars := 0.
	blocks := 0.
	self
		reversePostOrderDo: [ :block | 
			block
				instructionsDo: [ :inst | 
					names at: inst put: 'v' , vars printString.
					vars := vars + 1 ].
			names at: block put: 'B' , blocks printString.
			blocks := blocks + 1 ].
	self
		reversePostOrderDo: [ :block | 
			block printOn: aStream using: names.
			aStream cr ]
]

{ #category : 'printing' }
OBasicBlock >> printOn: aStream [
	predecessors isEmpty
		ifTrue: [self printAllNamedOn: aStream]
		ifFalse: [self primitivePrintOn: aStream]
]

{ #category : 'printing' }
OBasicBlock >> printOn: aStream using: names [
	| string |
	string := names at: self ifAbsent: [^self primitivePrintOn: aStream].
	aStream
		nextPutAll: '<=== ';
		nextPutAll: string;
		space;
		nextPut: $[;
		nextPutAll: self hash printString;
		nextPut: $];
		space;
		nextPut: $\.
	predecessors size > 0 ifTrue: [
		predecessors allButLast
			do: [:pred | aStream nextPutAll: (names at: pred ifAbsent: '?') , ' | '].
		aStream nextPutAll: (names at: predecessors last ifAbsent: '?')].
	aStream nextPutAll: '/'; cr.
	next printForwardOn: aStream using: names.
	aStream nextPutAll: '===>'
]

{ #category : 'unclassified' }
OBasicBlock >> realInstructionsDo: aBlock [
	| current |
	current := next.
	[current isPhi] whileTrue: [current := current next].
	current do: aBlock
]

{ #category : 'unclassified' }
OBasicBlock >> removePredecessor: aBasicBlock [
	predecessors remove: aBasicBlock
]

{ #category : 'unclassified' }
OBasicBlock >> replace: old asPredecessorIn: successors [
	successors do: [:succ | succ replacePredecessor: old with: self]
]

{ #category : 'unclassified' }
OBasicBlock >> replacePredecessor: old with: new [
	self phisDo: [:phi | phi replaceBlock: old with: new].
	predecessors replace: old with: new
]

{ #category : 'unclassified' }
OBasicBlock >> reversePostOrderDo: aBlock [
	self withSuccessorsPostOrder reverseDo: [:block | aBlock value: block]
]

{ #category : 'private' }
OBasicBlock >> size [
	| result |
	result := 0.
	next do: [:inst | result := result + 1].
	^result
]

{ #category : 'unclassified' }
OBasicBlock >> sortPhiVariables [
	self phisDo: [:phi | phi sortAfter: predecessors]
]

{ #category : 'unclassified' }
OBasicBlock >> split [
	^self class new
]

{ #category : 'unclassified' }
OBasicBlock >> splitAfter: anInstruction [
	| block start last |
	block := self class new.
	start := anInstruction next.
	start isEnd ifTrue: [^block].
	last := end prev.
	block
		replace: self asPredecessorIn: self successors;
		addFrom: start to: last.
	anInstruction afterConnect: end.
	^block
]

{ #category : 'unclassified' }
OBasicBlock >> splitAllCriticalEdges [
	self withSuccessorsPostOrder
		do: [:block | block splitIncomingCriticalEdges]
]

{ #category : 'unclassified' }
OBasicBlock >> splitBefore: anInstruction [
	^self splitAfter: anInstruction prev
]

{ #category : 'unclassified' }
OBasicBlock >> splitEdgeTo: block [
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
]

{ #category : 'unclassified' }
OBasicBlock >> splitIncomingCriticalEdges [
	predecessors size > 1 ifFalse: [^self].
	predecessors
		do: [:pred | pred hasMultipleSuccessors ifTrue: [pred splitEdgeTo: self]]
]

{ #category : 'unclassified' }
OBasicBlock >> successors [
	^end prev targets
]

{ #category : 'unclassified' }
OBasicBlock >> successorsDo: aBlock [
	| last |
	last := self lastInstruction.
	last !== self ifTrue: [ last successorsDo: aBlock]
]

{ #category : 'unclassified' }
OBasicBlock >> successorsPostOrder [
	| seen result |
	seen := Set new.
	result := OrderedCollection new: 10.
	self
		successorsDo: [:succ | (seen includes: succ)
			ifFalse: [succ postOrder: result seen: seen]].
	^result
]

{ #category : 'unclassified' }
OBasicBlock >> unifyReturns [
	| returns last ret prev end jump phi |
	returns := self allReturnsWithBlocks.
	last := returns removeFirst.
	returns isEmpty ifTrue: [^self].
	ret := last key.
	last := last value.
	prev := ret prev.
	(prev isPhi and: prev = last firstInstruction)
		ifTrue: [
			end := last.
			phi := prev]
		ifFalse: [
			end := last splitAfter: prev.
			last endWithJumpTo: end.
			phi := OPhi new.
			phi addVariable: ret source from: last.
			ret source removeUse: ret at: #source.
			ret source: phi; beforeInsert: phi].
	returns do: [:assoc | | tail block |
		tail := assoc key.
		block := assoc value.
		phi addVariable: tail source from: block.
		end addPredecessor: block.
		jump := tail next.
		jump target removePredecessor: block.
		jump target: end.
		tail dissolve]
]

{ #category : 'testing' }
OBasicBlock >> usesResultOf: anInstruction [
	next
		detect: [:instruction | instruction usesResultOf: anInstruction]
		ifNone: [^false].
	^true
]

{ #category : 'validation' }
OBasicBlock >> validateAllInstructions [
	| all blocks |
	self withSuccessorsDo: [:block | | forward current backwards |
		forward := OrderedCollection new.
		current := block.
		[current notNil] whileTrue: [
			forward add: current.
			current := current next].
		backwards := OrderedCollection new.
		current := forward last.
		[current notNil] whileTrue: [
			backwards add: current.
			current := current prev].
		self ASSERT: forward = backwards reversed].
	all := Set new.
	blocks := OrderedCollection new.
	blocks add: self.
	[blocks isEmpty] whileFalse: [| block |
		block := blocks removeFirst.
		block instructionsWithSuccessorsDo: [:inst | 
			all add: inst.
			inst
				operandsDo: [:o | o isBlockClosure ifTrue: [blocks add: o firstBlock]]]].
	self instructionsWithSuccessorsDo: [:inst | 
		inst
			validateUses;
			usesDo: [:operand | self _ASSERT: (all includes: operand instruction)]]
]

{ #category : 'unclassified' }
OBasicBlock >> validateCFG [
	self withSuccessorsDo: [:block | 
		block successors
			do: [:successor | self _ASSERT: (successor predecessors includes: block)].
		block predecessors
			do: [:predecessor | self _ASSERT: (predecessor successors includes: block)]]
]

{ #category : 'unclassified' }
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

{ #category : 'unclassified' }
OBasicBlock >> withSuccessorsDo: aBlock [
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
]

{ #category : 'unclassified' }
OBasicBlock >> withSuccessorsPostOrder [
	| seen result |
	seen := Set new.
	result := OrderedCollection new: 10.
	self postOrder: result seen: seen.
	^result
]
