'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #WinX64ABI category: #'Powerlang-Core-Assembler-Intel'!
X64ABI subclass: #WinX64ABI
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Powerlang-Core-Assembler-Intel'!
!WinX64ABI methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitEntrypoint: anFFIDescriptor with: anAssembler
	anAssembler saveCallerFrame;
		pushG;
		pushNil;
		pushTrue;
		pushFalse;
		pushM;
		pushE;
		pushS.
	self storeArgumentsInStack: anFFIDescriptor with: anAssembler.
	
! !

!WinX64ABI methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
popRetaddrAndArgs: anFFIDescriptor with: anAssembler
	anAssembler
		popA;
		popA;
		popA
! !

!WinX64ABI methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
restoreContext: anFFIDescriptor with: anAssembler
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
! !

!WinX64ABI methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:40'!
storeArgumentsInStack: anFFIDescriptor with: anAssembler
	anAssembler pushS;
		loadRwithArgPointer;
		convertRtoSmallInteger;
		pushR
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WinX64ABI class' category: #'Powerlang-Core-Assembler-Intel'!
WinX64ABI class
	instanceVariableNames: ''!


