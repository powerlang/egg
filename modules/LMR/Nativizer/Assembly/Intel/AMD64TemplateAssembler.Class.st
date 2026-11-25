'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #AMD64TemplateAssembler category: #'Powerlang-Core-Assembler-Intel'!
Assembler subclass: #AMD64TemplateAssembler
	instanceVariableNames: 'wordSize buffer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembler-Intel'!
!AMD64TemplateAssembler commentStamp: '<historical>' prior: 0!

Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addAtoR
	self assembleBytes: #[16r48 16r1 16rD0].
	
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addDoubleX1toX0
	self assembleBytes: #[16rF2 16rF 16r58 16rC1].
	
! !

!AMD64TemplateAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addSPwithImmediate: imm
	(-128 <= imm and: [ imm < 128 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16r83 16rC4];
				assembleByte: imm ].
	(-16r80000000 <= imm and: [ imm < 16r80000000 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16r81 16rC4];
				assembleBytes: imm count: 4 ].
	self
		assembleBytes: #[16r49 16rBB];
		assembleBytes: imm count: 8;
		assembleBytes: #[16r4C 16r1 16rDC]
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
addTtoR
	self assembleBytes: #[16r48 16r1 16rC8].
	
! !

!AMD64TemplateAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
andRwithA
	self assembleBytes: #[16r48 16r21 16rD0].

! !

!AMD64TemplateAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
andRwithImmediate: imm
	(-128 <= imm and: [ imm < 128 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16r83 16rE0];
				assembleByte: imm ].
	(-16r80000000 <= imm and: [ imm < 16r80000000 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16r25];
				assembleBytes: imm count: 4 ].
	self
		assembleBytes: #[16r49 16rBB];
		assembleBytes: imm count: 8;
		assembleBytes: #[16r4C 16r21 16rD8]
! !

!AMD64TemplateAssembler methodsFor:  'relocation' stamp: 'KenD 28/Jun/2026 13:27:40'!
applyFixups
	buffer applyFixupsWith: self
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleByte: anInteger
	buffer nextBytePut: anInteger
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBytes: aByteArray
	buffer nextBytesPut: aByteArray
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
assembleBytes: value count: count
	self ASSERT: value isInteger.
	self ASSERT:(count == 4 or:[ count == 8 ]).

	count == 4 
		ifTrue: [ buffer nextLongPut: value] 
		ifFalse: [ buffer nextLargePut: value]
! !

!AMD64TemplateAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
buildFrame
	self assembleBytes: #[16r55 16r48 16r89 16rE5].
	
! !

!AMD64TemplateAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
callIndirectA
	self assembleBytes: #[16rFF 16r12].
	
! !

!AMD64TemplateAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
callR
	self assembleBytes: #[16rFF 16rD0].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearFPUFlags
	self assembleBytes: #[16rDB 16rE2].
	
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearRhigh32
	self assembleBytes: #[16r89 16rC0].
	
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearRintegerBit
	self assembleBytes: #[16r48 16rFF 16rC8].
	
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
clearSafeRintegerBit
	self assembleBytes: #[16r24 16rFE].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareEqualDoubleX0withAindirect
	self assembleBytes: #[16rF2 16rF 16rC2 16r2 16r0].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareLessThanDoubleX0withAindirect
	self assembleBytes: #[16rF2 16rF 16rC2 16r2 16r1].
	
! !

!AMD64TemplateAssembler methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithA
	self assembleBytes: #[16r48 16r39 16rD0].
	
! !

!AMD64TemplateAssembler methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareRwithImmediate: imm
	(-128 <= imm and: [ imm < 128 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16r83 16rF8];
				assembleByte: imm ].
	(-16r80000000 <= imm and: [ imm < 16r80000000 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16r3D];
				assembleBytes: imm count: 4 ].
	self
		assembleBytes: #[16r49 16rBB];
		assembleBytes: imm count: 8;
		assembleBytes: #[16r4C 16r39 16rD8]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareSwithTindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r3B 16r31]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r3B 16r71];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r3B 16rB1];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:40'!
