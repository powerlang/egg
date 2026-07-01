'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #GenericAssembler category: #'Powerlang-Core-Assembly'!
Assembler subclass: #GenericAssembler
	instanceVariableNames: 'codegen'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!GenericAssembler commentStamp: '<historical>' prior: 0!

I am a JIT GenericAssembler frontend that can generate code for different architectures
using different code generators.
!

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
add: source1 to: source2andDest
	codegen add: source1 to: source2andDest
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addAtoR
	codegen add: codegen regA to: codegen regR
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addDoubleX1toX0
	codegen addDouble: codegen regX1 to: codegen regX0

! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addImm: imm to: dest
	codegen addImm: imm to: dest
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addRwithImmediate: imm
	codegen addImm: imm to: codegen regR 
! !

!GenericAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addSPwithImmediate: imm
	codegen addImm: imm to: codegen regSP
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addTtoR
	codegen add: codegen regT to: codegen regR
! !

!GenericAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addTwithImmediate: imm
	codegen addImm: imm to: codegen regT
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
alignTo: anInteger
	codegen alignTo: anInteger
! !

!GenericAssembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
and: source1andDest with: source2
	codegen and: source1andDest with: source2
! !

!GenericAssembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
and: source1andDest withImm: imm
	codegen and: source1andDest withImm: imm
! !

!GenericAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
andRwithA
	codegen and: codegen regR with: codegen regA
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
andRwithImmediate: imm
	codegen and: codegen regR withImm: imm
! !

!GenericAssembler methodsFor:  'relocation' stamp: 'KenD 28/Jun/2026 13:27:40'!
applyFixups
	codegen memory applyFixupsWith: self
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
breakpoint
	codegen breakpoint
! !

!GenericAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
buildFrame
	self
		push: codegen regFP;
		move: codegen regSP to: codegen regFP
! !

!GenericAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
bytes
	^codegen bytes
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
callIndirectA
	| memref |
	memref := codegen memRef: codegen regA indexImm: 1.
	codegen callIndirect: memref
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
callIndirectM
	| memref |
	memref := codegen memRef: codegen regM indexImm: 1.
	codegen callIndirect: memref
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
callR
	codegen call: codegen regR
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearFPUFlags
	codegen clearFPUFlags
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearRhigh32
	codegen clearHigh32: codegen regR

! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearRintegerBit
	self dec: codegen regR
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearSafeRintegerBit
	self clearSafeIntegerBit: codegen regR
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compare: reg1 with: reg2
	codegen compare: reg1 with: reg2
! !

!GenericAssembler methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compare: register withBoolean: aBoolean
	aBoolean
		ifTrue: [ self compareWithTrue: register ]
		ifFalse: [ self compareWithFalse: register ]
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compare: register withLiteral: anObject
	| index memref |
	index := self addLiteral: anObject.
	memref := codegen memRef: codegen regM indexImm: index.
	codegen compare: register withMem: memref
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareAwithFalse
	codegen compare: codegen regA with: codegen regFalse
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareAwithTrue
	codegen compare: codegen regA with: codegen regTrue
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareEqualDoubleX0withAindirect
	codegen compareEqualDoubleX0withAindirect
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareLessThanDoubleX0withAindirect
	codegen compareLessThanDoubleX0withAindirect
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithA
	codegen compare: codegen regR with: codegen regA
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithFalse
	codegen compare: codegen regR with: codegen regFalse
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithImmediate: imm
	codegen compare: codegen regR withImm: imm
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithNil
	codegen compare: codegen regR with: codegen regNil
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithTrue
	codegen compare: codegen regR with: codegen regTrue
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareSwithTindex: index
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen compare: codegen regS withMem: memref
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareTwithA
	codegen compare: codegen regT with: codegen regA
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareTwithImmediate: imm
	codegen compare: codegen regT withImm: imm
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareWithFalse: register
	codegen compare: register with: codegen regFalse
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareWithNil: register
	codegen compare: register with: codegen regNil
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareWithTrue: register
	codegen compare: register with: codegen regTrue
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertAtoNativeInteger
	self convertToNativeInteger: codegen regA
	
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertRtoNativeInteger
	self convertToNativeInteger: codegen regR
	
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertRtoSmallInteger
	self convertToSmallInteger: codegen regR
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertToNativeInteger: srcAndDstReg
	codegen shiftRightArithmetic: srcAndDstReg byImm: 1
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertTtoNativeInteger
	self convertToNativeInteger: codegen regT
