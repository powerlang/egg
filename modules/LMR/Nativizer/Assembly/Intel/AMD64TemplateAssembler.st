"
Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"
Class {
	#name : #AMD64TemplateAssembler,
	#superclass : #Assembler,
	#instVars : [
		'wordSize',
		'buffer'
	],
	#category : #'Powerlang-Core-Assembler-Intel'
}

{ #category : #arithmetic }
AMD64TemplateAssembler >> addAtoR [
	self assembleBytes: #[16r48 16r1 16rD0].
	
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> addDoubleX1toX0 [
	self assembleBytes: #[16rF2 16rF 16r58 16rC1].
	
]

{ #category : #logic }
AMD64TemplateAssembler >> addSPwithImmediate: imm [
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
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> addTtoR [
	self assembleBytes: #[16r48 16r1 16rC8].
	
]

{ #category : #logic }
AMD64TemplateAssembler >> andRwithA [
	self assembleBytes: #[16r48 16r21 16rD0].

]

{ #category : #logic }
AMD64TemplateAssembler >> andRwithImmediate: imm [
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
]

{ #category : #relocation }
AMD64TemplateAssembler >> applyFixups [
	buffer applyFixupsWith: self
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> assembleByte: anInteger [
	buffer nextBytePut: anInteger
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> assembleBytes: aByteArray [
	buffer nextBytesPut: aByteArray
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> assembleBytes: value count: count [
	self ASSERT: value isInteger.
	self ASSERT:(count == 4 or:[ count == 8 ]).

	count == 4 
		ifTrue: [ buffer nextLongPut: value] 
		ifFalse: [ buffer nextLargePut: value]
]

{ #category : #private }
AMD64TemplateAssembler >> buildFrame [
	self assembleBytes: #[16r55 16r48 16r89 16rE5].
	
]

{ #category : #private }
AMD64TemplateAssembler >> callIndirectA [
	self assembleBytes: #[16rFF 16r12].
	
]

{ #category : #private }
AMD64TemplateAssembler >> callR [
	self assembleBytes: #[16rFF 16rD0].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> clearFPUFlags [
	self assembleBytes: #[16rDB 16rE2].
	
]

{ #category : #integers }
AMD64TemplateAssembler >> clearRhigh32 [
	self assembleBytes: #[16r89 16rC0].
	
]

{ #category : #integers }
AMD64TemplateAssembler >> clearRintegerBit [
	self assembleBytes: #[16r48 16rFF 16rC8].
	
]

{ #category : #integers }
AMD64TemplateAssembler >> clearSafeRintegerBit [
	self assembleBytes: #[16r24 16rFE].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> compareEqualDoubleX0withAindirect [
	self assembleBytes: #[16rF2 16rF 16rC2 16r2 16r0].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> compareLessThanDoubleX0withAindirect [
	self assembleBytes: #[16rF2 16rF 16rC2 16r2 16r1].
	
]

{ #category : #comparing }
AMD64TemplateAssembler >> compareRwithA [
	self assembleBytes: #[16r48 16r39 16rD0].
	
]

{ #category : #comparing }
AMD64TemplateAssembler >> compareRwithImmediate: imm [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> compareSwithTindex: index [
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
]

{ #category : #comparing }
AMD64TemplateAssembler >> compareTwithImmediate: imm [
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
]

{ #category : #integers }
AMD64TemplateAssembler >> convertAtoNativeInteger [
	self assembleBytes: #[16r48 16rD1 16rFA].
	
]

{ #category : #integers }
AMD64TemplateAssembler >> convertRtoNativeInteger [
	self assembleBytes: #[16r48 16rD1 16rF8].
	
]

{ #category : #integers }
AMD64TemplateAssembler >> convertRtoSmallInteger [
	self assembleBytes: #[16r48 16rD1 16rE0 16r48 16rFF 16rC0].
	
]

{ #category : #integers }
AMD64TemplateAssembler >> convertTtoNativeInteger [
	self assembleBytes: #[16r48 16rD1 16rF9].
	
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> divideDoubleX0byX1 [
	self assembleBytes: #[16rF2 16rF 16r5E 16rC1].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> dropTopOfFPU [
	self assembleBytes: #[16rDD 16rD8].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> exchangeRindirectWithT [
	self assembleBytes: #[16r48 16r87 16r8].
	
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> extendRtoAandDividebyT [
	self assembleBytes: #[16r48 16r99 16r48 16rF7 16rF9].
	
]

{ #category : #private }
AMD64TemplateAssembler >> initializeS [
	self assembleBytes: #[16r48 16r89 16rC6].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadAwithAindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadAwithEindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadAwithFPindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadAwithFalse [
	self assembleBytes: #[16r4C 16r89 16rF2]
]

{ #category : #loading }
AMD64TemplateAssembler >> loadAwithImmediate: imm [
	(-16r80000000 <= imm and: [ imm < 16r80000000 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16rC7 16rC2];
				assembleBytes: imm count: 4 ].
	self
		assembleBytes: #[16r48 16rBA];
		assembleBytes: imm count: 8
]

{ #category : #loading }
AMD64TemplateAssembler >> loadAwithNil [
	self assembleBytes: #[16r4C 16r89 16rE2]
]

{ #category : #loading }
AMD64TemplateAssembler >> loadAwithR [
	self assembleBytes: #[16r48 16r89 16rC2].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadAwithRoffsetAtA [
	self assembleBytes: #[16r48 16r8B 16r14 16r10].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadAwithS [
	self assembleBytes: #[16r48 16r89 16rF2].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadAwithSindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadAwithTrue [
	self assembleBytes: #[16r4C 16r89 16rEA]
]

{ #category : #integers }
AMD64TemplateAssembler >> loadEwithAddressOfRatA [
	self assembleBytes: #[16r48 16r8D 16r7C 16rD0 16rF8].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadEwithFPindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadEwithR [
	self assembleBytes: #[16r48 16r89 16rC7].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadFPwithR [
	self assembleBytes: #[16r48 16r89 16rC5].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadFPwithSP [
	self assembleBytes: #[16r48 16r89 16rE5].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadLargeX0withRindirect [
	self assembleBytes: #[16r66 16r48 16rF 16r6E 16r0].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadLargeX1withAindirect [
	self assembleBytes: #[16r66 16r48 16rF 16r6E 16rA].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadLongRwithRatOffsetA [
	self assembleBytes: #[16r8B 16r4 16r10].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadMXCSRfromA [
	self assembleBytes: #[16rF 16rAE 16r12].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> loadMwithA [
	self assembleBytes: #[16r48 16r89 16rD3]
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRconvertingDoublePointedByR [
	self assembleBytes: #[16rF2 16r48 16rF 16r2C 16r0].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithA [
	self assembleBytes: #[16r48 16r89 16rD0].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithArgPointer [
	self assembleBytes: #[16r48 16r8D 16r45 16r10].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithE [
	self assembleBytes: #[16r48 16r89 16rF8].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithEindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithFP [
	self assembleBytes: #[16r48 16r89 16rE8].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithFPindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithFalse [
	self assembleBytes: #[16r4C 16r89 16rF0]
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithImmediate: imm [
	(-16r80000000 <= imm and: [ imm < 16r80000000 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16rC7 16rC0];
				assembleBytes: imm count: 4 ].
	self
		assembleBytes: #[16r48 16rB8];
		assembleBytes: imm count: 8
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithM [
	self assembleBytes: #[16r48 16r89 16rD8]
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithMindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithNil [
	self assembleBytes: #[16r4C 16r89 16rE0]
]

{ #category : #integers }
AMD64TemplateAssembler >> loadRwithRatA [
	self assembleBytes: #[16r48 16r8B 16r44 16rD0 16rF8].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithRatOffsetA [
	self assembleBytes: #[16r48 16r8B 16r4 16r10].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithRindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithS [
	self assembleBytes: #[16r48 16r89 16rF0].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithSPindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithSindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithT [
	self assembleBytes: #[16r48 16r89 16rC8].
	
]

{ #category : #storing }
AMD64TemplateAssembler >> loadRwithTIBatR [
	self assembleBytes: #[16r65 16r48 16r8B 16r4 16rC5 16r0 16r0 16r0 16r0].
	
]

{ #category : #storing }
AMD64TemplateAssembler >> loadRwithThreadVariableAtR [
	self assembleBytes: #[16r65 16r48 16r8B 16r4 16rC5 16r80 16r14 16r0 16r0].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadRwithTrue [
	self assembleBytes: #[16r4C 16r89 16rE8]
]

{ #category : #loading }
AMD64TemplateAssembler >> loadSPwithFP [
	self assembleBytes: #[16r48 16r89 16rEC].
	
]

{ #category : #integers }
AMD64TemplateAssembler >> loadSwithAddressOfSatA [
	self assembleBytes: #[16r48 16r8D 16r74 16rD6 16rF8].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadSwithFPindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadSwithRindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadTwithA [
	self assembleBytes: #[16r48 16r89 16rD1].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadTwithAindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadTwithEindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadTwithFPindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadTwithImmediate: imm [
	(-16r80000000 <= imm and: [ imm < 16r80000000 ])
		ifTrue: [ ^ self
				assembleBytes: #[16r48 16rC7 16rC1];
				assembleBytes: imm count: 4 ].
	self
		assembleBytes: #[16r48 16rB9];
		assembleBytes: imm count: 8
]

{ #category : #loading }
AMD64TemplateAssembler >> loadTwithR [
	self assembleBytes: #[16r48 16r89 16rC1].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> loadTwithTindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> loadX0withRasDouble [
	self assembleBytes: #[16rF2 16r48 16rF 16r2A 16rC0].
	
]

{ #category : #integers }
AMD64TemplateAssembler >> loadZeroExtendByteRwithRatA [
	self assembleBytes: #[16r48 16rF 16rB6 16r44 16r10 16rFF].
	
]

{ #category : #integers }
AMD64TemplateAssembler >> loadZeroExtendByteRwithSPatA [
	self assembleBytes: #[16r48 16rF 16rB6 16r44 16r14 16rFF].
	
]

{ #category : #integers }
AMD64TemplateAssembler >> loadZeroExtendLongRwithRatA [
	self assembleBytes: #[16r8B 16r44 16r90 16rFC].
	
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> lock [
	self assembleBytes: #[16rF0].
	
]

{ #category : #'opcodes - integer related' }
AMD64TemplateAssembler >> moveTslots [
	self assembleBytes: #[16rF3 16r48 16rA5].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> moveX0toR [
	self assembleBytes: #[16r66 16r48 16rF 16r7E 16rC0].
	
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> multiplyDoubleX0byX1 [
	self assembleBytes: #[16rF2 16rF 16r59 16rC1].
	
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> multiplyRbyAwideningToA [
	self assembleBytes: #[16r48 16rF7 16rEA].
	
]

{ #category : #accessing }
AMD64TemplateAssembler >> nativeCode [
	^ NativeCode new code: buffer bytes
]

{ #category : #logic }
AMD64TemplateAssembler >> orRwithA [
	self assembleBytes: #[16r48 16r9 16rD0].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> popA [
	self assembleBytes: #[16r5A].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> popE [
	self assembleBytes: #[16r5F].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> popFP [
	self assembleBytes: #[16r5D].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> popR [
	self assembleBytes: #[16r58].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> popS [
	self assembleBytes: #[16r5E].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> popSPindirect [
	self assembleBytes: #[16r8F 16r4 16r24].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> popT [
	self assembleBytes: #[16r59].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> pushA [
	self assembleBytes: #[16r52].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> pushAOnFPUStack [
	self assembleBytes: #[16rDD 16r2].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> pushE [
	self assembleBytes: #[16r57].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> pushFP [
	self assembleBytes: #[16r55].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> pushImmediate: imm [
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
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> pushIndirectR [
	self assembleBytes: #[16rFF 16r30].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> pushR [
	self assembleBytes: #[16r50].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> pushROnFPUStack [
	self assembleBytes: #[16rDD 16r0].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> pushS [
	self assembleBytes: #[16r56].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> pushT [
	self assembleBytes: #[16r51].
	
]

{ #category : #epilogue }
AMD64TemplateAssembler >> restoreCallerEnvironment [
	self assembleBytes: #[16r48 16r8B 16r7D 16rE8].
	
]

{ #category : #epilogue }
AMD64TemplateAssembler >> restoreCallerFrame [
	self assembleBytes: #[16r48 16r89 16rEC 16r5D].
	
]

{ #category : #epilogue }
AMD64TemplateAssembler >> restoreCallerM [
	self assembleBytes: #[16r48 16r8B 16r5D 16rF0]
]

{ #category : #epilogue }
AMD64TemplateAssembler >> restoreCallerSelf [
	self assembleBytes: #[16r48 16r8B 16r75 16rF8].
	
]

{ #category : #calls }
AMD64TemplateAssembler >> return [
	self assembleBytes: #[16rC3]
]


{ #category : #loading }
AMD64TemplateAssembler >> roundDoubleX0intoX1 [
	self assembleBytes: #[16r66 16rF 16r3A 16rB 16rC8 16r3].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> saveCallerFrame [
	self assembleBytes: #[16r55 16r48 16r89 16rE5].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> scaleFloatOnRWithA [
	self assembleBytes: #[16rDD 16r2 16rDD 16r0 16rD9 16rFD 16rDD 16r18 16rDD 16rD8].
	
]

{ #category : #integers }
AMD64TemplateAssembler >> setRintegerBit [
	self assembleBytes: #[16rC 16r1].
	
]

{ #category : #integers }
AMD64TemplateAssembler >> setSafeRintegerBit [
	self assembleBytes: #[16rC 16r1].
	
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> shiftLeftRwithT [
	self assembleBytes: #[16r48 16rD3 16rE0].
	
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> shiftRightRwithT [
	self assembleBytes: #[16r48 16rD3 16rF8].
	
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> sqrtDoubleX0 [
	self assembleBytes: #[16rF2 16rF 16r51 16rC0].
	
]

{ #category : #storing }
AMD64TemplateAssembler >> storeAinThreadVariableAtIndexR [
	self assembleBytes: #[16r65 16r48 16r89 16r14 16rC5 16r80 16r14 16r0 16r0].
	
]

{ #category : #storing }
AMD64TemplateAssembler >> storeAinTindex: index [
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
]

{ #category : #storing }
AMD64TemplateAssembler >> storeByteTinRatA [
	self assembleBytes: #[16r88 16r4C 16r10 16rFF].
	
]

{ #category : #'push/pop' }
AMD64TemplateAssembler >> storeDoubleResultInRindirect [
	self assembleBytes: #[16r66 16r48 16rF 16r7E 16r0].
	
]

{ #category : #storing }
AMD64TemplateAssembler >> storeEinRindex: index [
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
]

{ #category : #loading }
AMD64TemplateAssembler >> storeLargeX0inA [
	self assembleBytes: #[16r66 16r48 16rF 16r7E 16r2].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> storeLargeX0inT [
	self assembleBytes: #[16r66 16r48 16rF 16r7E 16r1].
	
]

{ #category : #storing }
AMD64TemplateAssembler >> storeLongTinRatA [
	self assembleBytes: #[16r89 16r4C 16r90 16rFC].
	
]

{ #category : #storing }
AMD64TemplateAssembler >> storeLongTinRatOffsetA [
	self assembleBytes: #[16r89 16rC 16r10].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> storeMXCSRintoA [
	self assembleBytes: #[16rF 16rAE 16r1A].
	
]

{ #category : #storing }
AMD64TemplateAssembler >> storeRinAindex: index [
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
]

{ #category : #storing }
AMD64TemplateAssembler >> storeRinEindex: index [
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
]

{ #category : #storing }
AMD64TemplateAssembler >> storeRinFPindex: index [
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
]

{ #category : #storing }
AMD64TemplateAssembler >> storeRinSindex: index [
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
]

{ #category : #storing }
AMD64TemplateAssembler >> storeRinTindex: index [
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
]

{ #category : #storing }
AMD64TemplateAssembler >> storeShortTinRatOffsetA [
	self assembleBytes: #[16r66 16r89 16rC 16r10].
	
]

{ #category : #storing }
AMD64TemplateAssembler >> storeSinRindex: index [
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
]

{ #category : #storing }
AMD64TemplateAssembler >> storeTIBatRwithA [
	self assembleBytes: #[16r65 16r48 16r89 16r14 16rC5 16r0 16r0 16r0 16r0].
	
]

{ #category : #storing }
AMD64TemplateAssembler >> storeTinRatA [
	self assembleBytes: #[16r48 16r89 16r4C 16rD0 16rF8].
	
]

{ #category : #storing }
AMD64TemplateAssembler >> storeTinRatOffsetA [
	self assembleBytes: #[16r48 16r89 16rC 16r10].
	
]

{ #category : #storing }
AMD64TemplateAssembler >> storeTinRindex: index [
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
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> subAfromR [
	self assembleBytes: #[16r48 16r29 16rD0].
	
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> subAfromT [
	self assembleBytes: #[16r48 16r29 16rD1].
	
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> subDoubleX1fromX0 [
	self assembleBytes: #[16rF2 16rF 16r5C 16rC1].
	
]

{ #category : #arithmetic }
AMD64TemplateAssembler >> subTslotsToSP [
	self assembleBytes: #[16r48 16rF7 16rD9 16r48 16r8D 16r24 16rCC 16r48 16rF7 16rD9].
	
]

{ #category : #initialization }
AMD64TemplateAssembler >> platform: aNativizationPlatform [
	super platform: aNativizationPlatform.
	wordSize := aNativizationPlatform wordSize.
	buffer := RelocatableBuffer new.

]

{ #category : #integers }
AMD64TemplateAssembler >> testRintegerBit [
	self assembleBytes: #[16rA8 16r1].
	
]

{ #category : #loading }
AMD64TemplateAssembler >> testRwithR [
	self assembleBytes: #[16r48 16r85 16rC0].
	
]

{ #category : #'opcodes - integer related' }
AMD64TemplateAssembler >> writeTslots [
	self assembleBytes: #[16rF3 16r48 16rAB].
	
]

{ #category : #logic }
AMD64TemplateAssembler >> xorAwithR [
	self assembleBytes: #[16r48 16r31 16rC2].
	
]

{ #category : #logic }
AMD64TemplateAssembler >> xorFPwithFP [
	self assembleBytes: #[16r48 16r31 16rED].
	
]

{ #category : #logic }
AMD64TemplateAssembler >> xorRwithA [
	self assembleBytes: #[16r48 16r31 16rD0].
	
]
