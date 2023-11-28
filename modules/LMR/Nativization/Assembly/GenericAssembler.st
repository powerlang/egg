"
I am a JIT GenericAssembler frontend that can generate code for different architectures
using different code generators.
"
Class {
	#name : #GenericAssembler,
	#superclass : #Assembler,
	#instVars : [
		'codegen'
	],
	#category : #'Powerlang-Core-Assembly'
}

{ #category : #'operations - arithmetic' }
GenericAssembler >> add: source1 to: source2andDest [
	codegen add: source1 to: source2andDest
]

{ #category : #arithmetic }
GenericAssembler >> addAtoR [
	codegen add: codegen regA to: codegen regR
]

{ #category : #arithmetic }
GenericAssembler >> addDoubleX1toX0 [
	codegen addDouble: codegen regX1 to: codegen regX0

]

{ #category : #'operations - arithmetic' }
GenericAssembler >> addImm: imm to: dest [
	codegen addImm: imm to: dest
]

{ #category : #arithmetic }
GenericAssembler >> addRwithImmediate: imm [
	codegen addImm: imm to: codegen regR 
]

{ #category : #logic }
GenericAssembler >> addSPwithImmediate: imm [
	codegen addImm: imm to: codegen regSP
]

{ #category : #arithmetic }
GenericAssembler >> addTtoR [
	codegen add: codegen regT to: codegen regR
]

{ #category : #logic }
GenericAssembler >> addTwithImmediate: imm [
	codegen addImm: imm to: codegen regT
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> alignTo: anInteger [
	codegen alignTo: anInteger
]

{ #category : #'operations - logical' }
GenericAssembler >> and: source1andDest with: source2 [
	codegen and: source1andDest with: source2
]

{ #category : #'operations - logical' }
GenericAssembler >> and: source1andDest withImm: imm [
	codegen and: source1andDest withImm: imm
]

{ #category : #logic }
GenericAssembler >> andRwithA [
	codegen and: codegen regR with: codegen regA
]

{ #category : #arithmetic }
GenericAssembler >> andRwithImmediate: imm [
	codegen and: codegen regR withImm: imm
]

{ #category : #relocation }
GenericAssembler >> applyFixups [
	codegen memory applyFixupsWith: self
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> breakpoint [
	codegen breakpoint
]

{ #category : #private }
GenericAssembler >> buildFrame [
	self
		push: codegen regFP;
		move: codegen regSP to: codegen regFP
]

{ #category : #private }
GenericAssembler >> bytes [
	^codegen bytes
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> callIndirectA [
	| memref |
	memref := codegen memRef: codegen regA indexImm: 1.
	codegen callIndirect: memref
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> callIndirectM [
	| memref |
	memref := codegen memRef: codegen regM indexImm: 1.
	codegen callIndirect: memref
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> callR [
	codegen call: codegen regR
]

{ #category : #'to-cleanup' }
GenericAssembler >> clearFPUFlags [
	codegen clearFPUFlags
]

{ #category : #'push/pop' }
GenericAssembler >> clearRhigh32 [
	codegen clearHigh32: codegen regR

]

{ #category : #'operations - arithmetic' }
GenericAssembler >> clearRintegerBit [
	self dec: codegen regR
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> clearSafeRintegerBit [
	self clearSafeIntegerBit: codegen regR
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compare: reg1 with: reg2 [
	codegen compare: reg1 with: reg2
]

{ #category : #comparing }
GenericAssembler >> compare: register withBoolean: aBoolean [
	aBoolean
		ifTrue: [ self compareWithTrue: register ]
		ifFalse: [ self compareWithFalse: register ]
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compare: register withLiteral: anObject [
	| index memref |
	index := self addLiteral: anObject.
	memref := codegen memRef: codegen regM indexImm: index.
	codegen compare: register withMem: memref
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareAwithFalse [
	codegen compare: codegen regA with: codegen regFalse
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareAwithTrue [
	codegen compare: codegen regA with: codegen regTrue
]

{ #category : #'to-cleanup' }
GenericAssembler >> compareEqualDoubleX0withAindirect [
	codegen compareEqualDoubleX0withAindirect
]

{ #category : #'to-cleanup' }
GenericAssembler >> compareLessThanDoubleX0withAindirect [
	codegen compareLessThanDoubleX0withAindirect
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareRwithA [
	codegen compare: codegen regR with: codegen regA
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareRwithFalse [
	codegen compare: codegen regR with: codegen regFalse
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareRwithImmediate: imm [
	codegen compare: codegen regR withImm: imm
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareRwithNil [
	codegen compare: codegen regR with: codegen regNil
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareRwithTrue [
	codegen compare: codegen regR with: codegen regTrue
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareSwithTindex: index [
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen compare: codegen regS withMem: memref
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareTwithA [
	codegen compare: codegen regT with: codegen regA
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareTwithImmediate: imm [
	codegen compare: codegen regT withImm: imm
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareWithFalse: register [
	codegen compare: register with: codegen regFalse
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareWithNil: register [
	codegen compare: register with: codegen regNil
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> compareWithTrue: register [
	codegen compare: register with: codegen regTrue
]

{ #category : #arithmetic }
GenericAssembler >> convertAtoNativeInteger [
	self convertToNativeInteger: codegen regA
	
]

{ #category : #arithmetic }
GenericAssembler >> convertRtoNativeInteger [
	self convertToNativeInteger: codegen regR
	
]

{ #category : #arithmetic }
GenericAssembler >> convertRtoSmallInteger [
	self convertToSmallInteger: codegen regR
]

{ #category : #arithmetic }
GenericAssembler >> convertToNativeInteger: srcAndDstReg [
	codegen shiftRightArithmetic: srcAndDstReg byImm: 1
]

{ #category : #arithmetic }
GenericAssembler >> convertTtoNativeInteger [
	self convertToNativeInteger: codegen regT
]

{ #category : #services }
GenericAssembler >> currentAddress [
	^ codegen currentAddress
]

{ #category : #'push/pop' }
GenericAssembler >> dec: srcAndDstReg [
	codegen dec: srcAndDstReg
]

{ #category : #private }
GenericAssembler >> decRindirect [
	| memref |
	memref := codegen memRef: codegen regR indexImm: 1.
	codegen decMem: memref
]

{ #category : #private }
GenericAssembler >> discardArguments: anInteger [
	anInteger = 0 ifTrue: [^self].
	codegen addImm: anInteger * codegen wordSize to: codegen regSP
]

{ #category : #'floting point' }
GenericAssembler >> divideDoubleX0byX1 [
	codegen divDouble: codegen regX0 by: codegen regX1
]

{ #category : #'to-cleanup' }
GenericAssembler >> dropTopOfFPU [
	codegen dropTopOfFPU
]

{ #category : #'push/pop' }
GenericAssembler >> dropTos: count [
	codegen addImm: (count * codegen addressSize) to: codegen regSP
]

{ #category : #arithmetic }
GenericAssembler >> exchangeRindirectWithT [
	| memref |
	memref := codegen memRef: codegen regR indexImm: 1.
	codegen exchange: codegen regT withMem: memref
]

{ #category : #storing }
GenericAssembler >> extendRtoAandDividebyT [
	codegen divide: codegen regR extendingTo: codegen regA by: codegen regT
]

{ #category : #'push/pop' }
GenericAssembler >> inc: srcAndDstReg [
	codegen inc: srcAndDstReg
]

{ #category : #'push/pop' }
GenericAssembler >> initializeS [
	codegen move: codegen regR to: codegen regS
]

{ #category : #jumps }
GenericAssembler >> jumpIfEqualTo: label [
	codegen jumpIfEqualTo: label
]

{ #category : #jumps }
GenericAssembler >> jumpIfGreaterOrEqualSignedTo: label [
	codegen jumpIfGreaterOrEqualSignedTo: label
]

{ #category : #jumps }
GenericAssembler >> jumpIfGreaterSignedTo: label [
	codegen jumpIfGreaterSignedTo: label
]

{ #category : #jumps }
GenericAssembler >> jumpIfLessOrEqualSignedTo: label [
	codegen jumpIfLessOrEqualSignedTo: label
]

{ #category : #jumps }
GenericAssembler >> jumpIfLessSignedTo: label [
	codegen jumpIfLessSignedTo: label
]

{ #category : #jumps }
GenericAssembler >> jumpIfNotEqualTo: label [
	codegen jumpIfNotEqualTo: label
]

{ #category : #jumps }
GenericAssembler >> jumpIfNotZeroTo: label [
	codegen jumpIfNotZeroTo: label
]

{ #category : #jumps }
GenericAssembler >> jumpIfOverflowTo: label [
	codegen jumpIfOverflowTo: label
]

{ #category : #jumps }
GenericAssembler >> jumpIfSignTo: label [
	codegen jumpIfSignTo: label
]

{ #category : #jumps }
GenericAssembler >> jumpIfZeroTo: label [
	codegen jumpIfZeroTo: label
]

{ #category : #accessing }
GenericAssembler >> jumpTo: label [
	codegen jumpTo: label
]

{ #category : #accessing }
GenericAssembler >> jumpToMindex: index [
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen jumpToMem: memref
]

{ #category : #integers }
GenericAssembler >> labeledIntegerBitTestOfR [
	^self labeledIntegerBitTestOf: codegen regR
]

{ #category : #integers }
GenericAssembler >> labeledIntegerBitTestOfT [
	^self labeledIntegerBitTestOf: codegen regT byte
]

{ #category : #integers }
GenericAssembler >> labeledIntegerNativizationOfA [
	^self labeledIntegerNativizationOf: codegen regA
]

{ #category : #integers }
GenericAssembler >> labeledIntegerNativizationOfR [
	^self labeledIntegerNativizationOf: codegen regR
]

{ #category : #integers }
GenericAssembler >> labeledIntegerNativizationOfT [
	^self labeledIntegerNativizationOf: codegen regT
]

{ #category : #integers }
GenericAssembler >> labeledNonIntegerBitTestOfR [
	^self labeledNonIntegerBitTestOf: codegen regR
]

{ #category : #'to-cleanup' }
GenericAssembler >> leadingRzeroCount [
	codegen leadingRzeroCount
]

{ #category : #'memory - load / store' }
GenericAssembler >> load: dstReg fromMem: srcMemRef [
	^codegen load: dstReg fromMem: srcMemRef
]

{ #category : #loading }
GenericAssembler >> load:dstReg withImmediate: imm [
	codegen moveImm: imm to: dstReg
]

{ #category : #loading }
GenericAssembler >> load: register withLiteral: anObject [
	| index memref |
	index := self addLiteral: anObject.
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: register
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadAwithAindex: index [
	| memref |
	memref := codegen memRef: codegen regA indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadAwithEindex: index [
	| memref |
	memref := codegen memRef: codegen regE indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadAwithFPindex: index [
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadAwithFalse [
	codegen move: codegen regFalse to: codegen regA
]

{ #category : #private }
GenericAssembler >> loadAwithGindex: index [
	| memref |
	memref := codegen memRef: codegen regG indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadAwithGlobal: aSymbol [
	| index |
	index := NativizationEnvironment indexOfGlobal: aSymbol.
	self loadAwithGindex: index
]

{ #category : #integers }
GenericAssembler >> loadAwithImmediate: imm [
	self load: codegen regA withImmediate: imm
]

{ #category : #arithmetic }
GenericAssembler >> loadAwithKnown: anObject [
	codegen breakpoint
]

{ #category : #loading }
GenericAssembler >> loadAwithLiteral: anObject [
	| index |
	index := self addLiteral: anObject.
	self loadAwithMindex: index
]

{ #category : #loading }
GenericAssembler >> loadAwithMindex: index [
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadAwithNil [
	codegen move: codegen regNil to: codegen regA
]

{ #category : #loading }
GenericAssembler >> loadAwithR [
	codegen move: codegen regR to: codegen regA
]

{ #category : #loading }
GenericAssembler >> loadAwithRoffsetAtA [
	| memref |
	memref := codegen memRef
				base: codegen regR;
				index: codegen regA;
				scale: 1.
	codegen
		load: codegen regA
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadAwithS [
	codegen move: codegen regS to: codegen regA
]

{ #category : #loading }
GenericAssembler >> loadAwithSindex: index [
	| memref |
	memref := codegen memRef: codegen regS indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
]

{ #category : #integers }
GenericAssembler >> loadAwithSmallInteger: anInteger [
	| smi |
	smi := (anInteger bitShift: 1) + 1.
	self loadAwithImmediate: smi
]

{ #category : #loading }
GenericAssembler >> loadAwithTrue [
	codegen move: codegen regTrue to: codegen regA
]

{ #category : #'push/pop' }
GenericAssembler >> loadEwithAddressOfRatA [
	| memref |
	memref := codegen
		memRef: codegen regR
		index: codegen regA
		offsetImm: codegen wordSize negated.
	codegen lea: codegen regE withMem: memref
]

{ #category : #loading }
GenericAssembler >> loadEwithFPindex: index [
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regE
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadEwithNil [
	codegen move: codegen regNil to: codegen regE
]

{ #category : #loading }
GenericAssembler >> loadEwithR [
	codegen move: codegen regR to: codegen regE
]

{ #category : #loading }
GenericAssembler >> loadFPwithR [
	codegen move: codegen regR to: codegen regFP
]

{ #category : #loading }
GenericAssembler >> loadFPwithSP [
	codegen move: codegen regSP to: codegen regFP
]

{ #category : #loading }
GenericAssembler >> loadFalseWithMindex: index [
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regFalse
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadGwithMindex: index [
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regG
		fromMem: memref
]

{ #category : #'push/pop' }
GenericAssembler >> loadLargeX0withRindirect [
	| memref |
	memref := codegen memRef64: codegen regR indexImm: 1.
	codegen loadDouble: codegen regX0 fromMem: memref
]

{ #category : #'push/pop' }
GenericAssembler >> loadLargeX1withAindirect [
	| memref |
	memref := codegen memRef64: codegen regA indexImm: 1.
	codegen loadDouble: codegen regX1 fromMem: memref
]

{ #category : #'to-cleanup' }
GenericAssembler >> loadLongMwithIPoffset: anInteger [
	codegen loadLongMwithIPoffset: anInteger
]

{ #category : #'push/pop' }
GenericAssembler >> loadLongRwithRatOffsetA [
	| memref |
	memref := codegen
		memRef32: codegen regR
		offset: codegen regA.
	codegen load: codegen regR fromMem: memref

]

{ #category : #'push/pop' }
GenericAssembler >> loadLongSwithRindex: index [
	| memref |
	memref := codegen memRef32: codegen regR indexImm: index.
	codegen load: codegen regS fromMem: memref

]

{ #category : #'to-cleanup' }
GenericAssembler >> loadMXCSRfromA [
	codegen loadMXCSRfromA
]

{ #category : #'push/pop' }
GenericAssembler >> loadMwithA [
	codegen move: codegen regA to: codegen regM
]

{ #category : #loading }
GenericAssembler >> loadMwithFPindex: index [
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
]

{ #category : #private }
GenericAssembler >> loadMwithGindex: index [
	| memref |
	memref := codegen memRef: codegen regG indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadMwithMindex: index [
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadMwithRindex: index [
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadMwithTindex: index [
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadNilWithMindex: index [
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regNil
		fromMem: memref
]

{ #category : #'push/pop' }
GenericAssembler >> loadRconvertingDoublePointedByR [
	| memref |
	memref := codegen memRef64: codegen regR indexImm: 1.
	codegen load: codegen regR convertingDoubleToIntegerFromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadRwithA [
	codegen move: codegen regA to: codegen regR
]

{ #category : #'push/pop' }
GenericAssembler >> loadRwithArgPointer [
	| memref |
	memref := codegen memRef: codegen regFP indexImm: 3.
	codegen lea: codegen regR withMem: memref
]

{ #category : #loading }
GenericAssembler >> loadRwithE [
	codegen move: codegen regE to: codegen regR
]

{ #category : #loading }
GenericAssembler >> loadRwithEindex: index [
	| memref |
	memref := codegen memRef: codegen regE indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadRwithFP [
	codegen move: codegen regFP to: codegen regR
]

{ #category : #loading }
GenericAssembler >> loadRwithFPindex: index [
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadRwithFalse [
	codegen move: codegen regFalse to: codegen regR
]

{ #category : #integers }
GenericAssembler >> loadRwithImmediate: imm [
	self load: codegen regR withImmediate: imm
]

{ #category : #loading }
GenericAssembler >> loadRwithM [
	codegen move: codegen regM to: codegen regR
]

{ #category : #loading }
GenericAssembler >> loadRwithMindex: index [
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadRwithNil [
	codegen move: codegen regNil to: codegen regR
]

{ #category : #integers }
GenericAssembler >> loadRwithRatA [
	| memref |
	memref := codegen memRef: codegen regR index: codegen regA.
	self
		load: codegen regR
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadRwithRatOffsetA [
	| memref |
	memref := codegen memRef
				base: codegen regR;
				index: codegen regA;
				scale: 1.
	codegen
		load: codegen regR
		fromMem:
			memref
]

{ #category : #loading }
GenericAssembler >> loadRwithRindex: index [
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadRwithS [
	codegen move: codegen regS to: codegen regR
]

{ #category : #loading }
GenericAssembler >> loadRwithSPindex: index [
	| memref |
	memref := codegen memRef: codegen regSP indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadRwithSindex: index [
	| memref |
	memref := codegen memRef: codegen regS indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadRwithT [
	codegen move: codegen regT to: codegen regR
]

{ #category : #'floting point' }
GenericAssembler >> loadRwithTIBatR [
	codegen load: codegen regR withTIBat: codegen regR
]

{ #category : #'floting point' }
GenericAssembler >> loadRwithThreadVariableAtR [
	codegen load: codegen regR withThreadVariableAt: codegen regR
]

{ #category : #loading }
GenericAssembler >> loadRwithTrue [
	codegen move: codegen regTrue to: codegen regR
]

{ #category : #loading }
GenericAssembler >> loadSPwithFP [
	codegen move: codegen regFP to: codegen regSP
]

{ #category : #'push/pop' }
GenericAssembler >> loadSwithAddressOfSatA [
	| memref |
	memref := codegen
		memRef: codegen regS
		index: codegen regA
		offsetImm: codegen wordSize negated.
	codegen lea: codegen regS withMem: memref
]

{ #category : #loading }
GenericAssembler >> loadSwithFPindex: index [
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regS
		fromMem: memref
]

{ #category : #private }
GenericAssembler >> loadSwithGindex: index [
	| memref |
	memref := codegen memRef: codegen regG indexImm: index.
	codegen
		load: codegen regS
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadSwithNil [
	codegen move: codegen regNil to: codegen regS
]

{ #category : #loading }
GenericAssembler >> loadSwithRindex: index [
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		load: codegen regS
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadTrueWithMindex: index [
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regTrue
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadTwithA [
	codegen move: codegen regA to: codegen regT
]

{ #category : #loading }
GenericAssembler >> loadTwithAindex: index [
	| memref |
	memref := codegen memRef: codegen regA indexImm: index.
	codegen
		load: codegen regT
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadTwithEindex: index [
	| memref |
	memref := codegen memRef: codegen regE indexImm: index.
	codegen
		load: codegen regT
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadTwithFPindex: index [
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regT
		fromMem: memref
]

{ #category : #integers }
GenericAssembler >> loadTwithImmediate: imm [
	self load: codegen regT withImmediate: imm
]

{ #category : #loading }
GenericAssembler >> loadTwithMindex: index [
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regT
		fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadTwithR [
	codegen move: codegen regR to: codegen regT
]

{ #category : #loading }
GenericAssembler >> loadTwithTindex: index [
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen load: codegen regT fromMem: memref
]

{ #category : #loading }
GenericAssembler >> loadWithFalse: register [ 
	codegen move: codegen regFalse to: register
]

{ #category : #loading }
GenericAssembler >> loadWithNil: register [ 
	codegen move: codegen regNil to: register
]

{ #category : #loading }
GenericAssembler >> loadWithTrue: register [ 
	codegen move: codegen regTrue to: register
]

{ #category : #'push/pop' }
GenericAssembler >> loadX0withRasDouble [
	codegen convert: codegen regR toDouble: codegen regX0
]

{ #category : #'to-cleanup' }
GenericAssembler >> loadZeroExtendByte: dstReg from: srcBaseReg atIndexAt: srcIndexReg [
	codegen loadZeroExtendByte: dstReg from: srcBaseReg atIndexAt: srcIndexReg

]

{ #category : #'to-cleanup' }
GenericAssembler >> loadZeroExtendByte: dstReg from: srcBaseReg atIndexImm: indexImm [

	codegen
		loadZeroExtendByte: dstReg
		from: srcBaseReg
		atIndexImm: indexImm
]

{ #category : #jumps }
GenericAssembler >> loadZeroExtendByte: reg1 from: reg2 atOffset: offset [
	codegen loadZeroExtendByte: reg1 from: reg2 atOffset: offset
]

{ #category : #integers }
GenericAssembler >> loadZeroExtendByteRwithRatA [
	self loadZeroExtendByte: codegen regR from: codegen regR atIndexAt: codegen regA
]

{ #category : #integers }
GenericAssembler >> loadZeroExtendByteRwithRindex: index [
	#dontOptimize.
	self loadZeroExtendByte: codegen regR from: codegen regR atIndexImm: index
]

{ #category : #integers }
GenericAssembler >> loadZeroExtendByteRwithSPatA [
	self loadZeroExtendByte: codegen regR from: codegen regSP atIndexAt: codegen regA
]

{ #category : #integers }
GenericAssembler >> loadZeroExtendByteTwithAindex: index [
	#dontOptimize.
	self loadZeroExtendByte: codegen regT from: codegen regA atIndexImm: index
]

{ #category : #integers }
GenericAssembler >> loadZeroExtendLongRwithRatA [
	| memref |
	memref := codegen memRef32: codegen regR index: codegen regA.
	codegen
		load: codegen regR
		fromMem: memref
]

{ #category : #integers }
GenericAssembler >> loadZeroExtendLongRwithRindex: index [
	| memref |
	#dontOptimize.
	memref := codegen memRef32: codegen regR indexImm: index.
	codegen
		load: codegen regR e
		fromMem: memref
]

{ #category : #'to-cleanup' }
GenericAssembler >> loadZeroExtendShortRwithRoffset: offset [
	codegen
		loadZeroExtendShortRwithRoffset: offset
]

{ #category : #'to-cleanup' }
GenericAssembler >> lock [
	codegen lock
]

{ #category : #jumps }
GenericAssembler >> loop: aBlock times: anInteger [
	| loop |
	loop := self newLabel.
	self loadTwithImmediate: anInteger; @ loop.
	aBlock value.
	self dec: codegen regT; shortJumpIfNotZeroTo: loop
]

{ #category : #jumps }
GenericAssembler >> loopTtimes: aBlock [
	| loop end |
	loop := self newLabel.
	end := self newLabel.
	self
		compareTwithImmediate: 0;
		@ loop;
		shortJumpIfEqualTo: end.
	aBlock value.
	self
		dec: codegen regT;
		shortJumpTo: loop;
		@ end
]

{ #category : #memory }
GenericAssembler >> memRef [
	"Return clean instance of pointer-sized memory reference"

	^ codegen memRef

]

{ #category : #memory }
GenericAssembler >> memRef32: baseReg indexImm: indexImm [
	^ codegen memRef32: baseReg indexImm: indexImm
]

{ #category : #memory }
GenericAssembler >> memRef8 [
	"Return clean instance of byte-sized memory reference"

	^ codegen memRef8
]

{ #category : #memory }
GenericAssembler >> memRef8: baseReg index: indexReg [
	^ codegen memRef8: baseReg index: indexReg
]

{ #category : #memory }
GenericAssembler >> memRef: baseReg index: indexReg [
	^ codegen memRef: baseReg index: indexReg
]

{ #category : #memory }
GenericAssembler >> memRef: baseReg indexImm: indexImm [
	^ codegen memRef: baseReg indexImm: indexImm
]

{ #category : #services }
GenericAssembler >> move: srcReg to: dstReg [
	^ codegen move: srcReg to: dstReg

]

{ #category : #services }
GenericAssembler >> moveImm: imm to: dstReg [
	codegen moveImm: imm to: dstReg

]

{ #category : #'to-cleanup' }
GenericAssembler >> moveTslots [
	codegen moveTslots
]

{ #category : #'floting point' }
GenericAssembler >> moveX0toR [
	codegen moveDouble: codegen regX0 into: codegen regR
]

{ #category : #'floting point' }
GenericAssembler >> multiplyDoubleX0byX1 [
	codegen mulDouble: codegen regX0 by: codegen regX1
]

{ #category : #storing }
GenericAssembler >> multiplyRbyAwideningToA [
	codegen
		multiply: codegen regR
		by: codegen regA
		wideningTo: codegen regA
]

{ #category : #arithmetic }
GenericAssembler >> nativeCode [
	^(NativeCode withAll: literals) code: codegen memory bytes
]

{ #category : #'operations - logical' }
GenericAssembler >> or: src1AndDst with: src2 [
	^ codegen or: src1AndDst with: src2
]

{ #category : #'operations - logical' }
GenericAssembler >> or: source1andDest withImm: imm [
	codegen or: source1andDest withImm: imm
]

{ #category : #logic }
GenericAssembler >> orRwithA [
	codegen or: codegen regR with: codegen regA

]

{ #category : #private }
GenericAssembler >> pop: dstReg [
	codegen pop: dstReg
]

{ #category : #'push/pop' }
GenericAssembler >> popA [
	codegen pop: codegen regA
]

{ #category : #'push/pop' }
GenericAssembler >> popE [
	codegen pop: codegen regE
]

{ #category : #'push/pop' }
GenericAssembler >> popFP [
	codegen pop: codegen regFP
]

{ #category : #'push/pop' }
GenericAssembler >> popFalse [
	codegen pop: codegen regFalse
]

{ #category : #'push/pop' }
GenericAssembler >> popG [
	codegen pop: codegen regG
]

{ #category : #'push/pop' }
GenericAssembler >> popM [
	codegen pop: codegen regM
]

{ #category : #'push/pop' }
GenericAssembler >> popNil [
	codegen pop: codegen regNil
]

{ #category : #'push/pop' }
GenericAssembler >> popR [
	codegen pop: codegen regR
]

{ #category : #'push/pop' }
GenericAssembler >> popS [
	codegen pop: codegen regS
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> popSPindirect [
	| memref |
	memref := codegen memRef: codegen regSP indexImm: 1.
	codegen popIntoMem: memref
]

{ #category : #'push/pop' }
GenericAssembler >> popT [
	codegen pop: codegen regT
]

{ #category : #'push/pop' }
GenericAssembler >> popTrue [
	codegen pop: codegen regTrue
]

{ #category : #private }
GenericAssembler >> push: srcReg [
	codegen push: srcReg

]

{ #category : #'push/pop' }
GenericAssembler >> pushA [
	codegen push: codegen regA
]

{ #category : #'floting point' }
GenericAssembler >> pushAatToffset: offset [
	| memref |
	memref := codegen memRef: codegen regA index: codegen regT.
	memref displacement: offset.
	codegen pushMem: memref
]

{ #category : #'push/pop' }
GenericAssembler >> pushE [
	codegen push: codegen regE
]

{ #category : #'push/pop' }
GenericAssembler >> pushFP [
	codegen push: codegen regFP
]

{ #category : #'push/pop' }
GenericAssembler >> pushFalse [
	codegen push: codegen regFalse
]

{ #category : #'push/pop' }
GenericAssembler >> pushG [
	codegen push: codegen regG
]

{ #category : #private }
GenericAssembler >> pushImm: imm [
	codegen pushImm: imm
]

{ #category : #private }
GenericAssembler >> pushIndirectR [
	| memref |
	memref := codegen memRef: codegen regR indexImm: 1.
	codegen pushMem: memref
]

{ #category : #'push/pop' }
GenericAssembler >> pushM [
	codegen push: codegen regM
]

{ #category : #'push/pop' }
GenericAssembler >> pushNil [
	codegen push: codegen regNil
]

{ #category : #'push/pop' }
GenericAssembler >> pushR [
	codegen push: codegen regR
]

{ #category : #'push/pop' }
GenericAssembler >> pushS [
	codegen push: codegen regS
]

{ #category : #'push/pop' }
GenericAssembler >> pushT [
	codegen push: codegen regT
]

{ #category : #'push/pop' }
GenericAssembler >> pushTrue [
	codegen push: codegen regTrue
]

{ #category : #'to-cleanup' }
GenericAssembler >> readFPUStatusOnA [
	codegen readFPUStatusOnA
]

{ #category : #'registers - IR' }
GenericAssembler >> regA [
	^codegen regA

]

{ #category : #'registers - IR' }
GenericAssembler >> regA8 [
	^ codegen regA byte

]

{ #category : #'registers - IR' }
GenericAssembler >> regE [
	^ codegen regE
]

{ #category : #'registers - IR' }
GenericAssembler >> regFP [
	^ codegen regFP
]

{ #category : #'registers - IR' }
GenericAssembler >> regFalse [
	^ codegen regFalse
]

{ #category : #'registers - IR' }
GenericAssembler >> regG [
	^ codegen regG
]

{ #category : #'registers - IR' }
GenericAssembler >> regIP [
	^ codegen regIP
]

{ #category : #'registers - IR' }
GenericAssembler >> regM [
	^ codegen regM
]

{ #category : #'registers - IR' }
GenericAssembler >> regNil [
	^ codegen regNil
]

{ #category : #'registers - IR' }
GenericAssembler >> regR [
	^ codegen regR
]

{ #category : #'registers - IR' }
GenericAssembler >> regR8 [
	^ codegen regR byte
]

{ #category : #'registers - IR' }
GenericAssembler >> regS [
	^ codegen regS
]

{ #category : #'registers - IR' }
GenericAssembler >> regSP [
	^ codegen regSP
]

{ #category : #'registers - IR' }
GenericAssembler >> regT [
	^ codegen regT
]

{ #category : #'registers - IR' }
GenericAssembler >> regT8 [
	^ codegen reg byte
]

{ #category : #'registers - IR' }
GenericAssembler >> regTrue [
	^ codegen regTrue
]

{ #category : #'registers - IR' }
GenericAssembler >> regV [
	^ codegen regV
]

{ #category : #'registers - IR' }
GenericAssembler >> regX0 [
	"IEEE 754 double register"
	^ codegen regX0
]

{ #category : #'registers - IR' }
GenericAssembler >> regX1 [
	"IEEE 754 double register"
	^ codegen regX1
]

{ #category : #jumps }
GenericAssembler >> renameByteRegisterIfNeeded: register preserving: preserved during: aBlock [
	codegen renameByteRegisterIfNeeded: register preserving: preserved during: aBlock
]

{ #category : #'floting point' }
GenericAssembler >> renameByteRegisterIfNeeded: register preserving: preserved1 preserving: preserved2 during: aBlock [
	codegen renameByteRegisterIfNeeded: register preserving: preserved1 preserving: preserved2 during: aBlock
]

{ #category : #loading }
GenericAssembler >> reserveStackSlots: amount [
	codegen subImm: amount * codegen addressSize from: codegen regSP
]

{ #category : #initialization }
GenericAssembler >> reset [
	super reset.
	codegen reset
]

{ #category : #epilogue }
GenericAssembler >> restoreCallerFrame [
	codegen
		move: codegen regFP to: codegen regSP;
		pop: codegen regFP
]

{ #category : #jumps }
GenericAssembler >> return [
	codegen return
]

{ #category : #'floting point' }
GenericAssembler >> roundDoubleX0intoX1 [
	codegen roundDouble: codegen regX0 into: codegen regX1
]

{ #category : #'to-cleanup' }
GenericAssembler >> scaleFloatOnRWithA [
	codegen scaleFloatOnRWithA
]

{ #category : #arithmetic }
GenericAssembler >> setRintegerBit [
	self setIntegerBit: codegen regR
]

{ #category : #arithmetic }
GenericAssembler >> setSafeRintegerBit [
	self setSafeIntegerBit: codegen regR
]

{ #category : #'operations - logical' }
GenericAssembler >> shiftLeft: srcAndDst byImm: count [
	codegen shiftLeft: srcAndDst byImm: count
]

{ #category : #arithmetic }
GenericAssembler >> shiftLeftRwithT [
	codegen shiftLeft: codegen regR by: codegen regT
]

{ #category : #arithmetic }
GenericAssembler >> shiftLogicalRright: count [
	codegen shiftRight: codegen regR byImm: count
]

{ #category : #'operations - logical' }
GenericAssembler >> shiftRightArithmetic: srcAndDst by: countReg [
	codegen shiftRightArithmetic: srcAndDst by: countReg
]

{ #category : #'operations - logical' }
GenericAssembler >> shiftRightArithmetic: srcAndDst byImm: count [
	codegen shiftRightArithmetic: srcAndDst byImm: count
]

{ #category : #arithmetic }
GenericAssembler >> shiftRightRwithT [
	codegen shiftRightArithmetic: codegen regR by: codegen regT

]

{ #category : #arithmetic }
GenericAssembler >> shiftRleft: count [
	 codegen shiftLeft: codegen regR byImm: count

]

{ #category : #arithmetic }
GenericAssembler >> shiftRright: count [
	codegen shiftRightArithmetic: codegen regR byImm: count

]

{ #category : #arithmetic }
GenericAssembler >> shiftTright: count [
	codegen shiftRightArithmetic: codegen regT byImm: count

]

{ #category : #jumps }
GenericAssembler >> shortJumpIfCarryTo: label [
	codegen shortJumpIfCarryTo: label
]

{ #category : #jumps }
GenericAssembler >> shortJumpIfEqualTo: label [
	codegen shortJumpIfEqualTo: label
]

{ #category : #jumps }
GenericAssembler >> shortJumpIfNotCarryTo: label [
	codegen shortJumpIfNotCarryTo: label
]

{ #category : #jumps }
GenericAssembler >> shortJumpIfNotEqualTo: label [
	codegen shortJumpIfNotEqualTo: label
]

{ #category : #jumps }
GenericAssembler >> shortJumpIfSignTo: label [
	codegen shortJumpIfSignTo: label
]

{ #category : #jumps }
GenericAssembler >> shortJumpTo: label [
	codegen shortJumpTo: label
]

{ #category : #'floting point' }
GenericAssembler >> sqrtDoubleX0 [
	codegen sqrtDouble: codegen regX0 into: codegen regX0
]

{ #category : #'memory - load / store' }
GenericAssembler >> store: srcReg intoMem: dstMemRef [
	^ codegen store: srcReg intoMem: dstMemRef
]

{ #category : #'floting point' }
GenericAssembler >> storeAinThreadVariableAtIndexR [
	codegen store: codegen regA intoThreadVariableAt: codegen regR
]

{ #category : #storing }
GenericAssembler >> storeAinTindex: index [
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen
		store: codegen regA
		intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeByteAinRindex: index [
	| memref |
	memref := codegen memRef8: codegen regR indexImm: index.
	codegen store: codegen regA byte intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeByteTinRatA [
	| memref |
	memref := codegen memRef8: codegen regR index: codegen regA.
	codegen store: codegen regT byte intoMem: memref
]

{ #category : #'floting point' }
GenericAssembler >> storeDoubleResultInRindirect [
	| memref |
	memref := codegen memRef: codegen regR indexImm: 1.
	codegen storeDoubleResultIntoMem:  memref
]

{ #category : #storing }
GenericAssembler >> storeEinRindex: index [
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		store: codegen regE
		intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeLargeX0inA [
	| memref |
	memref := codegen memRef64: codegen regA indexImm: 1.
	codegen storeDouble: codegen regX0 intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeLargeX0inT [
	| memref |
	memref := codegen memRef64: codegen regT indexImm: 1.
	codegen storeDouble: codegen regX0 intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeLongTinRatA [
	| memref |
	memref := codegen memRef32: codegen regR index: codegen regA.
	codegen
		store: codegen regT
		intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeLongTinRatOffsetA [
	| memref |
	memref := codegen memRef32: codegen regR offset: codegen regA.
	codegen store: codegen regT long intoMem: memref
]

{ #category : #'to-cleanup' }
GenericAssembler >> storeMXCSRintoA [
	codegen storeMXCSRintoA
]

{ #category : #storing }
GenericAssembler >> storeRinAindex: index [
	| memref |
	memref := codegen memRef: codegen regA indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeRinEindex: index [
	| memref |
	memref := codegen memRef: codegen regE indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeRinFPindex: index [
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeRinSindex: index [
	| memref |
	memref := codegen memRef: codegen regS indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeRinTindex: index [
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeShortAinRoffset: offset [
	|  memref |
	memref := codegen memRef16: codegen regR offsetImm: offset.
	codegen store: codegen regA short intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeShortTinRatOffsetA [
	| memref |
	memref := codegen memRef16: codegen regR offset: codegen regA.
	codegen store: codegen regT short intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeSinRindex: index [
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		store: codegen regS
		intoMem: memref
]

{ #category : #'floting point' }
GenericAssembler >> storeTIBatRwithA [
	codegen store: codegen regA intoTIBat: codegen regR
]

{ #category : #storing }
GenericAssembler >> storeTinRatA [
	| memref |
	memref := codegen memRef: codegen regR index: codegen regA.
	codegen
		store: codegen regT
		intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeTinRatOffsetA [
	| memref |
	memref := codegen memRef: codegen regR offset: codegen regA.
	codegen store: codegen regT intoMem: memref
]

{ #category : #storing }
GenericAssembler >> storeTinRindex: index [
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		store: codegen regT
		intoMem: memref
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> sub: src2 from: src1AndDst [
	codegen sub: src2  from: src1AndDst
]

{ #category : #arithmetic }
GenericAssembler >> subAfromR [
	codegen sub: codegen regA from: codegen regR
]

{ #category : #arithmetic }
GenericAssembler >> subAfromT [
	codegen sub: codegen regA from: codegen regT    
]

{ #category : #'floting point' }
GenericAssembler >> subDoubleX1fromX0 [
	codegen subDouble: codegen regX1 from: codegen regX0
]

{ #category : #arithmetic }
GenericAssembler >> subFromRconstant: imm [
	codegen subImm: imm from: codegen regR
]

{ #category : #'operations - arithmetic' }
GenericAssembler >> subImm: imm from: srcAndDst [
	codegen subImm: imm from: srcAndDst
]

{ #category : #'to-cleanup' }
GenericAssembler >> subTslotsToSP [
	codegen subTslotsToSP
]

{ #category : #initialization }
GenericAssembler >> platform: aNativizationPlatform [
	codegen := aNativizationPlatform newCodeGenerator.
	super platform: aNativizationPlatform.
]

{ #category : #loading }
GenericAssembler >> testIntegerBit: aRegister [
	codegen testIntegerBit: aRegister
]

{ #category : #loading }
GenericAssembler >> testIntegerBitOf: aRegister [
	codegen test: aRegister byte withImm: 1
]

{ #category : #loading }
GenericAssembler >> testRintegerBit [
	codegen test: codegen regR byte withImm: 1
]

{ #category : #loading }
GenericAssembler >> testRwithR [
	codegen test: codegen regR with: codegen regR
]

{ #category : #services }
GenericAssembler >> wordSize [
	^codegen wordSize
]

{ #category : #'to-cleanup' }
GenericAssembler >> writeTslots [
	codegen writeTslots
]

{ #category : #logic }
GenericAssembler >> xorAwithR [
	codegen xor: codegen regA with: codegen regR
]

{ #category : #logic }
GenericAssembler >> xorFPwithFP [
	codegen xor: codegen regFP with: codegen regFP
]

{ #category : #logic }
GenericAssembler >> xorRwithA [
	codegen xor: codegen regR with: codegen regA
]

