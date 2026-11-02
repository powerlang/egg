"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.

	AAPCS64 (the AArch64 procedure call standard) is the calling convention
	used by both Apple Silicon (Darwin) and Linux on ARM64. The IR-register
	mapping mirrors the x86_64 one in spirit:

	  regR  (return / scratch)            -> x0
	  regA  (arg / scratch)               -> x1
	  regS  (scratch)                     -> x2
	  regT  (scratch)                     -> x3
	  regV  (scratch of the codegen)      -> x16
	  regM  (current method, callee-save) -> x19
	  regE  (current environment)         -> x20
	  regG  (globals base)                -> x21
	  regNil                              -> x22
	  regTrue                             -> x23
	  regFalse                            -> x24
	  regFP (frame pointer)               -> x29
	  regSP (stack pointer)               -> sp (encoded as 31 in addressing)
	  regX0 / regX1 (xmm0/1 analogs)      -> v0 / v1 (FP/SIMD)

	Register accessors return a stable instance (the allocator keys on
	identity): the ones the Aarch64 module binds from ARM64Register registers.
"
Class {
	#name : #AAPCS64ABI,
	#superclass : #ABI,
	#instVars : [
		'regR', 'regA', 'regS', 'regT', 'regV',
		'regM', 'regE', 'regG',
		'regNil', 'regTrue', 'regFalse',
		'regFP', 'regSP', 'regL',
		'regX0', 'regX1',
		'packsStackArguments'
	],
	#category : #Aarch64
}

