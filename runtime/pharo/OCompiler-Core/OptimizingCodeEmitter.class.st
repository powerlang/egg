"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OptimizingCodeEmitter',
	#superclass : 'Object',
	#instVars : [
		'allocation',
		'assembler',
		'abi',
		'jumpDestinations',
		'assemblers',
		'method',
		'firstBlock',
		'currentBlockIndex',
		'blocks',
		'messageLinker'
	],
	#category : 'OCompiler-Core-Main',
	#package : 'OCompiler-Core',
	#tag : 'Main'
}

{ #category : 'accessing' }
OptimizingCodeEmitter >> abi: anAbi [
	abi := anAbi.
	assembler wordSize: anAbi wordSize
]

{ #category : 'accessing' }
OptimizingCodeEmitter >> activationRecord [
	^firstBlock activationRecord
]

{ #category : 'accessing' }
OptimizingCodeEmitter >> allocation: anAllocation [
	allocation := anAllocation
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleAsNative: asNativeSend [
	| src dst |
	src := allocation at: asNativeSend receiver.
	dst := allocation at: asNativeSend.
	self _ASSERT: src == dst.
	assembler convertToNativeInteger: src
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleAsObject: asNativeSend [
	| src dst |
	src := allocation at: asNativeSend receiver.
	dst := allocation at: asNativeSend.
	self _ASSERT: src == dst.
	assembler clearIntegerBit: src
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleAsPointer: asNativeSend [
	| src dst oop |
	src := allocation at: asNativeSend receiver.
	dst := allocation at: asNativeSend.
	self _ASSERT: src == dst.
	oop := assembler newLabel.
	assembler
		testIntegerBit: src;
		jumpIfZeroTo: oop;
		convertToNativeInteger: src;
		@ oop;
		setIntegerBit: src
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleAsSmallInteger: asNativeSend [
	| src dst |
	src := allocation at: asNativeSend receiver.
	dst := allocation at: asNativeSend.
	self _ASSERT: src == dst.
	assembler convertToSmallInteger: src
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleBasicAt: instruction [
	| base index result |
	index := instruction index value.
	index isInteger ifTrue: [^self assembleBasicAtConstant: instruction].
	base := allocation at: instruction base.
	index := allocation at: instruction index.
	result := allocation at: instruction.
	assembler
		convertToNativeInteger: index;
		load: result from: base atIndexAt: index.
	result != index ifTrue: [assembler convertToSmallInteger: index]
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleBasicAtConstant: instruction [
	| base dst |
	base := allocation at: instruction base.
	dst := allocation at: instruction ifAbsent: [^self].
	assembler load: dst from: base atIndex: instruction index value
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleBasicAtConstantPut: instruction [
	| base value |
	base := allocation at: instruction base.
	value := allocation at: instruction value.
	assembler store: value in: base index: instruction index value
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleBasicAtPut: instruction [
	| base value index |
	index := instruction index value.
	index isInteger ifTrue: [^self assembleBasicAtConstantPut: instruction].
	base := allocation at: instruction base.
	value := allocation at: instruction value.
	index := allocation at: index.
	assembler
		convertToNativeInteger: index;
		store: value in: base indexAt: index;
		convertToSmallInteger: index
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleBitAnd: instruction [
	| left right |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	assembler and: left with: right
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleBitAndConstant: instruction [
	| left value |
	left := allocation at: instruction.
	value := instruction right * 2 + 1.
	assembler and: left with: value
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleBitOr: instruction [
	| left right |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	assembler or: left with: right
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleBitOrConstant: instruction [
	| left value |
	left := allocation at: instruction.
	value := instruction right * 2 + 1.
	assembler or: left with: value
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleBitShift: instruction [
	| src offset |
	src := allocation at: instruction left.
	instruction right isConstant
		ifTrue: [self assembleBitShift: src by: instruction right value]
		ifFalse: [
			offset := allocation at: instruction right.
			offset halt]
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleBitShift: src by: amount [
	amount > 0
		ifTrue: [
			assembler
				convertToNativeInteger: src;
				shiftLeft: src by: amount + 1;
				convertToSmallInteger: src]
		ifFalse: [
			assembler
				shiftRight: src by: 0 - amount;
				setIntegerBit: src]
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleBitShiftConstant: instruction [
	| src amount |
	src := allocation at: instruction left.
	amount := instruction right.
	self assembleBitShift: src by: amount
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleByteAt: instruction [
	| base index dst |
	index := instruction index value.
	index isInteger ifTrue: [^self assembleByteAtConstant: instruction].
	base := allocation at: instruction base.
	index := allocation at: instruction index.
	dst := allocation at: instruction.
	assembler
		convertToNativeInteger: index;
		loadZeroExtendByte: dst from: base atIndexAt: index;
		convertToSmallInteger: dst.
	index != dst ifTrue: [assembler convertToSmallInteger: index]
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleByteAtConstant: instruction [
	| base dst |
	base := allocation at: instruction base.
	dst := allocation at: instruction.
	assembler
		loadZeroExtendByte: dst
		from: base
		atIndex: instruction index value;
		convertToSmallInteger: dst
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleByteAtConstantPut: instruction [
	| base value |
	base := allocation at: instruction base.
	value := allocation at: instruction value.
	assembler
		convertToNativeInteger: value;
		renameByteRegisterIfNeeded: value
		preserving: base
		during: [:final | assembler
			storeByte: final byte
			in: base
			offset: instruction index value - 1];
		convertToSmallInteger: value
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleByteAtPut: instruction [
	| index base value |
	index := instruction index value.
	index isInteger ifTrue: [^self assembleByteAtConstantPut: instruction].
	base := allocation at: instruction base.
	index := allocation at: instruction index.
	value := allocation at: instruction value.
	assembler
		convertToNativeInteger: index;
		convertToNativeInteger: value;
		renameByteRegisterIfNeeded: value
		preserving: base
		preserving: index
		during: [:final | assembler store: final byte in: base indexAt: index];
		convertToSmallInteger: value;
		convertToSmallInteger: index
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleCompare: instruction jumpTrue: trueBlock jumpFalse: falseBlock [
	| left right |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	assembler compare: left with: right.
	self assembleJumpTrue: trueBlock orJumpFalse: falseBlock in: instruction
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleCompareConstant: instruction jumpTrue: trueBlock jumpFalse: falseBlock [
	| left |
	left := allocation at: instruction left.
	self
		assembleCompareConstant: left with: instruction right;
		assembleJumpTrue: trueBlock orJumpFalse: falseBlock in: instruction
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleCompareConstant: left with: right [
	right isSmallInteger ifTrue: [^assembler compare: left with: right * 2 + 1].
	right ifNil: [^assembler compareWithNil: left].
	right = false ifTrue: [^assembler compareWithFalse: left].
	right = true ifTrue: [^assembler compareWithTrue: left].
	assembler compare: left withPointer: right
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleCopy: instruction [
	| source target |
	target := allocation at: instruction.
	source := allocation at: instruction receiver.
	self assembleCopyIfNeeded: source to: target
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleCopyIfNeeded: source to: dest [
	source = dest ifTrue: [^self].
	assembler move: source to: dest
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleCopyResult: instruction [
	| dest |
	dest := allocation at: instruction ifAbsent: [^self].
	self assembleCopyIfNeeded: abi regR to: dest
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleEquals: instruction [
	self
		assembleCompare: instruction
		jumpTrue: [:label | assembler jumpIfEqualTo: label]
		jumpFalse: [:label | assembler jumpIfNotEqualTo: label]
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleEqualsConstant: instruction [
	self
		assembleCompareConstant: instruction
		jumpTrue: [:label | assembler jumpIfEqualTo: label]
		jumpFalse: [:label | assembler jumpIfNotEqualTo: label]
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleExtendedSize: extendedSizeSend [
	| base dst |
	base := allocation at: extendedSizeSend receiver.
	dst := allocation at: extendedSizeSend.
	assembler
		load: dst e from: base atIndex: _ExtendedSize;
		convertToSmallInteger: dst
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleFrom: aBasicBlock [
	firstBlock := aBasicBlock.
	blocks := firstBlock withSuccessorsPostOrder reversed.
	self doAssemble
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleGenericMessageSend: instruction [
	| dest |
	self assembleLookup: instruction selector.
	dest := allocation at: instruction ifAbsent: [^self].
	self assembleCopyIfNeeded: abi regR to: dest
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleGreater: instruction [
	self
		assembleCompare: instruction
		jumpTrue: [:label | assembler jumpIfGreaterSignedTo: label]
		jumpFalse: [:label | assembler jumpIfLessOrEqualSignedTo: label]
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleGreaterConstant: instruction [
	self
		assembleCompareConstant: instruction
		jumpTrue: [:label | assembler jumpIfGreaterSignedTo: label]
		jumpFalse: [:label | assembler jumpIfLessOrEqualSignedTo: label]
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleGreaterEqual: instruction [
	self
		assembleCompare: instruction
		jumpTrue: [:label | assembler jumpIfGreaterOrEqualSignedTo: label]
		jumpFalse: [:label | assembler jumpIfLessSignedTo: label]
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleGreaterEqualConstant: instruction [
	self
		assembleCompareConstant: instruction
		jumpTrue: [:label | assembler jumpIfGreaterOrEqualSignedTo: label]
		jumpFalse: [:label | assembler jumpIfLessSignedTo: label]
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleIsSmallInteger: instruction [
	| src |
	src := allocation at: instruction receiver.
	assembler testIntegerBit: src.
	self
		assembleJumpTrue: [:label | assembler jumpIfNotZeroTo: label]
		orJumpFalse: [:label | assembler jumpIfZeroTo: label]
		in: instruction
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleJumpIfEqualTo: target [
	| label |
	label := jumpDestinations at: target.
	assembler jumpIfEqualTo: label
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleJumpTo: target [
	| label index |
	label := jumpDestinations at: target.
	index := blocks indexOf: target.
	^((index - currentBlockIndex) abs > 18 or: true)
		ifTrue: [assembler jumpTo: label]
		ifFalse: [assembler shortJumpTo: label]
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleJumpTrue: blockJumpTrue orJumpFalse: blockJumpFalse in: instruction [
	| success result loadFalse end |
	success := self
		tryOptimizing: instruction
		jumpTrue: blockJumpTrue
		jumpFalse: blockJumpFalse.
	success ifTrue: [^self].
	result := allocation at: instruction.
	loadFalse := assembler newLabel.
	end := assembler newLabel.
	blockJumpFalse value: loadFalse.
	assembler
		load: result withBoolean: true;
		shortJumpTo: end;
		@ loadFalse;
		load: result withBoolean: false;
		@ end
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleLoadConstant: value to: register [
	| constant |
	value isSmallInteger ifTrue: [
		constant := value * 2 + 1.
		^assembler load: register withImmediate: constant].
	value ifNil: [^assembler loadWithNil: register].
	value = false ifTrue: [^assembler loadWithFalse: register].
	value = true ifTrue: [^assembler loadWithTrue: register].
	assembler load: register withPointer: value
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleLongSlotAt: instruction [
	| base index result |
	index := instruction index value.
	index isInteger ifTrue: [^self assembleLongSlotAtConstant: instruction].
	base := allocation at: instruction base.
	index := allocation at: index.
	result := allocation at: instruction.
	assembler
		convertToNativeInteger: index;
		load: result e from: base atIndexAt: index.
	result != index ifTrue: [assembler convertToSmallInteger: index]
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleLongSlotAtConstant: instruction [
	| src dst |
	src := allocation at: instruction base.
	dst := allocation at: instruction ifAbsent: [^self].
	assembler load: dst e from: src atIndex: instruction index value
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleLongSlotAtConstantPut: instruction [
	| base value |
	base := allocation at: instruction base.
	value := allocation at: instruction value.
	assembler store: value e in: base index: instruction index value
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleLongSlotAtPut: instruction [
	| base value index |
	index := instruction index value.
	index isInteger ifTrue: [^self assembleLongSlotAtConstantPut: instruction].
	base := allocation at: instruction base.
	value := allocation at: instruction value.
	index := allocation at: index.
	assembler
		convertToNativeInteger: index;
		store: value e in: base indexAt: index;
		convertToSmallInteger: index
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleLookup: selector [
	self haltWhen: selector = #'&'.
	messageLinker emitSend: selector using: assembler
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleLower: instruction [
	self
		assembleCompare: instruction
		jumpTrue: [:label | assembler jumpIfLessSignedTo: label]
		jumpFalse: [:label | assembler jumpIfGreaterOrEqualSignedTo: label]
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleLowerConstant: instruction [
	self
		assembleCompareConstant: instruction
		jumpTrue: [:label | assembler jumpIfLessSignedTo: label]
		jumpFalse: [:label | assembler jumpIfGreaterOrEqualSignedTo: label]
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleLowerEqual: instruction [
	self
		assembleCompare: instruction
		jumpTrue: [:label | assembler jumpIfLessOrEqualSignedTo: label]
		jumpFalse: [:label | assembler jumpIfGreaterSignedTo: label]
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleLowerEqualConstant: instruction [
	self
		assembleCompareConstant: instruction
		jumpTrue: [:label | assembler jumpIfLessOrEqualSignedTo: label]
		jumpFalse: [:label | assembler jumpIfGreaterSignedTo: label]
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleMinus: instruction [
	| left right |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	assembler
		add: 1 to: left;
		subtract: right from: left
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleMinusConstant: instruction [
	| left value |
	left := allocation at: instruction left.
	value := instruction right * 2.
	assembler subtract: value from: left
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleNegate: instruction [
	| src dst |
	src := allocation at: instruction receiver.
	dst := allocation at: instruction.
	self _ASSERT: dst = src.
	assembler
		negate: src;
		add: 2 to: dst
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleNotEqualConstant: instruction [
	self
		assembleCompareConstant: instruction
		jumpTrue: [:label | assembler jumpIfNotEqualTo: label]
		jumpFalse: [:label | assembler jumpIfEqualTo: label]
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assembleObjectAtOffsetPut: instruction [
	| base value offset |
	base := allocation at: instruction receiver.
	value := allocation at: instruction right.
	offset := instruction left value.
	assembler storePointer: value in: base offset: offset
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assemblePlus: instruction [
	| left right |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	assembler
		clearIntegerBit: left;
		add: right to: left
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assemblePlusConstant: instruction [
	| left value |
	left := allocation at: instruction left.
	value := instruction right * 2.
	assembler add: value to: left
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assemblePop: instruction [
	| register |
	register := allocation at: instruction.
	assembler pop: register
]

{ #category : 'unclassified' }
OptimizingCodeEmitter >> assemblePush: instruction [
	| register |
	register := allocation at: instruction receiver.
	assembler push: register
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleTimesConstant: instruction [
	| left value shift |
	left := allocation at: instruction left.
	value := instruction right.
	self _ASSERT: (value == 4 or: [value == 8] or: [value == 2]).
	shift := value == 4
		ifTrue: [2]
		ifFalse: [value == 8 ifTrue: [3] ifFalse: [1]].
	assembler
		clearIntegerBit: left;
		shiftLeft: left by: shift;
		setIntegerBit: left
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleTransferControlTo: instruction [
	| code receiver activation |
	receiver := allocation at: instruction left.
	code := allocation at: instruction right.
	receiver == assembler regA ifTrue: [
		code == assembler regT
			ifTrue: [
				assembler move: assembler regA to: assembler regR.
				receiver := assembler regR]
			ifFalse: [
				assembler move: assembler regA to: assembler regT.
				receiver := assembler regT]].
	self assembleCopyIfNeeded: code to: assembler regM.
	self assembleCopyIfNeeded: receiver to: assembler regR.
	activation := self activationRecord.
	(activation savesPreviousSelf and: [activation hasFrame])
		ifTrue: [assembler pop: assembler regS].
	assembler restoreCallerFrame; jumpToMindex: 1
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleULongAt: instruction [
	| result |
	self assembleLongSlotAt: instruction.
	result := allocation at: instruction.
	assembler convertToSmallInteger: result
]

{ #category : 'private' }
OptimizingCodeEmitter >> assembleULongAtPut: instruction [
	| value |
	value := allocation at: instruction value.
	assembler convertToNativeInteger: value.
	self assembleLongSlotAtPut: instruction.
	assembler convertToSmallInteger: value
]

{ #category : 'inquiries' }
OptimizingCodeEmitter >> currentBlock [
	^blocks at: currentBlockIndex
]

{ #category : 'private' }
OptimizingCodeEmitter >> doAssemble [
	| nilval |
	nilval := firstBlock nilUnitializedTemporaries.
	nilval ifNotNil: [allocation at: nilval put: assembler regNil].
	self labelBlocks.
	blocks withIndexDo: [:block :index | | label |
		currentBlockIndex := index.
		label := jumpDestinations at: block.
		assembler @ label.
		block firstInstruction acceptVisitor: self].
	assembler applyFixups
]

{ #category : 'initialization' }
OptimizingCodeEmitter >> initialize [
	jumpDestinations := Dictionary new.
	self initializeLowLevelAssembler; initializeAssemblers
]

{ #category : 'initialization' }
OptimizingCodeEmitter >> initializeAssemblers [
	assemblers := Dictionary new
		at: #'+' put: #Plus;
		at: #'-' put: #Minus;
		at: #'*' put: #Times;
		at: #'=' put: #Equals;
		at: #'==' put: #Equals;
		at: #'~=' put: #NotEqual;
		at: #'!=' put: #NotEqual;
		at: #'<' put: #Lower;
		at: #'<=' put: #LowerEqual;
		at: #'>=' put: #GreaterEqual;
		at: #'>' put: #Greater;
		at: #'&' put: #BitAnd;
		at: #bitAnd: put: #BitAnd;
		at: #bitOr: put: #BitOr;
		at: #bitShift: put: #BitShift;
		at: #_asNative put: #AsNative;
		at: #_asObject put: #AsObject;
		at: #_asPointer put: #AsPointer;
		at: #_asSmallInteger put: #AsSmallInteger;
		at: #_byteAt: put: #ByteAt;
		at: #_basicAt: put: #BasicAt;
		at: #_longSlotAt: put: #LongSlotAt;
		at: #_uLongAt: put: #ULongAt;
		at: #_byteAt:put: put: #ByteAtPut;
		at: #_basicAt:put: put: #BasicAtPut;
		at: #_longSlotAt:put: put: #LongSlotAtPut;
		at: #_uLongAt:Put: put: #ULongAtPut;
		at: #_objectAtOffset:put: put: #ObjectAtOffsetPut;
		at: #_isSmallInteger put: #IsSmallInteger;
		at: #_transferControlTo: put: #TransferControlTo;
		at: #negate put: #Negate;
		at: #push put: #Push;
		at: #pop put: #Pop;
		at: #copy put: #Copy;
		at: #copyResult put: #CopyResult;
		yourself
]

{ #category : 'initialization' }
OptimizingCodeEmitter >> initializeLowLevelAssembler [
	assembler := JITAssembler64 new
]

{ #category : 'testing' }
OptimizingCodeEmitter >> jumpWasAssembledInComparison: aConditionalJump [
	| prev |
	prev := aConditionalJump prev.
	prev == aConditionalJump variable ifFalse: [^false].
	prev isUsedJustOnce ifFalse: [^false].
	prev class == OMessageSend ifTrue: [^false].
	prev class == OPhi ifTrue: [^false].
	prev class == OLoadOperation ifTrue: [^false].
	((prev isKindOf: OBinaryOperation) and: [prev isComparison]) ifTrue: [^true].
	prev class == OUnaryOperation ifTrue: [
		#_isSmallInteger = prev name ifTrue: [^true].
		#copy = prev name ifTrue: [^false]].
	self halt
]

{ #category : 'private' }
OptimizingCodeEmitter >> labelBlocks [
	blocks do: [:block | | label |
		label := assembler newLabel.
		jumpDestinations at: block put: label]
]

{ #category : 'private' }
OptimizingCodeEmitter >> loadMifNeeded [
	method selector == #_dispatchOn:
		ifTrue: [^assembler loadMwithGlobal: #Lookup].
	method selector == #_dispatchOn:startingAt:
		ifTrue: [^assembler loadMwithGlobal: #LookupSuper].
	method selector == #_dispatchDebuggableOn:
		ifTrue: [^assembler loadMwithGlobal: #DebuggableLookup].
	method selector == #_dispatchDebuggableOn:startingAt:
		ifTrue: [^assembler loadMwithGlobal: #DebuggableLookupSuper]
]

{ #category : 'accessing' }
OptimizingCodeEmitter >> messageLinker: aMessageLinker [
	messageLinker := aMessageLinker
]

{ #category : 'accessing' }
OptimizingCodeEmitter >> method: aCompiledMethod [
	method := aCompiledMethod
]

{ #category : 'inquiries' }
OptimizingCodeEmitter >> nativeCode [
	^assembler nativeCode
]

{ #category : 'inquiries' }
OptimizingCodeEmitter >> nextBlock [
	^blocks at: currentBlockIndex + 1 ifAbsent: [nil]
]

{ #category : 'testing' }
OptimizingCodeEmitter >> savesPreviousSelf [
	^self activationRecord savesPreviousSelf
]

{ #category : 'inquiries' }
OptimizingCodeEmitter >> selectorFor: instruction [
	^assemblers at: instruction name
]

{ #category : 'testing' }
OptimizingCodeEmitter >> tryOptimizing: comparison jumpTrue: blockJumpTrue jumpFalse: blockJumpFalse [
	| inst label |
	comparison isUsedJustOnce ifFalse: [^false].
	inst := comparison next.
	inst isConditionalJump ifFalse: [^false].
	label := jumpDestinations at: inst target.
	inst isJumpTrue
		ifTrue: [blockJumpTrue value: label]
		ifFalse: [blockJumpFalse value: label].
	self nextBlock != inst implicitTarget
		ifTrue: [self assembleJumpTo: inst implicitTarget].
	^true
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitBinaryWithConstant: instruction [
	| selector |
	selector := #assemble , (self selectorFor: instruction) , #Constant:.
	self perform: selector asSymbol with: instruction
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitBinaryWithVariable: instruction [
	self visitGeneric: instruction
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitBranch: branch comparing: aBoolean [
	| reg |
	(self jumpWasAssembledInComparison: branch) ifTrue: [^self].
	reg := allocation at: branch variable.
	assembler compare: reg withBoolean: aBoolean.
	self assembleJumpIfEqualTo: branch target.
	branch implicitTarget != self nextBlock
		ifTrue: [self assembleJumpTo: branch implicitTarget]
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitGeneric: instruction [
	| selector |
	selector := #assemble , (self selectorFor: instruction) , #':'.
	self perform: selector asSymbol with: instruction
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitJump: aJump [
	aJump target == self nextBlock ifTrue: [^self].
	self assembleJumpTo: aJump target
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitJumpFalse: aJumpFalse [
	self visitBranch: aJumpFalse comparing: false
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitJumpTrue: aJumpTrue [
	self visitBranch: aJumpTrue comparing: true
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitLoad: instruction [
	self visitGeneric: instruction
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitLoadConstant: aLoadConstant [
	| register value |
	register := allocation
		at: aLoadConstant
		ifAbsent: [aLoadConstant isUsed ifTrue: [self halt] ifFalse: [^self]].
	value := aLoadConstant value.
	self assembleLoadConstant: value to: register
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitLoadImplicit: instruction [
	| frame |
	instruction name == #activationRecord ifTrue: [
		assembler buildFrame.
		^self loadMifNeeded].
	instruction name == #self ifFalse: [^self].
	frame := instruction prev.
	frame hasFrame ifFalse: [^self].
	assembler
		reserveStackSlots: frame temporaries + 2;
		store: assembler regR in: assembler regFP index: 0;
		store: assembler regM in: assembler regFP index: -1.
	self savesPreviousSelf
		ifTrue: [assembler push: assembler regS; pushM; loadMwithA]
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitMessageSend: aMessageSend [
	self assembleGenericMessageSend: aMessageSend.
	firstBlock activationRecord haveFrame
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitNullary: instruction [
	self visitGeneric: instruction
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitPhi: phiInstruction [
	
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitReturn: aReturnInstruction [
	| source |
	source := allocation at: aReturnInstruction source.
	self assembleCopyIfNeeded: source to: assembler regR.
	self savesPreviousSelf
		ifTrue: [assembler popM; popS; restoreCallerFrame]
		ifFalse: [
			assembler
				restoreCallerFrame;
				load: assembler regS from: assembler regFP atIndex: 0;
				restoreCallerM].
	assembler return
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitStore: instruction [
	self visitGeneric: instruction
]

{ #category : 'visiting' }
OptimizingCodeEmitter >> visitUnary: instruction [
	self visitGeneric: instruction
]
