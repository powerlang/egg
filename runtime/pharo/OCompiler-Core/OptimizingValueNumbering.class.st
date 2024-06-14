"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OptimizingValueNumbering',
	#superclass : 'Object',
	#instVars : [
		'firstBlock',
		'currentBlock',
		'names',
		'hashes',
		'hashesOut'
	],
	#category : 'OCompiler-Core-Main',
	#package : 'OCompiler-Core-Main'
}

{ #category : 'private' }
OptimizingValueNumbering >> coalesce: instruction as: hash [
	hashes
		at: hash
		ifPresent: [:value | ^instruction replaceAllUsesWith: value; dissolveDeep].
	hashes at: hash put: instruction
]

{ #category : 'testing' }
OptimizingValueNumbering >> isCommutative: name [
	^name = #'+' or: [name = #'*']
]

{ #category : 'testing' }
OptimizingValueNumbering >> isStillAlive: block [
	^block == firstBlock or: [block isReachableFrom: firstBlock]
]

{ #category : 'accessing' }
OptimizingValueNumbering >> nameOf: instruction [
	^names at: instruction ifAbsentPut: 'v' , names size printString
]

{ #category : 'accessing' }
OptimizingValueNumbering >> resultOfBinaryWithConstants: aBinaryInstruction [
	| operation left right |
	operation := aBinaryInstruction name.
	left := aBinaryInstruction left value.
	right := aBinaryInstruction right value.
	operation = #'+' ifTrue: [^left + right].
	operation = #'-' ifTrue: [^left - right].
	operation = #'*' ifTrue: [^left * right].
	operation = #'//' ifTrue: [^left // right].
	operation = #'=' ifTrue: [^left = right].
	operation = #'==' ifTrue: [^left == right].
	self halt
]

{ #category : 'private' }
OptimizingValueNumbering >> tryMoving: variable justBeforeBranch: branch [
	| node inserted |
	node := branch prev.
	node == variable ifTrue: [^self].
	[
		node isConstant ifFalse: [^self].
		node := node prev.
		node == variable] whileFalse.
	inserted := variable isPhi
		ifTrue: [variable replaceUsesBy: branch with: variable newCopy]
		ifFalse: [variable remove].
	branch beforeInsert: inserted
]

{ #category : 'private' }
OptimizingValueNumbering >> unifyPredecessorHashes [
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
]

{ #category : 'private' }
OptimizingValueNumbering >> updateMemory: store as: storeHash andLoads: loadHash [
	"
	easy: hashes at: storeHash ifPresent: [:mapping | (mapping value livesInSameBlockThan: store)  ifTrue: [mapping value dissolve]]
	hard: hashes at: storeHash ifPresent: [:mapping | postDominatorTree does: blockOf dominate: currentBlock ifTrue: [mapping value dissolve]]
	"
	hashes at: loadHash put: store
]

{ #category : 'private' }
OptimizingValueNumbering >> valueBranchTo: aBasicBlock [
	| source last comparison hash name |
	aBasicBlock predecessors size != 1 ifTrue: [^self].
	source := aBasicBlock predecessors first.
	last := source lastInstruction.
	last isConditionalJump ifFalse: [^self].
	comparison := last variable.
	name := self nameOf: comparison.
	hash := 'branch' , name.
	last target == aBasicBlock
		ifTrue: [hashes at: hash put: last isJumpTrue]
		ifFalse: [hashes at: hash put: last isJumpFalse]
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitBinaryWithConstant: instruction [
	| left right hash temp value replacement |
	instruction isUseless ifTrue: [^instruction dissolveDeep].
	left := self nameOf: instruction left.
	right := self nameOf: instruction right.
	(self isCommutative: instruction name) ifTrue: [
		left > right ifTrue: [
			temp := left.
			left := right.
			right := temp]].
	hash := left , instruction name , right.
	instruction left isConstant ifTrue: [
		value := self resultOfBinaryWithConstants: instruction.
		replacement := OLoadConstant valued: value.
		instruction dissolveReplacingWith: replacement.
		self visitLoadConstant: replacement].
	(instruction name == #'=='
		and: [instruction left isBoolean and: [instruction right value == true]])
		ifTrue: [^instruction replaceAllUsesWith: instruction left; dissolveDeep].
	("avoid coalescing a comparison when it would cause an unoptimized branch"
	instruction isComparison and: [instruction isUsedJustOnce])
		ifFalse: [self coalesce: instruction as: hash]
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitBinaryWithVariable: instruction [
	| left right hash temp replacement |
	instruction isUseless ifTrue: [^instruction dissolveDeep].
	instruction right isConstant ifTrue: [
		replacement := OBinaryConstantOperation
			left: instruction left
			right: instruction right value
			name: instruction name.
		instruction dissolveReplacingWith: replacement.
		^self visitBinaryWithConstant: replacement].
	left := self nameOf: instruction left.
	right := self nameOf: instruction right.
	(self isCommutative: instruction name) ifTrue: [
		left > right ifTrue: [
			temp := left.
			left := right.
			right := temp]].
	hash := left , instruction name , right.
	self coalesce: instruction as: hash
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitBranch: branch [
	| variable hash receiver |
	variable := branch variable.
	self tryMoving: variable justBeforeBranch: branch.
	receiver := self nameOf: variable.
	hash := 'branch' , receiver.
	hashes at: hash ifPresent: [:outcome | 
		outcome isBoolean
			ifTrue: [branch replaceWithUnconditional: outcome in: currentBlock]]
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitJump: aJumpInstruction [
	
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitJumpFalse: branch [
	self visitBranch: branch
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitJumpTrue: branch [
	self visitBranch: branch
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitLoad: load [
	| base index indexHash hash |
	base := self nameOf: load base.
	index := load index.
	indexHash := index isInstruction
		ifTrue: [self nameOf: index]
		ifFalse: [index printString].
	hash := base , load name , indexHash.
	self coalesce: load as: hash
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitLoadConstant: instruction [
	"
	we don't coalesce constants, we prefer reloading them than risking spilling
	"
	instruction isUsed ifFalse: [^instruction dissolve]
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitLoadImplicit: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitMessageSend: instruction [
	hashes
		removeAllSuchThat: [:value | value isInstruction and: [value isLoad]]
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitNullary: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitPhi: instruction [
	instruction dissolveIfUseless
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitReturn: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitStore: store [
	| receiver index indexHash value valueHash hash load selector |
	receiver := self nameOf: store base.
	index := store index.
	indexHash := index isInstruction
		ifTrue: [self nameOf: index]
		ifFalse: [index printString].
	value := store value.
	valueHash := self nameOf: value.
	hash := receiver , store name , indexHash , valueHash.
	selector := store name allButLast: 4.
	load := receiver , selector , indexHash.
	self updateMemory: value as: hash andLoads: load
]

{ #category : 'visitor protocol' }
OptimizingValueNumbering >> visitUnary: instruction [
	"
	We cannot coalesce _asNative for now. It would extend its live range and may cause
	it to be spilled. Spilling would mean placing a native value in the stack, but the GC
	cannot distinguish native values yet
	"
	| receiver hash |
	(#(push _asNative) includes: instruction name) ifTrue: [^self].
	receiver := self nameOf: instruction receiver.
	hash := receiver , instruction name.
	self coalesce: instruction as: hash
]

{ #category : 'private' }
OptimizingValueNumbering >> workFrom: aBasicBlock [
	| count |
	hashes := Dictionary new.
	hashesOut := Dictionary new.
	names := IdentityDictionary new.
	firstBlock := aBasicBlock.
	count := 0.
	aBasicBlock instructionsWithSuccessorsDo: [:inst | 
		names at: inst put: 'v' , count printString.
		count := count + 1].
	aBasicBlock withSuccessorsPostOrder
		reverseDo: [:block | self workOn: block]
]

{ #category : 'private' }
OptimizingValueNumbering >> workOn: aBlock [
	(self isStillAlive: aBlock) ifFalse: [^self].
	currentBlock := aBlock.
	self unifyPredecessorHashes; valueBranchTo: aBlock.
	currentBlock firstInstruction acceptVisitor: self.
	hashesOut at: aBlock put: hashes copy
]
