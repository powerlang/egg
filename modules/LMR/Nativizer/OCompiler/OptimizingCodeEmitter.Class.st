'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #OptimizingCodeEmitter category: #OCompiler!
Object subclass: #OptimizingCodeEmitter
	instanceVariableNames: 'allocation assembler abi jumpDestinations assemblers method firstBlock currentBlockIndex blocks messageLinker'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'OCompiler'!
!OptimizingCodeEmitter commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!OptimizingCodeEmitter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
abi: anAbi
	abi := anAbi.
	assembler wordSize: anAbi wordSize
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
activationRecord
	^firstBlock firstInstruction
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocation: anAllocation
	allocation := anAllocation
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleAsNative: asNativeSend
	| src dst |
	src := allocation at: asNativeSend receiver.
	dst := allocation at: asNativeSend.
	self ASSERT: src == dst.
	assembler convertToNativeInteger: src
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleAsObject: asNativeSend
	| src dst |
	src := allocation at: asNativeSend receiver.
	dst := allocation at: asNativeSend.
	self ASSERT: src == dst.
	assembler clearIntegerBit: src
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleAsPointer: asNativeSend
	| src dst oop |
	src := allocation at: asNativeSend receiver.
	dst := allocation at: asNativeSend.
	self ASSERT: src == dst.
	oop := assembler newLabel.
	assembler
		testIntegerBit: src;
		jumpIfZeroTo: oop;
		convertToNativeInteger: src;
		@ oop;
		setIntegerBit: src
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleAsSmallInteger: asNativeSend
	| src dst |
	src := allocation at: asNativeSend receiver.
	dst := allocation at: asNativeSend.
	self ASSERT: src == dst.
	assembler convertToSmallInteger: src
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicAt: instruction
	| base index result |
	base := allocation at: instruction left.
	index := allocation at: instruction right.
	result := allocation at: instruction.
	assembler
		convertToNativeInteger: index;
		load: result from: base atIndexAt: index.
	result !!= index ifTrue: [assembler convertToSmallInteger: index]
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicAtConstant: instruction
	| src dst index |
	src := allocation at: instruction left.
	dst := allocation at: instruction ifAbsent: [^self].
	index := instruction right.
	assembler load: dst from: src atIndex: index
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicAtPut: instruction
	| base value index |
	index := instruction left value.
	index isInteger ifTrue: [^self assembleBasicAtPutConstant: instruction].
	base := allocation at: instruction receiver.
	value := allocation at: instruction right.
	index := allocation at: index.
	assembler
		convertToNativeInteger: index;
		store: value in: base indexAt: index;
		convertToSmallInteger: index
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicAtPutConstant: instruction
	| base value position |
	base := allocation at: instruction receiver.
	value := allocation at: instruction right.
	position := instruction left value.
	assembler store: value in: base index: position
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicFlags: basicFlagsSend
	| base dst |
	base := allocation at: basicFlagsSend receiver.
	dst := allocation at: basicFlagsSend.
	assembler
		loadZeroExtendByte: dst from: base atOffset: _Flags;
		convertToSmallInteger: dst
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicFlagsPut: basicFlagsPut
	self assembleByteAtOffset: _Flags put: basicFlagsPut
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicSize: basicSizeSend
	| base dst |
	base := allocation at: basicSizeSend receiver.
	dst := allocation at: basicSizeSend.
	assembler
		loadZeroExtendByte: dst from: base atOffset: _SmallSize;
		convertToSmallInteger: dst
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicSizePut: basicSizePut
	self assembleByteAtOffset: _SmallSize put: basicSizePut
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicSizePutConstant: basicFlagsPutSend
	| base value |
	base := allocation at: basicFlagsPutSend left.
	value := basicFlagsPutSend right.
	assembler storeByte: value in: base offset: _SmallSize
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicULongAt: instruction
	| base index result |
	base := allocation at: instruction left.
	index := allocation at: instruction right.
	result := allocation at: instruction.
	assembler
		convertToNativeInteger: index;
		load: result e from: base atIndexAt: index.
	result !!= index ifTrue: [assembler convertToSmallInteger: index]
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicULongAtConstant: instruction
	| src dst index |
	src := allocation at: instruction left.
	dst := allocation at: instruction ifAbsent: [^self].
	index := instruction right.
	assembler load: dst e from: src atIndex: index
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicULongAtPut: instruction
	| base value index |
	index := instruction left value.
	index isInteger
		ifTrue: [^self assembleBasicULongAtPutConstant: instruction].
	base := allocation at: instruction receiver.
	value := allocation at: instruction right.
	index := allocation at: index.
	assembler
		convertToNativeInteger: index;
		store: value e in: base indexAt: index;
		convertToSmallInteger: index
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBasicULongAtPutConstant: instruction
	| base value position |
	base := allocation at: instruction receiver.
	value := allocation at: instruction right.
	position := instruction left value.
	assembler store: value e in: base index: position
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBitAnd: instruction
	| left right |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	assembler and: left with: right
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBitAndConstant: instruction
	| left value |
	left := allocation at: instruction.
	value := instruction right * 2 + 1.
	assembler and: left with: value
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBitOr: instruction
	| left right |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	assembler or: left with: right
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBitOrConstant: instruction
	| left value |
	left := allocation at: instruction.
	value := instruction right * 2 + 1.
	assembler or: left with: value
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBitShift: instruction
	| src offset |
	src := allocation at: instruction left.
	instruction right isConstant
		ifTrue: [self assembleBitShift: src by: instruction right value]
		ifFalse: [
			offset := allocation at: instruction right.
			offset halt]
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBitShift: src by: amount
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
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleBitShiftConstant: instruction
	| src amount |
	src := allocation at: instruction left.
	amount := instruction right.
	self assembleBitShift: src by: amount
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleByteAt: instruction
	| base index dst |
	base := allocation at: instruction left.
	index := allocation at: instruction right.
	dst := allocation at: instruction.
	assembler
		convertToNativeInteger: index;
		loadZeroExtendByte: dst from: base atIndexAt: index;
		convertToSmallInteger: dst.
	index !!= dst ifTrue: [assembler convertToSmallInteger: index]
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleByteAt: index put: instruction
	self assembleByteAtOffset: index - 1 put: instruction
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleByteAtConstant: instruction
	| base index dst |
	base := allocation at: instruction left.
	index := instruction right.
	dst := allocation at: instruction.
	assembler
		loadZeroExtendByte: dst from: base atIndex: index;
		convertToSmallInteger: dst
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleByteAtOffset: offset put: instruction
	| base value |
	base := allocation at: instruction left.
	value := allocation at: instruction right.
	assembler
		convertToNativeInteger: value;
		renameByteRegisterIfNeeded: value
		preserving: base
		during: [:final | assembler storeByte: final byte in: base offset: offset];
		convertToSmallInteger: value
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleByteAtPut: instruction
	| index base value |
	base := allocation at: instruction receiver.
	index := allocation at: instruction left.
	value := allocation at: instruction right.
	assembler
		convertToNativeInteger: index;
		convertToNativeInteger: value;
		renameByteRegisterIfNeeded: value
		preserving: base
		preserving: index
		during: [:final | assembler store: final byte in: base indexAt: index];
		convertToSmallInteger: value;
		convertToSmallInteger: index
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleCompare: instruction
	| left right |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	assembler compare: left with: right
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleCompareConstant: instruction jumpTrue: trueBlock jumpFalse: falseBlock
	| left value |
	left := allocation at: instruction left.
	instruction right isSmallInteger
		ifTrue: [
			value := instruction right * 2 + 1.
			assembler compare: left with: value]
		ifFalse: [
			value := instruction right.
			assembler compare: left withPointer: value].
	self assembleJumpTrue: trueBlock orJumpFalse: falseBlock in: instruction
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleCopy: instruction
	| source target |
	target := allocation at: instruction.
	source := allocation at: instruction receiver.
	self assembleCopyIfNeeded: source to: target
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleCopyIfNeeded: source to: dest
	source = dest ifTrue: [^self].
	assembler move: source to: dest
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleCopyResult: instruction
	| dest |
	dest := allocation at: instruction ifAbsent: [^self].
	self assembleCopyIfNeeded: abi regR to: dest
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleEquals: instruction
	self
		assembleCompare: instruction;
		assembleJumpTrue: [:label | assembler jumpIfEqualTo: label]
		orJumpFalse: [:label | assembler jumpIfNotEqualTo: label]
		in: instruction
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleEqualsConstant: instruction
	self
		assembleCompareConstant: instruction
		jumpTrue: [:label | assembler jumpIfEqualTo: label]
		jumpFalse: [:label | assembler jumpIfNotEqualTo: label]
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleExtendedSize: extendedSizeSend
	| base dst |
	base := allocation at: extendedSizeSend receiver.
	dst := allocation at: extendedSizeSend.
	assembler
		load: dst e from: base atIndex: _ExtendedSize;
		convertToSmallInteger: dst
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleFrom: aBasicBlock
	firstBlock := aBasicBlock.
	blocks := firstBlock withSuccessorsPostOrder reversed.
	self doAssemble
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleGenericMessageSend: instruction
	self assembleLookup: instruction selector
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleGreater: instruction
	self
		assembleCompare: instruction;
		assembleJumpTrue: [:label | assembler jumpIfGreaterSignedTo: label]
		orJumpFalse: [:label | assembler jumpIfLessOrEqualSignedTo: label]
		in: instruction
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleGreaterConstant: instruction
	self
		assembleCompareConstant: instruction
		jumpTrue: [:label | assembler jumpIfGreaterSignedTo: label]
		jumpFalse: [:label | assembler jumpIfLessOrEqualSignedTo: label]
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleGreaterEqual: instruction
	self
		assembleCompare: instruction;
		assembleJumpTrue: [:label | assembler jumpIfGreaterOrEqualSignedTo: label]
		orJumpFalse: [:label | assembler jumpIfLessSignedTo: label]
		in: instruction
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleGreaterEqualConstant: instruction
	self
		assembleCompareConstant: instruction
		jumpTrue: [:label | assembler jumpIfGreaterOrEqualSignedTo: label]
		jumpFalse: [:label | assembler jumpIfLessSignedTo: label]
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleIsSmallInteger: instruction
	| src |
	src := allocation at: instruction receiver.
	assembler testIntegerBit: src.
	self
		assembleJumpTrue: [:label | assembler jumpIfNotZeroTo: label]
		orJumpFalse: [:label | assembler jumpIfZeroTo: label]
		in: instruction
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleJumpIfEqualTo: target
	| label |
	label := jumpDestinations at: target.
	assembler jumpIfEqualTo: label
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleJumpTo: target
	| label index |
	label := jumpDestinations at: target.
	index := blocks indexOf: target.
	^((index - currentBlockIndex) abs > 18 or: true)
		ifTrue: [assembler jumpTo: label]
		ifFalse: [assembler shortJumpTo: label]
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleJumpTrue: blockJumpTrue orJumpFalse: blockJumpFalse in: instruction
	| next end result label loadFalse |
	next := instruction next.
	(next isConditionalJump and: [instruction allUses size = 1])
		ifTrue: [
			label := jumpDestinations at: next target.
			next isJumpTrue
				ifTrue: [blockJumpTrue value: label]
				ifFalse: [blockJumpFalse value: label].
			self nextBlock !!= next implicitTarget
				ifTrue: [self assembleJumpTo: next implicitTarget]]
		ifFalse: [
			result := allocation at: instruction.
			loadFalse := assembler newLabel.
			end := assembler newLabel.
			blockJumpFalse value: loadFalse.
			self assembleLoadConstant: true to: result.
			assembler shortJumpTo: end; @ loadFalse.
			self assembleLoadConstant: false to: result.
			assembler @ end]
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleLoadConstant: value to: register
	| constant |
	value isSmallInteger
		ifTrue: [
			constant := value * 2 + 1.
			assembler load: register withImmediate: constant]
		ifFalse: [assembler load: register withPointer: value]
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleLookup: selector
	self haltWhen: selector = #'&'.
	messageLinker emitSend: selector using: assembler
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleLower: instruction
	self
		assembleCompare: instruction;
		assembleJumpTrue: [:label | assembler jumpIfLessSignedTo: label]
		orJumpFalse: [:label | assembler jumpIfGreaterOrEqualSignedTo: label]
		in: instruction
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleLowerConstant: instruction
	self
		assembleCompareConstant: instruction
		jumpTrue: [:label | assembler jumpIfLessSignedTo: label]
		jumpFalse: [:label | assembler jumpIfGreaterOrEqualSignedTo: label]
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleLowerEqual: instruction
	self
		assembleCompare: instruction;
		assembleJumpTrue: [:label | assembler jumpIfLessOrEqualSignedTo: label]
		orJumpFalse: [:label | assembler jumpIfGreaterSignedTo: label]
		in: instruction
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleLowerEqualConstant: instruction
	self
		assembleCompareConstant: instruction
		jumpTrue: [:label | assembler jumpIfLessOrEqualSignedTo: label]
		jumpFalse: [:label | assembler jumpIfGreaterSignedTo: label]
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleMinus: instruction
	| left right |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	assembler
		add: 1 to: left;
		subtract: right from: left
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleMinusConstant: instruction
	| left value |
	left := allocation at: instruction left.
	value := instruction right * 2.
	assembler subtract: value from: left
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleNegate: instruction
	| src dst |
	src := allocation at: instruction receiver.
	dst := allocation at: instruction.
	self ASSERT: dst = src.
	assembler
		negate: src;
		add: 2 to: dst
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleNotEqualConstant: instruction
	self
		assembleCompareConstant: instruction
		jumpTrue: [:label | assembler jumpIfNotEqualTo: label]
		jumpFalse: [:label | assembler jumpIfEqualTo: label]
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleObjectAtOffsetPut: instruction
	| base value offset |
	base := allocation at: instruction receiver.
	value := allocation at: instruction right.
	offset := instruction left value.
	assembler storePointer: value in: base offset: offset
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assemblePlus: instruction
	| left right |
	left := allocation at: instruction left.
	right := allocation at: instruction right.
	assembler
		clearIntegerBit: left;
		add: right to: left
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assemblePlusConstant: instruction
	| left value |
	left := allocation at: instruction left.
	value := instruction right * 2.
	assembler add: value to: left
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assemblePop: instruction
	| register |
	register := allocation at: instruction.
	assembler pop: register
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assemblePush: instruction
	| register |
	register := allocation at: instruction receiver.
	assembler push: register
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleRestorePreviousContext: instruction
	assembler restoreCallerFrame
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleTimesConstant: instruction
	| left value shift |
	left := allocation at: instruction left.
	value := instruction right.
	self ASSERT: (value == 4 or: [value == 8]).
	shift := value == 4 ifTrue: [2] ifFalse: [3].
	assembler
		clearIntegerBit: left;
		shiftLeft: left by: shift;
		setIntegerBit: left
