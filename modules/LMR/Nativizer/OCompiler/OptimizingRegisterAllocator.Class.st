'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingRegisterAllocator category: #OCompiler!
Object subclass: #OptimizingRegisterAllocator
	instanceVariableNames: 'abi liveRanges unifiedLiveRanges expirations allocation free used usedOut locals currentBlock firstBlock'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingRegisterAllocator commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
abi: anAbi
	abi := anAbi.
	free := OrderedCollection new.
	free
		add: abi regS;
		add: abi regT;
		add: abi regA;
		add: abi regR;
		add: abi regFP
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
activationRecord
	^firstBlock firstInstruction
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
addLiveRangesOf: block
	block
		instructionsDo: [:instruction | self
			assureLiveRangeStartingAt: instruction
			in: block]
! !

!OptimizingRegisterAllocator methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocateFor: inst
	| range register starts ends |
	(self rangesEndingAt: inst) reverseDo: [:ending | self free: ending].
	range := self unifiedLiveRangeOf: inst.
	starts := range startsAt: inst.
	ends := range endsAt: inst.
	(ends not and: [range isSpilled not]) ifTrue: [
		starts ifTrue: [self assignRegisterTo: inst in: range].
		register := allocation at: range.
		allocation at: inst put: register].
	inst isMessageSend ifTrue: [self repairToRespectABI: inst with: range]
! !

!OptimizingRegisterAllocator methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocateLiveRanges
	self preallocateImplicitVariables.
	firstBlock reversePostOrderDo: [:block | 
		currentBlock := block.
		self recalculateRegisterUsage.
		block instructionsDo: [:inst | self allocateFor: inst].
		usedOut at: block put: used copy]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocation
	^allocation
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assign: register to: aRange
	((free includes: register) not and: [(used at: register) !!= aRange])
		ifTrue: [self error: 'register ' , register , ' is not free'].
	allocation at: aRange put: register.
	free remove: register ifAbsent: [].
	used at: register put: aRange
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assignRegisterTo: instruction in: aRange
	| register |
	register := allocation at: aRange ifAbsent: [
		free isEmpty
			ifTrue: [self spillALiveRangeInUseAfter: instruction]
			ifFalse: [free last]].
	"register == edx ifTrue: [self halt]."
	self assign: register to: aRange
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assureLiveRangeOf: operand startingAt: anInstruction
	| range |
	range := self assureLiveRangeStartingAt: anInstruction in: currentBlock.
	liveRanges at: operand put: range
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assureLiveRangeStartingAt: anInstruction
	^self assureLiveRangeStartingAt: anInstruction in: currentBlock
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assureLiveRangeStartingAt: anInstruction in: block
	| range |
	range := OSimpleLiveRange new definedAt: anInstruction in: block.
	liveRanges at: anInstruction put: range.
	^range
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
computeExpirationOf: instruction
	| range |
	range := self unifiedLiveRangeOf: instruction.
	range expirationPoints do: [:operation | self kill: range at: operation]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
computeExpirations
	firstBlock
		instructionsWithSuccessorsDo: [:instruction | self
			computeExpirationOf: instruction]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
computeInterferenceGraph
	liveRanges do: [:range | self computeInterferencesOf: range]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
computeInterferencesOf: range
	range instructionsDo: [:instruction | | other |
		other := self liveRangeOf: instruction.
		self range: range interferes: other]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
