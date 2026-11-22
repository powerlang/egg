"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #OptimizingBraunAssigner,
	#superclass : #Object,
	#instVars : [
		'firstBlock',
		'liveness',
		'allocationEntry',
		'temporaries',
		'preferences',
		'occupied',
		'assignments',
		'clusters',
		'processed'
	],
	#category : #OCompiler
}

{ #category : #'instance creation' }
OptimizingBraunAssigner class >> new [
	^self basicNew initialize
]

{ #category : #private }
OptimizingBraunAssigner >> allRegistersByPreference [
	^self wordSize = 4
		ifTrue: [
			Array
				with: ebp
				with: eax
				with: edx
				with: ecx
				with: esi]
		ifFalse: [
			OrderedCollection new
				add: rbp;
				add: rax;
				add: rdx;
				add: rcx;
				add: rsi;
				add: r8;
				add: r9;
				add: r10;
				add: r11;
				add: rbx;
				add: r12;
				add: r13;
				add: r14;
				add: r15;
				yourself]
]

{ #category : #private }
OptimizingBraunAssigner >> assignRegisters [
	self
		computeLiveness;
		computeClusters;
		purgeAllocationEntry;
		preinitializePreferences;
		integrateABIPreferences;
		doAssignRegisters.
	^assignments
]

{ #category : #private }
OptimizingBraunAssigner >> assignRegisterTo: instruction [
	| register |
	self enforceConstraints: instruction.
	instruction operandsDo: [:operand | 
		(self clobbersOneRegister: operand) ifTrue: [
			(self does: operand dieAt: instruction) ifTrue: [
				register := assignments at: operand.
				occupied removeKey: register]]].
	(self clobbersOneRegister: instruction) ifTrue: [
		self getRegisterFor: instruction.
		(self does: instruction dieAt: instruction) ifTrue: [
			register := assignments at: instruction.
			occupied removeKey: register]]
]

{ #category : #private }
OptimizingBraunAssigner >> clobbersOneRegister: inst [
	^((inst isJump or: [inst isUnaryOperation and: [inst name == #push]])
		or: [inst isTernaryOperation and: [inst name = #_basicAt:put:]]) not
]

{ #category : #private }
OptimizingBraunAssigner >> colorBlock: block [
	"
	Determine initial register occupation and color φ-nodes
	"
	| incoming initial |
	incoming := liveness liveInOf: block.
	initial := incoming collect: [:value | (assignments at: value) -> value].
	occupied := Dictionary withAll: initial.
	block parametersDo: [:parameter | self getRegisterFor: parameter].
	block predecessors do: [:pred | 
		(processed includes: pred)
			ifTrue: [self insertParallelCopiesFrom: pred to: block]].
	"Assign registers"
	block firstNonPhi do: [:instruction | self assignRegisterTo: instruction].
	processed add: block.
	block successorsDo: [:succ |
		(processed includes: succ)
			ifTrue: [self insertParallelCopiesFrom: block to: block successors first]]
]

{ #category : #private }
OptimizingBraunAssigner >> computeClusters [
	firstBlock withSuccessorsPostOrder do: [:block | 
		block parametersDo: [:parameter | | cluster |
			cluster := clusters at: parameter ifAbsentPut: [OrderedCollection with: parameter].
			parameter operandsDo: [:value |
				cluster addIfAbsent: value.
				clusters at: value put: cluster]]]
]

{ #category : #private }
OptimizingBraunAssigner >> computeLiveness [
	liveness analyzeLiveness
]

{ #category : #private }
OptimizingBraunAssigner >> computePreferences: block [
	| argument |
	argument := firstBlock firstInstruction next next.
	argument do: [:instr | | reg index pref |
		instr isLoadImplicit ifFalse: [^self].
		reg := instr source.
		index := self indexOf: reg.
		pref := preferences at: instr.
		pref at: index put: (pref at: index) + 1]
]

{ #category : #private }
OptimizingBraunAssigner >> doAssignRegisters [
	self preallocateImplicitVariables.
	firstBlock withSuccessorsPostOrder
		reverseDo: [:block | self colorBlock: block]
]

{ #category : #private }
OptimizingBraunAssigner >> does: operand dieAt: instruction [
	^liveness does: operand dieAt: instruction
]

{ #category : #private }
OptimizingBraunAssigner >> enforceConstraints: instruction [
	
]

{ #category : #private }
OptimizingBraunAssigner >> from: allocator [
	firstBlock := allocator firstBlock.
	allocationEntry := allocator allocationEntry
]

{ #category : #private }
OptimizingBraunAssigner >> getRegisterFor: var [
	| prefs candidates cluster reg |
	assignments at: var ifPresent: [:preset | reg := preset].
	reg == nil ifTrue: [
		var isMessageSend ifTrue: [reg := self getRegisterForSend: var] ifFalse: [
			prefs := preferences at: var.
			candidates := self registersByPreference: prefs.
			cluster := clusters at: var ifAbsent: nil.
			cluster ifNotNil: [
				assignments
					at: cluster
					ifPresent: [:best | candidates remove: best; addFirst: best]].
			reg := candidates
				detect: [:register | (occupied includesKey: register) not]]].
	occupied at: reg put: var.
	assignments at: var put: reg.
	cluster ifNotNil: [assignments at: cluster put: reg].
	^reg
]

{ #category : #private }
OptimizingBraunAssigner >> getRegisterForSend: send [
	| receiver copy |
	receiver := send receiver.
	copy := receiver insertCopyBefore: send.
	copy addUse: send at: #receiver.
	receiver removeUse: send at: #receiver.
	liveness kill: copy at: send.
	assignments at: copy put: eax.
	^eax
]

{ #category : #private }
OptimizingBraunAssigner >> indexOf: register [
	| regs |
	regs := self wordSize = 4
		ifTrue: [#(ebp eax edx ecx esi)]
		ifFalse: [#(rbp rax rdx rcx rsi r8 r9 r10 r11 rbx r12 r13 r14 r15)].
	^regs indexOf: register name
]

{ #category : #private }
OptimizingBraunAssigner >> initialize [
	processed := OrderedCollection new.
	preferences := Dictionary new.
	assignments := Dictionary new.
	clusters := Dictionary new
]

{ #category : #private }
OptimizingBraunAssigner >> insertCopyTo: dest for: parameter at: pred [
	| value copy |
	value := parameter atOperand: pred.
	copy := value insertCopyBefore: pred lastInstruction.
	assignments at: copy put: dest.
	value removeUse: parameter at: pred.
	parameter atOperand: pred put: copy
]

{ #category : #private }
OptimizingBraunAssigner >> insertParallelCopiesFrom: pred to: block [
	| parameters sources destinations saved |
	parameters := block parameters.
	sources := parameters collect: [:parameter | | value |
		value := parameter atOperand: pred.
		assignments at: value].
	destinations := parameters collect: [:parameter | assignments at: parameter].
	"remove nops"
	parameters size to: 1 by: -1 do: [:i |
		(sources at: i) = (destinations at: i) ifTrue: [
			sources removeIndex: i.
			destinations removeIndex: i.
			parameters removeIndex: i]].
	"schedule copies"
	saved := OrderedCollection new.
	[
		self scheduleCopyingOf: parameters from: pred.
		parameters size > 0]
		whileTrue: [| free |
			free := parameters first.
			self insertPushOf: (free atOperand: pred) at: pred.
			saved add: free.
			parameters removeIndex: 1.
			sources removeIndex: 1.
			destinations removeIndex: 1].
	[saved isEmpty] whileFalse: [| var |
		var := saved removeLast.
		self insertPopOf: var at: pred]
]

{ #category : #private }
OptimizingBraunAssigner >> insertPopOf: var at: pred [
	| pop reg |
	pop := OUnaryOperation receiver: nil name: #pop.
	pred lastInstruction beforeInsert: pop.
	reg := assignments at: var.
	assignments at: pop put: reg
]

{ #category : #private }
OptimizingBraunAssigner >> insertPushOf: var at: pred [
	var insertPushBefore: pred lastInstruction
]

{ #category : #private }
OptimizingBraunAssigner >> integrateABIPreferences [
	firstBlock withSuccessorsPostOrder
		do: [:block | self computePreferences: block]
]

{ #category : #private }
OptimizingBraunAssigner >> liveInOf: block [
	^liveness liveInOf: block
]

{ #category : #private }
OptimizingBraunAssigner >> liveness: aLivenessAnalysis [
	liveness := aLivenessAnalysis
]

{ #category : #private }
OptimizingBraunAssigner >> preallocateImplicitVariables [
	| in |
	in := OrderedCollection new.
	firstBlock instructionsDo: [:inst | | register |
		inst isLoadImplicit ifTrue: [
			register := inst source.
			register ifNotNil: [
				in add: inst.
				assignments at: inst put: register]]].
	(liveness liveInOf: firstBlock) addAll: in
]

{ #category : #private }
OptimizingBraunAssigner >> preinitializePreferences [
	firstBlock instructionsWithSuccessorsDo: [:instruction | | array |
		array := #[0 0 0 0 0 0 0 0].
		preferences at: instruction put: array copy]
]

{ #category : #private }
OptimizingBraunAssigner >> purgeAllocationEntry [
	firstBlock withSuccessorsPostOrder do: [:block | | alive available |
		alive := self liveInOf: block.
		available := allocationEntry at: block.
		available
			removeAllSuchThat: [:var | (block parameters includes: var)
				or: [(alive includes: var) not]]]
]

{ #category : #private }
OptimizingBraunAssigner >> registersByPreference: prefs [
	| all indexes |
	all := self allRegistersByPreference.
	indexes := (1 to: all size) asOrderedCollection.
	indexes sortBy: [:i :j | (prefs at: i) > (prefs at: j) or: [i < j]].
	^indexes collect: [:index | all at: index]
]

{ #category : #private }
OptimizingBraunAssigner >> scheduleCopyingOf: parameters from: pred [
	| destinations changed sources |
	sources := parameters collect: [:parameter | | value |
		value := parameter atOperand: pred.
		assignments at: value].
	destinations := parameters collect: [:parameter | assignments at: parameter].
	"schedule copies"
	changed := true.
	[parameters size > 0 and: changed] whileTrue: [
		changed := false.
		parameters size to: 1 by: -1 do: [:i | | dest parameter |
			dest := destinations at: i.
			(sources includes: dest) ifFalse: [
				parameter := parameters at: i.
				self insertCopyTo: dest for: parameter at: pred.
				sources removeIndex: i.
				destinations removeIndex: i.
				parameters removeIndex: i.
				changed := true]]]
]

