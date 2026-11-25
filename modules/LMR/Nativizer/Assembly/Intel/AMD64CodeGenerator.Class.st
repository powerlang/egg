'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #AMD64CodeGenerator category: #'Powerlang-Core-Assembler-Intel'!
CodeGenerator subclass: #AMD64CodeGenerator
	instanceVariableNames: 'instruction operands1 operands2 operands3 pointer immediate encoder'
	classVariableNames: ''
	poolDictionaries: 'Registers'
	category: 'Powerlang-Core-Assembler-Intel'!
!AMD64CodeGenerator commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!AMD64CodeGenerator methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
add: src2 to: src1AndDst
	self assemble: 'add' with: src1AndDst with: src2

! !

!AMD64CodeGenerator methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addDouble: source1 to: source2andDest
	self 
		assemble: 'addsd'
		with: source2andDest
		with: source1
! !

!AMD64CodeGenerator methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addImm: imm to: src2AndDst
	self assemble: 'add' with: src2AndDst withImm: imm
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
and: src1AndDst with: source2
	self assemble: 'and' with: src1AndDst with: source2

! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
and: src1AndDst withImm: imm

	(imm between: -128 and: -1) ifTrue: [ 
		"When `imm` is a small negative, we can safely
		 and bits only in lower part of the 64 bit register
		 since higher bits of immediate are all ones anyway.
		 This helps to generate shorter code on x86."
		self assemble: 'and' with: src1AndDst byte withImm: imm
	] ifFalse: [
		self assemble: 'and' with: src1AndDst withImm: imm
	].

! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemble
	encoder reset; writeEncodingOn: memory
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemble: mnemonic
	instruction mnemonic: mnemonic; operands: #().
	self assemble
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemble: mnemonic with: op
	| op1 |
	op1 := op isInteger ifTrue: [immediate value: op] ifFalse: [op].
	operands1 at: 1 put: op1.
	instruction mnemonic: mnemonic; operands: operands1.
	self assemble
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemble: mnemonic with: op1 with: op2
	| op |
	op := op2 isInteger ifTrue: [immediate value: op2] ifFalse: [op2].
	operands2
		at: 1 put: op1;
		at: 2 put: op.
	instruction mnemonic: mnemonic; operands: operands2.
	self assemble
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemble: mnemonic with: op1 with: op2 with: op3
	| op |
	op := op3 isInteger ifTrue: [immediate value: op3] ifFalse: [op3].
	operands3
		at: 1 put: op1;
		at: 2 put: op2;
		at: 3 put: op.
	instruction mnemonic: mnemonic; operands: operands3.
	self assemble
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemble: mnemonic with: op1 withImm64: op2
	| v |
	v := self regV.
	self
		assemble: 'mov' with: v with: op2;
		assemble: mnemonic with: op1 with: v
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemble: mnemonic with: op1 withImm: imm
	immediate value: imm.
	(immediate length <= 32 or: [mnemonic = 'mov' and: [op1 class == Register]])
		ifTrue: [self assemble: mnemonic with: op1 with: immediate]
		ifFalse: [self assemble: mnemonic with: op1 withImm64: immediate]
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemble: mnemonic withImm64: op1
	| v |
	v := self regV.
	self
		assemble: 'mov' with: v with: op1;
		assemble: mnemonic with: v
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemble: mnemonic withImm: imm
	immediate value: imm.
	immediate length <= 32
		ifTrue: [self assemble: mnemonic with: immediate]
		ifFalse: [self assemble: mnemonic withImm64: immediate]
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemble: mnemonic withReg: reg index: index
	pointer
		reset;
		length: self addressLength;
		base: reg;
		displacement: index - 1 * wordSize.
	self assemble: mnemonic with: pointer
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assemble: mnemonic withReg: dst withReg: src index: index
	pointer
		reset;
		length: self addressLength;
		base: src;
		displacement: index - 1 * wordSize.
	self assemble: mnemonic with: dst with: pointer
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleByte: byte
	memory nextBytePut: byte
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBytes: aByteArray
	memory nextBytesPut: aByteArray
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBytes: value count: count
	self ASSERT: value isInteger.
	self ASSERT:(count == 4 or:[ count == 8 ]).

	count == 4 ifTrue: [
		memory nextLongPut: value
	] ifFalse: [ 
		memory nextLargePut: value
	].

! !

