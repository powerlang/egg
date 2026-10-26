"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #ARM64InstructionSpecTest,
	#superclass : #TestCase,
	#category : #'LMR.Nativizer.Assembly.Aarch64.Tests'
}

{ #category : #private }
ARM64InstructionSpecTest >> encode: mnemonic with: operands [
	^ARM64InstructionSpec encode: mnemonic with: operands
]

{ #category : #private }
ARM64InstructionSpecTest >> x: index [
	^ARM64Register name: 'x' , index printString index: index length: 64
]

{ #category : #private }
ARM64InstructionSpecTest >> sp [
	^ARM64Register name: 'sp' index: 31 length: 64
]

{ #category : #tests }
ARM64InstructionSpecTest >> testRegisters [
	self
		assert: (self encode: 'add' with: {self x: 0. self x: 1. self x: 2})
		equals: 16r8B020020
]

{ #category : #tests }
ARM64InstructionSpecTest >> testStackPointer [
	self
		assert: (self encode: 'add' with: {self sp. self sp. 16})
		equals: 16r910043FF
]

{ #category : #tests }
ARM64InstructionSpecTest >> testScaledOffset [
	self
		assert: (self encode: 'ldr' with: {self x: 0. self x: 1. 8})
		equals: 16rF9400420
]

{ #category : #tests }
ARM64InstructionSpecTest >> testSignedOffset [
	self
		assert: (self encode: 'ldur' with: {self x: 0. self x: 1. -8})
		equals: 16rF85F8020;
		assert: (self encode: 'ldur' with: {self x: 0. self x: 1. 3})
		equals: 16rF8403020
]

{ #category : #tests }
ARM64InstructionSpecTest >> testPreIndex [
	self
		assert: (self encode: 'str.pre' with: {self x: 0. self sp. -16})
		equals: 16rF81F0FE0
]

{ #category : #tests }
ARM64InstructionSpecTest >> testIndexRegister [
	self
		assert: (self encode: 'str' with: {self x: 0. self x: 1. self x: 2})
		equals: 16rF8227820
]

{ #category : #tests }
ARM64InstructionSpecTest >> testPostIndex [
	self
		assert: (self encode: 'ldr.post' with: {self x: 0. self sp. 16})
		equals: 16rF84107E0
]

{ #category : #tests }
ARM64InstructionSpecTest >> testAddressOfHere [
	self
		assert: (self encode: 'adr' with: {self x: 16})
		equals: 16r10000010
]

{ #category : #tests }
ARM64InstructionSpecTest >> testBitmaskImmediate [
	self
		assert: (self encode: 'orr' with: {self x: 0. self x: 1. 16rFF})
		equals: 16rB2401C20;
		assert: (self encode: 'orr' with: {self x: 0. self x: 1. 16rFFFFFFFF00000000})
		equals: 16rB2607C20;
		assert: (self encode: 'orr' with: {self x: 0. self x: 1. 16r5555555555555555})
		equals: 16rB200F020;
		assert: (self encode: 'tst' with: {self x: 2. 16r8000000000000000})
		equals: 16rF241005F;
		should: [self encode: 'orr' with: {self x: 0. self x: 1. 16r12345}] raise: Error
]

{ #category : #tests }
ARM64InstructionSpecTest >> testShiftedImmediate [
	self
		assert: (self encode: 'movz' with: {self x: 3. 16r1234. 16})
		equals: 16rD2A24683
]

{ #category : #tests }
ARM64InstructionSpecTest >> testConditions [
	self
		assert: (self encode: 'b.cond' with: #(lt 8))
		equals: 16r5400004B;
		assert: (self encode: 'ccmp' with: {self x: 1. self x: 2. 1. #eq})
		equals: 16rFA420021
]

{ #category : #tests }
ARM64InstructionSpecTest >> testSymbolOperand [
	self
		assert: (self encode: 'mrs' with: {self x: 5. #FPSR})
		equals: 16rD53B4425
]

{ #category : #tests }
ARM64InstructionSpecTest >> testRejectsWhatDoesNotFit [
	self
		should: [self encode: 'ldr' with: {self x: 0. self x: 1. 3}] raise: Error;
		should: [self encode: 'b.cond' with: #(13 8)] raise: Error
]
