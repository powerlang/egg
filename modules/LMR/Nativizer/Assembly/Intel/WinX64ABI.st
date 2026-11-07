Class {
	#name : #WinX64ABI,
	#superclass : #X64ABI,
	#category : #'Powerlang-Core-Assembler-Intel'
}

{ #category : #services }
WinX64ABI >> emitEntrypoint: anFFIDescriptor with: anAssembler [
	anAssembler saveCallerFrame;
		pushG;
		pushNil;
		pushTrue;
		pushFalse;
		pushM;
		pushE;
		pushS.
	self storeArgumentsInStack: anFFIDescriptor with: anAssembler.
	
]

{ #category : #callouts }
WinX64ABI >> placesOf: types [
	^types withIndexCollect: [:type :i |
		self ensureSupported: type.
		i > 4
			ifTrue: [i - 1 * 8]
			ifFalse: [
				(self isFloat: type)
					ifTrue: [{xmm0. xmm1. xmm2. xmm3} at: i]
					ifFalse: [{rcx. rdx. r8. r9} at: i]]]
]

{ #category : #services }
WinX64ABI >> popRetaddrAndArgs: anFFIDescriptor with: anAssembler [
	anAssembler
		popA;
		popA;
		popA
]

{ #category : #services }
WinX64ABI >> restoreContext: anFFIDescriptor with: anAssembler [
	self popRetaddrAndArgs: anFFIDescriptor with: anAssembler.
	anAssembler
		popS;
		popE;
		popM;
		popFalse;
		popTrue;
		popNil;
		popG;
		popFP;
		return
]

{ #category : #callouts }
WinX64ABI >> stackEndOf: places types: types [
	^(super stackEndOf: places types: types) max: 32
]

{ #category : #services }
WinX64ABI >> storeArgumentsInStack: anFFIDescriptor with: anAssembler [
	anAssembler pushS;
		loadRwithArgPointer;
		convertRtoSmallInteger;
		pushR
]