!AMD64CodeGenerator methodsFor:  'debugging' stamp: 'KenD 28/Jun/2026 13:27:40'!
breakpoint
	self assemble: 'int' with: 3
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
call: srcReg
	self assemble: 'call' with: srcReg
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
callIndirect: aMemRef
	self assemble: 'call' with: aMemRef 
! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearFPUFlags
	self assemble: 'fnclex'
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearHigh32: srcAndDstReg
	self assemble: 'mov' with: srcAndDstReg e with: srcAndDstReg e
! !

!AMD64CodeGenerator methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
compare: reg1 with: reg2
	self assemble: 'cmp' with: reg1 with: reg2
! !

!AMD64CodeGenerator methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
compare: reg1 withImm: imm
	#imm8.
	#imm32.
	self assemble: 'cmp' with: reg1 withImm: imm
! !

!AMD64CodeGenerator methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
compare: reg1 withMem: aMemRef
	self assemble: 'cmp' with: reg1 with: aMemRef
! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareEqualDoubleX0withAindirect
	pointer
		reset;
		length: 64;
		base: self regA.
	self 
		assemble: 'cmpsd'
		with: self regX0
		with: pointer
		with: 0
! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareLessThanDoubleX0withAindirect
	pointer
		reset;
		length: 64;
		base: self regA.
	self
		assemble: 'cmpsd'
		with: self regX0
		with: pointer
		with: 1
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convert: src toDouble: dst
	self assemble: 'cvtsi2sd' with: dst with: src
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
dec: srcAndDstReg
	self assemble: 'dec' with: srcAndDstReg
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
decMem: aMemRef
	self assemble: 'dec' with: aMemRef

! !

!AMD64CodeGenerator methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
disassembledText32
	^self nativeCode disassembledText32
! !

!AMD64CodeGenerator methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
disassembledText64
	^self nativeCode disassembledText64
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
divDouble: src1andDstReg by: src2reg
	self 
		assemble: 'divsd'
		with: src1andDstReg
		with: src2reg
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
divide: srcAndDstReg extendingTo: extReg by: divisorReg
	| conversion |
	self
		ASSERT: srcAndDstReg r == rax;
		ASSERT: extReg r == rdx.
	conversion := wordSize = 8
		ifTrue: [ 'cqo' ]
		ifFalse: [ 'cdq' ].
	self
		assemble: conversion;
		assemble: 'idiv' with: divisorReg
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
dropTopOfFPU
	"
	fstp st(0)
	"
	self assembleBytes: #[16rDD 16rD8]
! !

!AMD64CodeGenerator methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
exchange: op1 with: op2
	self assemble: 'xchg' with: op1 with: op2
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
exchange: srcAndDstReg withMem: aMemRef
	self assemble: 'xchg' with: aMemRef with: srcAndDstReg
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
inc: srcAndDstReg
	self assemble: 'inc' with: srcAndDstReg
! !

!AMD64CodeGenerator methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	super initialize.
	instruction := ISAInstruction new.
	operands1 := Array new: 1.
	operands2 := Array new: 2.
	operands3 := Array new: 3.
	immediate := ISAImmediate new.
	pointer := MemoryOperand new.
	encoder := instruction encoder.

! !

!AMD64CodeGenerator methodsFor:  'private - jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jump: mnemonic to: label size: n
	| placeholder end |
	placeholder := 1 bitShift: n - 1 * 8.
	self assemble: mnemonic with: placeholder.
	end := memory position.
	memory
		skip: -1;
		nextPut: 0;
		skip: n negated;
		addRelativeFixup: label size: n;
		position: end
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfEqualTo: label
	self nearJump: 'jz' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfGreaterOrEqualSignedTo: label
	self nearJump: 'jge' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfGreaterSignedTo: label
	self nearJump: 'jg' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfLessOrEqualSignedTo: label
	self nearJump: 'jle' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfLessSignedTo: label
	self nearJump: 'jl' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfNotEqualTo: label
	self nearJump: 'jnz' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfNotZeroTo: label
	self jumpIfNotEqualTo: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfOverflowTo: label
	self nearJump: 'jo' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfSignTo: label
	self nearJump: 'js' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfZeroTo: label
	self jumpIfEqualTo: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpTo: label
	self nearJump: 'jmp' to: label
! !

!AMD64CodeGenerator methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpToMem: aMemRef
	self assemble: 'jmp' with: aMemRef
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
lea: dstReg withMem: srcMemRef
	self assemble: 'lea' with: dstReg with: srcMemRef
