'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #Assembler category: #'Powerlang-Core-Assembly'!
Object subclass: #Assembler
	instanceVariableNames: 'labels literals'
	classVariableNames: 'IndexedLabels'
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!Assembler commentStamp: '<historical>' prior: 0!

I am the JIT assembler frontend. I provide a high-level assembler interface (if that really exists)
and delegate writing of the actual bytes to my backends.
!

!Assembler methodsFor:  'labels' stamp: 'KenD 28/Jun/2026 13:27:40'!
@ label
	self addLabel: label
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
add: source1 to: source2andDest
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addAtoR
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addDoubleX1toX0
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addImm: imm to: dest
	self subclassResponsibility
! !

!Assembler methodsFor:  'labels' stamp: 'KenD 28/Jun/2026 13:27:40'!
addLabel: aString
	self addLabel: aString to: self currentAddress
! !

!Assembler methodsFor:  'labels' stamp: 'KenD 28/Jun/2026 13:27:40'!
addLabel: label to: location
	labels at: label put: location
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
addLiteral: anObject
	| index |
	index := literals
		identityIndexOf: anObject
		ifAbsent: [ literals
				add: anObject;
				size ].
	^ index + 2
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addRwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addSPwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addTtoR
	self subclassResponsibility
! !

!Assembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addTwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
alignTo: anInteger
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
and: source1andDest with: source2
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
and: source1andDest withImm: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
andRwithA
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
andRwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
breakpoint
	self subclassResponsibility
! !

!Assembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
buildFrame
	self subclassResponsibility
! !

!Assembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
bytes
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
callIndirectA
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
callIndirectM
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
callR
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearFPUFlags
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearIntegerBit: srcAndDstReg
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearRhigh32
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearRintegerBit
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearSafeIntegerBit: srcAndDstReg
	self and: srcAndDstReg withImm: -2
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearSafeRintegerBit
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compare: reg1 with: reg2
	self subclassResponsibility
! !

!Assembler methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compare: register withBoolean: aBoolean
	aBoolean
		ifTrue: [ self compareWithTrue: register ]
		ifFalse: [ self compareWithFalse: register ]
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compare: register withLiteral: anObject
	self subclassResponsibility
! !

!Assembler methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareAwithBoolean: aBoolean
	aBoolean
		ifTrue: [ self compareAwithTrue ]
		ifFalse: [ self compareAwithFalse ]
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareAwithFalse
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareAwithTrue
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareEqualDoubleX0withAindirect
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareLessThanDoubleX0withAindirect
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithA
	self subclassResponsibility
! !

!Assembler methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithBoolean: aBoolean
	aBoolean
		ifTrue: [ self compareRwithTrue ]
		ifFalse: [ self compareRwithFalse ]
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithFalse
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithNil
	self subclassResponsibility
! !

!Assembler methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithSmallInteger: anInteger
	| smi |
	smi := self smallInteger: anInteger.
	self compareRwithImmediate: smi
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithTrue
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareSwithTindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareTwithA
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareTwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareWithFalse: register
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareWithNil: register
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareWithTrue: register
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertAtoNativeInteger
	self subclassResponsibility
	
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertRtoNativeInteger
	self subclassResponsibility
	
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertRtoSmallInteger
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertToNativeInteger: srcAndDstReg
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertToSmallInteger: srcAndDstReg
	self shiftLeft: srcAndDstReg byImm: 1; inc: srcAndDstReg
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertTtoNativeInteger
	self subclassResponsibility	
! !

!Assembler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
currentAddress
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
dec: srcAndDstReg
	self subclassResponsibility
! !

!Assembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
decRindirect
	self subclassResponsibility
! !

!Assembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
discardArguments: anInteger
	self subclassResponsibility
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
divideDoubleX0byX1
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
dropTopOfFPU
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
dropTos: count
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
exchangeRindirectWithT
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
extendRtoAandDividebyT
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
inc: srcAndDstReg
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeS
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfEqualTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfGreaterOrEqualSignedTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfGreaterSignedTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfLessOrEqualSignedTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfLessSignedTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfNotEqualTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfNotZeroTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfOverflowTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfSignTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpIfZeroTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpOver: aBlock
	| label |
	label := self newLabel.
	self jumpTo: label.
	aBlock value.
	self @ label
! !

!Assembler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpToMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledIntegerBitTestOf: aRegister
	| label |
	self testIntegerBitOf: aRegister.
	label := self newLabel.
	self shortJumpIfZeroTo: label.
	^label
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledIntegerBitTestOfR
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledIntegerBitTestOfT
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledIntegerNativizationOf: aRegister
	| label |
	self convertToNativeInteger: aRegister.
	label := self newLabel.
	self shortJumpIfNotCarryTo: label.
	^label
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledIntegerNativizationOfA
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledIntegerNativizationOfR
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledIntegerNativizationOfT
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledNonIntegerBitTestOf: aRegister
	| label |
	self testIntegerBitOf: aRegister.
	label := self newLabel.
	self shortJumpIfNotZeroTo: label.
	^label
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
labeledNonIntegerBitTestOfR
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
leadingRzeroCount
	self subclassResponsibility