! !

!GenericAssembler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
currentAddress
	^ codegen currentAddress
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
dec: srcAndDstReg
	codegen dec: srcAndDstReg
! !

!GenericAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
decRindirect
	| memref |
	memref := codegen memRef: codegen regR indexImm: 1.
	codegen decMem: memref
! !

!GenericAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
discardArguments: anInteger
	anInteger = 0 ifTrue: [^self].
	codegen addImm: anInteger * codegen wordSize to: codegen regSP
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
divideDoubleX0byX1
	codegen divDouble: codegen regX0 by: codegen regX1
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
dropTopOfFPU
	codegen dropTopOfFPU
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
dropTos: count
	codegen addImm: (count * codegen addressSize) to: codegen regSP
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
exchangeRindirectWithT
	| memref |
	memref := codegen memRef: codegen regR indexImm: 1.
	codegen exchange: codegen regT withMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
extendRtoAandDividebyT
	codegen divide: codegen regR extendingTo: codegen regA by: codegen regT
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
inc: srcAndDstReg
	codegen inc: srcAndDstReg
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeS
	codegen move: codegen regR to: codegen regS
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfEqualTo: label
	codegen jumpIfEqualTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfGreaterOrEqualSignedTo: label
	codegen jumpIfGreaterOrEqualSignedTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfGreaterSignedTo: label
	codegen jumpIfGreaterSignedTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfLessOrEqualSignedTo: label
	codegen jumpIfLessOrEqualSignedTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfLessSignedTo: label
	codegen jumpIfLessSignedTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfNotEqualTo: label
	codegen jumpIfNotEqualTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfNotZeroTo: label
	codegen jumpIfNotZeroTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfOverflowTo: label
	codegen jumpIfOverflowTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfSignTo: label
	codegen jumpIfSignTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfZeroTo: label
	codegen jumpIfZeroTo: label
! !

!GenericAssembler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpTo: label
	codegen jumpTo: label
! !

!GenericAssembler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpToMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen jumpToMem: memref
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledIntegerBitTestOfR
	^self labeledIntegerBitTestOf: codegen regR
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledIntegerBitTestOfT
	^self labeledIntegerBitTestOf: codegen regT byte
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledIntegerNativizationOfA
	^self labeledIntegerNativizationOf: codegen regA
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledIntegerNativizationOfR
	^self labeledIntegerNativizationOf: codegen regR
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledIntegerNativizationOfT
	^self labeledIntegerNativizationOf: codegen regT
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledNonIntegerBitTestOfR
	^self labeledNonIntegerBitTestOf: codegen regR
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
leadingRzeroCount
	codegen leadingRzeroCount
! !

!GenericAssembler methodsFor:  'memory - load / store' stamp: 'KenD 28/Jun/2026 13:27:40'!
load: dstReg fromMem: srcMemRef
	^codegen load: dstReg fromMem: srcMemRef
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
load:dstReg withImmediate: imm
	codegen moveImm: imm to: dstReg
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
load: register withLiteral: anObject
	| index memref |
	index := self addLiteral: anObject.
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: register
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithAindex: index
	| memref |
	memref := codegen memRef: codegen regA indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithEindex: index
	| memref |
	memref := codegen memRef: codegen regE indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithFalse
	codegen move: codegen regFalse to: codegen regA
! !

!GenericAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithGindex: index
	| memref |
	memref := codegen memRef: codegen regG indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithGlobal: aSymbol
	| index |
	index := NativizationEnvironment indexOfGlobal: aSymbol.
	self loadAwithGindex: index
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithImmediate: imm
	self load: codegen regA withImmediate: imm
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithKnown: anObject
	codegen breakpoint
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadAwithMindex: index
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithNil
	codegen move: codegen regNil to: codegen regA
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithR
	codegen move: codegen regR to: codegen regA
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithRoffsetAtA
	| memref |
	memref := codegen memRef
				base: codegen regR;
				index: codegen regA;
				scale: 1.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithS
	codegen move: codegen regS to: codegen regA
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithSindex: index
	| memref |
	memref := codegen memRef: codegen regS indexImm: index.
	codegen
		load: codegen regA
		fromMem: memref
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithSmallInteger: anInteger
	| smi |
	smi := (anInteger bitShift: 1) + 1.
	self loadAwithImmediate: smi
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithTrue
	codegen move: codegen regTrue to: codegen regA
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadEwithAddressOfRatA
	| memref |
	memref := codegen
		memRef: codegen regR
		index: codegen regA
		offsetImm: codegen wordSize negated.
	codegen lea: codegen regE withMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadEwithFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regE
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadEwithNil
	codegen move: codegen regNil to: codegen regE
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadEwithR
	codegen move: codegen regR to: codegen regE
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadFPwithR
	codegen move: codegen regR to: codegen regFP
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadFPwithSP
	codegen move: codegen regSP to: codegen regFP
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadFalseWithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regFalse
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadGwithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regG
		fromMem: memref
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLargeX0withRindirect
	| memref |
	memref := codegen memRef64: codegen regR indexImm: 1.
	codegen loadDouble: codegen regX0 fromMem: memref
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLargeX1withAindirect
	| memref |
	memref := codegen memRef64: codegen regA indexImm: 1.
	codegen loadDouble: codegen regX1 fromMem: memref
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLongMwithIPoffset: anInteger
	codegen loadLongMwithIPoffset: anInteger
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLongRwithRatOffsetA
	| memref |
	memref := codegen
		memRef32: codegen regR
		offset: codegen regA.
	codegen load: codegen regR fromMem: memref

! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLongSwithRindex: index
	| memref |
	memref := codegen memRef32: codegen regR indexImm: index.
	codegen load: codegen regS fromMem: memref

! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMXCSRfromA
	codegen loadMXCSRfromA
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithA
	codegen move: codegen regA to: codegen regM
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
! !

!GenericAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithGindex: index
	| memref |
	memref := codegen memRef: codegen regG indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithRindex: index
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithTindex: index
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen
		load: codegen regM
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadNilWithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regNil
		fromMem: memref
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRconvertingDoublePointedByR
	| memref |
	memref := codegen memRef64: codegen regR indexImm: 1.
	codegen load: codegen regR convertingDoubleToIntegerFromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithA
	codegen move: codegen regA to: codegen regR
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithArgPointer
	| memref |
	memref := codegen memRef: codegen regFP indexImm: 3.
	codegen lea: codegen regR withMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithE
	codegen move: codegen regE to: codegen regR
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithEindex: index
	| memref |
	memref := codegen memRef: codegen regE indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithFP
	codegen move: codegen regFP to: codegen regR
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithFalse
	codegen move: codegen regFalse to: codegen regR
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithImmediate: imm
	self load: codegen regR withImmediate: imm
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithM
	codegen move: codegen regM to: codegen regR
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithNil
	codegen move: codegen regNil to: codegen regR
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithRatA
	| memref |
	memref := codegen memRef: codegen regR index: codegen regA.
	self
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithRatOffsetA
	| memref |
	memref := codegen memRef
				base: codegen regR;
				index: codegen regA;
				scale: 1.
	codegen
		load: codegen regR
		fromMem:
			memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithRindex: index
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithS
	codegen move: codegen regS to: codegen regR
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithSPindex: index
	| memref |
	memref := codegen memRef: codegen regSP indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithSindex: index
	| memref |
	memref := codegen memRef: codegen regS indexImm: index.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithT
	codegen move: codegen regT to: codegen regR
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithTIBatR
	codegen load: codegen regR withTIBat: codegen regR
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithThreadVariableAtR
	codegen load: codegen regR withThreadVariableAt: codegen regR
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithTrue
	codegen move: codegen regTrue to: codegen regR
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSPwithFP
	codegen move: codegen regFP to: codegen regSP
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithAddressOfSatA
	| memref |
	memref := codegen
		memRef: codegen regS
		index: codegen regA
		offsetImm: codegen wordSize negated.
	codegen lea: codegen regS withMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regS
		fromMem: memref