! !

!OptimizingCodeEmitter methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
assembleTransferControlTo: instruction
	| code receiver |
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
	self assembleCopyIfNeeded: code to: assembler regA.
	self assembleCopyIfNeeded: receiver to: assembler regR.
	self activationRecord savesPreviousSelf
		ifTrue: [assembler pop: assembler regS].
	assembler restoreCallerFrame; jumpToReg: assembler regA
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
currentBlock
	^blocks at: currentBlockIndex
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
doAssemble
	self labelBlocks.
	blocks withIndexDo: [:block :index | | label |
		currentBlockIndex := index.
		label := jumpDestinations at: block.
		assembler @ label.
		block firstInstruction acceptVisitor: self].
	assembler applyFixups
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	jumpDestinations := Dictionary new.
	self initializeLowLevelAssembler; initializeAssemblers
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeAssemblers
	assemblers := Dictionary new
		at: #'+' put: #Plus;
		at: #'-' put: #Minus;
		at: #'*' put: #Times;
		at: #'=' put: #Equals;
		at: #'==' put: #Equals;
		at: #'~=' put: #NotEqual;
		at: #'!!=' put: #NotEqual;
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
		at: #_basicULongAt: put: #BasicULongAt;
		at: #_byteAt:put: put: #ByteAtPut;
		at: #_basicAt:put: put: #BasicAtPut;
		at: #_basicULongAt:put: put: #BasicULongAtPut;
		at: #_objectAtOffset:put: put: #ObjectAtOffsetPut;
		at: #_basicFlags put: #BasicFlags;
		at: #_basicFlags: put: #BasicFlagsPut;
		at: #_smallSize put: #BasicSize;
		at: #_smallSize: put: #BasicSizePut;
		at: #_largeSize put: #ExtendedSize;
		at: #_largeSize: put: #ExtendedSizePut;
		at: #_isSmallInteger put: #IsSmallInteger;
		at: #_transferControlTo: put: #TransferControlTo;
		at: #negate put: #Negate;
		at: #push put: #Push;
		at: #pop put: #Pop;
		at: #copy put: #Copy;
		at: #copyResult put: #CopyResult;
		yourself
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeLowLevelAssembler
	assembler := JITAssembler64 on: #[] writeStream
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
jumpWasAssembledInComparison: aConditionalJump
	| prev |
	prev := aConditionalJump prev.
	prev == aConditionalJump variable ifFalse: [^false].
	prev allUses size !!= 1 ifTrue: [^false].
	prev class == OMessageSend ifTrue: [^false].
	prev class == OPhi ifTrue: [^false].
	(prev isKindOf: OBinaryOperation) ifTrue: [
		(#(< <= = == !!= >= >) includes: prev name) ifTrue: [^true].
		(#(_basicAt:) includes: prev name) ifTrue: [^false]].
	prev class == OUnaryOperation ifTrue: [
		(#(_isSmallInteger) includes: prev name) ifTrue: [^true].
		(#(copy) includes: prev name) ifTrue: [^false]].
	self halt
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
labelBlocks
	blocks do: [:block | | label |
		label := assembler newLabel.
		jumpDestinations at: block put: label]
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
messageLinker: aMessageLinker
	messageLinker := aMessageLinker
! !

!OptimizingCodeEmitter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
method: aCompiledMethod
	method := aCompiledMethod
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
nativeCode
	^assembler nativeCode
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextBlock
	^blocks at: currentBlockIndex + 1 ifAbsent: [nil]
! !

!OptimizingCodeEmitter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
savesPreviousSelf
	^self activationRecord savesPreviousSelf
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
selectorFor: instruction
	^assemblers at: instruction name
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithConstant: instruction
	| selector |
	selector := #assemble , (self selectorFor: instruction) , #Constant:.
	self perform: selector asSymbol with: instruction
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBinaryWithVariable: instruction
	| selector |
	selector := #assemble , (self selectorFor: instruction) , #':'.
	self perform: selector asSymbol with: instruction
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitBranch: branch comparing: aBoolean
	| reg |
	(self jumpWasAssembledInComparison: branch) ifTrue: [^self].
	reg := allocation at: branch variable.
	assembler compare: reg withPointer: aBoolean.
	self assembleJumpIfEqualTo: branch target.
	branch implicitTarget !!= self nextBlock
		ifTrue: [self assembleJumpTo: branch implicitTarget]
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJump: aJump
	aJump target == self nextBlock ifTrue: [^self].
	self assembleJumpTo: aJump target
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpFalse: aJumpFalse
	self visitBranch: aJumpFalse comparing: false
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitJumpTrue: aJumpTrue
	self visitBranch: aJumpTrue comparing: true
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadConstant: aLoadConstant
	| register value |
	register := allocation
		at: aLoadConstant
		ifAbsent: [aLoadConstant isUsed ifTrue: [self halt] ifFalse: [^self]].
	value := aLoadConstant value.
	self assembleLoadConstant: value to: register
! !

!OptimizingCodeEmitter methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitLoadImplicit: instruction
	| frame |
	instruction name == #activationRecord ifTrue: [^assembler buildFrame].
	instruction name == #self ifTrue: [
		frame := instruction prev.
		^frame hasFrame ifTrue: [
			assembler
				reserveStackSlots: frame temporaries + 2;
				store: assembler regR in: assembler regFP index: 0;
				loadVwithPointer: method;
				store: assembler regV in: assembler regFP index: -1.
			self savesPreviousSelf ifTrue: [assembler push: assembler regS]]]
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitMessageSend: aMessageSend
	self assembleGenericMessageSend: aMessageSend.
	firstBlock activationRecord haveFrame
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitNullary: instruction
	| selector |
	selector := #assemble , (self selectorFor: instruction) , #':'.
	self perform: selector asSymbol with: instruction
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitPhi: phiInstruction
	
! !

!OptimizingCodeEmitter methodsFor:  'visiting' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitReturn: aReturnInstruction
	| source |
	source := allocation at: aReturnInstruction source.
	self assembleCopyIfNeeded: source to: assembler regR.
	self savesPreviousSelf
		ifTrue: [assembler pop: assembler regS; restoreCallerFrame]
		ifFalse: [
			assembler
				restoreCallerFrame;
				load: assembler regS from: assembler regFP atIndex: 0].
	assembler return
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitTernary: instruction
	| selector |
	selector := #assemble , (self selectorFor: instruction) , #':'.
	self perform: selector asSymbol with: instruction
! !

!OptimizingCodeEmitter methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
visitUnary: instruction
	| selector |
	selector := #assemble , (self selectorFor: instruction) , #':'.
	self perform: selector asSymbol with: instruction
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OptimizingCodeEmitter class' category: #OCompiler!
OptimizingCodeEmitter class
	instanceVariableNames: ''!

!OptimizingCodeEmitter class methodsFor:  'unclassified' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^self basicNew initialize
! !


OptimizingCodeEmitter initialize!

