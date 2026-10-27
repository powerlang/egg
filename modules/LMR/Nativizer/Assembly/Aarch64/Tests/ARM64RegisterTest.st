"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #ARM64RegisterTest,
	#superclass : #TestCase,
	#category : #'LMR.Nativizer.Assembly.Aarch64.Tests'
}

{ #category : #tests }
ARM64RegisterTest >> testGeneralRegisters [
	| registers |
	registers := ARM64Register registers.
	self
		assert: (registers at: #x5) index equals: 5;
		assert: (registers at: #x5) length equals: 64;
		assert: (registers at: #w5) index equals: 5;
		assert: (registers at: #w5) length equals: 32;
		assert: (registers at: #x5) isGeneral
]

{ #category : #tests }
ARM64RegisterTest >> testRegister31 [
	| registers |
	registers := ARM64Register registers.
	self
		assert: (registers at: #sp) index equals: 31;
		assert: (registers at: #sp) isSP;
		assert: (registers at: #xzr) index equals: 31;
		assert: (registers at: #xzr) isZero
]

{ #category : #tests }
ARM64RegisterTest >> testFloatRegisters [
	| registers |
	registers := ARM64Register registers.
	self
		assert: (registers at: #d3) isFloat;
		assert: (registers at: #d3) length equals: 64;
		assert: (registers at: #s3) length equals: 32
]

{ #category : #tests }
ARM64RegisterTest >> testABIUsesThePool [
	| abi |
	abi := AAPCS64ABI new.
	self
		assert: abi regR name equals: 'x0';
		assert: abi regSP isSP
]
