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
	  regV  (extra scratch)               -> x4
	  regM  (current method, callee-save) -> x19
	  regE  (current environment)         -> x20
	  regG  (globals base)                -> x21
	  regNil                              -> x22
	  regTrue                             -> x23
	  regFalse                            -> x24
	  regFP (frame pointer)               -> x29
	  regSP (stack pointer)               -> sp (encoded as 31 in addressing)
	  regIP (current PC)                  -> the special PC (read-only)
	  regX0 / regX1 (xmm0/1 analogs)      -> v0 / v1 (FP/SIMD)

	Register accessors return a stable instance (the allocator keys on
	identity), so they are built once in #initialize.
"
Class {
	#name : #AAPCS64ABI,
	#superclass : #ABI,
	#instVars : [
		'regR', 'regA', 'regS', 'regT', 'regV',
		'regM', 'regE', 'regG',
		'regNil', 'regTrue', 'regFalse',
		'regFP', 'regSP', 'regIP',
		'regX0', 'regX1'
	],
	#category : #Aarch64
}

{ #category : #initialization }
AAPCS64ABI >> initialize [
	super initialize.
	regR     := ARM64Register name: 'x0'  index: 0  length: 64.
	regA     := ARM64Register name: 'x1'  index: 1  length: 64.
	regS     := ARM64Register name: 'x2'  index: 2  length: 64.
	regT     := ARM64Register name: 'x3'  index: 3  length: 64.
	regV     := ARM64Register name: 'x4'  index: 4  length: 64.
	regM     := ARM64Register name: 'x19' index: 19 length: 64.
	regE     := ARM64Register name: 'x20' index: 20 length: 64.
	regG     := ARM64Register name: 'x21' index: 21 length: 64.
	regNil   := ARM64Register name: 'x22' index: 22 length: 64.
	regTrue  := ARM64Register name: 'x23' index: 23 length: 64.
	regFalse := ARM64Register name: 'x24' index: 24 length: 64.
	regFP    := ARM64Register name: 'x29' index: 29 length: 64.
	regSP    := ARM64Register name: 'sp'  index: 31 length: 64.
	regIP    := ARM64Register name: 'pc'  index: -1 length: 64.
	regX0    := ARM64Register name: 'v0'  index: 0  length: 128.
	regX1    := ARM64Register name: 'v1'  index: 1  length: 128
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
AAPCS64ABI >> regIP [
	^regIP
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

