'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:40 pm'!
!classDefinition: #HaltingSend category: #Nativization!
MessageLinker subclass: #HaltingSend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Nativization'!
!HaltingSend methodsFor:  'nativizing' stamp: 'KenD 28/Jun/2026 13:27:40'!
emitSend: aSymbol using: anAssembler
	anAssembler breakpoint
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'HaltingSend class' category: #Nativization!
HaltingSend class
	instanceVariableNames: ''!


