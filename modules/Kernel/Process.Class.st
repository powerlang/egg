'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Process category: #Kernel!
Object subclass: #Process
	instanceVariableNames: 'name nativeStack topContext protectedFrames exceptionHandler semaphore hopping'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Process commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.

	Processes are the base of concurrency in Egg. For simplicity they are currently designed without
	support parallel execution (this is something we are very open to discuss in the future).
	For the same reason, they are also designed without preemption support. This means processes
	assume they will run until they suspend themselves (i.e. because of an unhandled exception),
	because they go to sleep waiting in a Semaphore, or because they voluntarily yield.

	Processes dynamically change their class when switching state, from SuspendedProcess to ActiveProcess
	and viceversa.
	They can also be in two modes when suspended: reified or native. When reified the process' topContext
	points to its current stack frame, which forms a linked list down to its initial frame. In that case,
	the nativeStack is ignored (even by GC). If the process has no topContext, it means is nativeStack
	contains all of its frames in a format optimized for execution.
!

!Process methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
beActive
	self notAllowed
! !

!Process methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
beInactive
	self notAllowed
! !

!Process methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
launch: aMessage
	self notAllowed
! !

!Process methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
drop
	self subclassResponsibility
! !

!Process methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:38'!
evaluating: aMessageSend
	self notAllowed
! !

!Process methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
exceptionHandler
	^exceptionHandler
! !

!Process methodsFor:  'initializing' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	name := 'nameless process'.
	protectedFrames := OrderedCollection new: 20
! !

!Process methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
findHandlerFor: anException
	| original result |
	original := exceptionHandler ifNil: [^nil].
	exceptionHandler := nil.
	result := original findHandlerFor: anException.
	exceptionHandler := original.
	^result
! !

!Process methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
initializeStack
	nativeStack := ProcessVMStack on: self
! !

!Process methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isActive
	^false
! !

!Process methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
isReified
	^topContext notNil
! !

!Process methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isScheduled
	^Processor isScheduled: self
! !

!Process methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
name
	^name
! !

!Process methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
name: aString
	name := aString
! !

!Process methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
nativeStack
	nativeStack ifNil: [self initializeStack].
	^nativeStack
! !

!Process methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
notAllowed
	self error: 'this message cannot be executed in current process state'
! !

!Process methodsFor:  'scheduling' stamp: 'KenD 28/Jun/2026 13:27:38'!
takeControl
	self notAllowed
! !

!Process methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
topContext
	^topContext
! !

!Process methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
topContext: aContext
	topContext := aContext
! !

!Process methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
snapshot
	self notAllowed
! !

!Process methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
wantsToStepInto
	| answer |
	answer := hopping.
	answer ifTrue: [hopping := false].
	^answer
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Process class' category: #Kernel!
Process class
	instanceVariableNames: ''!

!Process class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
sending: aSymbol to: anObject with: arguments
	^SuspendedProcess sending: aSymbol to: anObject with: arguments
! !


Process initialize!

