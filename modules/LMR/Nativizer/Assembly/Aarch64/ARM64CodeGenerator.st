"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.

	ARM64 (AArch64) code generator. It implements the operations
	GenericAssembler expects from a CodeGenerator (add:to:, compare:with:,
	push:, load:fromMem:...) by assembling A64 instructions by mnemonic
	through ARM64InstructionSpec.
"
Class {
	#name : #ARM64CodeGenerator,
	#superclass : #CodeGenerator,
	#category : #Aarch64
}

{ #category : #initialization }
ARM64CodeGenerator >> platform: aNativizationPlatform [
	abi := aNativizationPlatform abi.
	wordSize := abi wordSize.
	memory := RelocatableBuffer new
]

{ #category : #emitting }
ARM64CodeGenerator >> emit: aWordInteger [
	memory nextULongPut: aWordInteger
]

{ #category : #emitting }
ARM64CodeGenerator >> assemble: mnemonic [
	self emit: (ARM64InstructionSpec encode: mnemonic with: #())
]

{ #category : #emitting }
ARM64CodeGenerator >> assemble: mnemonic with: op1 [
	self emit: (ARM64InstructionSpec encode: mnemonic with: {op1})
]

{ #category : #emitting }
ARM64CodeGenerator >> assemble: mnemonic with: op1 with: op2 [
	self emit: (ARM64InstructionSpec encode: mnemonic with: {op1. op2})
]

{ #category : #emitting }
ARM64CodeGenerator >> assemble: mnemonic with: op1 with: op2 with: op3 [
	self emit: (ARM64InstructionSpec encode: mnemonic with: {op1. op2. op3})
]

{ #category : #emitting }
ARM64CodeGenerator >> assemble: mnemonic with: op1 with: op2 with: op3 with: op4 [
	self emit: (ARM64InstructionSpec encode: mnemonic with: {op1. op2. op3. op4})
]

{ #category : #emitting }
ARM64CodeGenerator >> assemble: mnemonic with: registers withImm: imm [
	| operands word |
	operands := registers copyWith: imm.
	(ARM64InstructionSpec canEncode: mnemonic with: operands) ifFalse: [
		self moveImm: imm to: self regV.
		operands := registers copyWith: self regV].
	word := ARM64InstructionSpec encode: mnemonic with: operands.
	self emit: word
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> sub: src1 from: src2AndDst [
	| mnemonic |
	src1 isInteger ifTrue: [^self subImm: src1 from: src2AndDst].
	mnemonic := self settingFlags: 'sub' unlessSp: {src1. src2AndDst}.
	self assemble: mnemonic with: src2AndDst with: src2AndDst with: src1
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> add: source1 to: source2andDest [
	| mnemonic |
	source1 isInteger ifTrue: [^self addImm: source1 to: source2andDest].
	mnemonic := self settingFlags: 'add' unlessSp: {source1. source2andDest}.
	self assemble: mnemonic with: source2andDest with: source2andDest with: source1
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> addImm: imm to: dest [
	| mnemonic |
	imm < 0 ifTrue: [^self subImm: imm negated to: dest].
	mnemonic := self settingFlags: 'add' unlessSp: {dest}.
	self assemble: mnemonic with: {dest. dest} withImm: imm
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> subImm: imm to: dest [
	| mnemonic |
	imm < 0 ifTrue: [^self addImm: imm negated to: dest].
	mnemonic := self settingFlags: 'sub' unlessSp: {dest}.
	self assemble: mnemonic with: {dest. dest} withImm: imm
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> subImm: imm from: srcAndDst [
	^self subImm: imm to: srcAndDst
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> and: source1AndDest with: source2 [
	self assemble: 'and' with: source1AndDest with: source1AndDest with: source2
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> and: source1AndDest withImm: imm [
	self assemble: 'and' with: {source1AndDest. source1AndDest} withImm: imm
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> or: source1AndDest with: source2 [
	self assemble: 'orr' with: source1AndDest with: source1AndDest with: source2
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> or: source1AndDest withImm: imm [
	self assemble: 'orr' with: {source1AndDest. source1AndDest} withImm: imm
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> xor: source1AndDest with: source2 [
	self assemble: 'eor' with: source1AndDest with: source1AndDest with: source2
]

{ #category : #'operations - moves' }
ARM64CodeGenerator >> move: src to: dst [
	self assemble: 'mov' with: dst with: src
]

{ #category : #'operations - moves' }
ARM64CodeGenerator >> moveImm: imm to: reg [
	| value |
	value := imm < 0 ifTrue: [16r10000000000000000 + imm] ifFalse: [imm].
	self assemble: 'movz' with: reg with: (value bitAnd: 16rFFFF) with: 0.
	#(16 32 48) do: [:shift | | chunk |
		chunk := (value bitShift: shift negated) bitAnd: 16rFFFF.
		chunk = 0 ifFalse: [self assemble: 'movk' with: reg with: chunk with: shift]]
]

{ #category : #'register renaming' }
ARM64CodeGenerator >> renameByteRegisterIfNeeded: register preserving: preserved during: aBlock [
	aBlock value: register
]

{ #category : #'register renaming' }
ARM64CodeGenerator >> renameByteRegisterIfNeeded: register preserving: p1 preserving: p2 during: aBlock [
	aBlock value: register
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> testIntegerBit: reg [
	self assemble: 'tst' with: reg with: 1
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> test: reg withImm: imm [
	self assemble: 'tst' with: {reg} withImm: imm
]

{ #category : #alignment }
ARM64CodeGenerator >> nop [
	self assemble: 'nop'
]

{ #category : #alignment }
ARM64CodeGenerator >> nop: count [
	| n |
	n := count // 4.
	n timesRepeat: [self nop]
]

{ #category : #'push/pop' }
ARM64CodeGenerator >> push: reg [
	self assemble: 'str.pre' with: reg with: sp with: -16
]

{ #category : #'push/pop' }
ARM64CodeGenerator >> popIntoMem: dstMemRef [
	self
		pop: self regV;
		store: self regV intoMem: dstMemRef
]

{ #category : #'push/pop' }
ARM64CodeGenerator >> pushImm: imm [
	self
		moveImm: imm to: self regV;
		push: self regV
]

{ #category : #'push/pop' }
ARM64CodeGenerator >> pop: reg [
	self assemble: 'ldr.post' with: reg with: sp with: 16
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> compare: reg1 with: regOrImm [
	regOrImm isInteger
		ifTrue: [^self compare: reg1 withImm: regOrImm].
	self assemble: 'cmp' with: reg1 with: regOrImm
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> compare: reg withImm: imm [
	self assemble: 'cmp' with: {reg} withImm: imm
]

{ #category : #branching }
ARM64CodeGenerator >> breakpoint [
	self assemble: 'brk' with: 0
]

{ #category : #branching }
ARM64CodeGenerator >> return [
	self assemble: 'ret' with: x30
]

{ #category : #branching }
ARM64CodeGenerator >> return: anInteger [
	self
		assemble: 'add' with: sp with: sp with: anInteger;
		return
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> inc: reg [
	self addImm: 1 to: reg
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> dec: reg [
	self subImm: 1 to: reg
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> shiftRightArithmetic: srcAndDstReg byImm: imm [
	self assemble: 'sbfm' with: srcAndDstReg with: srcAndDstReg with: imm with: 63
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> shiftRight: srcAndDstReg byImm: imm [
	self shiftLogicalRight: srcAndDstReg byImm: imm
]

{ #category : #'operations - integers' }
ARM64CodeGenerator >> convertToNativeInteger: srcAndDstReg [
	self
		assemble: 'and' with: self regV with: srcAndDstReg with: 1;
		compare: self regV with: 1;
		shiftRightArithmetic: srcAndDstReg byImm: 1
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> shiftLeft: srcAndDstReg byImm: imm [
	imm = 1 ifTrue: [^self assemble: 'adds' with: srcAndDstReg with: srcAndDstReg with: srcAndDstReg].
	self
		assemble: 'ubfm'
		with: srcAndDstReg
		with: srcAndDstReg
		with: (64 - imm bitAnd: 63)
		with: 63 - imm
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> shiftLogicalRight: srcAndDstReg byImm: imm [
	self assemble: 'ubfm' with: srcAndDstReg with: srcAndDstReg with: imm with: 63
]

{ #category : #branching }
ARM64CodeGenerator >> jumpToReg: aReg [
	self assemble: 'br' with: aReg
]

{ #category : #branching }
ARM64CodeGenerator >> jumpToMem: srcMemRef [
	self
		load: self regV fromMem: srcMemRef;
		jumpToReg: self regV
]

{ #category : #branching }
ARM64CodeGenerator >> callIndirectReg: aReg [
	self assemble: 'blr' with: aReg
]

{ #category : #branching }
ARM64CodeGenerator >> callIndirect: srcMemRef [
	self
		load: self regV fromMem: srcMemRef;
		callIndirectReg: self regV
]

{ #category : #branching }
ARM64CodeGenerator >> jumpIndirect: srcMemRef [
	self jumpToMem: srcMemRef
]

{ #category : #'private - jumps' }
ARM64CodeGenerator >> jumpIf: condition to: label [
	| src |
	src := memory currentAddress.
	self assemble: 'b.cond' with: condition with: 0.
	memory fixups add: (ARM64BranchFixup kind: #bcond from: src to: label)
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpTo: label [
	| src |
	src := memory currentAddress.
	self assemble: 'b' with: 0.
	memory fixups add: (ARM64BranchFixup kind: #b from: src to: label)
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpTo: label [
	self jumpTo: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfCarryTo: label [
	self jumpIf: #cs to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfNotCarryTo: label [
	self jumpIf: #cc to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfEqualTo: label [
	self jumpIf: #eq to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfNotEqualTo: label [
	self jumpIf: #ne to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfZeroTo: label [
	self jumpIf: #eq to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfNotZeroTo: label [
	self jumpIf: #ne to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfSignTo: label [
	self jumpIf: #mi to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfCarryTo: label [
	self jumpIf: #cs to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfNotCarryTo: label [
	self jumpIf: #cc to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfEqualTo: label [
	self jumpIf: #eq to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfNotEqualTo: label [
	self jumpIf: #ne to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfZeroTo: label [
	self jumpIf: #eq to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfNotZeroTo: label [
	self jumpIf: #ne to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfSignTo: label [
	self jumpIf: #mi to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfNoSignTo: label [
	self jumpIf: #pl to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfGreaterSignedTo: label [
	self jumpIf: #gt to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfGreaterOrEqualSignedTo: label [
	self jumpIf: #ge to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfLessSignedTo: label [
	self jumpIf: #lt to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfLessOrEqualSignedTo: label [
	self jumpIf: #le to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfAboveTo: label [
	self jumpIf: #hi to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfAboveOrEqualTo: label [
	self jumpIf: #cs to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfBelowTo: label [
	self jumpIf: #cc to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfBelowOrEqualTo: label [
	self jumpIf: #ls to: label
]

{ #category : #'jumps - conditional' }
ARM64CodeGenerator >> jumpIfOverflowTo: label [
	self jumpIf: #vs to: label
]

{ #category : #'jumps - conditional' }
ARM64CodeGenerator >> jumpIfNoOverflowTo: label [
	self jumpIf: #vc to: label
]

{ #category : #'jumps - conditional' }
ARM64CodeGenerator >> shortJumpIfOverflowTo: label [
	self jumpIf: #vs to: label
]

{ #category : #'jumps - conditional' }
ARM64CodeGenerator >> shortJumpIfNoOverflowTo: label [
	self jumpIf: #vc to: label
]

{ #category : #accessing }
ARM64CodeGenerator >> addressSize [
	^8
]

{ #category : #memory }
ARM64CodeGenerator >> memRef [
	^ARM64MemoryOperand new
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> loadZeroExtendByte: dstReg from: baseReg atIndexImm: index [
	^self loadZeroExtendByte: dstReg from: baseReg atOffset: index - 1
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> loadZeroExtendByte: dstReg from: baseReg atIndexAt: idxReg [
	self
		assemble: 'add' with: self regV with: baseReg with: idxReg;
		assemble: 'ldrb' with: dstReg long with: self regV with: -1
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> loadZeroExtendByte: dstReg from: baseReg atOffset: offset [
	self load: 8 into: dstReg from: baseReg disp: offset
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> load: dstReg fromMem: srcMemRef [
	self
		load: srcMemRef length
		into: dstReg
		from: (self baseFor: srcMemRef)
		disp: srcMemRef displacement
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> lea: dstReg withMem: srcMemRef [
	srcMemRef index isNil
		ifTrue: [self move: srcMemRef base to: dstReg]
		ifFalse: [
			self emitEffectiveAddrToVOf: srcMemRef.
			self move: self regV to: dstReg].
	srcMemRef displacement = 0
		ifFalse: [self addImm: srcMemRef displacement to: dstReg]
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> loadLongMwithIPoffset: anInteger [
	self
		assemble: 'ldr' with: self regM long with: anInteger;
		assemble: 'adr' with: self regV;
		shiftLogicalRight: self regV byImm: 32;
		shiftLeft: self regV byImm: 32;
		or: self regM with: self regV
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> emitEffectiveAddrToVOf: memRef [
	| shift |
	shift := (#(1 2 4 8) indexOf: memRef scale) - 1.
	shift < 0 ifTrue: [^self error: 'ARM64 effective-address scale ' , memRef scale printString , ' NYI'].
	self assemble: 'add' with: self regV with: memRef base with: memRef index with: shift
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> store: valueReg in: baseReg indexAt: indexReg [
	self assemble: 'str' with: valueReg with: baseReg with: indexReg
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> storeByte: byteValueOrReg in: baseReg offset: offset [
	byteValueOrReg isInteger ifTrue: [
		self moveImm: byteValueOrReg to: self regV.
		^self storeByte: self regV in: baseReg offset: offset].
	self store: 8 from: byteValueOrReg into: baseReg disp: offset
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> store: srcReg intoMem: dstMemRef [
	self
		store: dstMemRef length
		from: srcReg
		into: (self baseFor: dstMemRef)
		disp: dstMemRef displacement
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> loadZeroExtendShortRwithRoffset: offset [
	self load: 16 into: self regR from: self regR disp: offset
]

{ #category : #'thread local' }
ARM64CodeGenerator >> load: dstReg withThreadVariableAt: srcReg [
	self moveImm: 0 to: dstReg
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> compare: reg withMem: srcMemRef [
	self
		load: self regV fromMem: srcMemRef;
		compare: reg with: self regV
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> baseFor: aMemRef [
	aMemRef index isNil ifTrue: [^aMemRef base].
	self emitEffectiveAddrToVOf: aMemRef.
	^self regV
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> load: bits into: aRegister from: baseReg disp: disp [
	self access: 'ldr' bits: bits reg: aRegister base: baseReg disp: disp
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> store: bits from: aRegister into: baseReg disp: disp [
	self access: 'str' bits: bits reg: aRegister base: baseReg disp: disp
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> access: mnemonic bits: bits reg: aRegister base: baseReg disp: disp [
	| suffix name reg |
	suffix := bits = 8 ifTrue: ['b'] ifFalse: [bits = 16 ifTrue: ['h'] ifFalse: ['']].
	name := mnemonic , suffix.
	reg := (aRegister isFloat or: [bits = 64])
		ifTrue: [aRegister]
		ifFalse: [aRegister withLength: 32].
	(ARM64InstructionSpec canEncode: name with: {reg. baseReg. disp})
		ifTrue: [^self assemble: name with: reg with: baseReg with: disp].
	self
		moveImm: disp to: x17;
		assemble: 'add' with: x17 with: baseReg with: x17;
		assemble: name with: reg with: x17 with: 0
]

{ #category : #private }
ARM64CodeGenerator >> settingFlags: mnemonic unlessSp: registers [
	^(registers anySatisfy: [:register | register isSP])
		ifTrue: [mnemonic]
		ifFalse: [mnemonic , 's']
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> leadingRzeroCount [
	self assemble: 'clz' with: self regR with: self regR
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> shiftLeft: srcAndDstReg by: countReg [
	self assemble: 'lslv' with: srcAndDstReg with: srcAndDstReg with: countReg
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> shiftRightArithmetic: srcAndDstReg by: countReg [
	self assemble: 'asrv' with: srcAndDstReg with: srcAndDstReg with: countReg
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> multiply: src1AndDstLoReg by: src2reg wideningTo: dstHiReg [
	self
		assemble: 'smulh' with: self regV with: src1AndDstLoReg with: src2reg;
		assemble: 'mul' with: src1AndDstLoReg with: src1AndDstLoReg with: src2reg;
		move: self regV to: dstHiReg;
		assemble: 'cmp' with: dstHiReg with: src1AndDstLoReg with: 63;
		assemble: 'ccmp' with: xzr with: xzr with: 2r0001 with: #eq
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> divide: srcAndDstReg extendingTo: extReg by: divisorReg [
	self
		assemble: 'sdiv' with: self regV with: srcAndDstReg with: divisorReg;
		assemble: 'msub' with: extReg with: self regV with: divisorReg with: srcAndDstReg;
		move: self regV to: srcAndDstReg
]