! !

!GenericAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithGindex: index
	| memref |
	memref := codegen memRef: codegen regG indexImm: index.
	codegen
		load: codegen regS
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithNil
	codegen move: codegen regNil to: codegen regS
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithRindex: index
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		load: codegen regS
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTrueWithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regTrue
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithA
	codegen move: codegen regA to: codegen regT
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithAindex: index
	| memref |
	memref := codegen memRef: codegen regA indexImm: index.
	codegen
		load: codegen regT
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithEindex: index
	| memref |
	memref := codegen memRef: codegen regE indexImm: index.
	codegen
		load: codegen regT
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		load: codegen regT
		fromMem: memref
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithImmediate: imm
	self load: codegen regT withImmediate: imm
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithMindex: index
	| memref |
	memref := codegen memRef: codegen regM indexImm: index.
	codegen
		load: codegen regT
		fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithR
	codegen move: codegen regR to: codegen regT
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithTindex: index
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen load: codegen regT fromMem: memref
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadWithFalse: register
	codegen move: codegen regFalse to: register
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadWithNil: register
	codegen move: codegen regNil to: register
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadWithTrue: register
	codegen move: codegen regTrue to: register
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadX0withRasDouble
	codegen convert: codegen regR toDouble: codegen regX0
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByte: dstReg from: srcBaseReg atIndexAt: srcIndexReg
	codegen loadZeroExtendByte: dstReg from: srcBaseReg atIndexAt: srcIndexReg

! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByte: dstReg from: srcBaseReg atIndexImm: indexImm

	codegen
		loadZeroExtendByte: dstReg
		from: srcBaseReg
		atIndexImm: indexImm
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByte: reg1 from: reg2 atOffset: offset
	codegen loadZeroExtendByte: reg1 from: reg2 atOffset: offset
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByteRwithRatA
	self loadZeroExtendByte: codegen regR from: codegen regR atIndexAt: codegen regA
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByteRwithRindex: index
	#dontOptimize.
	self loadZeroExtendByte: codegen regR from: codegen regR atIndexImm: index
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByteRwithSPatA
	self loadZeroExtendByte: codegen regR from: codegen regSP atIndexAt: codegen regA
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByteTwithAindex: index
	#dontOptimize.
	self loadZeroExtendByte: codegen regT from: codegen regA atIndexImm: index
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendLongRwithRatA
	| memref |
	memref := codegen memRef32: codegen regR index: codegen regA.
	codegen
		load: codegen regR
		fromMem: memref
! !

!GenericAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendLongRwithRindex: index
	| memref |
	#dontOptimize.
	memref := codegen memRef32: codegen regR indexImm: index.
	codegen
		load: codegen regR e
		fromMem: memref
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendShortRwithRoffset: offset
	codegen
		loadZeroExtendShortRwithRoffset: offset
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
lock
	codegen lock
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
loop: aBlock times: anInteger
	| loop |
	loop := self newLabel.
	self loadTwithImmediate: anInteger; @ loop.
	aBlock value.
	self dec: codegen regT; shortJumpIfNotZeroTo: loop
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
loopTtimes: aBlock
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
! !