! !

!AMD64CodeGenerator methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
leadingRzeroCount
	"
	lzcnt is a special x64 extension: it puts the REX
	prefix after the first opcode byte. Our x64 
	encoder doesn't support that, so we fix the
	bytes by hand
	"
	| pos |
	pos := self currentAddress.
	self assemble: 'lzcnt' with: self regR with: self regR.
	memory
		writeByte: 16rF3 at: pos;
		writeByte: 16r48 at: pos + 1
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
load: dstReg convertingDoubleToIntegerFromMem: srcMemRef
	self assemble: 'cvttsd2si' with: dstReg with: srcMemRef
! !

!AMD64CodeGenerator methodsFor:  'memory - load / store' stamp: 'KenD 28/Jun/2026 13:27:40'!
load: dstReg fromMem: srcMemRef
	| adjusted |
	adjusted := dstReg forLength: srcMemRef length.
	self
		assemble: 'mov'
		with: adjusted
		with: srcMemRef
! !

!AMD64CodeGenerator methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
load: dstReg withTIBat: indexReg
	| seg |
	seg := wordSize = 8
		ifTrue: [ gs ]
		ifFalse: [ fs ].
	pointer
		reset;
		length: self addressLength;
		index: indexReg; 
		scale: wordSize;
		segment: seg.
	self assemble: 'mov' with: dstReg with: pointer
! !

!AMD64CodeGenerator methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
load: dstReg withThreadVariableAt: indexReg
	pointer
		reset;
		length: self addressLength;
		index: indexReg;
		scale: wordSize.
	wordSize = 8
		ifTrue: [ pointer
				segment: gs;
				displacement: 16r1480 ]
		ifFalse: [ pointer
				segment: fs;
				displacement: 16rE10 ].
	self assemble: 'mov' with: dstReg with: pointer
! !

!AMD64CodeGenerator methodsFor:  'memory - load / store' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadDouble: dstReg fromMem: srcMemRef
	self ASSERT: srcMemRef sizeInBits == 64.
	self 
		assemble: 'movq'
		with: dstReg
		with: srcMemRef

! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLongMwithIPoffset: anInteger
	| instsize |
	#dontOptimize.
	instsize := 6.
	pointer
		reset;
		length: 32;
		base: self regIP;
		displacement: anInteger - instsize.
	self assemble: 'mov' with: self regM e with: pointer
! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMXCSRfromA
	pointer
		reset;
		length: 32;
		base: self regA.
	self assemble: 'ldmxcsr' with: pointer
! !

!AMD64CodeGenerator methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByte: reg1 from: reg2 atIndexAt: reg3
	pointer
		reset;
		length: 8;
		base: reg2;
		index: reg3;
		displacement: -1.
	self assemble: 'movzx' with: reg1 with: pointer
! !

!AMD64CodeGenerator methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByte: reg1 from: reg2 atIndexImm: index
	self loadZeroExtendByte: reg1 from: reg2 atOffset: index - 1
! !

!AMD64CodeGenerator methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByte: reg1 from: reg2 atOffset: offset
	pointer
		reset;
		length: 8;
		base: reg2;
		displacement: offset.
	self assemble: 'movzx' with: reg1 with: pointer
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendShortRwithRoffset: offset
	pointer
		reset;
		length: 16;
		base: self regR;
		displacement: offset.
	self assemble: 'movzx' with: self regR with: pointer
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
lock
	self assembleByte: 16rF0
! !

!AMD64CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef
	^ MemoryOperand new
		length: self addressBitSize
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
move: srcReg to: dstReg
	self ASSERT: (srcReg class = Register and: [dstReg class = Register]).
	self assemble: 'mov' with: dstReg with: srcReg

! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveDouble: srcReg into: dstReg
	| mov |

	mov := wordSize = 8 ifTrue: [
			'movq'
		] ifFalse: [ 'movd' ].
	self 
		assemble: mov
		with: dstReg
		with: srcReg
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveImm: imm to: dstReg
	self ASSERT: (imm isInteger and: [dstReg class = Register]).
	self assemble: 'mov' with: dstReg with: imm

! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveTslots
	| rep mnemonic |
	rep := 16rF3.
	mnemonic := wordSize = 8
		ifTrue: [ 'movsq' ]
		ifFalse: [ 'movsd' ].
	self
		assembleByte: rep;
		assemble: mnemonic
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
mulDouble: src1andDstReg by: src2reg
	self 
		assemble: 'mulsd'
		with: src1andDstReg
		with: src2reg
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
multiply: src1AndDstLoReg by: src2reg wideningTo: dstHiReg
	self
		ASSERT: src1AndDstLoReg r == rax;
		ASSERT: dstHiReg r == rdx.
	self assemble: 'imul' with: src2reg
! !

!AMD64CodeGenerator methodsFor:  'private - jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
nearJump: mnemonic to: label
	self jump: mnemonic to: label size: 4
! !

!AMD64CodeGenerator methodsFor:  'alignment' stamp: 'KenD 28/Jun/2026 13:27:40'!
nop
	self assemble: 'nop'
! !

!AMD64CodeGenerator methodsFor:  'alignment' stamp: 'KenD 28/Jun/2026 13:27:40'!
nop2
	memory nextPutAll: #[16r66 16r90]
! !

!AMD64CodeGenerator methodsFor:  'alignment' stamp: 'KenD 28/Jun/2026 13:27:40'!
nop3
	memory nextPutAll: #[16r0F 16r1F 16r00]
! !

!AMD64CodeGenerator methodsFor:  'alignment' stamp: 'KenD 28/Jun/2026 13:27:40'!
nop4
	memory nextPutAll: #[16r0F 16r1F 16r40 16r00]
! !

!AMD64CodeGenerator methodsFor:  'alignment' stamp: 'KenD 28/Jun/2026 13:27:40'!
nop5
	memory nextPutAll: #[16r0F 16r1F 16r44 16r00 16r00]
! !

!AMD64CodeGenerator methodsFor:  'alignment' stamp: 'KenD 28/Jun/2026 13:27:40'!
nop6
	memory nextPutAll: #[16r66 16r0F 16r1F 16r44 16r00 16r00]
! !

!AMD64CodeGenerator methodsFor:  'alignment' stamp: 'KenD 28/Jun/2026 13:27:40'!
nop7
	memory nextPutAll: #[16r0F 16r1F 16r80 16r00 16r00 16r00 16r00]
! !

!AMD64CodeGenerator methodsFor:  'alignment' stamp: 'KenD 28/Jun/2026 13:27:40'!
nop8
	memory nextPutAll: #[16r0F 16r1F 16r84 16r00 16r00 16r00 16r00 16r00]
! !

!AMD64CodeGenerator methodsFor:  'alignment' stamp: 'KenD 28/Jun/2026 13:27:40'!
nop9
	memory nextPutAll: #[16r66 16r0F 16r1F 16r84 16r00 16r00 16r00 16r00 16r00]
! !

!AMD64CodeGenerator methodsFor:  'alignment' stamp: 'KenD 28/Jun/2026 13:27:40'!
nop: count
	"
	ShellDLL current openWebPage: 'http://www.felixcloutier.com/x86/NOP.html'
	"
	| r |
	r := count.
	r >= 9 ifTrue: [
		r // 9 timesRepeat: [self nop9].
		r := r \\ 9].
	r = 8 ifTrue: [^self nop8].
	r = 7 ifTrue: [^self nop7].
	r = 6 ifTrue: [^self nop6].
	r = 5 ifTrue: [^self nop5].
	r = 4 ifTrue: [^self nop4].
	r = 3 ifTrue: [^self nop3].
	r = 2 ifTrue: [^self nop2].
	r = 1 ifTrue: [^self nop].

! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
or: src1AndDst with: src2
	self assemble: 'or' with: src1AndDst with: src2

! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
or: src1AndDst withImm: imm

	(imm between: 0 and: 127) ifTrue: [ 
		"When `imm` is a small POSITIVE, we can safely
		 or bits only in lower part of the 64 bit register
		 since higher bits of immediate are all zeros anyway.
		 This helps to generate shorter code on x86."
		self assemble: 'or' with: src1AndDst byte withImm: imm
	] ifFalse: [
		self assemble: 'or' with: src1AndDst withImm: imm
	].

! !

!AMD64CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pop: dstReg
	self assemble: 'pop' with: dstReg

! !

!AMD64CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popIntoMem: dstMemRef
	self assemble: 'pop' with: dstMemRef
! !

!AMD64CodeGenerator methodsFor:  'printing & storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	aStream print: self class; cr; cr;
		nextPutAll: memory bytes disassembledAmd64
