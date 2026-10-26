'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingValueNumbering category: #OCompiler!
Object subclass: #OptimizingValueNumbering
	instanceVariableNames: 'firstBlock currentBlock names hashes hashesOut'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingValueNumbering commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingValueNumbering methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
addNewName: instruction
	^names at: instruction put: '{v' , names size printString , '}'
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
hashOfLoadConstant: instruction
	^[instruction value printString] on: Error do: [^nil]
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
hashOfUnary: instruction
	| receiver |
	receiver := self nameOf: instruction receiver.
	^receiver , instruction name
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isCommutative: name
	^name = #'+' or: [name = #'*']
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
isStillAlive: block
	^block withPredecessors includes: firstBlock
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
nameOf: instruction
	^names at: instruction
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
processMemoryStore: value as: storeHash andLoads: loadHash
	hashes
		at: loadHash
		put: value
	"facil hashes at: storeHash ifPresent: [:mapping | (mapping value livesInSameBlockThan: store)  ifTrue: [mapping value dissolve]]"
	"dificil hashes at: storeHash ifPresent: [:mapping | postDominatorTree does: blockOf dominate: currentBlock ifTrue: [mapping value dissolve]]"
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
resultOfBinaryWithConstants: aBinaryInstruction
	| operation left right |
	operation := aBinaryInstruction name.
	left := aBinaryInstruction left value.
	right := aBinaryInstruction right value.
	operation = #'+' ifTrue: [^left + right].
	operation = #'-' ifTrue: [^left - right].
	operation = #'*' ifTrue: [^left * right].
	operation = #'//' ifTrue: [^left // right].
	operation = #'=' ifTrue: [^left = right].
	self halt
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
unifyPredecessorHashes
	| incoming any |
	hashes := Dictionary new.
	currentBlock predecessors size = 0 ifTrue: [^self].
	incoming := currentBlock predecessors
		collect: [:pred | hashesOut at: pred ifAbsent: [Dictionary new]].
	any := incoming removeLast.
	any keysAndValuesDo: [:hash :value | | unanimous |
		unanimous := incoming
			conform: [:dict | dict
				at: hash
				ifAbsent: false
				ifPresent: [:prev | prev = value]].
		unanimous ifTrue: [hashes at: hash put: value]]
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueBranchTo: aBasicBlock
	| source last comparison hash name |
	aBasicBlock predecessors size !!= 1 ifTrue: [^self].
	source := aBasicBlock predecessors first.
	last := source lastInstruction.
	last isConditionalJump ifFalse: [^self].
	comparison := last variable.
	name := self nameOf: comparison.
	hash := 'branch' , name.
	last target == aBasicBlock
		ifTrue: [hashes at: hash put: last isJumpTrue]
		ifFalse: [hashes at: hash put: last isJumpFalse]
! !

!OptimizingValueNumbering methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
valueOf: hash be: instruction
	hashes at: hash ifPresent: [:value | | copy |
		copy := instruction replaceWithCopyOf: value.
		self addNewName: copy.
		^copy == value ifFalse: [
			(copy isUnaryOperation and: [copy name = #copy])
				ifTrue: [hashes at: (self hashOfUnary: copy) put: instruction].
			copy isConstant
				ifTrue: [hashes at: (self hashOfLoadConstant: copy) put: instruction]]].
	hashes at: hash put: instruction
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithConstant: instruction
	| left right hash selector load temp value replacement |
	left := self nameOf: instruction left.
	right := instruction right printString.
	(self isCommutative: instruction name) ifTrue: [
		left > right ifTrue: [
			temp := left.
			left := right.
			right := temp]].
	hash := left , instruction name , right.
	(#(_basicFlags: _extendedFlags:) includes: instruction name)
		ifTrue: [
			selector := instruction name allButLast: 1.
			load := left , selector.
			self processMemoryStore: instruction right as: hash andLoads: load]
		ifFalse: [
			(instruction left isConstant and: instruction name !!= #_basicAt:) ifTrue: [
				value := self resultOfBinaryWithConstants: instruction.
				replacement := OLoadConstant valued: value.
				instruction dissolveReplacingWith: replacement.
				^self
					addNewName: replacement;
					visitLoadConstant: replacement;
					valueOf: hash be: replacement].
			self valueOf: hash be: instruction]
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithVariable: instruction
	| left right hash selector load temp |
	left := self nameOf: instruction left.
	right := self nameOf: instruction right.
	(self isCommutative: instruction name) ifTrue: [
		left > right ifTrue: [
			temp := left.
			left := right.
			right := temp]].
	hash := left , instruction name , right.
	(#(_basicFlags: _extendedFlags:) includes: instruction name)
		ifTrue: [
			selector := instruction name allButLast: 1.
			load := left , selector.
			self processMemoryStore: instruction right as: hash andLoads: load]
		ifFalse: [self valueOf: hash be: instruction]
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBranch: branch
	| hash receiver |
	receiver := self nameOf: branch variable.
	hash := 'branch' , receiver.
	hashes at: hash ifPresent: [:outcome | 
		outcome isBoolean
			ifTrue: [branch replaceWithUnconditional: outcome in: currentBlock]]
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJump: aJumpInstruction
	
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpFalse: branch
	self visitBranch: branch
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpTrue: branch
	self visitBranch: branch
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadConstant: instruction
	| hash |
	hash := self hashOfLoadConstant: instruction.
	hash ifNil: [self].
	self valueOf: hash be: instruction
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadImplicit: instruction
	
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitMessageSend: instruction
	| loads |
	loads := names keys select: [:instr | 
		instr isPrimitiveOperation
			and: [#(_basicAt: _byteAt: _basicFlags) includes: instr name]].
	loads do: [:load | hashes removeAllSuchThat: [:value | value = load]]
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitNullary: instruction
	
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitPhi: instruction
	
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitReturn: instruction
	
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitTernary: instruction
	| receiver operand left right hash load |
	receiver := self nameOf: instruction receiver.
	operand := instruction left.
	left := operand isInstruction
		ifTrue: [self nameOf: operand]
		ifFalse: [operand printString].
	right := self nameOf: instruction right.
	hash := receiver , instruction name , left , right.
	(#(_basicAt:put: _byteAt:put:) includes: instruction name)
		ifTrue: [| selector |
			selector := instruction name allButLast: 4.
			load := receiver , selector , left.
			self processMemoryStore: instruction right as: hash andLoads: load]
		ifFalse: [^self valueOf: hash be: instruction]
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitUnary: instruction
	| hash |
	(#(push) includes: instruction name) ifTrue: [^self].
	hash := self hashOfUnary: instruction.
	self valueOf: hash be: instruction
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
workFrom: aBasicBlock
	| count |
	hashes := Dictionary new.
	hashesOut := Dictionary new.
	names := Dictionary new.
	firstBlock := aBasicBlock.
	count := 0.
	aBasicBlock instructionsWithSuccessorsDo: [:inst | 
		names at: inst put: '{v' , count printString , '}'.
		count := count + 1].
	aBasicBlock withSuccessorsPostOrder
		reverseDo: [:block | self workOn: block]
! !

!OptimizingValueNumbering methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
workOn: aBlock
	(self isStillAlive: aBlock) ifFalse: [^self].
	currentBlock := aBlock.
	self unifyPredecessorHashes.
	self valueBranchTo: aBlock.
	currentBlock firstInstruction acceptVisitor: self.
	hashesOut at: aBlock put: hashes copy
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingValueNumbering class' category: #OCompiler!
OptimizingValueNumbering class
	instanceVariableNames: ''!


