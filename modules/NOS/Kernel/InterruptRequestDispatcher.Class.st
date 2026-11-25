'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #InterruptRequestDispatcher category: 'SqueakNOS-Kernel'!
Object subclass: #InterruptRequestDispatcher
	instanceVariableNames: 'semaphore process interruptNumber clients'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Kernel'!
!InterruptRequestDispatcher methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
addHandler: anObject
	clients add: anObject
! !

!InterruptRequestDispatcher methodsFor:  'handling' stamp: 'KenD 28/Jun/2026 13:32:25'!
handleOn: aComputer
"	Transcript cr; show: 'handling IRQ #', interruptNumber asString.
"	clients
		do: [:each |
			[each handleIRQfor: self on: aComputer]
				ifError: [:err :rcvr | 
					Transcript
						nextPutAll: err;
					 	nextPutAll: ' when handling IRQ #';
						print: interruptNumber;
						nextPutAll: ' on ';
						print: each;
						cr;
						flush.
				]
	].
"	Transcript cr; show: ' handled'.
"
! !

!InterruptRequestDispatcher methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	semaphore := Semaphore new.
	clients := OrderedCollection new
! !

!InterruptRequestDispatcher methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
installOn: aComputer
	self registerSemaphore.
	process := [ [ semaphore wait.
	self handleOn: aComputer.
	interruptNumber = 46 ifTrue: [ Transcript show: 'irq ended' ].
	aComputer interruptController signalEndOfInterrupt: interruptNumber ] repeat ]
		forkAt: Processor highIOPriority.
	process name: 'Iterrupt Dispatcher for IRQ#:' , interruptNumber printString.
	aComputer interruptController enableIRQ: interruptNumber
! !

!InterruptRequestDispatcher methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
interruptNumber
	^ interruptNumber
! !

!InterruptRequestDispatcher methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
primRegisterSemaphoreIndex: externalObjectForSemaphore forIRQ: IRQNumber
	<primitive: 'primitiveRegisterSemaphoreIndexForIRQ' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
! !

!InterruptRequestDispatcher methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
privInterruptNumber: irqNumber
	interruptNumber
		ifNil: [
			interruptNumber := irqNumber.
			self registerSemaphore]
		ifNotNil: [self error: 'Can''t change the IRQ number for a handler']
! !

!InterruptRequestDispatcher methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
registerSemaphore
	self
		primRegisterSemaphoreIndex: (Smalltalk registerExternalObject: semaphore)
		forIRQ: interruptNumber
! !

!InterruptRequestDispatcher methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
removeHandler: anObject
	" should not be called from a handler routine,
	as it may terminate the process if it's the last handler,
	in which case the interrupt will not be finished signaling the interruptController.
	XXX: This must be solved, there must be a clean wat of doing one time IRQs"
	clients remove: anObject.
	clients ifEmpty: [self uninstall].
! !

!InterruptRequestDispatcher methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
uninstall
	Computer current interruptController disableIRQ: interruptNumber.
	self primRegisterSemaphoreIndex: 0 forIRQ: interruptNumber.
	Computer current interruptController removeDispatcher: self.

	" the next is forked so it doesn't kill the process calling.
	  Of utter importance if called from within handleIRQ:
	  as otherwise the interrupt end will not be signaled.
	  The current process is running at hiIOPriority, so the
	  new one won't be executed until the current is idle"
	[process terminate] forkAt: Processor lowIOPriority.

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InterruptRequestDispatcher class' category: 'SqueakNOS-Kernel'!
InterruptRequestDispatcher class
	instanceVariableNames: ''!

!InterruptRequestDispatcher class methodsFor:  'instace creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
new
	^ super new initialize
! !

!InterruptRequestDispatcher class methodsFor:  'instace creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
onIRQ: aNumber
	^ self new privInterruptNumber: aNumber
! !


InterruptRequestDispatcher initialize!