! !

!Assembler methodsFor:  'memory - load / store' stamp: 'KenD 28/Jun/2026 13:27:40'!
load: dstReg fromMem: srcMemRef
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
load:dstReg withImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
load: register withLiteral: anObject
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithAindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithEindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithFalse
	self subclassResponsibility
! !

!Assembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithGindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithGlobal: aSymbol
	| index |
	index := NativizationEnvironment indexOfGlobal: aSymbol.
	self loadAwithGindex: index
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithKnown: anObject
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadAwithMindex: index
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithNil
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithR
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithRoffsetAtA
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithS
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithSindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithSmallInteger: anInteger
	| smi |
	smi := (anInteger bitShift: 1) + 1.
	self loadAwithImmediate: smi
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithTrue
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadEwithAddressOfRatA
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadEwithFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadEwithNil
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadEwithR
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadFPwithR
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadFPwithSP
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadFalseWithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadFalseWithMindex: index
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadFalseWithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadGwithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadGwithMindex: index
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadGwithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLargeX0withRindirect
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLargeX1withAindirect
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLongMwithIPoffset: anInteger
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLongRwithRatOffsetA
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLongSwithRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMXCSRfromA
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithA
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithGindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithGlobal: aSymbol
	| index |
	index := NativizationEnvironment indexOfGlobal: aSymbol.
	self loadMwithGindex: index
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithTindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadNilWithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadNilWithMindex: index
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadNilWithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRconvertingDoublePointedByR
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithA
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithArgPointer
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithE
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithEindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithFP
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithFalse
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadRwithMindex: index
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithM
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithNil
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithRatA
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithRatOffsetA
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithS
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithSPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithSindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithSmallInteger: anInteger
	| smi |
	smi := self smallInteger: anInteger.
	self loadRwithImmediate: smi
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithT
	self subclassResponsibility
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithTIBatR
	self subclassResponsibility
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithThreadVariableAtR
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithTrue
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSPwithFP
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithAddressOfSatA
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithGindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithNil
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTrueWithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadTrueWithMindex: index
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTrueWithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithA
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithAindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithEindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithImmediate: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithLiteral: anObject
	| index |
	index := self addLiteral: anObject.
	self loadTwithMindex: index
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithMindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithR
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithTindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadWithFalse: register
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadWithNil: register
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadWithTrue: register
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadX0withRasDouble
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByte: dstReg from: srcBaseReg atIndexAt: srcIndexReg
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByte: dstReg from: srcBaseReg atIndexImm: indexImm
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByte: reg1 from: reg2 atOffset: offset
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByteRwithRatA
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByteRwithRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByteRwithSPatA
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByteTwithAindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendLongRwithRatA
	self subclassResponsibility
! !

!Assembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendLongRwithRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendShortRwithRoffset: offset
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
lock
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
loop: aBlock times: anInteger
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
loopTtimes: aBlock
	self subclassResponsibility
! !

!Assembler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
move: srcReg to: dstReg
	self subclassResponsibility
! !

!Assembler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveImm: imm to: dstReg
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveTslots
	self subclassResponsibility
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveX0toR
	self subclassResponsibility
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
multiplyDoubleX0byX1
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
multiplyRbyAwideningToA
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativeCode
	self subclassResponsibility
! !

!Assembler methodsFor:  'labels' stamp: 'KenD 28/Jun/2026 13:27:40'!
newLabel
	| label next |
	next := labels size + 1.
	IndexedLabels size < next ifTrue: [self class growIndexedLabelsTo: next].
	label := IndexedLabels at: next.
	self addLabel: label to: nil.
	^label
! !

!Assembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
or: src1AndDst with: src2
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
or: source1andDest withImm: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
orRwithA
	self subclassResponsibility
! !

!Assembler methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
platform: aNativizationPlatform
! !

!Assembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
pop: dstReg
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popA
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popE
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popFP
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popFalse
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popG
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popM
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popNil
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popR
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popS
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
popSPindirect
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popT
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popTrue
	self subclassResponsibility
! !

!Assembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
push: srcReg
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushA
	self subclassResponsibility
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushAatToffset: offset
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushE
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushFP
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushFalse
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushG
	self subclassResponsibility
! !

!Assembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushImm: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushIndirectR
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushM
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushNil
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushR
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushS
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushSmallInteger: integer
	| smi |
	smi := self smallInteger: integer.
	self pushImm: smi
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushT
	self subclassResponsibility
! !

!Assembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushTrue
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
readFPUStatusOnA
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regA
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regA8
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regE
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regFP
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regFalse
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regG
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regIP
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regM
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regNil
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regR
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regR8
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regS
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regSP
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regT
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regT8
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regTrue
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regV
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regX0
	self subclassResponsibility
! !

