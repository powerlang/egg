"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.

	An encoding of an A64 instruction, read from the table in #encodings,
	which follows the notation of the Arm Architecture Reference Manual:
	the syntax of the instruction, a tab, and its 32 bits from bit 31 down,
	as fixed 0s and 1s and named fields (Rd:5, imm12:12, ...).

	Operands in the syntax name the field they go to: a register Xd goes to
	Rd, an immediate #imm12 to imm12. #imm12*8 is a byte offset encoded
	divided by 8, #simm9 a signed field imm9, Xn|SP takes sp where Xn takes
	xzr (both are register 31), and FPSR or other capitalized words are
	operands given as symbols, which encode nothing. Constants, like the #3
	of LSL #3, are fixed bits and not operands. Brackets only document
	the addressing mode; pre- and post-indexed forms are named .pre and .post.
	Where more than one encoding takes the same operands, the first one is used.
"

Class {
	#name : #ARM64InstructionSpec,
	#superclass : #Object,
	#instVars : [
		'syntax',
		'mnemonic',
		'opcode',
		'operands'
	],
	#classVars : [
		'Specs'
	],
	#category : #Aarch64
}

{ #category : #encoding }
ARM64InstructionSpec class >> encode: mnemonic with: operands [
	| spec |
	spec := (Specs at: mnemonic ifAbsent: [#()])
		detect: [:s | s matches: operands]
		ifNone: [^self error: 'no A64 encoding of ' , mnemonic , ' for ' , operands printString].
	^spec encode: operands
]

{ #category : #initialization }
ARM64InstructionSpec class >> initialize [
	Specs := Dictionary new.
	self encodings lines do: [:line | | spec |
		spec := self fromLine: line.
		(Specs at: spec mnemonic ifAbsentPut: [OrderedCollection new]) add: spec]
]

{ #category : #'instance creation' }
ARM64InstructionSpec class >> fromLine: aString [
	| tab syntax bits |
	tab := aString indexOf: Character tab.
	syntax := aString copyFrom: 1 to: tab - 1.
	bits := aString copyFrom: tab + 1.
	^self new syntax: syntax bits: bits
]

{ #category : #documentation }
ARM64InstructionSpec class >> encodings [
	^'ADD Xd, Xn, Xm	1 0 0 01011 00 0 Rm:5 000000 Rn:5 Rd:5
ADD Xd, Xn, Xm, LSL #imm6	1 0 0 01011 00 0 Rm:5 imm6:6 Rn:5 Rd:5
ADD Xd|SP, Xn|SP, Xm	1 0 0 01011 00 1 Rm:5 011 000 Rn:5 Rd:5
ADD Xd|SP, Xn|SP, #imm12	1 0 0 100010 0 imm12:12 Rn:5 Rd:5
ADD Xd|SP, Xn|SP, #imm12*4096	1 0 0 100010 1 imm12:12 Rn:5 Rd:5
ADDS Xd, Xn, Xm	1 0 1 01011 00 0 Rm:5 000000 Rn:5 Rd:5
ADDS Xd, Xn|SP, #imm12	1 0 1 100010 0 imm12:12 Rn:5 Rd:5
SUB Xd, Xn, Xm	1 1 0 01011 00 0 Rm:5 000000 Rn:5 Rd:5
SUB Xd|SP, Xn|SP, Xm	1 1 0 01011 00 1 Rm:5 011 000 Rn:5 Rd:5
SUB Xd|SP, Xn|SP, #imm12	1 1 0 100010 0 imm12:12 Rn:5 Rd:5
SUB Xd|SP, Xn|SP, #imm12*4096	1 1 0 100010 1 imm12:12 Rn:5 Rd:5
SUBS Xd, Xn, Xm	1 1 1 01011 00 0 Rm:5 000000 Rn:5 Rd:5
SUBS Xd, Xn|SP, #imm12	1 1 1 100010 0 imm12:12 Rn:5 Rd:5
CMP Xn, Xm	1 1 1 01011 00 0 Rm:5 000000 Rn:5 11111
CMP Xn, Xm, ASR #imm6	1 1 1 01011 10 0 Rm:5 imm6:6 Rn:5 11111
CMP Xn|SP, #imm12	1 1 1 100010 0 imm12:12 Rn:5 11111
CCMP Xn, Xm, #nzcv, cond	1 1 1 11010010 Rm:5 cond:4 0 0 Rn:5 0 nzcv:4
CSEL Xd, Xn, Xm, cond	1 0 0 11010100 Rm:5 cond:4 0 0 Rn:5 Rd:5
AND Xd, Xn, Xm	1 00 01010 00 0 Rm:5 000000 Rn:5 Rd:5
ORR Xd, Xn, Xm	1 01 01010 00 0 Rm:5 000000 Rn:5 Rd:5
ORR Xd, Xn, Xm, LSL #imm6	1 01 01010 00 0 Rm:5 imm6:6 Rn:5 Rd:5
ORR Xd|SP, Xn, #bimm	1 01 100100 N:1 immr:6 imms:6 Rn:5 Rd:5
EOR Xd, Xn, Xm	1 10 01010 00 0 Rm:5 000000 Rn:5 Rd:5
ANDS Xd, Xn, Xm	1 11 01010 00 0 Rm:5 000000 Rn:5 Rd:5
TST Xn, Xm	1 11 01010 00 0 Rm:5 000000 Rn:5 11111
TST Xn, #bimm	1 11 100100 N:1 immr:6 imms:6 Rn:5 11111
MOV Xd, Xm	1 01 01010 00 0 Rm:5 000000 11111 Rd:5
MOV Xd|SP, Xn|SP	1 0 0 100010 0 000000000000 Rn:5 Rd:5
MOVN Xd, #imm16, LSL #hw*16	1 00 100101 hw:2 imm16:16 Rd:5
MOVZ Xd, #imm16, LSL #hw*16	1 10 100101 hw:2 imm16:16 Rd:5
MOVK Xd, #imm16, LSL #hw*16	1 11 100101 hw:2 imm16:16 Rd:5
SBFM Xd, Xn, #immr, #imms	1 00 100110 1 immr:6 imms:6 Rn:5 Rd:5
BFM Xd, Xn, #immr, #imms	1 01 100110 1 immr:6 imms:6 Rn:5 Rd:5
UBFM Xd, Xn, #immr, #imms	1 10 100110 1 immr:6 imms:6 Rn:5 Rd:5
SDIV Xd, Xn, Xm	1 0 0 11010110 Rm:5 000011 Rn:5 Rd:5
LSLV Xd, Xn, Xm	1 0 0 11010110 Rm:5 001000 Rn:5 Rd:5
LSRV Xd, Xn, Xm	1 0 0 11010110 Rm:5 001001 Rn:5 Rd:5
ASRV Xd, Xn, Xm	1 0 0 11010110 Rm:5 001010 Rn:5 Rd:5
CLZ Xd, Xn	1 1 0 11010110 00000 000100 Rn:5 Rd:5
MUL Xd, Xn, Xm	1 00 11011 000 Rm:5 0 11111 Rn:5 Rd:5
MSUB Xd, Xn, Xm, Xa	1 00 11011 000 Rm:5 1 Ra:5 Rn:5 Rd:5
SMULH Xd, Xn, Xm	1 00 11011 010 Rm:5 0 11111 Rn:5 Rd:5
ADR Xd	0 00 10000 0000000000000000000 Rd:5
B #simm26*4	0 00101 imm26:26
B.cond cond, #simm19*4	0101010 0 imm19:19 0 cond:4
CBZ Xt, #simm19*4	1 011010 0 imm19:19 Rt:5
CBNZ Xt, #simm19*4	1 011010 1 imm19:19 Rt:5
BR Xn	1101011 0 0 00 11111 000000 Rn:5 00000
BLR Xn	1101011 0 0 01 11111 000000 Rn:5 00000
RET Xn	1101011 0 0 10 11111 000000 Rn:5 00000
LDRB Wt, [Xn|SP, #imm12]	00 111 0 01 01 imm12:12 Rn:5 Rt:5
LDRH Wt, [Xn|SP, #imm12*2]	01 111 0 01 01 imm12:12 Rn:5 Rt:5
LDR Wt, [Xn|SP, #imm12*4]	10 111 0 01 01 imm12:12 Rn:5 Rt:5
LDR Xt, [Xn|SP, #imm12*8]	11 111 0 01 01 imm12:12 Rn:5 Rt:5
LDR Dt, [Xn|SP, #imm12*8]	11 111 1 01 01 imm12:12 Rn:5 Rt:5
LDURB Wt, [Xn|SP, #simm9]	00 111 0 00 01 0 imm9:9 00 Rn:5 Rt:5
LDURH Wt, [Xn|SP, #simm9]	01 111 0 00 01 0 imm9:9 00 Rn:5 Rt:5
LDUR Wt, [Xn|SP, #simm9]	10 111 0 00 01 0 imm9:9 00 Rn:5 Rt:5
LDUR Xt, [Xn|SP, #simm9]	11 111 0 00 01 0 imm9:9 00 Rn:5 Rt:5
LDUR Dt, [Xn|SP, #simm9]	11 111 1 00 01 0 imm9:9 00 Rn:5 Rt:5
LDR St, [Xn|SP, #imm12*4]	10 111 1 01 01 imm12:12 Rn:5 Rt:5
LDUR St, [Xn|SP, #simm9]	10 111 1 00 01 0 imm9:9 00 Rn:5 Rt:5
LDRB Wt, [Xn|SP, Xm]	00 111 0 00 01 1 Rm:5 011 0 10 Rn:5 Rt:5
LDR Xt, [Xn|SP, Xm, LSL #3]	11 111 0 00 01 1 Rm:5 011 1 10 Rn:5 Rt:5
LDR.post Xt, [Xn|SP], #simm9	11 111 0 00 01 0 imm9:9 01 Rn:5 Rt:5
LDR Wt, #simm19*4	00 011 0 00 imm19:19 Rt:5
STRB Wt, [Xn|SP, #imm12]	00 111 0 01 00 imm12:12 Rn:5 Rt:5
STRH Wt, [Xn|SP, #imm12*2]	01 111 0 01 00 imm12:12 Rn:5 Rt:5
STR Wt, [Xn|SP, #imm12*4]	10 111 0 01 00 imm12:12 Rn:5 Rt:5
STR Xt, [Xn|SP, #imm12*8]	11 111 0 01 00 imm12:12 Rn:5 Rt:5
STR Dt, [Xn|SP, #imm12*8]	11 111 1 01 00 imm12:12 Rn:5 Rt:5
STURB Wt, [Xn|SP, #simm9]	00 111 0 00 00 0 imm9:9 00 Rn:5 Rt:5
STURH Wt, [Xn|SP, #simm9]	01 111 0 00 00 0 imm9:9 00 Rn:5 Rt:5
STUR Wt, [Xn|SP, #simm9]	10 111 0 00 00 0 imm9:9 00 Rn:5 Rt:5
STUR Xt, [Xn|SP, #simm9]	11 111 0 00 00 0 imm9:9 00 Rn:5 Rt:5
STUR Dt, [Xn|SP, #simm9]	11 111 1 00 00 0 imm9:9 00 Rn:5 Rt:5
STR St, [Xn|SP, #imm12*4]	10 111 1 01 00 imm12:12 Rn:5 Rt:5
STUR St, [Xn|SP, #simm9]	10 111 1 00 00 0 imm9:9 00 Rn:5 Rt:5
STR Xt, [Xn|SP, Xm, LSL #3]	11 111 0 00 00 1 Rm:5 011 1 10 Rn:5 Rt:5
STR.post Xt, [Xn|SP], #simm9	11 111 0 00 00 0 imm9:9 01 Rn:5 Rt:5
STR.pre Xt, [Xn|SP, #simm9]!	11 111 0 00 00 0 imm9:9 11 Rn:5 Rt:5
LDR.pre Xt, [Xn|SP, #simm9]!	11 111 0 00 01 0 imm9:9 11 Rn:5 Rt:5
SWPAL Xs, Xt, [Xn|SP]	11 111 0 00 1 1 1 Rs:5 1 000 00 Rn:5 Rt:5
FADD Dd, Dn, Dm	0 0 0 11110 01 1 Rm:5 001010 Rn:5 Rd:5
FSUB Dd, Dn, Dm	0 0 0 11110 01 1 Rm:5 001110 Rn:5 Rd:5
FMUL Dd, Dn, Dm	0 0 0 11110 01 1 Rm:5 000010 Rn:5 Rd:5
FDIV Dd, Dn, Dm	0 0 0 11110 01 1 Rm:5 000110 Rn:5 Rd:5
FSQRT Dd, Dn	0 0 0 11110 01 1 000011 10000 Rn:5 Rd:5
FRINTZ Dd, Dn	0 0 0 11110 01 1 001011 10000 Rn:5 Rd:5
FMOV Dd, Dn	0 0 0 11110 01 1 000000 10000 Rn:5 Rd:5
FMOV Xd, Dn	1 0 0 11110 01 1 00 110 000000 Rn:5 Rd:5
FMOV Dd, Xn	1 0 0 11110 01 1 00 111 000000 Rn:5 Rd:5
SCVTF Dd, Xn	1 0 0 11110 01 1 00 010 000000 Rn:5 Rd:5
FCVTZS Xd, Dn	1 0 0 11110 01 1 11 000 000000 Rn:5 Rd:5
FCVT Sd, Dn	0 0 0 11110 01 1 000100 10000 Rn:5 Rd:5
FCVT Dd, Sn	0 0 0 11110 00 1 000101 10000 Rn:5 Rd:5
FCMEQ Dd, Dn, Dm	01 0 11110 0 1 1 Rm:5 11100 1 Rn:5 Rd:5
FCMGT Dd, Dn, Dm	01 1 11110 1 1 1 Rm:5 11100 1 Rn:5 Rd:5
MRS Xt, FPSR	110101010011101101000100001 Rt:5
MSR FPSR, Xt	110101010001101101000100001 Rt:5
NOP	11010101000000110010000000011111
BRK #imm16	11010100 001 imm16:16 000 00'
]

{ #category : #accessing }
ARM64InstructionSpec >> mnemonic [
	^mnemonic
]

{ #category : #parsing }
ARM64InstructionSpec >> syntax: syntaxString bits: bitsString [
	| fields rest |
	syntax := syntaxString.
	mnemonic := syntaxString substrings first asLowercase.
	fields := self parseBits: bitsString.
	rest := syntaxString copyFrom: mnemonic size + 1.
	operands := self operandsIn: rest fields: fields
]

{ #category : #parsing }
ARM64InstructionSpec >> parseBits: aString [
	| fields position |
	opcode := 0.
	fields := Dictionary new.
	position := 32.
	aString substrings do: [:token | position := self parse: token endingAt: position into: fields].
	position = 0 ifFalse: [self error: 'A64 encoding of ' , syntax , ' is not 32 bits wide'].
	^fields
]

{ #category : #parsing }
ARM64InstructionSpec >> parse: token endingAt: end into: fields [
	| colon width position bits name field |
	colon := token indexOf: $:.
	colon = 0 ifTrue: [
		position := end - token size.
		bits := Integer readFrom: token readStream radix: 2.
		opcode := opcode bitOr: (bits bitShift: position).
		^position].
	width := (token copyFrom: colon + 1) asInteger.
	position := end - width.
	name := token copyFrom: 1 to: colon - 1.
	field := ARM64Field at: position width: width.
	fields at: name put: field.
	^position
]

{ #category : #parsing }
ARM64InstructionSpec >> operandsIn: aString fields: aDictionary [
	| clean names |
	clean := aString reject: [:c | c = $[ or: [c = $] or: [c = $!]]].
	clean trimBlanks isEmpty ifTrue: [^#()].
	names := (clean substringsSplitBy: $,) collect: [:token | token substrings last].
	names := names reject: [:name | name first = $# and: [(name at: 2) isDigit]].
	^(names collect: [:name | ARM64OperandSpec fromToken: name fields: aDictionary]) asArray
]

{ #category : #encoding }
ARM64InstructionSpec >> matches: anArray [
	anArray size = operands size ifFalse: [^false].
	operands with: anArray do: [:spec :operand | (spec accepts: operand) ifFalse: [^false]].
	^true
]

{ #category : #encoding }
ARM64InstructionSpec >> encode: anArray [
	| word |
	word := opcode.
	operands with: anArray do: [:spec :operand | | bits |
		bits := spec encode: operand.
		word := word bitOr: bits].
	^word
]

{ #category : #printing }
ARM64InstructionSpec >> printOn: aStream [
	aStream nextPutAll: syntax
]
