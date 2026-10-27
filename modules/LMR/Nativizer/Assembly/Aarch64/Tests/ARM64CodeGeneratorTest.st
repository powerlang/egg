"
	Copyright (c) 2026, Javier Pimás.
	See (MIT) license in root directory.
"

Class {
	#name : #ARM64CodeGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'codegen',
		'registers'
	],
	#category : #'LMR.Nativizer.Assembly.Aarch64.Tests'
}

{ #category : #running }
ARM64CodeGeneratorTest >> setUp [
	codegen := ARM64CodeGenerator new platform: NativizationPlatform aarch64_darwin.
	registers := ARM64Register registers
]

{ #category : #private }
ARM64CodeGeneratorTest >> x: index [
	^registers at: ('x' , index printString) asSymbol
]

{ #category : #private }
ARM64CodeGeneratorTest >> words [
	| bytes |
	bytes := codegen memory bytes.
	^(1 to: bytes size by: 4) collect: [:i |
		(bytes at: i) + ((bytes at: i + 1) bitShift: 8) + ((bytes at: i + 2) bitShift: 16) + ((bytes at: i + 3) bitShift: 24)]
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testLeadingZeroCount [
	codegen leadingRzeroCount.
	self assert: self words asArray equals: #(16rDAC01000)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testVariableShifts [
	codegen
		shiftLeft: (self x: 0) by: (self x: 3);
		shiftRightArithmetic: (self x: 0) by: (self x: 3).
	self assert: self words asArray equals: #(16r9AC32000 16r9AC32800)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testWideningMultiply [
	codegen multiply: (self x: 0) by: (self x: 1) wideningTo: (self x: 1).
	self
		assert: self words asArray
		equals: #(16r9B417C10 16r9B017C00 16rAA1003E1 16rEB80FC3F 16rFA5F03E1)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testDivide [
	codegen divide: (self x: 0) extendingTo: (self x: 1) by: (self x: 3).
	self assert: self words asArray equals: #(16r9AC30C10 16r9B038201 16rAA1003E0)
]