compareTwithImmediate: imm
	(-128 <= imm and: [ imm < 128 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16r83 16rF9];
				assembleByte: imm ].
	(-16r80000000 <= imm and: [ imm < 16r80000000 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16r81 16rF9];
				assembleBytes: imm count: 4 ].
	self
		assembleBytes: #[16r49 16rBB];
		assembleBytes: imm count: 8;
		assembleBytes: #[16r4C 16r39 16rD9]
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertAtoNativeInteger
	self assembleBytes: #[16r48 16rD1 16rFA].
	
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertRtoNativeInteger
	self assembleBytes: #[16r48 16rD1 16rF8].
	
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertRtoSmallInteger
	self assembleBytes: #[16r48 16rD1 16rE0 16r48 16rFF 16rC0].
	
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
convertTtoNativeInteger
	self assembleBytes: #[16r48 16rD1 16rF9].
	
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
divideDoubleX0byX1
	self assembleBytes: #[16rF2 16rF 16r5E 16rC1].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
dropTopOfFPU
	self assembleBytes: #[16rDD 16rD8].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
exchangeRindirectWithT
	self assembleBytes: #[16r48 16r87 16r8].
	
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
extendRtoAandDividebyT
	self assembleBytes: #[16r48 16r99 16r48 16rF7 16rF9].
	
! !