! !

!AMD64CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
push: srcReg
	self assemble: 'push' with: srcReg

! !

!AMD64CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushAOnFPUStack
	pointer reset; length: 64; base: self regA.
	self assemble: 'fld' with: pointer
! !

!AMD64CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushImm: imm
	#imm8.
	#imm32.
	self assemble: 'push' withImm: imm
! !

!AMD64CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushMem: aMemRef
	self push: aMemRef
! !

!AMD64CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushROnFPUStack
	pointer reset; length: 64; base: self regR.
	self assemble: 'fld' with: pointer
! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
readFPUStatusOnA
	pointer
		reset;
		length: 16;
		base: self regA.
	self assemble: 'fstsw' with: pointer
! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
renameByteRegisterIfNeeded: register preserving: preserved during: aBlock
	self
		renameByteRegisterIfNeeded: register
		preserving: preserved
		preserving: nil
		during: aBlock
! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
renameByteRegisterIfNeeded: register preserving: preserved1 preserving: preserved2 during: aBlock
	| final |
	(self addressSize !!= 4 or: [register byte isLongModeOld8BitRegister not])
		ifTrue: [aBlock value: register]
		ifFalse: [
			final := self renameRegisterPreserving: preserved1 preserving: preserved2.
			self exchange: register e with: final.
			aBlock value: final.
			self exchange: final with: register e]
! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
renameRegisterPreserving: preserved1 preserving: preserved2
	preserved1 == self regR
		ifTrue: [preserved2 == self regA
			ifTrue: [^self regT]
			ifFalse: [^self regA]].
	preserved2 == self regR
		ifTrue: [preserved1 == self regA
			ifTrue: [^self regT]
			ifFalse: [^self regA]].
	^self regR
! !

!AMD64CodeGenerator methodsFor:  'calls' stamp: 'KenD 28/Jun/2026 13:27:40'!
return
	self assemble: 'ret'
! !

!AMD64CodeGenerator methodsFor:  'calls' stamp: 'KenD 28/Jun/2026 13:27:40'!
return: anInteger
	anInteger = 0
		ifTrue: [self assemble: 'ret']
		ifFalse: [self assemble: 'ret' with: anInteger * self addressSize]
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
roundDouble: srcReg into: dstReg
	self 
		assemble: 'roundsd'
		with: dstReg
		with: srcReg
		with: 3
! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
scaleFloatOnRWithA
	self
		pushAOnFPUStack;
		pushROnFPUStack;
		assemble: 'fscale'.
	pointer
		reset;
		length: 64;
		base: self regR.
	self
		assemble: 'fstp' with: pointer;
		dropTopOfFPU
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftLeft: srcAndDst by: countReg
	self ASSERT: countReg r = rcx.
	self assemble: 'sal' with: srcAndDst with: countReg b
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftLeft: srcAndDst byImm: count
	self ASSERT: (count between: 0 and: srcAndDst length - 1).
	self assemble: 'sal' with: srcAndDst withImm: count
! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRight: srcAndDst by: countReg
	self ASSERT: countReg r = rcx.
	self assemble: 'sar' with: srcAndDst with: countReg b
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRight: srcAndDst byImm: count
	self ASSERT: (count between: 0 and: srcAndDst length - 1).
	self assemble: 'shr' with: srcAndDst withImm: count
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRightArithmetic: srcAndDst by: countReg
	self ASSERT: countReg r = rcx.
	self assemble: 'sar' with: srcAndDst with: countReg b
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRightArithmetic: srcAndDst byImm: count
	self ASSERT: (count between: 0 and: srcAndDst length - 1).
	self assemble: 'sar' with: srcAndDst withImm: count
! !

!AMD64CodeGenerator methodsFor:  'private - jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJump: mnemonic to: label
	self jump: mnemonic to: label size: 1
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfCarryTo: label
	self shortJump: 'jc' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfEqualTo: label
	self shortJump: 'jz' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfNotCarryTo: label
	self shortJump: 'jnc' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfNotEqualTo: label
	self shortJump: 'jnz' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfSignTo: label
	self shortJump: 'js' to: label
! !

!AMD64CodeGenerator methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpTo: label
	self shortJump: 'jmp' to: label
! !

!AMD64CodeGenerator methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
sqrtDouble: srcReg into: dstReg
	self 
		assemble: 'sqrtsd'
		with: srcReg
		with: dstReg