computeLiveRanges
	firstBlock
		reversePostOrderDo: [:block | self addLiveRangesOf: block];
		reversePostOrderDo: [:block | self
			currentBlock: block;
			computeLiveRangesOf: block].
	self computeExpirations
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
computeLiveRangesOf: block
	block firstInstruction acceptVisitor: self
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
currentBlock: aBasicBlock
	currentBlock := aBasicBlock
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
doAllocation
	| record |
	"	record := self activationRecord.
	record isLoadImplicit ifFalse: [free remove: ebp]."
	self computeLiveRanges; allocateLiveRanges; reserveSpaceForLocals.
	^allocation
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstBlock: aBasicBlock
	firstBlock := aBasicBlock
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
free: range
	| register |
	register := allocation at: range ifAbsent: [^self].
	(free includes: register) ifTrue: [^self].
	(used at: register) == range ifFalse: [^self].
	"register == ecx ifTrue: [self halt]."
	free add: register.
	used removeKey: register.
	^register
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	allocation := IdentityDictionary new.
	liveRanges := IdentityDictionary new.
	unifiedLiveRanges := IdentityDictionary new.
	expirations := IdentityDictionary new.
	locals := 2.
	used := Dictionary new.
	usedOut := Dictionary new
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertCopyResultAfter: messageSend
	| copy range |
	copy := OUnaryOperation receiver: messageSend name: #copyResult.
	messageSend
		afterInsert: copy;
		replaceAllUsesWith: copy;
		addUse: copy at: #receiver.
	range := self liveRangeOf: messageSend.
	range definition: copy.
	liveRanges at: copy put: range.
	unifiedLiveRanges
		at: messageSend
		ifPresent: [:unified | unifiedLiveRanges at: copy put: unified]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertCopyToR: anInstruction before: inst
	| copy range |
	copy := OUnaryOperation receiver: anInstruction name: #copy.
	anInstruction addUse: copy at: #receiver.
	inst beforeInsert: copy.
	range := self unifiedLiveRangeOf: anInstruction.
	liveRanges at: copy put: range.
	allocation at: copy put: abi regR
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertLoadBefore: use at: block changing: operand
	| stack load range definition |
	use isPhi ifTrue: [
		range := self liveRangeOf: use.
		range beSpilled.
		^self].
	stack := used at: abi regFP.
	load := OBinaryConstantOperation
		left: stack anyDefinition
		right: 1 - locals
		name: #_basicAt:.
	stack anyDefinition addUse: load at: #left.
	use beforeInsert: load.
	definition := operand definition.
	operand replaceUseWith: load.
	load addUse: use at: operand name.
	range := self assureLiveRangeStartingAt: load.
	range addUseFrom: use at: block.
	self kill: range at: use.
	allocation
		at: definition
		ifPresent: [:register | allocation at: load put: register]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertPop: anInstruction to: register after: messageSend
	| pop range |
	pop := OUnaryOperation receiver: nil name: #pop.
	messageSend afterInsert: pop.
	range := self unifiedLiveRangeOf: anInstruction.
	liveRanges at: pop put: range.
	allocation at: pop put: register
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertPush: anInstruction before: inst
	| push |
	push := OUnaryOperation receiver: anInstruction name: #push.
	anInstruction addUse: push at: #receiver.
	inst beforeInsert: push
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
insertStoreAfter: definition at: block
	| stack store range |
	unifiedLiveRanges removeKey: definition ifAbsent: [].
	definition isPhi ifTrue: [^self].
	stack := used at: abi regFP.
	store := OTernaryOperation
		receiver: stack anyDefinition
		left: 1 - locals
		right: definition
		name: #_basicAt:put:.
	stack anyDefinition addUse: store at: #receiver.
	definition addUse: store at: #right.
	definition afterInsert: store.
	range := self assureLiveRangeStartingAt: definition.
	range addUseFrom: store at: block.
	stack addUseFrom: store at: block.
	self kill: range at: store.
	range := self assureLiveRangeStartingAt: store.
	self kill: range at: store
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isFree: register
	^free includes: register
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isSpilled: register
	^false
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
kill: range at: instruction
	| expiring |
	(range class = OSimpleLiveRange or: [range class == OComposedLiveRange])
		ifFalse: [self halt].
	expiring := expirations
		at: instruction
		ifAbsentPut: [OrderedCollection new].
	expiring add: range
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
liveRangeOf: value
	^liveRanges at: value
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
preallocateImplicitVariables
	firstBlock instructionsDo: [:inst | | range register |
		inst isLoadImplicit ifFalse: [^self].
		range := self unifiedLiveRangeOf: inst.
		register := inst source.
		register ifNotNil: [allocation at: range put: register]]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
rangesEndingAt: instruction
	^expirations at: instruction ifAbsent: [OrderedCollection new]
! !

!OptimizingRegisterAllocator methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
recalculateRegisterUsage
	| incoming recalculated |
	currentBlock predecessors size = 0 ifTrue: [^self].
	incoming := (currentBlock predecessors
		select: [:block | usedOut includesKey: block])
		collect: [:block | usedOut at: block].
	recalculated := incoming first.
	used := recalculated select: [:assoc | assoc value isLiveAt: currentBlock].
	free := OrderedCollection new: 10.
	free
		add: abi regS;
		add: abi regT;
		add: abi regA;
		add: abi regR;
		add: abi regFP;
		removeAll: used keys
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
repairToRespectABI: messageSend with: range
	| result clobbered receiver spillPoint |
	result := allocation at: messageSend ifAbsent: nil.
	clobbered := (used copy
		removeKey: abi regFP ifAbsent: [];
		removeKey: result ifAbsent: [];
		yourself) associations.
	spillPoint := messageSend arguments size > 0
		ifTrue: [messageSend arguments first]
		ifFalse: [messageSend].
	clobbered do: [:assoc | 
		self
			insertPush: assoc value anyDefinition before: spillPoint;
			insertPop: assoc value anyDefinition to: assoc key after: messageSend].
	receiver := allocation at: messageSend receiver.
	receiver == abi regR
		ifFalse: [self insertCopyToR: messageSend receiver before: messageSend].
	(result !!= nil and: [result !!= abi regR])
		ifTrue: [self insertCopyResultAfter: messageSend]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
