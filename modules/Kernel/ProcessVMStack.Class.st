'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ProcessVMStack category: #Kernel!
ProcessStack subclass: #ProcessVMStack
	instanceVariableNames: 'buffer bufferSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ProcessVMStack commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
!

!ProcessVMStack methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger
	<primitive: ProcessVMStackAt>
! !

!ProcessVMStack methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger put: anObject
	<primitive: ProcessVMStackAtPut>
! !

!ProcessVMStack methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeWithNewBuffer
	<primitive: ProcessVMStackInitializeWithNewBuffer>
! !

!ProcessVMStack methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeWithActiveBuffer
	<primitive: ProcessVMStackInitializeWithActiveBuffer>
! !

!ProcessVMStack methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
bp
	<primitive: ProcessVMStackBP>
! !

!ProcessVMStack methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
bpAt: anInteger
	<primitive: ProcessVMStackBpAt>
! !

!ProcessVMStack methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
bpAt: anInteger put: anotherInteger
	<primitive: ProcessVMStackBpAtPut>
! !

!ProcessVMStack methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
bufferSize
	<primitive: ProcessVMStackBufferSize>
! !

!ProcessVMStack methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
contextSwitchTo: aProcessStack
	<primitive: ProcessVMStackContextSwitchTo>
! !

!ProcessVMStack methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
process: aProcess
	super process: aProcess.
	aProcess isActive
		ifTrue: [self initializeWithActiveBuffer]
		ifFalse: [self initializeWithNewBuffer]
! !

!ProcessVMStack methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
pcAt: anInteger
	<primitive: ProcessVMStackPcAt>
! !

!ProcessVMStack methodsFor:  'Primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
pcAt: anInteger put: anotherInteger of: code
	<primitive: ProcessVMStackPcAtPut>
! !

!ProcessVMStack methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
snapshot
	<primitive: ProcessVMStackSnapshot>
! !

!ProcessVMStack methodsFor:  'primitives' stamp: 'KenD 28/Jun/2026 13:27:38'!
sp: anInteger
	<primitive: ProcessVMStackSPPut>
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ProcessVMStack class' category: #Kernel!
ProcessVMStack class
	instanceVariableNames: ''!

!ProcessVMStack class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
on: aProcess
	^self new process: aProcess
! !


