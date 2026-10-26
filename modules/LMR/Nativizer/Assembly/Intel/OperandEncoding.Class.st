'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #OperandEncoding category: #'Powerlang-Core-Assembler-Intel'!
Object subclass: #OperandEncoding
	instanceVariableNames: 'name selectors descriptions immediate modrm'
	classVariableNames: 'Encodings'
	poolDictionaries: 'Registers'
	category: 'Powerlang-Core-Assembler-Intel'!
!OperandEncoding commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!OperandEncoding methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
bytesFor: integer length: n
	| bytes v |
	bytes := ByteArray new: n.
	v := integer.
	v < 0 ifTrue: [v := v + (1 bitShift: n * 8)].
	1 to: n do: [:i | | b |
		b := v bitAnd: 16rFF.
		bytes at: i put: b.
		v := v bitShift: -8].
	^bytes
! !

!OperandEncoding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
descriptions
	^descriptions
! !

!OperandEncoding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
descriptions: aCollection
	descriptions := aCollection.
	modrm := immediate := false.
	(selectors conform: [:s | s beginsWith: 'encodeNP']) ifTrue: [^self].
	descriptions do: [:d | 
		(d includesString: 'ModRM') ifTrue: [modrm := true].
		(d includesString: 'offs') ifTrue: [immediate := true].
		(d includesString: 'imm') ifTrue: [immediate := true]]
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeAOperand1: operand
	"
	imm8
	"
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeDOperand1: instruction
	"
	offset
	"
	| op bytes |
	op := instruction spec operands at: 1.
	bytes := self bytesFor: instruction operand1 value length: op length // 8.
	instruction immediate: bytes
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeFDOperand1: instruction
	"
	AL/AX/EAX/RAX
	Moffs
	"
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeFDOperand2: operand
	"
	AL/AX/EAX/RAX
	Moffs
	"
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeFVOperand1: instruction
	"
	ModRM:reg (w)
	EVEX.vvvv
	ModRM:r/m (r)
	"
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeFVOperand2: instruction
	"
	ModRM:reg (w)
	EVEX.vvvv
	ModRM:r/m (r)
	"
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeFVOperand3: instruction
	"
	ModRM:reg (w)
	EVEX.vvvv
	ModRM:r/m (r)
	"
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeFVRVMOperand1: instruction
	"
	ModRM:reg (w)
	EVEX.vvvv
	ModRM:r/m (r)
	"
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeFVRVMOperand2: instruction
	"
	ModRM:reg (w)
	EVEX.vvvv
	ModRM:r/m (r)
	"
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeFVRVMOperand3: instruction
	"
	ModRM:reg (w)
	EVEX.vvvv
	ModRM:r/m (r)
	"
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeIIOperand1: instruction
	"
	iw
	imm8
	"
	| op bytes |
	op := instruction spec operands at: 1.
	bytes := self bytesFor: instruction operand1 value length: op length // 8.
	instruction immediate: bytes
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeIIOperand2: instruction
	"
	iw
	imm8
	"
	| op bytes |
	op := instruction spec operands at: 2.
	bytes := self bytesFor: instruction operand2 value length: op length // 8.
	instruction immediate2: bytes
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeIOperand1: instruction
	"
	AL/AX/EAX/RAX
	imm8
	"
	"
	do nothing
	"
	instruction arity = 1 ifTrue: [| op bytes |
		op := instruction spec operands at: 1.
		bytes := self bytesFor: instruction operand1 value length: op length // 8.
		instruction immediate: bytes]
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeIOperand2: instruction
	"
	AL/AX/EAX/RAX
	imm8
	"
	| op bytes |
	op := instruction spec operands at: 2.
	bytes := self bytesFor: instruction operand2 value length: op length // 8.
	instruction immediate: bytes
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeM1Operand1: instruction
	"
	ModRM:r/m (w)
	1
	"
	instruction rm: instruction operand1 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeM1Operand2: instruction
	"
	ModRM:r/m (w)
	1
	"
	"
	do nothing
	"
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMCOperand1: instruction
	"
	ModRM:r/m (w)
	CL
	"
	instruction rm: instruction operand1 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMCOperand2: operand
	"
	ModRM:r/m (w)
	CL
	"
	"
	do nothing
	"
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMIOperand1: instruction
	"
	ModRM:r/m (r, w)
	imm8
	"
	instruction rm: instruction operand1 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMIOperand2: instruction
	"
	ModRM:r/m (r, w)
	imm8
	"
	| op bytes |
	op := instruction spec operands at: 2.
	bytes := self bytesFor: instruction operand2 value length: op length // 8.
	instruction immediate: bytes
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMOperand1: instruction
	"
	ModRM:r/m (r)
	"
	instruction rm: instruction operand1 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMRCOperand1: instruction
	"
	ModRM:r/m (w)
	ModRM:reg (r)
	CL
	"
	instruction rm: instruction operand1 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMRCOperand2: instruction
	"
	ModRM:r/m (w)
	ModRM:reg (r)
	CL
	"
	instruction reg: instruction operand2
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMRCOperand3: instruction
	"
	ModRM:r/m (w)
	ModRM:reg (r)
	CL
	"
	"
	do nothing
	"
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMRIOperand1: instruction
	"
	ModRM:r/m (w)
	ModRM:reg (r)
	imm8
	"
	instruction rm: instruction operand1 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMRIOperand2: instruction
	"
	ModRM:r/m (w)
	ModRM:reg (r)
	imm8
	"
	instruction reg: instruction operand2
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMRIOperand3: instruction
	"
	ModRM:r/m (w)
	ModRM:reg (r)
	imm8
	"
	| op bytes |
	op := instruction spec operands at: 3.
	bytes := self bytesFor: instruction operand3 value length: op length // 8.
	instruction immediate: bytes
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMROperand1: instruction
	"
	ModRM:r/m (r, w)
	ModRM:reg (r)
	"
	instruction rm: instruction operand1 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMROperand2: instruction
	"
	ModRM:r/m (r, w)
	ModRM:reg (r)
	"
	instruction reg: instruction operand2
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMVROperand1: instruction
	"
	ModRM:r/m (w)
	VEX.vvvv (r)
	ModRM:reg (r)
	"
	instruction vrm: instruction operand1 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMVROperand2: instruction
	"
	ModRM:r/m (w)
	VEX.vvvv (r)
	ModRM:reg (r)
	"
	instruction vvvv: instruction operand2 index
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeMVROperand3: instruction
	"
	ModRM:r/m (w)
	VEX.vvvv (r)
	ModRM:reg (r)
	"
	instruction vreg: instruction operand3
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeNPOperand1: instruction
	"
	ModRM:r/m (w)
	ModRM:reg (r)
	"
	self ASSERT: instruction operand1 isImmediate
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeNPOperand2: operand
	"
	ModRM:r/m (w)
	ModRM:reg (r)
	"
	self ASSERT: false
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeOIOperand1: instruction
	"
	opcode + rd (w)
	imm8/16/32/64
	"
	self encodeOOperand1: instruction
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeOIOperand2: instruction
	"
	opcode + rd (w)
	imm8/16/32/64
	"
	instruction operand2 length: instruction operand1 length.
	instruction immediate: instruction operand2 bytes
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeOOperand1: instruction
	"
	opcode + rd (r, w)
	"
	| index i opcode |
	index := instruction operand1 index.
	i := index bitAnd: 2r111.
	opcode := instruction spec primaryOpcode copy.
	opcode at: opcode size put: opcode last + i.
	index > 7
		ifTrue: [instruction rexB: true opcode: opcode]
		ifFalse: [instruction opcode: opcode]
