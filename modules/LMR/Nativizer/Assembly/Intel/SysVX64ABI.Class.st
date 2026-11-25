'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #SysVX64ABI category: #'Powerlang-Core-Assembler-Intel'!
X64ABI subclass: #SysVX64ABI
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembler-Intel'!
!SysVX64ABI methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitEntrypoint: anFFIDescriptor with: anAssembler
	anAssembler saveCallerFrame;
			pushG;
		pushNil;
		pushTrue;
		pushFalse;
		pushM.
	self storeArgumentsInStack: anFFIDescriptor with: anAssembler.
	
! !

!SysVX64ABI methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
popRetaddrAndArgs: anFFIDescriptor with: anAssembler
	anAssembler
		popA;
		popA;
		popA
! !

!SysVX64ABI methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
restoreContext: anFFIDescriptor with: anAssembler
	self popRetaddrAndArgs: anFFIDescriptor with: anAssembler.
	anAssembler
		popM;
		popFalse;
		popTrue;
		popNil;
		popG;
		popFP;
		return
! !

!SysVX64ABI methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeArgumentsInStack: anFFIDescriptor with: anAssembler
	anAssembler pushS;
		loadRwithArgPointer;
		convertRtoSmallInteger;
		pushR
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SysVX64ABI class' category: #'Powerlang-Core-Assembler-Intel'!
SysVX64ABI class
	instanceVariableNames: ''!


