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
	self emit: (16rCB000000
		bitOr: (src1 index bitShift: 16))
		+ (src2AndDst index bitShift: 5)
		+ src2AndDst index
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> subImm: imm from: src2AndDst [
	(imm >= 0 and: [imm <= 4095])
		ifTrue: [
			^self emit: (16rD1000000
				bitOr: (imm bitShift: 10))
				+ (src2AndDst index bitShift: 5)
				+ src2AndDst index].
	(imm >= 4096 and: [(imm bitAnd: 16rFFF) = 0 and: [imm <= 16773120]])
		ifTrue: [
			^self emit: (16rD1400000
				bitOr: ((imm bitShift: -12) bitShift: 10))
				+ (src2AndDst index bitShift: 5)
				+ src2AndDst index].
	self moveImm: imm to: (ARM64Register name: 'x16' index: 16 length: 64).
	self emit: (16rCB000000
		bitOr: (16 bitShift: 16))
		+ (src2AndDst index bitShift: 5)
		+ src2AndDst index
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> add: source1 to: source2andDest [
	source1 isInteger ifTrue: [^self addImm: source1 to: source2andDest].
	self emit: (16r8B000000
		bitOr: (source1 index bitShift: 16))
		+ (source2andDest index bitShift: 5)
		+ source2andDest index
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> addImm: imm to: dest [
	| scratch |
	imm < 0 ifTrue: [
		^self subImm: imm negated to: dest].
	(imm bitAnd: 16rFFFFF000) = 0 ifTrue: [
		^self emit: (16r91000000
			bitOr: (imm bitShift: 10))
			+ (dest index bitShift: 5)
			+ dest index].
	scratch := ARM64Register name: 'x16' index: 16 length: 64.
	self moveImm: imm to: scratch.
	self add: scratch to: dest
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> subImm: imm to: dest [
	(imm bitAnd: 16rFFFFF000) = 0
		ifFalse: [^self error: 'ARM64 subImm:to:: immediate ' , imm printString , ' too large'].
	self emit: (16rD1000000
		bitOr: (imm bitShift: 10))
		+ (dest index bitShift: 5)
		+ dest index
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> subImm: imm from: srcAndDst [
	^self subImm: imm to: srcAndDst
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> and: source1AndDest with: source2 [
	self emit: (16r8A000000
		bitOr: (source2 index bitShift: 16))
		+ (source1AndDest index bitShift: 5)
		+ source1AndDest index
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> and: source1AndDest withImm: imm [
	| scratch |
	scratch := ARM64Register name: 'x16' index: 16 length: 64.
	self moveImm: imm to: scratch.
	self and: source1AndDest with: scratch
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> or: source1AndDest with: source2 [
	self emit: (16rAA000000
		bitOr: (source2 index bitShift: 16))
		+ (source1AndDest index bitShift: 5)
		+ source1AndDest index
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> or: source1AndDest withImm: imm [
	| scratch |
	scratch := ARM64Register name: 'x16' index: 16 length: 64.
	self moveImm: imm to: scratch.
	self or: source1AndDest with: scratch
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> xor: source1AndDest with: source2 [
	self emit: (16rCA000000
		bitOr: (source2 index bitShift: 16))
		+ (source1AndDest index bitShift: 5)
		+ source1AndDest index
]

{ #category : #'operations - moves' }
ARM64CodeGenerator >> move: src to: dst [
	(src index = 31 or: [dst index = 31])
		ifTrue: [
			^self emit: (16r91000000
				bitOr: (src index bitShift: 5))
				+ dst index].
	self emit: (16rAA0003E0
		bitOr: (src index bitShift: 16))
		+ dst index
]

{ #category : #'operations - moves' }
ARM64CodeGenerator >> moveImm: imm to: reg [
	| value c0 c1 c2 c3 |
	value := imm < 0
		ifTrue: [(16r10000000000000000 + imm) bitAnd: 16rFFFFFFFFFFFFFFFF]
		ifFalse: [imm].
	c0 := value bitAnd: 16rFFFF.
	c1 := (value bitShift: -16) bitAnd: 16rFFFF.
	c2 := (value bitShift: -32) bitAnd: 16rFFFF.
	c3 := (value bitShift: -48) bitAnd: 16rFFFF.
	self emit: 16rD2800000 + (c0 bitShift: 5) + reg index.
	c1 != 0 ifTrue: [
		self emit: 16rF2A00000 + (c1 bitShift: 5) + reg index].
	c2 != 0 ifTrue: [
		self emit: 16rF2C00000 + (c2 bitShift: 5) + reg index].
	c3 != 0 ifTrue: [
		self emit: 16rF2E00000 + (c3 bitShift: 5) + reg index]
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
	self emit: (16rF240001F bitOr: (reg index bitShift: 5))
]

{ #category : #'operations - logical' }
ARM64CodeGenerator >> test: reg withImm: imm [
	imm = 1 ifFalse: [self error: 'TST imm only supports #1 for now'].
	self emit: (16rF240001F bitOr: (reg index bitShift: 5))
]

{ #category : #alignment }
ARM64CodeGenerator >> nop [
	self emit: 16rD503201F
]

{ #category : #alignment }
ARM64CodeGenerator >> nop: count [
	| n |
	n := count // 4.
	n timesRepeat: [self nop]
]

{ #category : #'push/pop' }
ARM64CodeGenerator >> push: reg [
	self emit: (16rF81F0FE0 bitOr: reg index)
]

{ #category : #'push/pop' }
ARM64CodeGenerator >> popIntoMem: dstMemRef [
	| scratch |
	scratch := ARM64Register name: 'x16' index: 16 length: 64.
	self pop: scratch.
	self store: scratch intoMem: dstMemRef
]

{ #category : #'push/pop' }
ARM64CodeGenerator >> pushImm: imm [
	| scratch |
	scratch := ARM64Register name: 'x16' index: 16 length: 64.
	self moveImm: imm to: scratch.
	self push: scratch
]

{ #category : #'push/pop' }
ARM64CodeGenerator >> pop: reg [
	self emit: (16rF84107E0 bitOr: reg index)
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> compare: reg1 with: regOrImm [
	regOrImm isInteger
		ifTrue: [^self compare: reg1 withImm: regOrImm].
	self emit: (16rEB00001F
		bitOr: (regOrImm index bitShift: 16))
		+ (reg1 index bitShift: 5)
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> compare: reg withImm: imm [
	(imm bitAnd: 16rFFFFF000) = 0
		ifFalse: [^self error: 'ARM64 compare:withImm:: immediate ' , imm printString , ' too large'].
	self emit: (16rF100001F
		bitOr: (imm bitShift: 10))
		+ (reg index bitShift: 5)
]

{ #category : #branching }
ARM64CodeGenerator >> breakpoint [
	self emit: 16rD4200000
]

{ #category : #branching }
ARM64CodeGenerator >> return [
	self emit: 16rD65F03C0
]

{ #category : #branching }
ARM64CodeGenerator >> return: anInteger [
	(anInteger bitAnd: 16rFFFFF000) = 0
		ifFalse: [^self error: 'ARM64 return:: imm too large'].
	self emit: (16r910003FF bitOr: (anInteger bitShift: 10)).
	self emit: 16rD65F03C0
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
	self emit: (16r9340FC00
		bitOr: (imm bitShift: 16))
		+ (srcAndDstReg index bitShift: 5)
		+ srcAndDstReg index
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> shiftRight: srcAndDstReg byImm: imm [
	self emit: (16rD340FC00
		bitOr: (imm bitShift: 16))
		+ (srcAndDstReg index bitShift: 5)
		+ srcAndDstReg index
]

{ #category : #'operations - integers' }
ARM64CodeGenerator >> convertToNativeInteger: srcAndDstReg [
	self emit: (16rF240001F bitOr: (srcAndDstReg index bitShift: 5)).
	self shiftRightArithmetic: srcAndDstReg byImm: 1
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> shiftLeft: srcAndDstReg byImm: imm [
	| immr imms |
	immr := 64 - imm bitAnd: 63.
	imms := 63 - imm.
	self emit: (16rD3400000
		bitOr: (immr bitShift: 16))
		+ (imms bitShift: 10)
		+ (srcAndDstReg index bitShift: 5)
		+ srcAndDstReg index
]

{ #category : #'operations - arithmetic' }
ARM64CodeGenerator >> shiftLogicalRight: srcAndDstReg byImm: imm [
	self emit: (16rD340FC00
		bitOr: (imm bitShift: 16))
		+ (srcAndDstReg index bitShift: 5)
		+ srcAndDstReg index
]

{ #category : #branching }
ARM64CodeGenerator >> jumpToReg: aReg [
	self emit: (16rD61F0000 bitOr: (aReg index bitShift: 5))
]

{ #category : #branching }
ARM64CodeGenerator >> jumpToMem: srcMemRef [
	| scratch |
	scratch := ARM64Register name: 'x16' index: 16 length: 64.
	self
		load: scratch fromMem: srcMemRef;
		jumpToReg: scratch
]

{ #category : #branching }
ARM64CodeGenerator >> callIndirectReg: aReg [
	self emit: (16rD63F0000 bitOr: (aReg index bitShift: 5))
]

{ #category : #branching }
ARM64CodeGenerator >> callIndirect: srcMemRef [
	| scratch |
	scratch := ARM64Register name: 'x16' index: 16 length: 64.
	self
		load: scratch fromMem: srcMemRef;
		callIndirectReg: scratch
]

{ #category : #branching }
ARM64CodeGenerator >> jumpIndirect: srcMemRef [
	| scratch |
	scratch := ARM64Register name: 'x16' index: 16 length: 64.
	self
		load: scratch fromMem: srcMemRef;
		jumpToReg: scratch
]

{ #category : #'private - jumps' }
ARM64CodeGenerator >> condJump: cond4 to: label [
	| src |
	src := memory currentAddress.
	self emit: (16r54000000 bitOr: cond4).
	memory fixups add: (ARM64BranchFixup kind: #bcond from: src to: label)
]

{ #category : #'private - jumps' }
ARM64CodeGenerator >> uncondJumpTo: label [
	| src |
	src := memory currentAddress.
	self emit: 16r14000000.
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
	self condJump: 16r1 to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfNotCarryTo: label [
	self condJump: 16r0 to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfEqualTo: label [
	self condJump: 16r0 to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfNotEqualTo: label [
	self condJump: 16r1 to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfZeroTo: label [
	self condJump: 16r0 to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfNotZeroTo: label [
	self condJump: 16r1 to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> shortJumpIfSignTo: label [
	self condJump: 16r4 to: label
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
	self condJump: 16r5 to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfGreaterSignedTo: label [
	self condJump: 16rC to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfGreaterOrEqualSignedTo: label [
	self condJump: 16rA to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfLessSignedTo: label [
	self condJump: 16rB to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfLessOrEqualSignedTo: label [
	self condJump: 16rD to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfAboveTo: label [
	self condJump: 16r8 to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfAboveOrEqualTo: label [
	self condJump: 16r2 to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfBelowTo: label [
	self condJump: 16r3 to: label
]

{ #category : #jumps }
ARM64CodeGenerator >> jumpIfBelowOrEqualTo: label [
	self condJump: 16r9 to: label
]

{ #category : #'jumps - conditional' }
ARM64CodeGenerator >> jumpIfOverflowTo: label [
	self condJump: 16r6 to: label
]

{ #category : #'jumps - conditional' }
ARM64CodeGenerator >> jumpIfNoOverflowTo: label [
	self condJump: 16r7 to: label
]

{ #category : #'jumps - conditional' }
ARM64CodeGenerator >> shortJumpIfOverflowTo: label [
	self condJump: 16r6 to: label
]

{ #category : #'jumps - conditional' }
ARM64CodeGenerator >> shortJumpIfNoOverflowTo: label [
	self condJump: 16r7 to: label
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
	| scratch |
	scratch := ARM64Register name: 'x16' index: 16 length: 64.
	self emit: (16r8B000000
		bitOr: (idxReg index bitShift: 16))
		+ (baseReg index bitShift: 5)
		+ 16.
	^self emit: (16r38400000
		bitOr: ((-1 bitAnd: 16r1FF) bitShift: 12))
		+ (16 bitShift: 5)
		+ dstReg index
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> loadZeroExtendByte: dstReg from: baseReg atOffset: offset [
	(offset >= 0 and: [offset <= 4095])
		ifTrue: [
			^self emit: (16r39400000
				bitOr: (offset bitShift: 10))
				+ (baseReg index bitShift: 5)
				+ dstReg index].
	(offset >= -256 and: [offset <= 255])
		ifTrue: [
			^self emit: (16r38400000
				bitOr: ((offset bitAnd: 16r1FF) bitShift: 12))
				+ (baseReg index bitShift: 5)
				+ dstReg index].
	^self error: 'ARM64 LDRB out-of-range offset ' , offset printString
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> load: dstReg fromMem: srcMemRef [
	srcMemRef index isNil
		ifTrue: [^self ldrFromBase: srcMemRef base index disp: srcMemRef displacement toReg: dstReg].
	self emitEffectiveAddrToX16Of: srcMemRef.
	^self ldrFromBase: 16 disp: srcMemRef displacement toReg: dstReg
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> lea: dstReg withMem: srcMemRef [
	srcMemRef index isNil
		ifTrue: [self move: srcMemRef base to: dstReg]
		ifFalse: [
			self emitEffectiveAddrToX16Of: srcMemRef.
			self move: (ARM64Register name: 'x16' index: 16 length: 64) to: dstReg].
	srcMemRef displacement = 0
		ifFalse: [self addImm: srcMemRef displacement to: dstReg]
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> loadLongMwithIPoffset: anInteger [
	| imm19 scratch |
	(anInteger bitAnd: 3) = 0
		ifFalse: [^self error: 'ARM64 LDR literal needs a word-aligned offset'].
	imm19 := anInteger // 4.
	(imm19 >= -262144 and: [imm19 <= 262143])
		ifFalse: [^self error: 'ARM64 LDR literal offset out of range'].
	self emit: (16r18000000
		bitOr: ((imm19 bitAnd: 16r7FFFF) bitShift: 5))
		+ self regM index.
	scratch := ARM64Register name: 'x16' index: 16 length: 64.
	self emit: 16r10000000 + scratch index.
	self shiftLogicalRight: scratch byImm: 32.
	self shiftLeft: scratch byImm: 32.
	self or: self regM with: scratch
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> ldrFromBase: baseIdx disp: disp toReg: dstReg [
	(disp >= 0 and: [(disp bitAnd: 7) = 0 and: [disp <= (4095 * 8)]])
		ifTrue: [
			^self emit: (16rF9400000
				bitOr: ((disp bitShift: -3) bitShift: 10))
				+ (baseIdx bitShift: 5)
				+ dstReg index].
	(disp >= -256 and: [disp <= 255])
		ifTrue: [
			^self emit: (16rF8400000
				bitOr: ((disp bitAnd: 16r1FF) bitShift: 12))
				+ (baseIdx bitShift: 5)
				+ dstReg index].
	^self error: 'ARM64 LDR/LDUR out-of-range displacement ' , disp printString
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> emitEffectiveAddrToX16Of: memRef [
	| scale baseIdx idxIdx shiftAmt |
	scale := memRef scale.
	baseIdx := memRef base index.
	idxIdx := memRef index index.
	scale = 8 ifTrue: [shiftAmt := 3]
		ifFalse: [scale = 1
			ifTrue: [shiftAmt := 0]
			ifFalse: [^self error: 'ARM64 effective-address scale ', scale printString, ' NYI']].
	^self emit: (16r8B000000
		bitOr: (idxIdx bitShift: 16))
		+ (shiftAmt bitShift: 10)
		+ (baseIdx bitShift: 5)
		+ 16
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> store: valueReg in: baseReg indexAt: indexReg [
	self emit: (16rF8207800
		bitOr: (indexReg index bitShift: 16))
		+ (baseReg index bitShift: 5)
		+ valueReg index
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> storeByte: byteValueOrReg in: baseReg offset: offset [
	| byteReg |
	byteValueOrReg isInteger ifTrue: [
		byteReg := ARM64Register name: 'x16' index: 16 length: 64.
		self moveImm: byteValueOrReg to: byteReg.
		^self storeByte: byteReg in: baseReg offset: offset].
	byteReg := byteValueOrReg.
	(offset >= 0 and: [offset <= 4095])
		ifTrue: [
			^self emit: (16r39000000
				bitOr: (offset bitShift: 10))
				+ (baseReg index bitShift: 5)
				+ byteReg index].
	(offset >= -256 and: [offset <= 255])
		ifTrue: [
			^self emit: (16r38000000
				bitOr: ((offset bitAnd: 16r1FF) bitShift: 12))
				+ (baseReg index bitShift: 5)
				+ byteReg index].
	^self error: 'ARM64 STRB out-of-range offset ' , offset printString
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> store: srcReg intoMem: dstMemRef [
	dstMemRef index isNil
		ifTrue: [^self strFromReg: srcReg toBase: dstMemRef base index disp: dstMemRef displacement].
	self emitEffectiveAddrToX16Of: dstMemRef.
	^self strFromReg: srcReg toBase: 16 disp: dstMemRef displacement
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> strFromReg: srcReg toBase: baseIdx disp: disp [
	(disp >= 0 and: [(disp bitAnd: 7) = 0 and: [disp <= (4095 * 8)]])
		ifTrue: [
			^self emit: (16rF9000000
				bitOr: ((disp bitShift: -3) bitShift: 10))
				+ (baseIdx bitShift: 5)
				+ srcReg index].
	(disp >= -256 and: [disp <= 255])
		ifTrue: [
			^self emit: (16rF8000000
				bitOr: ((disp bitAnd: 16r1FF) bitShift: 12))
				+ (baseIdx bitShift: 5)
				+ srcReg index].
	^self error: 'ARM64 STR/STUR out-of-range displacement ' , disp printString
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> loadZeroExtendShortRwithRoffset: offset [
	| r |
	r := self regR.
	(offset >= 0 and: [(offset bitAnd: 1) = 0 and: [offset <= (4095 * 2)]])
		ifTrue: [
			^self emit: (16r79400000
				bitOr: ((offset bitShift: -1) bitShift: 10))
				+ (r index bitShift: 5)
				+ r index].
	(offset >= -256 and: [offset <= 255])
		ifTrue: [
			^self emit: (16r78400000
				bitOr: ((offset bitAnd: 16r1FF) bitShift: 12))
				+ (r index bitShift: 5)
				+ r index].
	^self error: 'ARM64 loadZeroExtendShortRwithRoffset:: bad offset ' , offset printString
]

{ #category : #'thread local' }
ARM64CodeGenerator >> load: dstReg withThreadVariableAt: srcReg [
	self emit: 16rD2800000 + dstReg index
]

{ #category : #'memory - load / store' }
ARM64CodeGenerator >> compare: reg withMem: srcMemRef [
	| scratch |
	scratch := ARM64Register name: 'x16' index: 16 length: 64.
	self
		load: scratch fromMem: srcMemRef;
		compare: reg with: scratch
]
