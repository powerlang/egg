'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #SuspendedProcess category: #Kernel!
Process subclass: #SuspendedProcess
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!SuspendedProcess commentStamp: '<historical>' prior: 0!

    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
!

!SuspendedProcess methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
beActive
	self changeClassTo: ActiveProcess
! !

!SuspendedProcess methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
drop
	"
		We are not active, just remove ourselves from the scheduler queues
	"
	
	Processor unschedule: self
! !

!SuspendedProcess methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluating: aMessageSend
	| method |
	method := ActiveProcess >> #launch:.
	method prepareForExecution.
	topContext := LaunchContext new 
		receiver: self;
		code: method executableCode method: method;
		arguments: { aMessageSend }.
! !

!SuspendedProcess methodsFor:  'executing' stamp: 'KenD 28/Jun/2026 13:27:38'!
prepareForExecution
	self isReified ifFalse: [^self].
	nativeStack ifNil: [self initializeStack].
	nativeStack fillFrom: topContext.
	topContext := nil
! !

!SuspendedProcess methodsFor:  'scheduling' stamp: 'KenD 28/Jun/2026 13:27:38'!
takeControl
	| current |
	self prepareForExecution.
	current := Processor activeProcess.
	current beInactive.
	Processor activeProcess: self beActive.
	current nativeStack contextSwitchTo: nativeStack
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SuspendedProcess class' category: #Kernel!
SuspendedProcess class
	instanceVariableNames: ''!

!SuspendedProcess class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
sending: aSymbol to: anObject with: arguments
	| message |
	message := MessageSend receiver: anObject selector: aSymbol arguments: arguments.
	^self new evaluating: message
! !