reserveSpaceForLocals
	self activationRecord temporaries: locals - 2
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
spillALiveRangeInUseAfter: instruction
	| freed register |
	freed := self usedRangeReadLastAfter: instruction.
	locals := locals + 1.
	self splitRange: freed.
	register := self free: freed.
	^register
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
splitRange: aLiveRange
	| real |
	real := self unifiedLiveRangeOfRange: aLiveRange.
	real definitionsWithBlocksDo: [:definition :block | 
		definition allUses
			do: [:operand | self
				insertLoadBefore: operand instruction
				at: nil
				changing: operand].
		self insertStoreAfter: definition at: block]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
unifiedLiveRangeOf: anInstruction
	^unifiedLiveRanges
		at: anInstruction
		ifAbsent: [liveRanges at: anInstruction]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
unifiedLiveRangeOfRange: aLiveRange
	^unifiedLiveRanges at: aLiveRange ifAbsent: [aLiveRange]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
unify: anInstruction liveRangeTo: unified
	| range |
	range := self unifiedLiveRangeOf: anInstruction.
	range = unified ifTrue: [^self].
	unified addAll: range simpleRanges.
	unified allDefinitions
		do: [:instruction | unifiedLiveRanges at: instruction put: unified]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
use: operand from: anInstruction
	self use: operand from: anInstruction in: currentBlock
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
use: operand from: anInstruction in: block
	| range |
	range := self liveRangeOf: operand.
	range addUseFrom: anInstruction at: block
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usedRangeLessAccessed
	| ranges |
	ranges := (used copy removeKey: abi regFP) values asOrderedCollection.
	^ranges
		min: [:range | (range allDefinitions , range allUses reject: #isPhi) size]
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usedRangeReadLast
	| ranges |
	ranges := (used copy removeKey: abi regFP) values asOrderedCollection.
	currentBlock
		instructionsWithReversePostOrderSuccessorsDo: [:instruction | | candidate |
			candidate := ranges first.
			ranges removeAllSuchThat: [:range | 
				range allDefinitions
					anySatisfy: [:definition | instruction usesResultOf: definition]].
			ranges size = 1 ifTrue: [^ranges first].
			ranges size = 0 ifTrue: [^candidate]].
	self ASSERT: false
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
usedRangeReadLastAfter: first
	| ranges |
	ranges := (used copy removeKey: abi regFP) values asOrderedCollection.
	currentBlock
		instructionsAfter: first
		withReversePostOrderSuccessorsDo: [:instruction | | candidate |
			candidate := ranges first.
			ranges removeAllSuchThat: [:range | range isUsedBy: instruction].
			ranges size = 1 ifTrue: [^ranges first].
			ranges size = 0 ifTrue: [^candidate]].
	^ranges first
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithConstant: instruction
	self use: instruction left from: instruction
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithVariable: instruction
	self
		use: instruction left from: instruction;
		use: instruction right from: instruction
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJump: instruction
	
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpFalse: instruction
	self use: instruction variable from: instruction
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpTrue: instruction
	self use: instruction variable from: instruction
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadConstant: instruction
	
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadImplicit: instruction
	
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitMessageSend: instruction
	self
		use: instruction receiver
		from: instruction
	"instruction arguments
		do: [:operation | self use: operation from: instruction]"
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitNullary: instruction
	
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitPhi: instruction
	| unified |
	unified := OComposedLiveRange new.
	instruction variables do: [:source | 
		self
			use: source from: instruction;
			unify: source liveRangeTo: unified].
	self unify: instruction liveRangeTo: unified
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitReturn: instruction
	self
		use: instruction source from: instruction;
		use: self activationRecord from: instruction
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitTernary: instruction
	self use: instruction receiver from: instruction.
	instruction left isInteger
		ifFalse: [self use: instruction left from: instruction].
	self use: instruction right from: instruction
! !

!OptimizingRegisterAllocator methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitUnary: instruction
	self use: instruction receiver from: instruction
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingRegisterAllocator class' category: #OCompiler!
OptimizingRegisterAllocator class
	instanceVariableNames: ''!

!OptimizingRegisterAllocator class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


OptimizingRegisterAllocator initialize!

