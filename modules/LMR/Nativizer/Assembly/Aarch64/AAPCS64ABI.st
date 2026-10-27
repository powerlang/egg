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
		'regX0', 'regX1'
	],
	#category : #Aarch64
}

{ #category : #initialization }
AAPCS64ABI >> initialize [
	super initialize.
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
		push: self regL;
		saveCallerFrame;
		pushE;
		pushG;
		pushNil;
		pushTrue;
		pushFalse;
		pushM.
	self storeArgumentsInStack: anFFIDescriptor with: anAssembler
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

{ #category : #accessing }
AAPCS64ABI >> newAssembler [
	^GenericAssembler new
]

{ #category : #'registers - IR' }
AAPCS64ABI >> regA [
	^regA
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

