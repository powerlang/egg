'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #CodeGenerator category: #'Powerlang-Core-Assembly'!
Object subclass: #CodeGenerator
	instanceVariableNames: 'abi wordSize memory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembly'!
!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
add: source1 to: source2andDest
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'operations - arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addDouble: source1 to: source2andDest
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addImm: imm to: dest
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
addressBitSize
	^self addressSize * 8

! !

!CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
addressLength
	^wordSize * 8
! !

!CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
addressSize
	"Return the size of address in bytes, e.g, 4 for 32bit archs
	 and 8 for 64bit archs"

	^wordSize
! !

!CodeGenerator methodsFor:  'alignment' stamp: 'KenD 28/Jun/2026 13:27:40'!
alignTo: aNumber
	| current count |
	current := memory position.
	count := (current alignedTo: aNumber) - current.
	self nop: count
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
and: source1andDest with: source2
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
and: source1andDest withImm: imm
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'relocation' stamp: 'KenD 28/Jun/2026 13:27:40'!
baseAddress
	^memory baseAddress
! !

!CodeGenerator methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
bitLengthOf: anInteger
	(anInteger between: -16r80 and: 16r7F) ifTrue: [^8].
	(anInteger between: -16r8000 and: 16r7FFF) ifTrue: [^16].
	(anInteger between: -16r80000000 and: 16r7FFFFFFF) ifTrue: [^32].
	(anInteger between: -16r8000000000000000 and: 16r7FFFFFFFFFFFFFFF)
		ifTrue: [^64].
	(anInteger
		between: -16r80000000000000000000000000000000
		and: 16r7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
		ifTrue: [^128].
	^nil
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
breakpoint
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
bytes
	^memory bytes
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
call: srcReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
callIndirect: aMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearHigh32: srcAndDstReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
codeSize
	^memory codeSize
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compare: reg1 with: reg2
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compare: reg1 withImm: imm
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
compare: reg1 withMem: aMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
convert: src toDouble: dst
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'labels' stamp: 'KenD 28/Jun/2026 13:27:40'!
currentAddress
	^memory currentAddress
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
dec: srcAndDstReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
decMem: aMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
divDouble: src1andDstReg by: src2reg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
divide: srcAndDstReg extendingTo: extReg by: divisorReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
exchange: srcAndDstReg withMem: aMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
inc: srcAndDstReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
initialize
	memory := RelocatableBuffer new.
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpTo: label
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
jumpToMem: aMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
lea: dstReg withMem: srcMemRef
	^self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
load: dstReg convertingDoubleToIntegerFromMem: srcMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
load: dstReg fromMem: srcMemRef
	"Load `dstReg` from memory location `srcMemRef`.
	 The size of data loaded is specified in `srcMemRef`.

	 When loading 32bits into 64bit register, high 32bits must be
	 cleared (in other words, 32bit value is *zero* extended to
	 64bits and stored in `dstReg`.

	 However, when loading 16bits or 8bits, high 48 or 56 bits
	 are *left intact*.

	 This somewhat weird behavior is heritage of x86.
	"

	^ self subclassResponsibility

! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
load: dstReg withTIBat: indexReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
load: dstReg withThreadVariableAt: indexReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadDouble: dstReg fromMem: srcMemRef
	"Load 64-bit floating point `dstReg` from memory location `srcMemRef`"
	
	^ self subclassResponsibility
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef16
	"Return clean instance of memory reference."

	^ self memRef length: 16; yourself

! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef16: baseReg offset: offsetReg
	^ self memRef16
		base: baseReg;
		index: offsetReg;
		scale: 1;
		yourself
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef16: baseReg offsetImm: offsetImm
	^ self memRef16
		base: baseReg;
		displacement: offsetImm;
		yourself
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef32
	"Return clean instance of memory reference."

	^ self memRef length: 32; yourself

! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef32: baseReg index: indexReg
	^ self memRef32 
		base: baseReg; 
		displacement: -4;
		index: indexReg;
		scale: 4;
		yourself

! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef32: baseReg indexImm: indexImm
	^ self memRef32 
		base: baseReg; 
		displacement: (indexImm - 1) * 4;
		yourself

! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef32: baseReg offset: offsetReg
	^ self memRef32
		base: baseReg;
		index: offsetReg;
		scale: 1;
		yourself
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef64
	"Return clean instance of memory reference."

	^ self memRef length: 64; yourself

! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef64: baseReg indexImm: indexImm
	^ self memRef64
		base: baseReg;
		displacement: (indexImm - 1) * 8;
		yourself
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef8
	"Return clean instance of memory reference."

	^ self memRef length: 8; yourself

! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef8: baseReg index: indexReg
	^ self memRef8 
		base: baseReg; 
		displacement: -1;
		index: indexReg;
		scale: 1;
		yourself

! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef8: baseReg indexImm: indexImm
	^ self memRef8
		base: baseReg; 
		displacement: (indexImm - 1);
		yourself

! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef: baseReg index: indexRef
	^ self memRef 
		base: baseReg; 
		displacement: self addressSize negated;
		index: indexRef;
		scale: self addressSize;
		yourself

! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef: baseReg index: indexRef offsetImm: anInteger
	^ self memRef 
		base: baseReg; 
		displacement: anInteger;
		index: indexRef;
		scale: self addressSize;
		yourself

! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef: baseReg indexImm: indexImm
	^ self memRef 
		base: baseReg; 
		displacement: (indexImm - 1) * self addressSize;
		yourself

! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRef: baseReg offset: indexReg
	^ self memRef
		base: baseReg;
		index: indexReg;
		scale: 1;
		yourself
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRefAatT
^self memRef: self regA index: self regT
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
memRefSPatT
	^ self memRef: self regSP index: self regT
! !

!CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
memory
	^memory
! !

!CodeGenerator methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
move: srcReg to: dstReg
	^ self subclassResponsibility

! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveDouble: srcReg into: dstReg
	"move from X-type register srcReg into general purpose dstReg"
	
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveImm: imm to: dstReg
	"Load constant to register `dstImm`"

	self subclassResponsibility

! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
mulDouble: src1andDstReg by: src2reg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
multiply: src1AndDstLoReg by: src2reg wideningTo: dstHiReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativeCode
	^ NativeCode new code: memory bytes
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
or: src1andDest withImm: imm
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pop: dstReg
	^ self subclassResponsibility

! !

!CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popIntoMem: dstMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
push: srcReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushAOnFPUStack
	^ self subclassResponsibility

! !

!CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushImm: imm
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushMem: aMemRef
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushROnFPUStack
	^ self subclassResponsibility

! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regA
	^abi regA
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regE
	^abi regE
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regFP
	^abi regFP
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regFalse
	^abi regFalse
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regG
	^ abi regG
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regIP
	^abi regIP
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regM
	^abi regM
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regNil
	^abi regNil
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regR
	^abi regR
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regS
	^abi regS
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regSP
	^abi regSP
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regT
	^abi regT
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regTrue
	^abi regTrue
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regV
	^abi regV
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regX0
	^ abi regX0
! !

!CodeGenerator methodsFor:  'registers - IR' stamp: 'KenD 28/Jun/2026 13:27:40'!
regX1
	^ abi regX1
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
reset
	memory reset
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
roundDouble: srcReg into: dstReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftLeft: srcAndDst byImm: count
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRight: srcAndDst byImm: count
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRightArithmetic: srcAndDst by: countReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRightArithmetic: srcAndDst byImm: count
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
sqrtDouble: srcReg into: dstReg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
store: srcReg intoMem: dstMemRef
	"Store `srcReg` into memory location `dstMemRef`. 

	 The size of data loaded is specified in `dstMemRef`"
	^self subclassResponsibility
! !

!CodeGenerator methodsFor:  'memory' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeDouble: srcReg intoMem: dstMemRef
	^ self subclassResponsibility
! !

!CodeGenerator methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
stream
	^memory stream
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
sub: src1 from: src2AndDst
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subDouble: src1 from: src2AndDst
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subImm: imm from: srcAndDst
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
platform: aNativizationPlatform
	abi := aNativizationPlatform abi.
	wordSize := aNativizationPlatform wordSize.
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
test: src1Reg with: src2Reg
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'basic' stamp: 'KenD 28/Jun/2026 13:27:40'!
test: srcReg withImm: imm
	self subclassResponsibility
! !

!CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSize
	^wordSize
! !

!CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSize: anInteger
	self ASSERT: anInteger == 8.
	wordSize := anInteger.
! !

!CodeGenerator methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
wordSizeShift
	^wordSize = 8 ifTrue: [3] ifFalse: [2]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CodeGenerator class' category: #'Powerlang-Core-Assembly'!
CodeGenerator class
	instanceVariableNames: ''!


CodeGenerator initialize!

