Class {
	#name : #SysVX64ABI,
	#superclass : #X64ABI,
	#category : #'Powerlang-Core-Assembler-Intel'
}

{ #category : #callouts }
SysVX64ABI >> emitBeforeCall: places with: codegen [
	| vectors |
	vectors := places count: [:place | place isInteger not and: [place isSIMD]].
	codegen moveImm: vectors to: rax
]

{ #category : #'as yet unclassified' }
SysVX64ABI >> emitEntrypoint: anFFIDescriptor with: anAssembler [
	anAssembler saveCallerFrame;
			pushG;
		pushNil;
		pushTrue;
		pushFalse;
		pushM.
	self storeArgumentsInStack: anFFIDescriptor with: anAssembler.
	
]

{ #category : #callouts }
SysVX64ABI >> placesOf: types [
	| ints floats offset |
	ints := 0.
	floats := 0.
	offset := 0.
	^types collect: [:type | | place |
		self ensureSupported: type.
		(self isFloat: type)
			ifTrue: [
				floats := floats + 1.
				floats <= 8 ifTrue: [place := {xmm0. xmm1. xmm2. xmm3. xmm4. xmm5. xmm6. xmm7} at: floats]]
			ifFalse: [
				ints := ints + 1.
				ints <= 6 ifTrue: [place := {rdi. rsi. rdx. rcx. r8. r9} at: ints]].
		place ifNil: [
			place := offset.
			offset := offset + 8].
		place]
]

{ #category : #'as yet unclassified' }
SysVX64ABI >> popRetaddrAndArgs: anFFIDescriptor with: anAssembler [
	anAssembler
		popA;
		popA;
		popA
]

{ #category : #'as yet unclassified' }
SysVX64ABI >> restoreContext: anFFIDescriptor with: anAssembler [
	self popRetaddrAndArgs: anFFIDescriptor with: anAssembler.
	anAssembler
		popM;
		popFalse;
		popTrue;
		popNil;
		popG;
		popFP;
		return
]

{ #category : #'as yet unclassified' }
SysVX64ABI >> storeArgumentsInStack: anFFIDescriptor with: anAssembler [
	anAssembler pushS;
		loadRwithArgPointer;
		convertRtoSmallInteger;
		pushR
]
