"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.

	ARM64 (AArch64) code generator. Emits 32-bit fixed-width instructions
	directly into the codegen's memory buffer. Methods follow the same
	signatures GenericAssembler expects from CodeGenerator (e.g. add:to:,
	compare:with:, push:, mov:to:, load:fromMem:, etc.) so the
	architecture-agnostic JIT logic in GenericAssembler / OptimizingCodeEmitter
	composes transparently.

	NOTE: this implementation is intentionally minimal — only methods reached
	during the LMR bootstrap are present. Calls into not-yet-implemented
	opcodes fail with a clear error so we can spot and fix them one by one
	rather than silently emitting wrong bytes.
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
	memory nextBytePut: (aWordInteger bitAnd: 16rFF).
	memory nextBytePut: ((aWordInteger bitShift: -8) bitAnd: 16rFF).
	memory nextBytePut: ((aWordInteger bitShift: -16) bitAnd: 16rFF).
	memory nextBytePut: ((aWordInteger bitShift: -24) bitAnd: 16rFF)
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

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regA [
	^abi regA
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regE [
	^abi regE
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regFP [
	^abi regFP
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regFalse [
	^abi regFalse
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regG [
	^abi regG
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regM [
	^abi regM
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regNil [
	^abi regNil
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regR [
	^abi regR
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regS [
	^abi regS
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regSP [
	^abi regSP
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regT [
	^abi regT
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regTrue [
	^abi regTrue
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regV [
	^abi regV
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regX0 [
	^abi regX0
]

{ #category : #'registers - IR' }
ARM64CodeGenerator >> regX1 [
	^abi regX1
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> sub: src1 from: src2AndDst [
	src1 isInteger ifTrue: [^self subImm: src1 from: src2AndDst].
	self assemble: 'sub' with: src2AndDst with: src2AndDst with: src1
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> add: source1 to: source2andDest [
	source1 isInteger ifTrue: [^self addImm: source1 to: source2andDest].
	self assemble: 'add' with: source2andDest with: source2andDest with: source1
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> addImm: imm to: dest [
	imm < 0 ifTrue: [^self subImm: imm negated to: dest].
	imm < 4096 ifTrue: [^self assemble: 'add' with: dest with: dest with: imm].
	self moveImm: imm to: self regV.
	self add: self regV to: dest
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> subImm: imm to: dest [
	(imm between: 0 and: 4095)
		ifFalse: [^self error: 'ARM64 subImm:to:: immediate ' , imm printString , ' too large'].
	self assemble: 'sub' with: dest with: dest with: imm
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
	self moveImm: imm to: self regV.
	self and: source1AndDest with: self regV
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> or: source1AndDest with: source2 [
	self assemble: 'orr' with: source1AndDest with: source1AndDest with: source2
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> or: source1AndDest withImm: imm [
	self moveImm: imm to: self regV.
	self or: source1AndDest with: self regV
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
	imm = 1 ifFalse: [self error: 'TST imm only supports #1 for now'].
	self assemble: 'tst' with: reg with: imm
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
	(imm between: 0 and: 4095)
		ifFalse: [^self error: 'ARM64 compare:withImm:: immediate ' , imm printString , ' too large'].
	self assemble: 'cmp' with: reg with: imm
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
		assemble: 'tst' with: srcAndDstReg with: 1;
		shiftRightArithmetic: srcAndDstReg byImm: 1
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> shiftLeft: srcAndDstReg byImm: imm [
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
ARM64CodeGenerator >> condJump: condition to: label [
	| src |
	src := memory currentAddress.
	self assemble: 'b.cond' with: condition with: 0.
	memory fixups add: (ARM64BranchFixup kind: #bcond from: src to: label)
]

{ #category : #'private - jumps' }
ARM64CodeGenerator >> uncondJumpTo: label [
	| src |
	src := memory currentAddress.
	self assemble: 'b' with: 0.
	memory fixups add: (ARM64BranchFixup kind: #b from: src to: label)
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpTo: label [
	self uncondJumpTo: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpTo: label [
	self uncondJumpTo: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfCarryTo: label [
	self condJump: #ne to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfNotCarryTo: label [
	self condJump: #eq to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfEqualTo: label [
	self condJump: #eq to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfNotEqualTo: label [
	self condJump: #ne to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfZeroTo: label [
	self condJump: #eq to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfNotZeroTo: label [
	self condJump: #ne to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfSignTo: label [
	self condJump: #mi to: label
]


{ #category : #jumps }
ARM64CodeGenerator >> jumpIfCarryTo: label [
	self shortJumpIfCarryTo: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfNotCarryTo: label [
	self shortJumpIfNotCarryTo: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfEqualTo: label [
	self shortJumpIfEqualTo: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfNotEqualTo: label [
	self shortJumpIfNotEqualTo: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfZeroTo: label [
	self shortJumpIfZeroTo: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfNotZeroTo: label [
	self shortJumpIfNotZeroTo: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfSignTo: label [
	self shortJumpIfSignTo: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfNoSignTo: label [
	self condJump: #pl to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfGreaterSignedTo: label [
	self condJump: #gt to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfGreaterOrEqualSignedTo: label [
	self condJump: #ge to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfLessSignedTo: label [
	self condJump: #lt to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfLessOrEqualSignedTo: label [
	self condJump: #le to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfAboveTo: label [
	self condJump: #hi to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfAboveOrEqualTo: label [
	self condJump: #cs to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfBelowTo: label [
	self condJump: #cc to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfBelowOrEqualTo: label [
	self condJump: #ls to: label
]

{ #category : #'jumps - conditional' }
ARM64CodeGenerator >> jumpIfOverflowTo: label [
	self condJump: #vs to: label
]

{ #category : #'jumps - conditional' }
ARM64CodeGenerator >> jumpIfNoOverflowTo: label [
	self condJump: #vc to: label
]

{ #category : #'jumps - conditional' }
ARM64CodeGenerator >> shortJumpIfOverflowTo: label [
	self condJump: #vs to: label
]

{ #category : #'jumps - conditional' }
ARM64CodeGenerator >> shortJumpIfNoOverflowTo: label [
	self condJump: #vc to: label
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
		assemble: 'ldurb' with: dstReg long with: self regV with: -1
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> loadZeroExtendByte: dstReg from: baseReg atOffset: offset [
	self load: 8 into: dstReg from: baseReg disp: offset
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> load: dstReg fromMem: srcMemRef [
	self
		load: 64
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
		store: 64
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
	self access: 'ldr' unscaled: 'ldur' bits: bits reg: aRegister base: baseReg disp: disp
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> store: bits from: aRegister into: baseReg disp: disp [
	self access: 'str' unscaled: 'stur' bits: bits reg: aRegister base: baseReg disp: disp
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> access: scaled unscaled: unscaled bits: bits reg: aRegister base: baseReg disp: disp [
	| bytes suffix reg |
	bytes := bits // 8.
	suffix := bits = 8 ifTrue: ['b'] ifFalse: [bits = 16 ifTrue: ['h'] ifFalse: ['']].
	reg := (aRegister isFloat or: [bits = 64])
		ifTrue: [aRegister]
		ifFalse: [aRegister withLength: 32].
	(disp >= 0 and: [disp \\ bytes = 0 and: [disp // bytes < 4096]])
		ifTrue: [^self assemble: scaled , suffix with: reg with: baseReg with: disp].
	(disp between: -256 and: 255)
		ifTrue: [^self assemble: unscaled , suffix with: reg with: baseReg with: disp].
	self
		moveImm: disp to: x17;
		assemble: 'add' with: x17 with: baseReg with: x17;
		assemble: scaled , suffix with: reg with: x17 with: 0
]