!GenericAssembler methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef
	"Return clean instance of pointer-sized memory reference"

	^ codegen memRef

! !

!GenericAssembler methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef32: baseReg indexImm: indexImm
	^ codegen memRef32: baseReg indexImm: indexImm
! !

!GenericAssembler methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef8
	"Return clean instance of byte-sized memory reference"

	^ codegen memRef8
! !

!GenericAssembler methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef8: baseReg index: indexReg
	^ codegen memRef8: baseReg index: indexReg
! !

!GenericAssembler methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef: baseReg index: indexReg
	^ codegen memRef: baseReg index: indexReg
! !

!GenericAssembler methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef: baseReg indexImm: indexImm
	^ codegen memRef: baseReg indexImm: indexImm
! !

!GenericAssembler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
move: srcReg to: dstReg
	^ codegen move: srcReg to: dstReg

! !

!GenericAssembler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveImm: imm to: dstReg
	codegen moveImm: imm to: dstReg

! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveTslots
	codegen moveTslots
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveX0toR
	codegen moveDouble: codegen regX0 into: codegen regR
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
multiplyDoubleX0byX1
	codegen mulDouble: codegen regX0 by: codegen regX1
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
multiplyRbyAwideningToA
	codegen
		multiply: codegen regR
		by: codegen regA
		wideningTo: codegen regA
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativeCode
	^(NativeCode withAll: literals) code: codegen memory bytes
! !

!GenericAssembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
or: src1AndDst with: src2
	^ codegen or: src1AndDst with: src2
! !

!GenericAssembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
or: source1andDest withImm: imm
	codegen or: source1andDest withImm: imm
! !

!GenericAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
orRwithA
	codegen or: codegen regR with: codegen regA

! !

!GenericAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
pop: dstReg
	codegen pop: dstReg
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popA
	codegen pop: codegen regA
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popE
	codegen pop: codegen regE
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popFP
	codegen pop: codegen regFP
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popFalse
	codegen pop: codegen regFalse
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popG
	codegen pop: codegen regG
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popM
	codegen pop: codegen regM
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popNil
	codegen pop: codegen regNil
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popR
	codegen pop: codegen regR
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popS
	codegen pop: codegen regS
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
popSPindirect
	| memref |
	memref := codegen memRef: codegen regSP indexImm: 1.
	codegen popIntoMem: memref
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popT
	codegen pop: codegen regT
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popTrue
	codegen pop: codegen regTrue
! !

!GenericAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
push: srcReg
	codegen push: srcReg

! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushA
	codegen push: codegen regA
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushAatToffset: offset
	| memref |
	memref := codegen memRef: codegen regA index: codegen regT.
	memref displacement: offset.
	codegen pushMem: memref
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushE
	codegen push: codegen regE
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushFP
	codegen push: codegen regFP
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushFalse
	codegen push: codegen regFalse
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushG
	codegen push: codegen regG
! !

!GenericAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushImm: imm
	codegen pushImm: imm
! !

!GenericAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushIndirectR
	| memref |
	memref := codegen memRef: codegen regR indexImm: 1.
	codegen pushMem: memref
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushM
	codegen push: codegen regM
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushNil
	codegen push: codegen regNil
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushR
	codegen push: codegen regR
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushS
	codegen push: codegen regS
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushT
	codegen push: codegen regT
! !

!GenericAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushTrue
	codegen push: codegen regTrue
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
readFPUStatusOnA
	codegen readFPUStatusOnA
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regA
	^codegen regA

! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regA8
	^ codegen regA byte

! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regE
	^ codegen regE
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regFP
	^ codegen regFP
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regFalse
	^ codegen regFalse
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regG
	^ codegen regG
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regIP
	^ codegen regIP
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regM
	^ codegen regM
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regNil
	^ codegen regNil
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regR
	^ codegen regR
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regR8
	^ codegen regR byte
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regS
	^ codegen regS
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regSP
	^ codegen regSP
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regT
	^ codegen regT
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regT8
	^ codegen reg byte
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regTrue
	^ codegen regTrue
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regV
	^ codegen regV
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regX0
	"IEEE 754 double register"
	^ codegen regX0
! !

!GenericAssembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regX1
	"IEEE 754 double register"
	^ codegen regX1
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
renameByteRegisterIfNeeded: register preserving: preserved during: aBlock
	codegen renameByteRegisterIfNeeded: register preserving: preserved during: aBlock
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
renameByteRegisterIfNeeded: register preserving: preserved1 preserving: preserved2 during: aBlock
	codegen renameByteRegisterIfNeeded: register preserving: preserved1 preserving: preserved2 during: aBlock
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
reserveStackSlots: amount
	codegen subImm: amount * codegen addressSize from: codegen regSP
! !

!GenericAssembler methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
reset
	super reset.
	codegen reset
! !

!GenericAssembler methodsFor:  'epilogue' stamp: 'KenD 28/Jun/2026 13:27:40'!
restoreCallerFrame
	codegen
		move: codegen regFP to: codegen regSP;
		pop: codegen regFP
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
return
	codegen return
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
roundDoubleX0intoX1
	codegen roundDouble: codegen regX0 into: codegen regX1
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
scaleFloatOnRWithA
	codegen scaleFloatOnRWithA
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
setRintegerBit
	self setIntegerBit: codegen regR
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
setSafeRintegerBit
	self setSafeIntegerBit: codegen regR
! !

!GenericAssembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftLeft: srcAndDst byImm: count
	codegen shiftLeft: srcAndDst byImm: count
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftLeftRwithT
	codegen shiftLeft: codegen regR by: codegen regT
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftLogicalRright: count
	codegen shiftRight: codegen regR byImm: count
! !

!GenericAssembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRightArithmetic: srcAndDst by: countReg
	codegen shiftRightArithmetic: srcAndDst by: countReg
! !

!GenericAssembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRightArithmetic: srcAndDst byImm: count
	codegen shiftRightArithmetic: srcAndDst byImm: count
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRightRwithT
	codegen shiftRightArithmetic: codegen regR by: codegen regT

! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRleft: count
	 codegen shiftLeft: codegen regR byImm: count

! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRright: count
	codegen shiftRightArithmetic: codegen regR byImm: count

! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftTright: count
	codegen shiftRightArithmetic: codegen regT byImm: count

! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfCarryTo: label
	codegen shortJumpIfCarryTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfEqualTo: label
	codegen shortJumpIfEqualTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfNotCarryTo: label
	codegen shortJumpIfNotCarryTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfNotEqualTo: label
	codegen shortJumpIfNotEqualTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfSignTo: label
	codegen shortJumpIfSignTo: label
! !

!GenericAssembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpTo: label
	codegen shortJumpTo: label
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
sqrtDoubleX0
	codegen sqrtDouble: codegen regX0 into: codegen regX0
! !