!AMD64TemplateAssembler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:40'!
initializeS
	self assembleBytes: #[16r48 16r89 16rC6].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithAindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r12]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r52];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r92];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithEindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r17]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r57];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r97];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithFPindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r55 16r0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r55];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r95];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithFalse
	self assembleBytes: #[16r4C 16r89 16rF2]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithImmediate: imm
	(-16r80000000 <= imm and: [ imm < 16r80000000 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16rC7 16rC2];
				assembleBytes: imm count: 4 ].
	self
		assembleBytes: #[16r48 16rBA];
		assembleBytes: imm count: 8
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithNil
	self assembleBytes: #[16r4C 16r89 16rE2]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithR
	self assembleBytes: #[16r48 16r89 16rC2].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithRoffsetAtA
	self assembleBytes: #[16r48 16r8B 16r14 16r10].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithS
	self assembleBytes: #[16r48 16r89 16rF2].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithSindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r16]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r56];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r96];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadAwithTrue
	self assembleBytes: #[16r4C 16r89 16rEA]
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadEwithAddressOfRatA
	self assembleBytes: #[16r48 16r8D 16r7C 16rD0 16rF8].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadEwithFPindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r7D 16r0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r7D];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16rBD];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadEwithR
	self assembleBytes: #[16r48 16r89 16rC7].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadFPwithR
	self assembleBytes: #[16r48 16r89 16rC5].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadFPwithSP
	self assembleBytes: #[16r48 16r89 16rE5].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLargeX0withRindirect
	self assembleBytes: #[16r66 16r48 16rF 16r6E 16r0].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLargeX1withAindirect
	self assembleBytes: #[16r66 16r48 16rF 16r6E 16rA].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadLongRwithRatOffsetA
	self assembleBytes: #[16r8B 16r4 16r10].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMXCSRfromA
	self assembleBytes: #[16rF 16rAE 16r12].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadMwithA
	self assembleBytes: #[16r48 16r89 16rD3]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRconvertingDoublePointedByR
	self assembleBytes: #[16rF2 16r48 16rF 16r2C 16r0].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithA
	self assembleBytes: #[16r48 16r89 16rD0].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithArgPointer
	self assembleBytes: #[16r48 16r8D 16r45 16r10].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithE
	self assembleBytes: #[16r48 16r89 16rF8].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithEindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r7]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r47];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r87];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithFP
	self assembleBytes: #[16r48 16r89 16rE8].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithFPindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r45 16r0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r45];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r85];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithFalse
	self assembleBytes: #[16r4C 16r89 16rF0]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithImmediate: imm
	(-16r80000000 <= imm and: [ imm < 16r80000000 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16rC7 16rC0];
				assembleBytes: imm count: 4 ].
	self
		assembleBytes: #[16r48 16rB8];
		assembleBytes: imm count: 8
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithM
	self assembleBytes: #[16r48 16r89 16rD8]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithMindex: index
	| offset |
	offset := (index - 1) * wordSize.
	offset = 0
		ifTrue: [ ^ self assembleBytes: #[16r48 16r8B 16r03] ].
	(-128 <= offset and: [ offset < 128 ])
		ifTrue: [ self
				assembleBytes: #[16r48 16r8B 16r43];
				assembleByte: offset ]
		ifFalse: [ self
				assembleBytes: #[16r48 16r8B 16r83];
				assembleBytes: offset count: 4 ]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithNil
	self assembleBytes: #[16r4C 16r89 16rE0]
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithRatA
	self assembleBytes: #[16r48 16r8B 16r44 16rD0 16rF8].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithRatOffsetA
	self assembleBytes: #[16r48 16r8B 16r4 16r10].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithRindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r40];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r80];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithS
	self assembleBytes: #[16r48 16r89 16rF0].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithSPindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r4 16r24]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r44 16r24];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r84 16r24];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithSindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r6]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r46];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r86];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithT
	self assembleBytes: #[16r48 16r89 16rC8].
	
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithTIBatR
	self assembleBytes: #[16r65 16r48 16r8B 16r4 16rC5 16r0 16r0 16r0 16r0].
	
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithThreadVariableAtR
	self assembleBytes: #[16r65 16r48 16r8B 16r4 16rC5 16r80 16r14 16r0 16r0].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadRwithTrue
	self assembleBytes: #[16r4C 16r89 16rE8]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSPwithFP
	self assembleBytes: #[16r48 16r89 16rEC].
	
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithAddressOfSatA
	self assembleBytes: #[16r48 16r8D 16r74 16rD6 16rF8].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithFPindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r75 16r0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r75];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16rB5];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadSwithRindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r30]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r70];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16rB0];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithA
	self assembleBytes: #[16r48 16r89 16rD1].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithAindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16rA]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r4A];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r8A];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithEindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16rF]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r4F];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r8F];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithFPindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r4D 16r0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r4D];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r8D];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithImmediate: imm
	(-16r80000000 <= imm and: [ imm < 16r80000000 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16rC7 16rC1];
				assembleBytes: imm count: 4 ].
	self
		assembleBytes: #[16r48 16rB9];
		assembleBytes: imm count: 8
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithR
	self assembleBytes: #[16r48 16r89 16rC1].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadTwithTindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r8B 16r9]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r8B 16r49];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r8B 16r89];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadX0withRasDouble
	self assembleBytes: #[16rF2 16r48 16rF 16r2A 16rC0].
	
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByteRwithRatA
	self assembleBytes: #[16r48 16rF 16rB6 16r44 16r10 16rFF].
	
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendByteRwithSPatA
	self assembleBytes: #[16r48 16rF 16rB6 16r44 16r14 16rFF].
	
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
loadZeroExtendLongRwithRatA
	self assembleBytes: #[16r8B 16r44 16r90 16rFC].
	
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
lock
	self assembleBytes: #[16rF0].
	
! !

!AMD64TemplateAssembler methodsFor:  'opcodes - integer related' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveTslots
	self assembleBytes: #[16rF3 16r48 16rA5].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
moveX0toR
	self assembleBytes: #[16r66 16r48 16rF 16r7E 16rC0].
	
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
multiplyDoubleX0byX1
	self assembleBytes: #[16rF2 16rF 16r59 16rC1].
	
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
multiplyRbyAwideningToA
	self assembleBytes: #[16r48 16rF7 16rEA].
	
! !

!AMD64TemplateAssembler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:40'!
nativeCode
	^ NativeCode new code: buffer bytes
! !

!AMD64TemplateAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
orRwithA
	self assembleBytes: #[16r48 16r9 16rD0].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popA
	self assembleBytes: #[16r5A].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popE
	self assembleBytes: #[16r5F].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popFP
	self assembleBytes: #[16r5D].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popR
	self assembleBytes: #[16r58].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popS
	self assembleBytes: #[16r5E].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popSPindirect
	self assembleBytes: #[16r8F 16r4 16r24].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
popT
	self assembleBytes: #[16r59].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushA
	self assembleBytes: #[16r52].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushAOnFPUStack
	self assembleBytes: #[16rDD 16r2].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushE
	self assembleBytes: #[16r57].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushFP
	self assembleBytes: #[16r55].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushImmediate: imm
	(-128 <= imm and: [ imm < 128 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r6A];
				assembleByte: imm ].
	(-16r80000000 <= imm and: [ imm < 16r80000000 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r68];
				assembleBytes: imm count: 4 ].
	self
		assembleBytes: #[16r49 16rBB];
		assembleBytes: imm count: 8;
		assembleBytes: #[16r41 16r53]
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushIndirectR
	self assembleBytes: #[16rFF 16r30].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushR
	self assembleBytes: #[16r50].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushROnFPUStack
	self assembleBytes: #[16rDD 16r0].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushS
	self assembleBytes: #[16r56].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
pushT
	self assembleBytes: #[16r51].
	
! !

!AMD64TemplateAssembler methodsFor:  'epilogue' stamp: 'KenD 28/Jun/2026 13:27:40'!
restoreCallerEnvironment
	self assembleBytes: #[16r48 16r8B 16r7D 16rE8].
	
! !

!AMD64TemplateAssembler methodsFor:  'epilogue' stamp: 'KenD 28/Jun/2026 13:27:40'!
restoreCallerFrame
	self assembleBytes: #[16r48 16r89 16rEC 16r5D].
	
! !

!AMD64TemplateAssembler methodsFor:  'epilogue' stamp: 'KenD 28/Jun/2026 13:27:40'!
restoreCallerM
	self assembleBytes: #[16r48 16r8B 16r5D 16rF0]
! !

!AMD64TemplateAssembler methodsFor:  'epilogue' stamp: 'KenD 28/Jun/2026 13:27:40'!
restoreCallerSelf
	self assembleBytes: #[16r48 16r8B 16r75 16rF8].
	
! !

!AMD64TemplateAssembler methodsFor:  'calls' stamp: 'KenD 28/Jun/2026 13:27:40'!
return
	self assembleBytes: #[16rC3]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
roundDoubleX0intoX1
	self assembleBytes: #[16r66 16rF 16r3A 16rB 16rC8 16r3].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
saveCallerFrame
	self assembleBytes: #[16r55 16r48 16r89 16rE5].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
scaleFloatOnRWithA
	self assembleBytes: #[16rDD 16r2 16rDD 16r0 16rD9 16rFD 16rDD 16r18 16rDD 16rD8].
	
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
setRintegerBit
	self assembleBytes: #[16rC 16r1].
	
! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
setSafeRintegerBit
	self assembleBytes: #[16rC 16r1].
	
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftLeftRwithT
	self assembleBytes: #[16r48 16rD3 16rE0].
	
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
shiftRightRwithT
	self assembleBytes: #[16r48 16rD3 16rF8].
	
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
sqrtDoubleX0
	self assembleBytes: #[16rF2 16rF 16r51 16rC0].
	
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeAinThreadVariableAtIndexR
	self assembleBytes: #[16r65 16r48 16r89 16r14 16rC5 16r80 16r14 16r0 16r0].
	
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeAinTindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r89 16r11]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r89 16r51];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r89 16r91];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeByteTinRatA
	self assembleBytes: #[16r88 16r4C 16r10 16rFF].
	