! !

!OperandEncoding methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeOperand: i of: instruction
	| selector |
	selector := selectors at: i.
	self perform: selector with: instruction
! !

!OperandEncoding methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeOperands: instruction
	1 to: instruction arity do: [:i | self encodeOperand: i of: instruction]
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRM0Operand1: instruction
	"
	ModRM:reg (r, w)
	ModRM:r/m (r)
	"
	instruction vreg: instruction operand1
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRM0Operand2: instruction
	"
	ModRM:reg (r, w)
	ModRM:r/m (r)
	"
	instruction vrm: instruction operand2 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRMIOperand1: instruction
	"
	ModRM:reg (w)
	ModRM:r/m (r)
	imm8
	"
	instruction reg: instruction operand1
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRMIOperand2: instruction
	"
	ModRM:reg (w)
	ModRM:r/m (r)
	imm8
	"
	instruction rm: instruction operand2 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRMIOperand3: instruction
	"
	ModRM:reg (w)
	ModRM:r/m (r)
	imm8
	"
	| op bytes |
	op := instruction spec operands at: 3.
	bytes := self bytesFor: instruction operand3 value length: op length // 8.
	instruction immediate: bytes
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRMOperand1: instruction
	"
	ModRM:reg (r, w)
	ModRM:r/m (r)
	"
	instruction reg: instruction operand1
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRMOperand2: instruction
	"
	ModRM:reg (r, w)
	ModRM:r/m (r)
	"
	instruction rm: instruction operand2 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRMVOperand1: instruction
	"
	ModRM:reg (w)
	ModRM:r/m (r)
	VEX.vvvv (r)
	"
	instruction vreg: instruction operand1
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRMVOperand2: instruction
	"
	ModRM:reg (w)
	ModRM:r/m (r)
	VEX.vvvv (r)
	"
	instruction vrm: instruction operand2 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRMVOperand3: instruction
	"
	ModRM:reg (w)
	ModRM:r/m (r)
	VEX.vvvv (r)
	"
	instruction vvvv: instruction operand3 index
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRVMIOperand1: instruction
	"
	ModRM:reg (w)
	VEX.vvvv (r)
	ModRM:r/m (r)
	imm8[3:0]
	"
	instruction vreg: instruction operand1
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRVMIOperand2: instruction
	"
	ModRM:reg (w)
	VEX.vvvv (r)
	ModRM:r/m (r)
	imm8[3:0]
	"
	instruction vvvv: instruction operand2 index
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRVMIOperand3: instruction
	"
	ModRM:reg (w)
	VEX.vvvv (r)
	ModRM:r/m (r)
	imm8[3:0]
	"
	instruction vrm: instruction operand3 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRVMIOperand4: instruction
	"
	ModRM:reg (w)
	VEX.vvvv (r)
	ModRM:r/m (r)
	imm8[3:0]
	"
	| op bytes |
	op := instruction spec operands at: 4.
	bytes := self bytesFor: instruction operand4 value length: op length // 8.
	instruction immediate: bytes
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRVMOperand1: instruction
	"
	ModRM:reg (w)
	VEX.vvvv
	ModRM:r/m (r)
	"
	instruction vreg: instruction operand1
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRVMOperand2: instruction
	"
	ModRM:reg (w)
	VEX.vvvv
	ModRM:r/m (r)
	"
	instruction vvvv: instruction operand2 index
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRVMOperand3: instruction
	"
	ModRM:reg (w)
	VEX.vvvv
	ModRM:r/m (r)
	"
	instruction vrm: instruction operand3 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRVMROperand1: instruction
	"
	ModRM:reg (w)
	VEX.vvvv (r)
	ModRM:r/m (r)
	imm8[7:4]
	"
	instruction vreg: instruction operand1
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRVMROperand2: instruction
	"
	ModRM:reg (w)
	VEX.vvvv (r)
	ModRM:r/m (r)
	imm8[7:4]
	"
	instruction vvvv: instruction operand2 index
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRVMROperand3: instruction
	"
	ModRM:reg (w)
	VEX.vvvv (r)
	ModRM:r/m (r)
	imm8[7:4]
	"
	instruction vrm: instruction operand3 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeRVMROperand4: instruction
	"
	ModRM:reg (w)
	VEX.vvvv (r)
	ModRM:r/m (r)
	imm8[7:4]
	"
	| imm |
	imm := instruction operand4 index bitShift: 4.
	instruction immediate: imm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeT1SOperand1: instruction
	"
	ModRM:reg (w)
	EVEX.vvvv
	ModRM:r/m (r)
	"
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeT1SOperand2: instruction
	"
	ModRM:reg (w)
	EVEX.vvvv
	ModRM:r/m (r)
	"
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeT1SOperand3: instruction
	"
	ModRM:reg (w)
	EVEX.vvvv
	ModRM:r/m (r)
	"
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeT1SRVMOperand1: instruction
	"
	ModRM:reg (w)
	EVEX.vvvv
	ModRM:r/m (r)
	"
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeT1SRVMOperand2: instruction
	"
	ModRM:reg (w)
	EVEX.vvvv
	ModRM:r/m (r)
	"
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeT1SRVMOperand3: instruction
	"
	ModRM:reg (w)
	EVEX.vvvv
	ModRM:r/m (r)
	"
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeTDOperand1: operand
	"
	Moffs (w)
	AL/AX/EAX/RAX
	"
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeTDOperand2: operand
	"
	Moffs (w)
	AL/AX/EAX/RAX
	"
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeTOOperand1: operand
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeTOOperand2: operand
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeVMIOperand1: instruction
	"
	VEX.vvvv (w)
	ModRM:r/m (r)
	imm8
	"
	instruction vvvv: instruction operand1 index
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeVMIOperand2: instruction
	"
	VEX.vvvv (w)
	ModRM:r/m (r)
	imm8
	"
	instruction vrm: instruction operand2 rm
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeVMIOperand3: instruction
	"
	VEX.vvvv (w)
	ModRM:r/m (r)
	imm8
	"
	| op bytes |
	op := instruction spec operands at: 3.
	bytes := self bytesFor: instruction operand3 value length: op length // 8.
	instruction immediate: bytes
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeVMOperand1: operand
	"
	VEX.vvvv (w)
	ModRM:r/m (r)
	"
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeVMOperand2: operand
	"
	VEX.vvvv (w)
	ModRM:r/m (r)
	"
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeXMOperand1: operand
	"
	ModRM:reg (w)
	ModRM:r/m (r)
	"
	