{ #category : #initialization }
AAPCS64ABI >> initialize [
	super initialize.
	packsStackArguments := false.
	regR := x0.
	regA := x1.
	regS := x2.
	regT := x3.
	regV := x16.
	regM := x19.
	regE := x20.
	regG := x21.
	regNil := x22.
	regTrue := x23.
	regFalse := x24.
	regFP := x29.
	regSP := sp.
	regL := x30.
	regX0 := v0.
	regX1 := v1
]

{ #category : #callbacks }
AAPCS64ABI >> emitEntrypoint: anFFIDescriptor with: anAssembler [
	anAssembler
		saveCallerFrame;
		pushE;
		pushG;
		pushNil;
		pushTrue;
		pushFalse;
		pushM.
	self storeArgumentsInStack: anFFIDescriptor with: anAssembler
]

{ #category : #callouts }
AAPCS64ABI >> stackAreaOf: places types: types [
	| end |
	end := 0.
	places with: types do: [:place :type |
		place isInteger ifTrue: [end := end max: place + (self stackBytesOf: type)]].
	^end alignedTo: 16
]

{ #category : #callouts }
AAPCS64ABI >> stackBytesOf: type [
	^packsStackArguments ifTrue: [(self bitsOf: type) // 8] ifFalse: [8]
]

{ #category : #callbacks }
AAPCS64ABI >> storeArgumentsInStack: anFFIDescriptor with: anAssembler [
	anAssembler
		pushS;
		loadRwithArgPointer;
		convertRtoSmallInteger;
		pushR
]

{ #category : #callbacks }
AAPCS64ABI >> popRetaddrAndArgs: anFFIDescriptor with: anAssembler [
	anAssembler popA; popA; popA
]

{ #category : #callbacks }
AAPCS64ABI >> restoreContext: anFFIDescriptor with: anAssembler [
	self popRetaddrAndArgs: anFFIDescriptor with: anAssembler.
	anAssembler
		popM;
		popFalse;
		popTrue;
		popNil;
		popG;
		popE;
		popFP;
		pop: self regL;
		return
]


{ #category : #accessing }
AAPCS64ABI >> bits [
	^64
]

{ #category : #callouts }
AAPCS64ABI >> bitsOf: type [
	(#(uint8 sint8 uchar schar) includes: type) ifTrue: [^8].
	(#(uint16 sint16 ushort sshort) includes: type) ifTrue: [^16].
	(#(uint32 sint32 uint sint float) includes: type) ifTrue: [^32].
	^64
]

{ #category : #callouts }
AAPCS64ABI >> emitCallout: types with: anAssembler loading: aBlock [
	| codegen places area order |
	codegen := anAssembler codegen.
	places := self placesOf: types.
	area := self stackAreaOf: places types: types.
	codegen move: self regR to: self regCallout.
	area > 0 ifTrue: [codegen subImm: area from: sp].
	order := self indexesLeavingX0Last: places.
	order do: [:i | | place type |
		place := places at: i.
		type := types at: i.
		aBlock value: i.
		place isInteger
			ifTrue: [self emitStackArgument: type at: place with: codegen]
			ifFalse: [self moveArgumentTo: place with: codegen]].
	codegen callIndirectReg: self regCallout.
	area > 0 ifTrue: [codegen addImm: area to: sp]
]

{ #category : #callouts }
AAPCS64ABI >> floatRegistersFor: type [
	type == #float ifTrue: [^{s0. s1. s2. s3. s4. s5. s6. s7}].
	^{d0. d1. d2. d3. d4. d5. d6. d7}
]

{ #category : #callouts }
AAPCS64ABI >> indexesLeavingX0Last: places [
	| indexes |
	indexes := 1 to: places size.
	^(indexes reject: [:i | (places at: i) == x0]) , (indexes select: [:i | (places at: i) == x0])
]

{ #category : #callouts }
AAPCS64ABI >> emitStackArgument: type at: offset with: codegen [
	| bits |
	type == #float ifTrue: [
		self moveSingleTo: s16 with: codegen.
		^codegen store: 32 from: s16 into: sp disp: offset].
	bits := packsStackArguments ifTrue: [self bitsOf: type] ifFalse: [64].
	codegen store: bits from: x0 into: sp disp: offset
]

{ #category : #callouts }
AAPCS64ABI >> extendResult: type with: anAssembler [
	| bits opcode |
	type == #float ifTrue: [^anAssembler codegen assemble: 'fcvt' with: d0 with: s0].
	type == #double ifTrue: [^self].
	bits := self bitsOf: type.
	bits = 64 ifTrue: [^self].
	opcode := type first = $s ifTrue: ['sbfm'] ifFalse: ['ubfm'].
	anAssembler codegen assemble: opcode with: self regR with: self regR with: 0 with: bits - 1
]

{ #category : #callouts }
AAPCS64ABI >> isFloat: type [
	^#(float double) includes: type
]

{ #category : #callouts }
AAPCS64ABI >> moveArgumentTo: aRegister with: codegen [
	aRegister == x0 ifTrue: [^self].
	aRegister isFloat ifFalse: [^codegen move: x0 to: aRegister].
	aRegister length = 64 ifTrue: [^codegen moveDouble: x0 into: aRegister].
	self moveSingleTo: aRegister with: codegen
]

{ #category : #accessing }
AAPCS64ABI >> newAssembler [
	^ARM64TemplateAssembler new
]

{ #category : #callouts }
AAPCS64ABI >> moveSingleTo: aRegister with: codegen [
	codegen moveDouble: x0 into: d16.
	codegen assemble: 'fcvt' with: aRegister with: d16
]

{ #category : #accessing }
AAPCS64ABI >> packsStackArguments: aBoolean [
	packsStackArguments := aBoolean
]

{ #category : #callouts }
AAPCS64ABI >> placesOf: types [
	| ints floats offset |
	ints := 0.
	floats := 0.
	offset := 0.
	^types collect: [:type | | place bytes |
		(#(longdouble complexFloat complexDouble complexLongdouble) includes: type)
			ifTrue: [^self error: 'FFI type ' , type , ' not supported natively yet'].
		(self isFloat: type)
			ifTrue: [
				floats := floats + 1.
				floats <= 8 ifTrue: [place := (self floatRegistersFor: type) at: floats]]
			ifFalse: [
				ints := ints + 1.
				ints <= 8 ifTrue: [place := {x0. x1. x2. x3. x4. x5. x6. x7} at: ints]].
		place ifNil: [
			bytes := self stackBytesOf: type.
			offset := offset alignedTo: bytes.
			place := offset.
			offset := offset + bytes].
		place]
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regA [
	^regA
]

{ #category : #accessing }
AAPCS64ABI >> regCallout [
	^x9
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regE [
	^regE
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regFP [
	^regFP
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regFalse [
	^regFalse
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regG [
	^regG
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regL [
	^regL
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regM [
	^regM
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regNil [
	^regNil
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regR [
	^regR
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regS [
	^regS
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regSP [
	^regSP
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regT [
	^regT
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regTrue [
	^regTrue
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regV [
	^regV
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regX0 [
	^regX0
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regX1 [
	^regX1
]

{ #category : #accessing }
AAPCS64ABI >> wordSize [
	^8
]

{ #category : #accessing }
AAPCS64ABI >> wordSizeShift [
	^3
]