!Assembler methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regX1
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
renameByteRegisterIfNeeded: register preserving: preserved during: aBlock
	self subclassResponsibility
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
renameByteRegisterIfNeeded: register preserving: preserved1 preserving: preserved2 during: aBlock
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
reserveStackSlots: amount
	self subclassResponsibility
! !

!Assembler methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
reset
	labels := Dictionary new: 100.
	literals := OrderedCollection new.
! !

!Assembler methodsFor:  'labels' stamp: 'KenD 28/Jun/2026 13:27:40'!
resolveLabel: aString
	^labels at: aString
! !

!Assembler methodsFor:  'epilogue' stamp: 'KenD 28/Jun/2026 13:27:40'!
restoreCallerEnvironment
	self loadEwithFPindex: -2
! !

!Assembler methodsFor:  'epilogue' stamp: 'KenD 28/Jun/2026 13:27:40'!
restoreCallerFrame
	self subclassResponsibility
! !

!Assembler methodsFor:  'epilogue' stamp: 'KenD 28/Jun/2026 13:27:40'!
restoreCallerM
	self loadMwithFPindex: -1
! !

!Assembler methodsFor:  'epilogue' stamp: 'KenD 28/Jun/2026 13:27:40'!
restoreCallerSelf
	self loadSwithFPindex: 0
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
return
	self subclassResponsibility
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
roundDoubleX0intoX1
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
saveCallerFrame
	self pushFP; loadFPwithSP
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
scaleFloatOnRWithA
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
setIntegerBit: srcAndDstReg
	self setSafeIntegerBit: srcAndDstReg
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
setRintegerBit
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
setSafeIntegerBit: srcAndDstReg
	self or: srcAndDstReg withImm: 1
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
setSafeRintegerBit
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftLeft: srcAndDst by: countReg
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftLeft: srcAndDst byImm: count
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftLeftRwithT
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftLogicalRright: count
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRight: srcAndDst by: countReg
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRight: srcAndDst byImm: count
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRightArithmetic: srcAndDst by: countReg
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRightArithmetic: srcAndDst byImm: count
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRightRwithT
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRleft: count
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRright: count
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftTright: count
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfCarryTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfEqualTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfNotCarryTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfNotEqualTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfNotZeroTo: label
	self shortJumpIfNotEqualTo: label
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfSignTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpIfZeroTo: label
	self shortJumpIfEqualTo: label
! !

!Assembler methodsFor:  'jumps' stamp: 'KenD 28/Jun/2026 13:27:40'!
shortJumpTo: label
	self subclassResponsibility
! !

!Assembler methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
smallInteger: anInteger
	^(anInteger bitShift: 1) + 1
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
sqrtDoubleX0
	self subclassResponsibility
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeAinThreadVariableAtIndexR
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeAinTindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeByteAinRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeByteTinRatA
	self subclassResponsibility
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeDoubleResultInRindirect
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeEinRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeLargeX0inA
	self subclassResponsibility		
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeLargeX0inT
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeLongTinRatA
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeLongTinRatOffsetA
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeMXCSRintoA
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinAindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinEindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinFPindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinSindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinTindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeShortAinRoffset: offset
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeShortTinRatOffsetA
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeSinRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeTIBatRwithA
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeTinRatA
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeTinRatOffsetA
	self subclassResponsibility
! !

!Assembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeTinRindex: index
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
sub: src2 from: src1AndDst
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subAfromR
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subAfromT
	self subclassResponsibility
! !

!Assembler methodsFor:  'floting point' stamp: 'KenD 28/Jun/2026 13:27:40'!
subDoubleX1fromX0
	self subclassResponsibility
! !

!Assembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subFromRconstant: imm
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subImm: imm from: srcAndDst
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
subTslotsToSP
	self subclassResponsibility
! !

!Assembler methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
platform: aNativizationPlatform
	self reset
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
testIntegerBit: aRegister
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
testIntegerBitOf: aRegister
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
testRintegerBit
	self subclassResponsibility
! !

!Assembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
testRwithR
	self subclassResponsibility
! !

!Assembler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSize
	self subclassResponsibility
! !

!Assembler methodsFor:  'to-cleanup' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeTslots
	self subclassResponsibility
! !

!Assembler methodsFor:  'operations - logical' stamp: 'KenD 28/Jun/2026 13:27:40'!
xor: src1AndDst with: src2
	^ self subclassResponsibility
! !

!Assembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
xorAwithR
	self subclassResponsibility
! !

!Assembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
xorFPwithFP
	self subclassResponsibility
! !

!Assembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
xorRwithA
	self subclassResponsibility
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Assembler class' category: #'Powerlang-Core-Assembly'!
Assembler class
	instanceVariableNames: 'IndexedLabels'!

!Assembler class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
growIndexedLabelsTo: anInteger
	| new |
	new := (IndexedLabels size + 1 to: anInteger)
		collect: [:i | ('@' , i asString) asSymbol].
	IndexedLabels := IndexedLabels , new
! !

!Assembler class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	self initializeIndexedLabels
	
! !

!Assembler class methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeIndexedLabels
	IndexedLabels := #().
	self growIndexedLabelsTo: 100
! !


Assembler initialize!

