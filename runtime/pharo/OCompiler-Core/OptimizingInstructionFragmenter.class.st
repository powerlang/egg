"
Copyright (c) 2020-2023 Quorum Software.
	See (MIT) license in root directory.
"
Class {
	#name : 'OptimizingInstructionFragmenter',
	#superclass : 'Object',
	#instVars : [
		'messages',
		'firstBlock'
	],
	#category : 'OCompiler-Core-Main',
	#package : 'OCompiler-Core-Main'
}

{ #category : 'accessing' }
OptimizingInstructionFragmenter >> activationRecord [
	^firstBlock activationRecord
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> doFragment [
	firstBlock
		reversePostOrderDo: [:block | self fragmentInstructionsOf: block]
]

{ #category : 'accessing' }
OptimizingInstructionFragmenter >> firstBlock: aBasicBlock [
	firstBlock := aBasicBlock
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentBinaryCommutative: instruction [
	| left right |
	left := instruction receiver.
	right := instruction arguments first.
	right isConstant
		ifTrue: [^self replace: instruction withBinary: left withConstant: right].
	left isConstant
		ifTrue: [^self replace: instruction withBinary: right withConstant: left].
	self replace: instruction withVariable: left with: right
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentBinaryCompare: instruction [
	| left right new |
	left := instruction receiver.
	right := instruction arguments first.
	right isConstant
		ifTrue: [^self replace: instruction withBinary: left withConstant: right].
	left isConstant ifTrue: [
		new := self replace: instruction withBinary: right withConstant: left.
		^new invertOperation].
	self replace: instruction withVariable: left with: right
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentBinaryNonCommutative: instruction [
	| left right |
	left := instruction receiver.
	right := instruction arguments first.
	right isConstant
		ifTrue: [^self replace: instruction withBinary: left withConstant: right].
	self replace: instruction withVariable: left with: right
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentBitsAt: instruction [
	| receiver constant stretch and shift |
	receiver := instruction receiver.
	constant := instruction arguments first.
	self _ASSERT: constant isConstant.
	stretch := constant value.
	and := OBinaryConstantOperation
		left: receiver
		right: stretch mask
		name: #bitAnd:.
	shift := OBinaryConstantOperation
		left: and
		right: stretch shift
		name: #bitShift:.
	instruction beforeInsert: and; dissolveReplacingWith: shift
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentCallSite: instruction [
	| callsite |
	callsite := OLoadOperation base: self activationRecord slotAtImm: 2.
	instruction dissolveReplacingWith: callsite
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentGenericMessage: instruction [
	| arguments new |
	arguments := instruction arguments.
	new := arguments
		collect: [:argument | argument insertPushBefore: instruction].
	instruction arguments: new.
	arguments
		do: [:argument | argument removeUseBy: instruction; dissolveIfUnused].
	firstBlock activationRecord haveFrame
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentInstructionsFrom: aBasicBlock [
	self firstBlock: aBasicBlock.
	aBasicBlock
		reversePostOrderDo: [:block | self fragmentInstructionsOf: block]
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentInstructionsOf: block [
	block firstInstruction acceptVisitor: self
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentLoadByte: instruction [
	| base index new |
	base := instruction receiver.
	index := instruction arguments first.
	new := index isConstant
		ifTrue: [OLoadOperation base: base byteAtImm: index value]
		ifFalse: [OLoadOperation base: base byteAt: index].
	instruction dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentLoadFlags: instruction [
	| base new |
	base := instruction receiver.
	new := OLoadOperation base: base byteAtImm: _Flags + 1.
	instruction dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentLoadLargeSize: instruction [
	| base new |
	base := instruction receiver.
	new := OLoadOperation base: base uLongAtImm: _ExtendedSize.
	instruction dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentLoadLongSlot: instruction [
	| base index new |
	base := instruction receiver.
	index := instruction arguments first.
	new := index isConstant
		ifTrue: [OLoadOperation base: base longSlotAtImm: index value]
		ifFalse: [OLoadOperation base: base longSlotAt: index].
	instruction dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentLoadSlot: instruction [
	| base index new |
	base := instruction receiver.
	index := instruction arguments first.
	new := index isConstant
		ifTrue: [OLoadOperation base: base slotAtImm: index value]
		ifFalse: [OLoadOperation base: base slotAt: index].
	instruction dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentLoadSmallSize: instruction [
	| base new |
	base := instruction receiver.
	new := OLoadOperation base: base byteAtImm: _SmallSize + 1.
	instruction dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentLoadULong: instruction [
	| base index new |
	base := instruction receiver.
	index := instruction arguments first.
	new := index isConstant
		ifTrue: [OLoadOperation base: base uLongAtImm: index value]
		ifFalse: [OLoadOperation base: base slotAt: index].
	instruction dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentPatchIndirectCallSiteTo: instruction [
	| nativeCode callsite patch |
	nativeCode := instruction arguments first.
	callsite := OLoadOperation base: self activationRecord slotAtImm: 2.
	patch := OStoreOperation base: callsite slotAtImm: 0 put: nativeCode.
	instruction dissolveReplacingWith: patch.
	patch beforeInsert: callsite
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentStoreByte: instruction [
	| base index new value |
	base := instruction receiver.
	index := instruction arguments first.
	value := instruction arguments second.
	new := index isConstant
		ifTrue: [OStoreOperation base: base byteAtImm: index value put: value]
		ifFalse: [OStoreOperation base: base byteAt: index put: value].
	instruction replaceAllUsesWith: value; dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentStoreFlags: instruction [
	| base value new |
	base := instruction receiver.
	value := instruction arguments first.
	new := OStoreOperation base: base byteAtImm: _Flags + 1 put: value.
	instruction replaceAllUsesWith: value; dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentStoreLargeSize: instruction [
	| base value new |
	base := instruction receiver.
	value := instruction arguments first.
	new := OStoreOperation base: base uLongAtImm: _ExtendedSize put: value.
	instruction replaceAllUsesWith: value; dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentStoreLongSlot: instruction [
	| base index new value |
	base := instruction receiver.
	index := instruction arguments first.
	value := instruction arguments second.
	new := index isConstant
		ifTrue: [OStoreOperation base: base longSlotAtImm: index value put: value]
		ifFalse: [OStoreOperation base: base longSlotAt: index put: value].
	instruction replaceAllUsesWith: value; dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentStoreSlot: instruction [
	| base index new value |
	base := instruction receiver.
	index := instruction arguments first.
	value := instruction arguments second.
	new := index isConstant
		ifTrue: [OStoreOperation base: base slotAtImm: index value put: value]
		ifFalse: [OStoreOperation base: base slotAt: index put: value].
	instruction replaceAllUsesWith: value; dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentStoreSmallSize: instruction [
	| base value new |
	base := instruction receiver.
	value := instruction arguments first.
	new := OStoreOperation base: base byteAtImm: _SmallSize + 1 put: value.
	instruction replaceAllUsesWith: value; dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentStoreULong: instruction [
	| base index new value |
	base := instruction receiver.
	index := instruction arguments first.
	value := instruction arguments second.
	new := index isConstant
		ifTrue: [OStoreOperation base: base uLongAtImm: index value put: value]
		ifFalse: [OStoreOperation base: base uLongAt: index put: value].
	instruction replaceAllUsesWith: value; dissolveReplacingWith: new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentTransferControlTo: instruction [
	| receiver machine |
	receiver := instruction receiver.
	machine := instruction arguments first.
	self replace: instruction withVariable: receiver with: machine
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> fragmentUnary: instruction [
	| receiver new |
	receiver := instruction receiver.
	"	receiver isConstant ifTrue: [self halt]."
	new := OUnaryOperation new receiver: receiver; name: instruction selector.
	instruction dissolveReplacingWith: new
]

{ #category : 'initialization' }
OptimizingInstructionFragmenter >> initialize [
	self initializeMessages
]

{ #category : 'initialization' }
OptimizingInstructionFragmenter >> initializeMessages [
	messages := Dictionary new
		at: #'+' put: #BinaryCommutative:;
		at: #'-' put: #BinaryNonCommutative:;
		at: #'*' put: #BinaryCommutative:;
		at: #'//' put: #BinaryNonCommutative:;
		at: #'<' put: #BinaryCompare:;
		at: #'<=' put: #BinaryCompare:;
		at: #'=' put: #BinaryCompare:;
		at: #'==' put: #BinaryCompare:;
		at: #'~=' put: #BinaryCompare:;
		at: #'!=' put: #BinaryCompare:;
		at: #'>=' put: #BinaryCompare:;
		at: #'>' put: #BinaryCompare:;
		at: #'&' put: #BinaryCommutative:;
		at: #_asNative put: #Unary:;
		at: #_asObject put: #Unary:;
		at: #_asPointer put: #Unary:;
		at: #_asSmallInteger put: #Unary:;
		at: #bitAnd: put: #BinaryCommutative:;
		at: #bitOr: put: #BinaryCommutative:;
		at: #bitShift: put: #BinaryNonCommutative:;
		at: #bitsAt: put: #BitsAt:;
		at: #_byteAt: put: #LoadByte:;
		at: #_basicAt: put: #LoadSlot:;
		at: #_longSlotAt: put: #LoadLongSlot:;
		at: #_byteAt:put: put: #StoreByte:;
		at: #_basicAt:put: put: #StoreSlot:;
		at: #_longSlotAt:put: put: #StoreLongSlot:;
		at: #_objectAtOffset:put: put: #StoreSlotAtOffset:;
		at: #_basicFlags put: #LoadFlags:;
		at: #_basicFlags: put: #StoreFlags:;
		at: #_smallSize put: #LoadSmallSize:;
		at: #_smallSize: put: #StoreSmallSize:;
		at: #_largeSize put: #LoadLargeSize:;
		at: #_largeSize: put: #StoreLargeSize:;
		at: #_isSmallInteger put: #Unary:;
		at: #_transferControlTo: put: #TransferControlTo:;
		at: #_callSite put: #CallSite:;
		at: #_patchIndirectCallSiteTo:
		put: #PatchIndirectCallSiteTo:;
		at: #not put: #Not:;
		yourself
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> insertCopyResultAfter: anInstruction [
	| copy |
	copy := OUnaryOperation receiver: anInstruction name: #copyResult.
	anInstruction afterInsert: copy; replaceAllUsesWith: copy
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> replace: instruction withBinary: left withConstant: right [
	| constant new |
	constant := right value.
	new := OBinaryConstantOperation
		left: left
		right: constant
		name: instruction selector.
	instruction dissolveReplacingWith: new.
	^new
]

{ #category : 'private' }
OptimizingInstructionFragmenter >> replace: instruction withVariable: left with: right [
	| new |
	new := OBinaryVariableOperation
		left: left
		right: right
		name: instruction selector.
	instruction dissolveReplacingWith: new.
	^new
]

{ #category : 'accessing' }
OptimizingInstructionFragmenter >> selectorFor: name [
	^(#fragment , (messages at: name ifAbsent: [#GenericMessage:])) asSymbol
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitBinaryWithConstant: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitBinaryWithVariable: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitJump: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitJumpFalse: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitJumpTrue: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitLoad: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitLoadConstant: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitLoadImplicit: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitMessageSend: instruction [
	| selector |
	selector := self selectorFor: instruction selector.
	self perform: selector with: instruction
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitPhi: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitReturn: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitStore: instruction [
	
]

{ #category : 'visitor protocol' }
OptimizingInstructionFragmenter >> visitUnary: instruction [
	
]