! !

!AMD64TemplateAssembler methodsFor:  'push/pop' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeDoubleResultInRindirect
	self assembleBytes: #[16r66 16r48 16rF 16r7E 16r0].
	
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeEinRindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r89 16r38]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r89 16r78];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r89 16rB8];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeLargeX0inA
	self assembleBytes: #[16r66 16r48 16rF 16r7E 16r2].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeLargeX0inT
	self assembleBytes: #[16r66 16r48 16rF 16r7E 16r1].
	
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeLongTinRatA
	self assembleBytes: #[16r89 16r4C 16r90 16rFC].
	
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeLongTinRatOffsetA
	self assembleBytes: #[16r89 16rC 16r10].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeMXCSRintoA
	self assembleBytes: #[16rF 16rAE 16r1A].
	
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinAindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r89 16r2]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r89 16r42];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r89 16r82];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinEindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r89 16r7]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r89 16r47];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r89 16r87];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinFPindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r89 16r45 16r0]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r89 16r45];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r89 16r85];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinSindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r89 16r6]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r89 16r46];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r89 16r86];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeRinTindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r89 16r1]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r89 16r41];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r89 16r81];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeShortTinRatOffsetA
	self assembleBytes: #[16r66 16r89 16rC 16r10].
	
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeSinRindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r89 16r30]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r89 16r70];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r89 16rB0];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeTIBatRwithA
	self assembleBytes: #[16r65 16r48 16r89 16r14 16rC5 16r0 16r0 16r0 16r0].
	
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeTinRatA
	self assembleBytes: #[16r48 16r89 16r4C 16rD0 16rF8].
	
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeTinRatOffsetA
	self assembleBytes: #[16r48 16r89 16rC 16r10].
	
