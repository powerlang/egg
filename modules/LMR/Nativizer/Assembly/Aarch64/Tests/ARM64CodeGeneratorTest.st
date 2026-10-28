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

{ #category : #private }
ARM64CodeGeneratorTest >> d: index [
	^registers at: ('d' , index printString) asSymbol
]

{ #category : #private }
ARM64CodeGeneratorTest >> x1Plus8 [
	^codegen memRef base: (self x: 1); displacement: 8; yourself
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testDoubleArithmetic [
	codegen
		addDouble: (self d: 1) to: (self d: 0);
		subDouble: (self d: 1) from: (self d: 0);
		mulDouble: (self d: 0) by: (self d: 1);
		divDouble: (self d: 0) by: (self d: 1);
		sqrtDouble: (self d: 0) into: (self d: 1);
		roundDouble: (self d: 1) into: (self d: 0).
	self
		assert: self words asArray
		equals: #(16r1E612800 16r1E613800 16r1E610800 16r1E611800 16r1E61C020 16r1E65C020)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testDoubleMoves [
	codegen
		convert: (self x: 1) toDouble: (self d: 0);
		moveDouble: (self x: 1) into: (self d: 0);
		moveDouble: (self d: 0) into: (self x: 1);
		moveDouble: (self d: 1) into: (self d: 0).
	self
		assert: self words asArray
		equals: #(16r9E620020 16r9E670020 16r9E660001 16r1E604020)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testDoubleMemory [
	codegen
		loadDouble: (self d: 0) fromMem: self x1Plus8;
		storeDouble: (self d: 0) intoMem: self x1Plus8;
		load: (self x: 0) convertingDoubleToIntegerFromMem: self x1Plus8.
	self
		assert: self words asArray
		equals: #(16rFD400420 16rFD000420 16rFD40043F 16r9E7803E0)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testDoubleCompares [
	codegen
		compareEqualDoubleX0withAindirect;
		compareLessThanDoubleX0withAindirect.
	self
		assert: self words asArray
		equals: #(16rFD400030 16r5E70E400 16rFD400030 16r7EE0E600)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testScaleFloat [
	codegen scaleFloatOnRWithA.
	self
		assert: self words asArray
		equals: #(16rFD400030 16r9E780210 16r92810671 16rEB11021F 16r9A90B230 16rD2810691 16rEB11021F 16r9A90C230
			16r9342FE11 16rCB110210 16rCB110210 16rCB110210 16r910FFE31 16rD34C2E31 16r9E670231 16r910FFE10
			16rD34C2E10 16r9E670212 16rFD400010 16r1E710A10 16r1E710A10 16r1E710A10 16r1E720A10 16rFD000010)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testLeaKeepsTheFlags [
	codegen lea: (self x: 0) withMem: self x1Plus8.
	self assert: self words asArray equals: #(16rAA0103E0 16r91002000)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testWriteTslots [
	codegen writeTslots.
	self
		assert: self words asArray
		equals: #(16rB4000083 16rF8008680 16rF1000463 16r54FFFFC1)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testMoveTslots [
	codegen moveTslots.
	self
		assert: self words asArray
		equals: #(16rB40000A3 16rF8408450 16rF8008690 16rF1000463 16r54FFFFA1)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testPushMem [
	| memory |
	memory := codegen memRef base: (self x: 1); displacement: 8; yourself.
	codegen pushMem: memory.
	self assert: self words asArray equals: #(16rF9400430 16rF81F0FF0)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testExchange [
	| memory |
	memory := codegen memRef base: (self x: 1); displacement: 16; yourself.
	codegen exchange: (self x: 3) withMem: memory.
	self
		assert: self words asArray
		equals: #(16rAA0103F0 16r91004210 16rF8E38203)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testLeaFarDisplacement [
	| memory |
	memory := codegen memRef base: (self x: 1); displacement: 5000; yourself.
	codegen lea: (self x: 0) withMem: memory.
	self assert: self words asArray equals: #(16rAA0103E0 16rD2827111 16r8B110000)
]

{ #category : #tests }
ARM64CodeGeneratorTest >> testFrameSlots [
	| frame above below |
	frame := self x: 29.
	above := codegen memRef: frame stackIndexImm: 3.
	below := codegen memRef: frame stackIndexImm: -2.
	codegen
		load: (self x: 0) fromMem: above;
		store: (self x: 1) intoMem: below.
	self assert: self words asArray equals: #(16rF94013A0 16rF81D03A1)
]
