Class {
	#name : #InterruptRequestDispatcher,
	#superclass : #Object,
	#instVars : [
		'semaphore',
		'process',
		'interruptNumber',
		'clients'
	],
	#category : 'SqueakNOS-Kernel'
}

{ #category : #'instace creation' }
InterruptRequestDispatcher class >> new [
	^ super new initialize
]

{ #category : #'instace creation' }
InterruptRequestDispatcher class >> onIRQ: aNumber [
	^ self new privInterruptNumber: aNumber
]

{ #category : #accessing }
InterruptRequestDispatcher >> addHandler: anObject [
	clients add: anObject
]

{ #category : #handling }
InterruptRequestDispatcher >> handleOn: aComputer [ 
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
]

{ #category : #initialization }
InterruptRequestDispatcher >> initialize [
	semaphore := Semaphore new.
	clients := OrderedCollection new
]

{ #category : #initialization }
InterruptRequestDispatcher >> installOn: aComputer [
	self registerSemaphore.
	process := [ [ semaphore wait.
	self handleOn: aComputer.
	interruptNumber = 46 ifTrue: [ Transcript show: 'irq ended' ].
	aComputer interruptController signalEndOfInterrupt: interruptNumber ] repeat ]
		forkAt: Processor highIOPriority.
	process name: 'Iterrupt Dispatcher for IRQ#:' , interruptNumber printString.
	aComputer interruptController enableIRQ: interruptNumber
]

{ #category : #accessing }
InterruptRequestDispatcher >> interruptNumber [
	^ interruptNumber
]

{ #category : #private }
InterruptRequestDispatcher >> primRegisterSemaphoreIndex: externalObjectForSemaphore forIRQ: IRQNumber [ 
	<primitive: 'primitiveRegisterSemaphoreIndexForIRQ' module:'SqueakNOSPlugin'> 
	^ self primitiveFailed
]

{ #category : #private }
InterruptRequestDispatcher >> privInterruptNumber: irqNumber [
	interruptNumber
		ifNil: [
			interruptNumber := irqNumber.
			self registerSemaphore]
		ifNotNil: [self error: 'Can''t change the IRQ number for a handler']
]

{ #category : #private }
InterruptRequestDispatcher >> registerSemaphore [
	self
		primRegisterSemaphoreIndex: (Smalltalk registerExternalObject: semaphore)
		forIRQ: interruptNumber
]

{ #category : #accessing }
InterruptRequestDispatcher >> removeHandler: anObject [
	" should not be called from a handler routine,
	as it may terminate the process if it's the last handler,
	in which case the interrupt will not be finished signaling the interruptController.
	XXX: This must be solved, there must be a clean wat of doing one time IRQs"
	clients remove: anObject.
	clients ifEmpty: [self uninstall].
]

{ #category : #initialization }
InterruptRequestDispatcher >> uninstall [
	Computer current interruptController disableIRQ: interruptNumber.
	self primRegisterSemaphoreIndex: 0 forIRQ: interruptNumber.
	Computer current interruptController removeDispatcher: self.

	" the next is forked so it doesn't kill the process calling.
	  Of utter importance if called from within handleIRQ:
	  as otherwise the interrupt end will not be signaled.
	  The current process is running at hiIOPriority, so the
	  new one won't be executed until the current is idle"
	[process terminate] forkAt: Processor lowIOPriority.

]
