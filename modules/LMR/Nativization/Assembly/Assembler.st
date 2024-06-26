"
I am the JIT assembler frontend. I provide a high-level assembler interface (if that really exists)
and delegate writing of the actual bytes to my backends.
"
Class {
	#name : #Assembler,
	#superclass : #Object,
	#instVars : [
		'labels',
		'literals'
	],
	#classVars : [
		'IndexedLabels'
	],
	#category : #'Powerlang-Core-Assembly'
}

{ #category : #initialization }
Assembler class >> growIndexedLabelsTo: anInteger [
	| new |
	new := (IndexedLabels size + 1 to: anInteger)
		collect: [:i | ('@' , i asString) asSymbol].
	IndexedLabels := IndexedLabels , new
]

{ #category : #initialization }
Assembler class >> initialize [
	self initializeIndexedLabels
	
]

{ #category : #initialization }
Assembler class >> initializeIndexedLabels [
	IndexedLabels := #().
	self growIndexedLabelsTo: 100
]

{ #category : #labels }
Assembler >> @ label [
	self addLabel: label
]

{ #category : #'operations - arithmetic' }
Assembler >> add: source1 to: source2andDest [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> addAtoR [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> addDoubleX1toX0 [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> addImm: imm to: dest [
	self subclassResponsibility
]

{ #category : #labels }
Assembler >> addLabel: aString [
	self addLabel: aString to: self currentAddress
]

{ #category : #labels }
Assembler >> addLabel: label to: location [
	labels at: label put: location
]

{ #category : #loading }
Assembler >> addLiteral: anObject [
	| index |
	index := literals
		identityIndexOf: anObject
		ifAbsent: [ literals
				add: anObject;
				size ].
	^ index + 2
]

{ #category : #arithmetic }
Assembler >> addRwithImmediate: imm [
	self subclassResponsibility
]

{ #category : #logic }
Assembler >> addSPwithImmediate: imm [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> addTtoR [
	self subclassResponsibility
]

{ #category : #logic }
Assembler >> addTwithImmediate: imm [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> alignTo: anInteger [
	self subclassResponsibility
]

{ #category : #'operations - logical' }
Assembler >> and: source1andDest with: source2 [
	self subclassResponsibility
]

{ #category : #'operations - logical' }
Assembler >> and: source1andDest withImm: imm [
	self subclassResponsibility
]

{ #category : #logic }
Assembler >> andRwithA [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> andRwithImmediate: imm [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> breakpoint [
	self subclassResponsibility
]

{ #category : #private }
Assembler >> buildFrame [
	self subclassResponsibility
]

{ #category : #private }
Assembler >> bytes [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> callIndirectA [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> callIndirectM [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> callR [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> clearFPUFlags [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> clearIntegerBit: srcAndDstReg [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> clearRhigh32 [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> clearRintegerBit [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> clearSafeIntegerBit: srcAndDstReg [
	self and: srcAndDstReg withImm: -2
]

{ #category : #'operations - arithmetic' }
Assembler >> clearSafeRintegerBit [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> compare: reg1 with: reg2 [
	self subclassResponsibility
]

{ #category : #comparing }
Assembler >> compare: register withBoolean: aBoolean [
	aBoolean
		ifTrue: [ self compareWithTrue: register ]
		ifFalse: [ self compareWithFalse: register ]
]

{ #category : #'operations - arithmetic' }
Assembler >> compare: register withLiteral: anObject [
	self subclassResponsibility
]

{ #category : #comparing }
Assembler >> compareAwithBoolean: aBoolean [
	aBoolean
		ifTrue: [ self compareAwithTrue ]
		ifFalse: [ self compareAwithFalse ]
]

{ #category : #'operations - arithmetic' }
Assembler >> compareAwithFalse [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> compareAwithTrue [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> compareEqualDoubleX0withAindirect [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> compareLessThanDoubleX0withAindirect [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> compareRwithA [
	self subclassResponsibility
]

{ #category : #comparing }
Assembler >> compareRwithBoolean: aBoolean [
	aBoolean
		ifTrue: [ self compareRwithTrue ]
		ifFalse: [ self compareRwithFalse ]
]

{ #category : #'operations - arithmetic' }
Assembler >> compareRwithFalse [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> compareRwithImmediate: imm [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> compareRwithNil [
	self subclassResponsibility
]

{ #category : #comparing }
Assembler >> compareRwithSmallInteger: anInteger [
	| smi |
	smi := self smallInteger: anInteger.
	self compareRwithImmediate: smi
]

{ #category : #'operations - arithmetic' }
Assembler >> compareRwithTrue [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> compareSwithTindex: index [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> compareTwithA [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> compareTwithImmediate: imm [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> compareWithFalse: register [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> compareWithNil: register [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> compareWithTrue: register [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> convertAtoNativeInteger [
	self subclassResponsibility
	
]

{ #category : #arithmetic }
Assembler >> convertRtoNativeInteger [
	self subclassResponsibility
	
]

{ #category : #arithmetic }
Assembler >> convertRtoSmallInteger [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> convertToNativeInteger: srcAndDstReg [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> convertToSmallInteger: srcAndDstReg [ 
	self shiftLeft: srcAndDstReg byImm: 1; inc: srcAndDstReg
]

{ #category : #arithmetic }
Assembler >> convertTtoNativeInteger [
	self subclassResponsibility	
]

{ #category : #services }
Assembler >> currentAddress [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> dec: srcAndDstReg [
	self subclassResponsibility
]

{ #category : #private }
Assembler >> decRindirect [
	self subclassResponsibility
]

{ #category : #private }
Assembler >> discardArguments: anInteger [
	self subclassResponsibility
]

{ #category : #'floting point' }
Assembler >> divideDoubleX0byX1 [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> dropTopOfFPU [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> dropTos: count [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> exchangeRindirectWithT [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> extendRtoAandDividebyT [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> inc: srcAndDstReg [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> initializeS [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> jumpIfEqualTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> jumpIfGreaterOrEqualSignedTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> jumpIfGreaterSignedTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> jumpIfLessOrEqualSignedTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> jumpIfLessSignedTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> jumpIfNotEqualTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> jumpIfNotZeroTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> jumpIfOverflowTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> jumpIfSignTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> jumpIfZeroTo: label [
	self subclassResponsibility
]

{ #category : #accessing }
Assembler >> jumpOver: aBlock [
	| label |
	label := self newLabel.
	self jumpTo: label.
	aBlock value.
	self @ label
]

{ #category : #accessing }
Assembler >> jumpTo: label [
	self subclassResponsibility
]

{ #category : #accessing }
Assembler >> jumpToMindex: index [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> labeledIntegerBitTestOf: aRegister [
	| label |
	self testIntegerBitOf: aRegister.
	label := self newLabel.
	self shortJumpIfZeroTo: label.
	^label
]

{ #category : #integers }
Assembler >> labeledIntegerBitTestOfR [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> labeledIntegerBitTestOfT [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> labeledIntegerNativizationOf: aRegister [
	| label |
	self convertToNativeInteger: aRegister.
	label := self newLabel.
	self shortJumpIfNotCarryTo: label.
	^label
]

{ #category : #integers }
Assembler >> labeledIntegerNativizationOfA [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> labeledIntegerNativizationOfR [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> labeledIntegerNativizationOfT [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> labeledNonIntegerBitTestOf: aRegister [
	| label |
	self testIntegerBitOf: aRegister.
	label := self newLabel.
	self shortJumpIfNotZeroTo: label.
	^label
]

{ #category : #integers }
Assembler >> labeledNonIntegerBitTestOfR [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> leadingRzeroCount [
	self subclassResponsibility
]

{ #category : #'memory - load / store' }
Assembler >> load: dstReg fromMem: srcMemRef [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> load:dstReg withImmediate: imm [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> load: register withLiteral: anObject [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadAwithAindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadAwithEindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadAwithFPindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadAwithFalse [
	self subclassResponsibility
]

{ #category : #private }
Assembler >> loadAwithGindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadAwithGlobal: aSymbol [
	| index |
	index := NativizationEnvironment indexOfGlobal: aSymbol.
	self loadAwithGindex: index
]

{ #category : #integers }
Assembler >> loadAwithImmediate: imm [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> loadAwithKnown: anObject [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadAwithLiteral: anObject [
	| index |
	index := self addLiteral: anObject.
	self loadAwithMindex: index
]

{ #category : #loading }
Assembler >> loadAwithMindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadAwithNil [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadAwithR [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadAwithRoffsetAtA [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadAwithS [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadAwithSindex: index [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> loadAwithSmallInteger: anInteger [
	| smi |
	smi := (anInteger bitShift: 1) + 1.
	self loadAwithImmediate: smi
]

{ #category : #loading }
Assembler >> loadAwithTrue [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> loadEwithAddressOfRatA [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadEwithFPindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadEwithNil [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadEwithR [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadFPwithR [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadFPwithSP [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadFalseWithLiteral: anObject [
	| index |
	index := self addLiteral: anObject.
	self loadFalseWithMindex: index
]

{ #category : #loading }
Assembler >> loadFalseWithMindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadGwithLiteral: anObject [
	| index |
	index := self addLiteral: anObject.
	self loadGwithMindex: index
]

{ #category : #loading }
Assembler >> loadGwithMindex: index [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> loadLargeX0withRindirect [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> loadLargeX1withAindirect [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> loadLongMwithIPoffset: anInteger [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> loadLongRwithRatOffsetA [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> loadLongSwithRindex: index [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> loadMXCSRfromA [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> loadMwithA [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadMwithFPindex: index [
	self subclassResponsibility
]

{ #category : #private }
Assembler >> loadMwithGindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadMwithGlobal: aSymbol [
	| index |
	index := NativizationEnvironment indexOfGlobal: aSymbol.
	self loadMwithGindex: index
]

{ #category : #loading }
Assembler >> loadMwithMindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadMwithRindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadMwithTindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadNilWithLiteral: anObject [
	| index |
	index := self addLiteral: anObject.
	self loadNilWithMindex: index
]

{ #category : #loading }
Assembler >> loadNilWithMindex: index [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> loadRconvertingDoublePointedByR [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithA [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> loadRwithArgPointer [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithE [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithEindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithFP [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithFPindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithFalse [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> loadRwithImmediate: imm [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithLiteral: anObject [
	| index |
	index := self addLiteral: anObject.
	self loadRwithMindex: index
]

{ #category : #loading }
Assembler >> loadRwithM [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithMindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithNil [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> loadRwithRatA [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithRatOffsetA [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithRindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithS [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithSPindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithSindex: index [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> loadRwithSmallInteger: anInteger [
	| smi |
	smi := self smallInteger: anInteger.
	self loadRwithImmediate: smi
]

{ #category : #loading }
Assembler >> loadRwithT [
	self subclassResponsibility
]

{ #category : #'floting point' }
Assembler >> loadRwithTIBatR [
	self subclassResponsibility
]

{ #category : #'floting point' }
Assembler >> loadRwithThreadVariableAtR [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadRwithTrue [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadSPwithFP [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> loadSwithAddressOfSatA [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadSwithFPindex: index [
	self subclassResponsibility
]

{ #category : #private }
Assembler >> loadSwithGindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadSwithNil [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadSwithRindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadTrueWithLiteral: anObject [
	| index |
	index := self addLiteral: anObject.
	self loadTrueWithMindex: index
]

{ #category : #loading }
Assembler >> loadTrueWithMindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadTwithA [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadTwithAindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadTwithEindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadTwithFPindex: index [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> loadTwithImmediate: imm [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadTwithLiteral: anObject [
	| index |
	index := self addLiteral: anObject.
	self loadTwithMindex: index
]

{ #category : #loading }
Assembler >> loadTwithMindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadTwithR [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadTwithTindex: index [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadWithFalse: register [ 
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadWithNil: register [ 
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> loadWithTrue: register [ 
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> loadX0withRasDouble [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> loadZeroExtendByte: dstReg from: srcBaseReg atIndexAt: srcIndexReg [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> loadZeroExtendByte: dstReg from: srcBaseReg atIndexImm: indexImm [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> loadZeroExtendByte: reg1 from: reg2 atOffset: offset [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> loadZeroExtendByteRwithRatA [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> loadZeroExtendByteRwithRindex: index [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> loadZeroExtendByteRwithSPatA [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> loadZeroExtendByteTwithAindex: index [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> loadZeroExtendLongRwithRatA [
	self subclassResponsibility
]

{ #category : #integers }
Assembler >> loadZeroExtendLongRwithRindex: index [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> loadZeroExtendShortRwithRoffset: offset [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> lock [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> loop: aBlock times: anInteger [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> loopTtimes: aBlock [
	self subclassResponsibility
]

{ #category : #services }
Assembler >> move: srcReg to: dstReg [
	self subclassResponsibility
]

{ #category : #services }
Assembler >> moveImm: imm to: dstReg [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> moveTslots [
	self subclassResponsibility
]

{ #category : #'floting point' }
Assembler >> moveX0toR [
	self subclassResponsibility
]

{ #category : #'floting point' }
Assembler >> multiplyDoubleX0byX1 [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> multiplyRbyAwideningToA [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> nativeCode [
	self subclassResponsibility
]

{ #category : #labels }
Assembler >> newLabel [
	| label next |
	next := labels size + 1.
	IndexedLabels size < next ifTrue: [self class growIndexedLabelsTo: next].
	label := IndexedLabels at: next.
	self addLabel: label to: nil.
	^label
]

{ #category : #'operations - logical' }
Assembler >> or: src1AndDst with: src2 [
	self subclassResponsibility
]

{ #category : #'operations - logical' }
Assembler >> or: source1andDest withImm: imm [
	self subclassResponsibility
]

{ #category : #logic }
Assembler >> orRwithA [
	self subclassResponsibility
]

{ #category : #private }
Assembler >> pop: dstReg [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> popA [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> popE [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> popFP [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> popFalse [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> popG [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> popM [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> popNil [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> popR [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> popS [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> popSPindirect [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> popT [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> popTrue [
	self subclassResponsibility
]

{ #category : #private }
Assembler >> push: srcReg [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> pushA [
	self subclassResponsibility
]

{ #category : #'floting point' }
Assembler >> pushAatToffset: offset [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> pushE [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> pushFP [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> pushFalse [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> pushG [
	self subclassResponsibility
]

{ #category : #private }
Assembler >> pushImm: imm [
	self subclassResponsibility
]

{ #category : #private }
Assembler >> pushIndirectR [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> pushM [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> pushNil [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> pushR [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> pushS [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> pushSmallInteger: integer [
	| smi |
	smi := self smallInteger: integer.
	self pushImm: smi
]

{ #category : #'push/pop' }
Assembler >> pushT [
	self subclassResponsibility
]

{ #category : #'push/pop' }
Assembler >> pushTrue [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> readFPUStatusOnA [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regA [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regA8 [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regE [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regFP [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regFalse [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regG [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regIP [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regM [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regNil [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regR [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regR8 [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regS [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regSP [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regT [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regT8 [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regTrue [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regV [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regX0 [
	self subclassResponsibility
]

{ #category : #'registers - IR' }
Assembler >> regX1 [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> renameByteRegisterIfNeeded: register preserving: preserved during: aBlock [
	self subclassResponsibility
]

{ #category : #'floting point' }
Assembler >> renameByteRegisterIfNeeded: register preserving: preserved1 preserving: preserved2 during: aBlock [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> reserveStackSlots: amount [
	self subclassResponsibility
]

{ #category : #initialization }
Assembler >> reset [
	labels := Dictionary new: 100.
	literals := OrderedCollection new.
]

{ #category : #labels }
Assembler >> resolveLabel: aString [
	^labels at: aString
]

{ #category : #epilogue }
Assembler >> restoreCallerEnvironment [
	self loadEwithFPindex: -2
]

{ #category : #epilogue }
Assembler >> restoreCallerFrame [
	self subclassResponsibility
]

{ #category : #epilogue }
Assembler >> restoreCallerM [
	self loadMwithFPindex: -1
]

{ #category : #epilogue }
Assembler >> restoreCallerSelf [
	self loadSwithFPindex: 0
]

{ #category : #jumps }
Assembler >> return [
	self subclassResponsibility
]

{ #category : #'floting point' }
Assembler >> roundDoubleX0intoX1 [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> saveCallerFrame [
	self pushFP; loadFPwithSP
]

{ #category : #'to-cleanup' }
Assembler >> scaleFloatOnRWithA [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> setIntegerBit: srcAndDstReg [
	self setSafeIntegerBit: srcAndDstReg
]

{ #category : #arithmetic }
Assembler >> setRintegerBit [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> setSafeIntegerBit: srcAndDstReg [
	self or: srcAndDstReg withImm: 1
]

{ #category : #arithmetic }
Assembler >> setSafeRintegerBit [
	self subclassResponsibility
]

{ #category : #'operations - logical' }
Assembler >> shiftLeft: srcAndDst by: countReg [
	self subclassResponsibility
]

{ #category : #'operations - logical' }
Assembler >> shiftLeft: srcAndDst byImm: count [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> shiftLeftRwithT [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> shiftLogicalRright: count [
	self subclassResponsibility
]

{ #category : #'operations - logical' }
Assembler >> shiftRight: srcAndDst by: countReg [
	self subclassResponsibility
]

{ #category : #'operations - logical' }
Assembler >> shiftRight: srcAndDst byImm: count [
	self subclassResponsibility
]

{ #category : #'operations - logical' }
Assembler >> shiftRightArithmetic: srcAndDst by: countReg [
	self subclassResponsibility
]

{ #category : #'operations - logical' }
Assembler >> shiftRightArithmetic: srcAndDst byImm: count [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> shiftRightRwithT [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> shiftRleft: count [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> shiftRright: count [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> shiftTright: count [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> shortJumpIfCarryTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> shortJumpIfEqualTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> shortJumpIfNotCarryTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> shortJumpIfNotEqualTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> shortJumpIfNotZeroTo: label [
	self shortJumpIfNotEqualTo: label
]

{ #category : #jumps }
Assembler >> shortJumpIfSignTo: label [
	self subclassResponsibility
]

{ #category : #jumps }
Assembler >> shortJumpIfZeroTo: label [
	self shortJumpIfEqualTo: label
]

{ #category : #jumps }
Assembler >> shortJumpTo: label [
	self subclassResponsibility
]

{ #category : #comparing }
Assembler >> smallInteger: anInteger [
	^(anInteger bitShift: 1) + 1
]

{ #category : #'floting point' }
Assembler >> sqrtDoubleX0 [
	self subclassResponsibility
]

{ #category : #'floting point' }
Assembler >> storeAinThreadVariableAtIndexR [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeAinTindex: index [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeByteAinRindex: index [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeByteTinRatA [
	self subclassResponsibility
]

{ #category : #'floting point' }
Assembler >> storeDoubleResultInRindirect [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeEinRindex: index [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeLargeX0inA [
	self subclassResponsibility		
]

{ #category : #storing }
Assembler >> storeLargeX0inT [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeLongTinRatA [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeLongTinRatOffsetA [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> storeMXCSRintoA [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeRinAindex: index [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeRinEindex: index [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeRinFPindex: index [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeRinSindex: index [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeRinTindex: index [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeShortAinRoffset: offset [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeShortTinRatOffsetA [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeSinRindex: index [
	self subclassResponsibility
]

{ #category : #'floting point' }
Assembler >> storeTIBatRwithA [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeTinRatA [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeTinRatOffsetA [
	self subclassResponsibility
]

{ #category : #storing }
Assembler >> storeTinRindex: index [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> sub: src2 from: src1AndDst [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> subAfromR [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> subAfromT [
	self subclassResponsibility
]

{ #category : #'floting point' }
Assembler >> subDoubleX1fromX0 [
	self subclassResponsibility
]

{ #category : #arithmetic }
Assembler >> subFromRconstant: imm [
	self subclassResponsibility
]

{ #category : #'operations - arithmetic' }
Assembler >> subImm: imm from: srcAndDst [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> subTslotsToSP [
	self subclassResponsibility
]

{ #category : #initialization }
Assembler >> platform: aNativizationPlatform [
	self reset
]

{ #category : #loading }
Assembler >> testIntegerBit: aRegister [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> testIntegerBitOf: aRegister [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> testRintegerBit [
	self subclassResponsibility
]

{ #category : #loading }
Assembler >> testRwithR [
	self subclassResponsibility
]

{ #category : #services }
Assembler >> wordSize [
	self subclassResponsibility
]

{ #category : #'to-cleanup' }
Assembler >> writeTslots [
	self subclassResponsibility
]

{ #category : #'operations - logical' }
Assembler >> xor: src1AndDst with: src2 [
	^ self subclassResponsibility
]

{ #category : #logic }
Assembler >> xorAwithR [
	self subclassResponsibility
]

{ #category : #logic }
Assembler >> xorFPwithFP [
	self subclassResponsibility
]

{ #category : #logic }
Assembler >> xorRwithA [
	self subclassResponsibility
]