! !

!AMD64CodeGenerator methodsFor:  'memory - load / store' stamp: 'KenD 28/Jun/2026 13:27:40'!
store: srcReg intoMem: dstMemRef
	| adjusted |
	adjusted := srcReg forLength: dstMemRef length.
	self
		assemble: 'mov'
		with: dstMemRef
		with: adjusted
! !

!AMD64CodeGenerator methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
store: srcReg intoTIBat: indexReg
	| seg |
	seg := wordSize = 8
		ifTrue: [ gs ]
		ifFalse: [ fs ].
	pointer
		reset;
		length: self addressLength;
		index: indexReg;
		scale: wordSize;
		segment: seg.
	self assemble: 'mov' with: pointer with: srcReg
! !

!AMD64CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
store: srcReg intoThreadVariableAt: indexReg
	pointer
		reset;
		length: self addressLength;
		index: indexReg;
		scale: wordSize.
	wordSize = 8
		ifTrue: [ pointer
				segment: gs;
				displacement: 16r1480 ]
		ifFalse: [ pointer
				segment: fs;
				displacement: 16rE10 ].
	self assemble: 'mov' with: pointer with: srcReg
! !

!AMD64CodeGenerator methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeByte: byte in: reg2 offset: offset
	pointer
		reset;
		length: 8;
		base: reg2;
		displacement: offset.
	self assemble: 'mov' with: pointer with: byte
! !

!AMD64CodeGenerator methodsFor:  'memory - load / store' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeDouble: srcReg intoMem: dstMemRef
	self ASSERT: dstMemRef sizeInBits == 64.
	self 
		assemble: 'movq'
		with: dstMemRef
		with: srcReg

! !

!AMD64CodeGenerator methodsFor:  'memory - load / store' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeDoubleResultIntoMem: dstMemRef
	wordSize = 8
		ifTrue:
			[ self assemble: 'movq' with: dstMemRef  with: self regX0 ]
		ifFalse: [ self assemble: 'fstp' with: dstMemRef ]
! !

!AMD64CodeGenerator methodsFor:  'memory - load / store' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeImm: imm intoMem: dstMemRef
	self
		assemble: 'mov'
		with: dstMemRef
		withImm: imm

! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeMXCSRintoA
	pointer
		reset;
		length: 32;
		base: self regA.
	self assemble: 'stmxcsr' with: pointer
! !

!AMD64CodeGenerator methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
sub: src1 from: src2AndDst
	self assemble: 'sub' with: src2AndDst with:  src1

! !

!AMD64CodeGenerator methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subDouble: src1 from: src2AndDst
	self 
		assemble: 'subsd'
		with: src2AndDst
		with: src1
! !

!AMD64CodeGenerator methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subImm: imm from: srcAndDst
	self assemble: 'sub' with: srcAndDst withImm: imm

! !

!AMD64CodeGenerator methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
subTslotsToSP
	self assemble: 'neg' with: self regT.
	pointer
		reset;
		length: self addressLength;
		base: self regSP;
		index: self regT;
		scale: self regSP sizeInBytes.
	self
		assemble: 'lea' with: self regSP with: pointer;
		assemble: 'neg' with: self regT
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
test: src1Reg with: src2Reg
	self assemble: 'test' with: src1Reg with: src2Reg
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
test: srcReg withImm: imm
	self assemble: 'test' with: srcReg with: imm
! !

!AMD64CodeGenerator methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
testIntegerBit: op1
	| op |
	op := op1 byte.
	(self addressSize = 4 and: [op isLongModeOld8BitRegister])
		ifTrue: [op := op1].
	self assemble: 'test' with: op with: 1
! !

!AMD64CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSize: anInteger
	super wordSize: anInteger.
	encoder wordSize: anInteger
! !

!AMD64CodeGenerator methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeTslots
	| rep mnemonic |
	rep := 16rF3.
	mnemonic := wordSize = 8
		ifTrue: [ 'stosq' ]
		ifFalse: [ 'stosd' ].
	self
		assembleByte: rep;
		assemble: mnemonic
! !

!AMD64CodeGenerator methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
xor: src1AndDst with: src2
	self assemble: 'xor' with: src1AndDst with: src2

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AMD64CodeGenerator class' category: #'Powerlang-Core-Assembler-Intel'!
AMD64CodeGenerator class
	instanceVariableNames: ''!


AMD64CodeGenerator initialize!