! !

!OperandEncoding methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
encodeXMOperand2: operand
	"
	ModRM:reg (w)
	ModRM:r/m (r)
	"
	
! !

!OperandEncoding methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
immediateOperand
	^descriptions findFirst: [:d | d includesString: 'imm']
! !

!OperandEncoding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isImmediate1Operand: index
	^(self isImmediateOperand: index)
		and: [(1 to: index - 1) noneSatisfy: [:i | self isImmediateOperand: i]]
! !

!OperandEncoding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isImmediate2Operand: index
	^(self isImmediateOperand: index)
		and: [(1 to: index - 1) anySatisfy: [:i | self isImmediateOperand: i]]
! !

!OperandEncoding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isImmediateOperand: index
	| d |
	d := descriptions at: index.
	^(d includesString: 'imm') or: [d includesString: 'offs'] or: [d = 'iw']
! !

!OperandEncoding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
isVvvvOperand: index
	^(descriptions at: index) includesString: 'vvvv'
! !

!OperandEncoding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name
	^name
! !

!OperandEncoding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
name: aString
	name := aString
! !

!OperandEncoding methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
operand: index of: instruction
	| d |
	d := descriptions at: index.
	(d includesString: 'reg') ifTrue: [^instruction regOperand: index].
	(d includesString: 'r/m') ifTrue: [^instruction rmOperand: index].
	(d includesString: 'vvvv') ifTrue: [^instruction vvvvOperand: index].
	(self isImmediate1Operand: index) ifTrue: [^instruction immediateOperand].
	(self isImmediate2Operand: index) ifTrue: [^instruction immediateOperand2].
	(instruction spec operands at: index) isImmediate
		ifTrue: [^instruction immediateOperand].
	((d beginsWith: 'opcode') and: [index = 1])
		ifTrue: [^instruction opcodeOperand].
	self ASSERT: false
