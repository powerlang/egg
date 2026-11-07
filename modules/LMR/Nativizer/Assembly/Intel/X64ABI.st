"
Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
"
Class {
	#name : #X64ABI,
	#superclass : #ABI,
	#pools : [
		'Registers'
	],
	#category : #'Powerlang-Core-Assembler-Intel'
}

{ #category : #callouts }
X64ABI >> at: offset of: baseRegister with: codegen [
	^codegen memRef64 base: baseRegister; displacement: offset; yourself
]

{ #category : #accessing }
X64ABI >> bits [
	^64
]

{ #category : #callouts }
X64ABI >> emitBeforeCall: places with: codegen [
]

{ #category : #callouts }
X64ABI >> emitCallout: types with: anAssembler loading: aBlock [
	| codegen places area saved |
	codegen := anAssembler codegen.
	places := self placesOf: types.
	area := self stackAreaOf: places types: types.
	codegen
		move: self regR to: self regCallout;
		move: rsp to: r10;
		assemble: 'and' with: rsp withImm: -16;
		subImm: area from: rsp.
	saved := self savedSlotsIn: area with: codegen.
	codegen
		store: r10 intoMem: saved first;
		store: self regE intoMem: saved second;
		store: self regS intoMem: saved last.
	places withIndexDo: [:place :i | | type |
		type := types at: i.
		aBlock value: i.
		place isInteger
			ifTrue: [self emitStackArgument: type at: place with: codegen]
			ifFalse: [self moveArgument: type to: place with: codegen]].
	self emitBeforeCall: places with: codegen.
	codegen
		call: self regCallout;
		load: self regS fromMem: saved last;
		load: self regE fromMem: saved second;
		load: rsp fromMem: saved first
]

{ #category : #callouts }
X64ABI >> emitStackArgument: type at: offset with: codegen [
	| slot |
	slot := self at: offset of: rsp with: codegen.
	type == #float ifTrue: [
		self moveSingleTo: xmm15 with: codegen.
		^codegen storeDouble: xmm15 intoMem: slot].
	codegen store: rax intoMem: slot
]

{ #category : #callouts }
X64ABI >> extendResult: type with: anAssembler [
	| codegen bits narrow |
	codegen := anAssembler codegen.
	type == #float ifTrue: [^codegen assemble: 'cvtss2sd' with: xmm0 with: xmm0].
	type == #double ifTrue: [^self].
	bits := self bitsOf: type.
	bits = 64 ifTrue: [^self].
	narrow := rax forLength: bits.
	type first = $s ifTrue: [
		bits = 32 ifTrue: [^codegen assemble: 'movsxd' with: rax with: narrow].
		^codegen assemble: 'movsx' with: rax with: narrow].
	bits = 32 ifTrue: [^codegen assemble: 'mov' with: narrow with: narrow].
	codegen assemble: 'movzx' with: rax with: narrow
]

{ #category : #callouts }
X64ABI >> moveArgument: type to: aRegister with: codegen [
	aRegister isSIMD ifFalse: [^codegen move: rax to: aRegister].
	type == #float ifTrue: [^self moveSingleTo: aRegister with: codegen].
	codegen moveDouble: rax into: aRegister
]

{ #category : #callouts }
X64ABI >> moveSingleTo: aRegister with: codegen [
	codegen moveDouble: rax into: xmm15.
	codegen assemble: 'cvtsd2ss' with: aRegister with: xmm15
]

{ #category : #accessing }
X64ABI >> newAssembler [
	^AMD64TemplateAssembler new
]

{ #category : #'registers - IR' }
X64ABI >> regA [
	^rdx
]

{ #category : #'registers - IR' }
X64ABI >> regCallout [
	^r11
]

{ #category : #'registers - IR' }
X64ABI >> regE [
	^rdi
]

{ #category : #'registers - IR' }
X64ABI >> regFP [
	^rbp
]

{ #category : #'registers - IR' }
X64ABI >> regFalse [
	^ r14
]

{ #category : #'registers - IR' }
X64ABI >> regG [
	^r15
]

{ #category : #'registers - IR' }
X64ABI >> regIP [
	^ rip
]

{ #category : #'registers - IR' }
X64ABI >> regM [
	^rbx
]

{ #category : #'registers - IR' }
X64ABI >> regNil [
	^ r12
]

{ #category : #'registers - IR' }
X64ABI >> regR [
	^rax
]

{ #category : #'registers - IR' }
X64ABI >> regS [
	^rsi
]

{ #category : #'registers - IR' }
X64ABI >> regSP [
	^rsp
]

{ #category : #'registers - IR' }
X64ABI >> regT [
	^rcx
]

{ #category : #'registers - IR' }
X64ABI >> regTrue [
	^ r13
]

{ #category : #'registers - IR' }
X64ABI >> regV [
	^r11
]

{ #category : #'registers - IR' }
X64ABI >> regX0 [
	^xmm0
]

{ #category : #'registers - IR' }
X64ABI >> regX1 [
	^xmm1
]

{ #category : #callouts }
X64ABI >> savedSlotsIn: area with: codegen [
	^#(8 16 24) collect: [:offset | self at: area - offset of: rsp with: codegen]
]

{ #category : #callouts }
X64ABI >> stackAreaOf: places types: types [
	^(self stackEndOf: places types: types) + 24 alignedTo: 16
]

{ #category : #accessing }
X64ABI >> wordSize [
	^8
]

{ #category : #accessing }
X64ABI >> wordSizeShift [
	^3
]