!GenericAssembler methodsFor:  'memory - load / store' stamp: 'KenD 28/Jun/2026 13:27:40'!
store: srcReg intoMem: dstMemRef
	^ codegen store: srcReg intoMem: dstMemRef
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeAinThreadVariableAtIndexR
	codegen store: codegen regA intoThreadVariableAt: codegen regR
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeAinTindex: index
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen
		store: codegen regA
		intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeByteAinRindex: index
	| memref |
	memref := codegen memRef8: codegen regR indexImm: index.
	codegen store: codegen regA byte intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeByteTinRatA
	| memref |
	memref := codegen memRef8: codegen regR index: codegen regA.
	codegen store: codegen regT byte intoMem: memref
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeDoubleResultInRindirect
	| memref |
	memref := codegen memRef: codegen regR indexImm: 1.
	codegen storeDoubleResultIntoMem:  memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeEinRindex: index
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		store: codegen regE
		intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeLargeX0inA
	| memref |
	memref := codegen memRef64: codegen regA indexImm: 1.
	codegen storeDouble: codegen regX0 intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeLargeX0inT
	| memref |
	memref := codegen memRef64: codegen regT indexImm: 1.
	codegen storeDouble: codegen regX0 intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeLongTinRatA
	| memref |
	memref := codegen memRef32: codegen regR index: codegen regA.
	codegen
		store: codegen regT
		intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeLongTinRatOffsetA
	| memref |
	memref := codegen memRef32: codegen regR offset: codegen regA.
	codegen store: codegen regT long intoMem: memref
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeMXCSRintoA
	codegen storeMXCSRintoA
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinAindex: index
	| memref |
	memref := codegen memRef: codegen regA indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinEindex: index
	| memref |
	memref := codegen memRef: codegen regE indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinFPindex: index
	| memref |
	memref := codegen memRef: codegen regFP indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinSindex: index
	| memref |
	memref := codegen memRef: codegen regS indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinTindex: index
	| memref |
	memref := codegen memRef: codegen regT indexImm: index.
	codegen
		store: codegen regR
		intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeShortAinRoffset: offset
	|  memref |
	memref := codegen memRef16: codegen regR offsetImm: offset.
	codegen store: codegen regA short intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeShortTinRatOffsetA
	| memref |
	memref := codegen memRef16: codegen regR offset: codegen regA.
	codegen store: codegen regT short intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeSinRindex: index
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		store: codegen regS
		intoMem: memref
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeTIBatRwithA
	codegen store: codegen regA intoTIBat: codegen regR
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeTinRatA
	| memref |
	memref := codegen memRef: codegen regR index: codegen regA.
	codegen
		store: codegen regT
		intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeTinRatOffsetA
	| memref |
	memref := codegen memRef: codegen regR offset: codegen regA.
	codegen store: codegen regT intoMem: memref
! !

!GenericAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeTinRindex: index
	| memref |
	memref := codegen memRef: codegen regR indexImm: index.
	codegen
		store: codegen regT
		intoMem: memref
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
sub: src2 from: src1AndDst
	codegen sub: src2  from: src1AndDst
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subAfromR
	codegen sub: codegen regA from: codegen regR
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subAfromT
	codegen sub: codegen regA from: codegen regT    
! !

!GenericAssembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
subDoubleX1fromX0
	codegen subDouble: codegen regX1 from: codegen regX0
! !

!GenericAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subFromRconstant: imm
	codegen subImm: imm from: codegen regR
! !

!GenericAssembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subImm: imm from: srcAndDst
	codegen subImm: imm from: srcAndDst
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
subTslotsToSP
	codegen subTslotsToSP
! !

!GenericAssembler methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
platform: aNativizationPlatform
	codegen := aNativizationPlatform newCodeGenerator.
	super platform: aNativizationPlatform.
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
testIntegerBit: aRegister
	codegen testIntegerBit: aRegister
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
testIntegerBitOf: aRegister
	codegen test: aRegister byte withImm: 1
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
testRintegerBit
	codegen test: codegen regR byte withImm: 1
! !

!GenericAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
testRwithR
	codegen test: codegen regR with: codegen regR
! !

!GenericAssembler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSize
	^codegen wordSize
! !

!GenericAssembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeTslots
	codegen writeTslots
! !

!GenericAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
xorAwithR
	codegen xor: codegen regA with: codegen regR
! !

!GenericAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
xorFPwithFP
	codegen xor: codegen regFP with: codegen regFP
! !

!GenericAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
xorRwithA
	codegen xor: codegen regR with: codegen regA
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'GenericAssembler class' category: #'Powerlang-Core-Assembly'!
GenericAssembler class
	instanceVariableNames: ''!