! !

!OperandEncoding methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:40'!
printOn: aStream
	name isNil ifTrue: [^super printOn: aStream].
	aStream nextPutAll: name
! !

!OperandEncoding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
selectors
	^selectors
! !

!OperandEncoding methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
selectors: aCollection
	selectors := aCollection
! !

!OperandEncoding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
usesImmediate
	^immediate
! !

!OperandEncoding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
usesImmediate2
	^immediate and: [selectors anySatisfy: [:s | s includesString: 'II']]
! !

!OperandEncoding methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:40'!
usesModRM
	^modrm
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OperandEncoding class' category: #'Powerlang-Core-Assembler-Intel'!
OperandEncoding class
	instanceVariableNames: 'Encodings'!

!OperandEncoding class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
commentEncodingMethods
	"
	StChangesetBrowser new
		label: 'OperandEncoding comments';
		setModel: (ChangesetBrowserModel on: OperandEncoding commentEncodingMethods);
		openInWindow
	"
	| changes |
	changes := OrderedCollection new.
	Encodings collect: [:oe | | comment |
		comment := String streamContents: [:strm | 
			strm crtab; nextPut: $"; crtab.
			oe descriptions do: [:d | strm nextPutAll: d; crtab].
			strm nextPut: $"; cr].
		oe selectors do: [:s | | cm reader source change |
			cm := self >> s.
			reader := cm sourceCode readStream.
			source := String streamContents: [:strm | 
				strm
					nextPutAll: reader nextLine;
					nextPutAll: comment;
					nextPutAll: reader upToEnd].
			change := self project changes
				methodDefinitionClass: self
				sourceCode: source.
			changes add: change]].
	^changes
! !

!OperandEncoding class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
defs
	^#(
		#('A' 'imm8')
		#('D' 'offset')
		#('FD' 'AL/AX/EAX/RAX' 'Moffs')
		#('FV' 'ModRM:reg (w)' 'EVEX.vvvv' 'ModRM:r/m (r)')
		#('FV-RVM' 'ModRM:reg (w)' 'EVEX.vvvv' 'ModRM:r/m (r)')
		#('I' 'AL/AX/EAX/RAX' 'imm8')
		#('II' 'iw' 'imm8')
		#('M' 'ModRM:r/m (r)')
		#('M1' 'ModRM:r/m (w)' '1')
		#('MC' 'ModRM:r/m (w)' 'CL')
		#('MI' 'ModRM:r/m (r, w)' 'imm8')
		#('MR' 'ModRM:r/m (r, w)' 'ModRM:reg (r)')
		#('MRC' 'ModRM:r/m (w)' 'ModRM:reg (r)' 'CL')
		#('MRI' 'ModRM:r/m (w)' 'ModRM:reg (r)' 'imm8')
		#('MVR' 'ModRM:r/m (w)' 'VEX.vvvv (r)' 'ModRM:reg (r)')
		#('NP' 'ModRM:r/m (w)' 'ModRM:reg (r)')
		#('O' 'opcode + rd (r, w)')
		#('OI' 'opcode + rd (w)' 'imm8/16/32/64')
		#('RM' 'ModRM:reg (r, w)' 'ModRM:r/m (r)')
		#('RM0' 'ModRM:reg (r, w)' 'ModRM:r/m (r)')
		#('RMI' 'ModRM:reg (w)' 'ModRM:r/m (r)' 'imm8')
		#('RMV' 'ModRM:reg (w)' 'ModRM:r/m (r)' 'VEX.vvvv (r)')
		#('RVM' 'ModRM:reg (w)' 'VEX.vvvv' 'ModRM:r/m (r)')
		#('RVMI' 'ModRM:reg (w)' 'VEX.vvvv (r)' 'ModRM:r/m (r)' 'imm8[3:0]')
		#('RVMR' 'ModRM:reg (w)' 'VEX.vvvv (r)' 'ModRM:r/m (r)' 'imm8[7:4]')
		#('T1S' 'ModRM:reg (w)' 'EVEX.vvvv' 'ModRM:r/m (r)')
		#('T1S-RVM' 'ModRM:reg (w)' 'EVEX.vvvv' 'ModRM:r/m (r)')
		#('TD' 'Moffs (w)' 'AL/AX/EAX/RAX')
		#('VM' 'VEX.vvvv (w)' 'ModRM:r/m (r)')
		#('VMI' 'VEX.vvvv (w)' 'ModRM:r/m (r)' 'imm8')
		#('XM' 'ModRM:reg (w)' 'ModRM:r/m (r)'))
! !

!OperandEncoding class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeEncodings
	Encodings := OrderedCollection new.
	self defs
		do: [ :def | 
			| oe n selectors |
			n := def first replaceAllSubstrings: '-' with: ''.
			oe := self new.
			selectors := (2 to: def size)
				collect: [ :i | ('encode' , n , 'Operand' , (i - 1) asString , ':') asSymbol ].
			oe
				name: n;
				selectors: selectors;
				descriptions: def allButFirst.
			selectors
				reject: [ :s | self includesSelector: s ]
				thenDo: [ :s | self compile: s , ' instruction' ].
			Encodings add: oe ].
	Encodings := Encodings asArray
! !

!OperandEncoding class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:40'!
named: aString
	^Encodings
		detect: [:e | e name = aString]
		ifNone: [(aString includes: $-) ifTrue: [self halt]]
! !


