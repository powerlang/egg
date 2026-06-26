"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.

	An ARM64 memory operand describes an addressing mode for LDR/STR:
		[base, #displacement]              -- offset
		[base, indexReg, LSL #scaleShift]  -- register-indexed (scale must be log2 of length/8)
	`length` (the access width in bits, set by memRef8/16/32/64) determines
	which LDR/STR variant to emit.
"
Class {
	#name : #ARM64MemoryOperand,
	#superclass : #Object,
	#instVars : [
		'base',
		'index',
		'displacement',
		'scale',
		'length'
	],
	#category : #Aarch64
}

{ #category : #accessing }
ARM64MemoryOperand >> base [
	^base
]

{ #category : #accessing }
ARM64MemoryOperand >> base: aRegister [
	base := aRegister
]

{ #category : #accessing }
ARM64MemoryOperand >> displacement [
	^displacement ifNil: [0]
]

{ #category : #accessing }
ARM64MemoryOperand >> displacement: anInteger [
	displacement := anInteger
]

{ #category : #accessing }
ARM64MemoryOperand >> index [
	^index
]

{ #category : #accessing }
ARM64MemoryOperand >> index: aRegister [
	index := aRegister
]

{ #category : #accessing }
ARM64MemoryOperand >> length [
	^length ifNil: [64]
]

{ #category : #accessing }
ARM64MemoryOperand >> length: bits [
	length := bits
]

{ #category : #accessing }
ARM64MemoryOperand >> scale [
	^scale ifNil: [1]
]

{ #category : #accessing }
ARM64MemoryOperand >> scale: anInteger [
	scale := anInteger
]