! !

!AMD64TemplateAssembler methodsFor:  'storing' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeTinRindex: index
	| offset |
	offset := index - 1 * wordSize.
	offset = 0 ifTrue: [^self assembleBytes: #[16r48 16r89 16r8]].
	(-128 <= offset and: [offset < 128])
		 ifTrue: [
			self
				assembleBytes: #[16r48 16r89 16r48];
		 		assembleByte: offset]
		ifFalse: [ 
			self
				assembleBytes: #[16r48 16r89 16r88];
				assembleBytes: offset count: 4]
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subAfromR
	self assembleBytes: #[16r48 16r29 16rD0].
	
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subAfromT
	self assembleBytes: #[16r48 16r29 16rD1].
	
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subDoubleX1fromX0
	self assembleBytes: #[16rF2 16rF 16r5C 16rC1].
	
! !

!AMD64TemplateAssembler methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:40'!
subTslotsToSP
	self assembleBytes: #[16r48 16rF7 16rD9 16r48 16r8D 16r24 16rCC 16r48 16rF7 16rD9].
	
! !

!AMD64TemplateAssembler methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:40'!
platform: aNativizationPlatform
	super platform: aNativizationPlatform.
	wordSize := aNativizationPlatform wordSize.
	buffer := RelocatableBuffer new.

! !

!AMD64TemplateAssembler methodsFor:  'integers' stamp: 'KenD 28/Jun/2026 13:27:40'!
testRintegerBit
	self assembleBytes: #[16rA8 16r1].
	
! !

!AMD64TemplateAssembler methodsFor:  'loading' stamp: 'KenD 28/Jun/2026 13:27:40'!
testRwithR
	self assembleBytes: #[16r48 16r85 16rC0].
	
! !

!AMD64TemplateAssembler methodsFor:  'opcodes - integer related' stamp: 'KenD 28/Jun/2026 13:27:40'!
writeTslots
	self assembleBytes: #[16rF3 16r48 16rAB].
	
! !

!AMD64TemplateAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
xorAwithR
	self assembleBytes: #[16r48 16r31 16rC2].
	
! !

!AMD64TemplateAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
xorFPwithFP
	self assembleBytes: #[16r48 16r31 16rED].
	
! !

!AMD64TemplateAssembler methodsFor:  'logic' stamp: 'KenD 28/Jun/2026 13:27:40'!
xorRwithA
	self assembleBytes: #[16r48 16r31 16rD0].
	
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AMD64TemplateAssembler class' category: #'Powerlang-Core-Assembler-Intel'!
AMD64TemplateAssembler class
	instanceVariableNames: ''!


