'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingBraunAssigner category: #OCompiler!
Object subclass: #OptimizingBraunAssigner
	instanceVariableNames: 'firstBlock liveness allocationEntry temporaries preferences occupied assignments clusters processed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingBraunAssigner commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
allRegistersByPreference
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
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assignRegisters
	self
		computeLiveness;
		computeClusters;
		purgeAllocationEntry;
		preinitializePreferences;
		integrateABIPreferences;
		doAssignRegisters.
	^assignments
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assignRegisterTo: instruction
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
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
clobbersOneRegister: inst
	^((inst isJump or: [inst isUnaryOperation and: [inst name == #push]])
		or: [inst isTernaryOperation and: [inst name = #_basicAt:put:]]) not
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
colorBlock: block
	"
	Determine initial register occupation and color φ-nodes
	"
	| incoming initial |
	incoming := liveness liveInOf: block.
	initial := incoming collect: [:value | (assignments at: value) -> value].
	occupied := Dictionary withAll: initial.
	block phisDo: [:phi | self getRegisterFor: phi].
	block predecessors do: [:pred | 
		(processed includes: pred)
			ifTrue: [self insertParallelCopiesFrom: pred to: block]].
	"Assign registers"
	block firstNonPhi do: [:instruction | self assignRegisterTo: instruction].
	processed add: block.
	block successors do: [:succ | 
		(processed includes: succ)
			ifTrue: [self insertParallelCopiesFrom: block to: block successors first]]
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
computeClusters
	firstBlock withSuccessorsPostOrder do: [:block | 
		block phisDo: [:phi | | cluster |
			cluster := clusters at: phi ifAbsentPut: [OrderedCollection with: phi].
			phi operandsDo: [:value | 
				cluster addIfAbsent: value.
				clusters at: value put: cluster]]]
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
computeLiveness
	liveness analyzeLiveness
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
computePreferences: block
	| argument |
	argument := firstBlock firstInstruction next next.
	argument do: [:instr | | reg index pref |
		instr isLoadImplicit ifFalse: [^self].
		reg := instr source.
		index := self indexOf: reg.
		pref := preferences at: instr.
		pref at: index put: (pref at: index) + 1]
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
doAssignRegisters
	self preallocateImplicitVariables.
	firstBlock withSuccessorsPostOrder
		reverseDo: [:block | self colorBlock: block]
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
does: operand dieAt: instruction
	^liveness does: operand dieAt: instruction
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
enforceConstraints: instruction
	
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
from: allocator
	firstBlock := allocator firstBlock.
	allocationEntry := allocator allocationEntry
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
getRegisterFor: var
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
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
getRegisterForSend: send
	| receiver copy |
	receiver := send receiver.
	copy := receiver insertCopyBefore: send.
	copy addUse: send at: #receiver.
	receiver removeUse: send at: #receiver.
	liveness kill: copy at: send.
	assignments at: copy put: eax.
	^eax
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
indexOf: register
	| regs |
	regs := self wordSize = 4
		ifTrue: #(ebp eax edx ecx esi)
		ifFalse: [#(rbp rax rdx rcx rsi r8 r9 r10 r11 rbx r12 r13 r14 r15)].
	^regs indexOf: register name
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	processed := OrderedCollection new.
	preferences := Dictionary new.
	assignments := Dictionary new.
	clusters := Dictionary new
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertCopyTo: dest for: phi at: pred
	| value copy |
	value := phi atOperand: pred.
	copy := value insertCopyBefore: pred lastInstruction.
	assignments at: copy put: dest.
	value removeUse: phi at: pred.
	phi atOperand: pred put: copy
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertParallelCopiesFrom: pred to: block
	| phis sources destinations saved |
	phis := block phis.
	sources := phis collect: [:phi | | value |
		value := phi atOperand: pred.
		assignments at: value].
	destinations := phis collect: [:phi | assignments at: phi].
	"remove nops"
	phis size to: 1 by: -1 do: [:i | 
		(sources at: i) = (destinations at: i) ifTrue: [
			sources removeIndex: i.
			destinations removeIndex: i.
			phis removeIndex: i]].
	"schedule copies"
	saved := OrderedCollection new.
	[
		self scheduleCopyingOf: phis from: pred.
		phis size > 0]
		whileTrue: [| free |
			free := phis first.
			self insertPushOf: (free atOperand: pred) at: pred.
			saved add: free.
			phis removeIndex: 1.
			sources removeIndex: 1.
			destinations removeIndex: 1].
	[saved isEmpty] whileFalse: [| var |
		var := saved removeLast.
		self insertPopOf: var at: pred]
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertPopOf: var at: pred
	| pop reg |
	pop := OUnaryOperation receiver: nil name: #pop.
	pred lastInstruction beforeInsert: pop.
	reg := assignments at: var.
	assignments at: pop put: reg
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertPushOf: var at: pred
	var insertPushBefore: pred lastInstruction
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
integrateABIPreferences
	firstBlock withSuccessorsPostOrder
		do: [:block | self computePreferences: block]
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
liveInOf: block
	^liveness liveInOf: block
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
liveness: aLivenessAnalysis
	liveness := aLivenessAnalysis
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
preallocateImplicitVariables
	| in |
	in := OrderedCollection new.
	firstBlock instructionsDo: [:inst | | register |
		inst isLoadImplicit ifTrue: [
			register := inst source.
			register ifNotNil: [
				in add: inst.
				assignments at: inst put: register]]].
	(liveness liveInOf: firstBlock) addAll: in
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
preinitializePreferences
	firstBlock instructionsWithSuccessorsDo: [:instruction | | array |
		array := #[0 0 0 0 0 0 0 0].
		preferences at: instruction put: array copy]
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
purgeAllocationEntry
	firstBlock withSuccessorsPostOrder do: [:block | | alive available |
		alive := self liveInOf: block.
		available := allocationEntry at: block.
		available
			removeAllSuchThat: [:var | (block phis includes: var)
				or: [(alive includes: var) not]]]
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
registersByPreference: prefs
	| all indexes |
	all := self allRegistersByPreference.
	indexes := (1 to: all size) asOrderedCollection.
	indexes sortBy: [:i :j | (prefs at: i) > (prefs at: j) or: [i < j]].
	^indexes collect: [:index | all at: index]
! !

!OptimizingBraunAssigner methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
scheduleCopyingOf: phis from: pred
	| destinations changed sources |
	sources := phis collect: [:phi | | value |
		value := phi atOperand: pred.
		assignments at: value].
	destinations := phis collect: [:phi | assignments at: phi].
	"schedule copies"
	changed := true.
	[phis size > 0 and: changed] whileTrue: [
		changed := false.
		phis size to: 1 by: -1 do: [:i | | dest phi |
			dest := destinations at: i.
			(sources includes: dest) ifFalse: [
				phi := phis at: i.
				self insertCopyTo: dest for: phi at: pred.
				sources removeIndex: i.
				destinations removeIndex: i.
				phis removeIndex: i.
				changed := true]]]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingBraunAssigner class' category: #OCompiler!
OptimizingBraunAssigner class
	instanceVariableNames: ''!

!OptimizingBraunAssigner class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


OptimizingBraunAssigner initialize!

