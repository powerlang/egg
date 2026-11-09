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
	self spillCallbackArguments: anFFIDescriptor with: anAssembler
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
WinX64ABI >> restoreContext: anFFIDescriptor with: anAssembler [
	self loadCallbackResult: anFFIDescriptor with: anAssembler.
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

{ #category : #callbacks }
WinX64ABI >> callbackFloatRegisters [
	^{xmm0. xmm1. xmm2. xmm3}
]

{ #category : #callbacks }
WinX64ABI >> callbackIntegerRegisters [
	^{rcx. rdx. r8. r9}
]
