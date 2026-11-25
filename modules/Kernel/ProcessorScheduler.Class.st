'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #ProcessorScheduler category: #Kernel!
Object subclass: #ProcessorScheduler
	instanceVariableNames: 'activeProcess queues dropHandler interruptsEnabled'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!ProcessorScheduler commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
!

!ProcessorScheduler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
activeProcess
	^activeProcess
! !

!ProcessorScheduler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
activeProcess: anActiveProcess
	activeProcess := anActiveProcess
! !

!ProcessorScheduler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
areInterruptsEnabled
	^interruptsEnabled
! !

!ProcessorScheduler methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
dropHandler: aClosure
	dropHandler := aClosure
! !

!ProcessorScheduler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
dropActive
	| process |
	self enableInterrupts: false.
	self dropping: activeProcess.
	process := self nextReadyProcess ifNil: [self idle].
	process takeControl
! !

!ProcessorScheduler methodsFor:  'events' stamp: 'KenD 28/Jun/2026 13:27:38'!
dropping: aProcess
	^dropHandler value: aProcess
! !

!ProcessorScheduler methodsFor:  'priorities' stamp: 'KenD 28/Jun/2026 13:27:38'!
enableInterrupts: aBoolean
	"
		Interrupt checks happen periodically, and in case interrupts are
		enabled the system might trigger UI updates or rescue ephemerons
	"
	| prev |
	prev := interruptsEnabled.
	interruptsEnabled := aBoolean.
	^prev
! !

!ProcessorScheduler methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
idle
	"when there's absolutely nothing to do, just try to tell the host we are doomed"
	self _halt
! !

!ProcessorScheduler methodsFor:  'priorities' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	interruptsEnabled := false.
	activeProcess := ActiveProcess new name: 'main process'.
	dropHandler := [:process | ]
! !

!ProcessorScheduler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
nextReadyProcess
	queues
		reverseDo: [:queue | queue isEmpty ifFalse: [^queue removeFirst]].
	^nil
! !

!ProcessorScheduler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
schedule: aProcess
	| process |
	prev := self enableInterrupts: false.
	queue := scheduledProcesses at: aProcess priority.
	queue add: aProcess.
	prev ifTrue: [self enableInterrupts: true]
! !

!ProcessorScheduler methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
unschedule: aProcess
		| queue prev |
		prev := self enableInterrupts: false.
		self dropping: aProcess.
		queue := queues at: aProcess priority.
		queue remove: aProcess ifAbsent: nil.
		prev ifTrue: [self enableInterrupts: true]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ProcessorScheduler class' category: #Kernel!
ProcessorScheduler class
	instanceVariableNames: ''!


ProcessorScheduler initialize!

