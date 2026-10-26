'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Semaphore category: #Kernel!
Object subclass: #Semaphore
	instanceVariableNames: 'signals waiting'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Semaphore commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Semaphore methodsFor:  'delaying' stamp: 'KenD 28/Jun/2026 13:27:38'!
critical: aBlock
	^[
		self wait.
		aBlock value]
		ensure: [self signal]
! !

!Semaphore methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hasWaitingProcesses
	^waiting notEmpty
! !

!Semaphore methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	waiting := OrderedCollection new.
	signals := 0
! !

!Semaphore methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isSignaled
	^signals > 0
! !

!Semaphore methodsFor:  'synchronization' stamp: 'KenD 28/Jun/2026 13:27:38'!
signal
	| enabled |
	enabled := Processor enableInterrupts: false.
	[waiting notEmpty and: [waiting first hasFinished]]
		whileTrue: [
			signals := signals + 1.
			waiting removeFirst].
	signals := signals + 1.
	signals < 1 ifTrue: [waiting removeFirst wakeUp].
	enabled ifTrue: [Processor enableInterrupts: true]
! !

!Semaphore methodsFor:  'synchronization' stamp: 'KenD 28/Jun/2026 13:27:38'!
wait
	| enabled active |
	enabled := Processor enableInterrupts: false.
	signals := signals - 1.
	signals < 0 ifTrue: [
		active := Processor activeProcess.
		active canBeSuspended
			ifFalse: [^self error: 'The process can not be suspended at this time'].
		waiting addLast: active.
		active sleepOn: self].
	enabled ifTrue: [Processor enableInterrupts: true]
! !

!Semaphore methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
waitingProcesses
	^waiting
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Semaphore class' category: #Kernel!
Semaphore class
	instanceVariableNames: ''!

!Semaphore class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
forMutualExclusion
	^self new signal
! !


Semaphore initialize!

