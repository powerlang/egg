"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
"

Class {
	#name : #ProcessorScheduler,
	#superclass : #Object,
	#instVars : [
		'activeProcess',
		'queues',
		'dropHandler',
		'interruptsEnabled'
	],
	#category : #Kernel
}

{ #category : #accessing }
ProcessorScheduler >> activeProcess [
	^activeProcess
]

{ #category : #accessing }
ProcessorScheduler >> activeProcess: anActiveProcess [
	activeProcess := anActiveProcess
]

{ #category : #accessing }
ProcessorScheduler >> dropHandler: aClosure [
	dropHandler := aClosure
]

{ #category : #private }
ProcessorScheduler >> dropActive [
	| process |
	self enableInterrupts: false.
	self dropping: activeProcess.
	process := self nextReadyProcess ifNil: [self idle].
	process takeControl
]

{ #category : #events }
ProcessorScheduler >> dropping: aProcess [
	^dropHandler value: aProcess
]


{ #category : #priorities }
ProcessorScheduler >> enableInterrupts: aBoolean [
	"
		Interrupt checks happen periodically, and in case interrupts are
		enabled the system might trigger UI updates or rescue ephemerons
	"
	| prev |
	prev := interruptsEnabled.
	interruptsEnabled := aBoolean.
	^prev
]

{ #category : #services }
ProcessorScheduler >> idle [
	"when there's absolutely nothing to do, just try to tell the host we are doomed"
	self _halt
]

{ #category : #priorities }
ProcessorScheduler >> initialize [
	interruptsEnabled := false.
	activeProcess := ActiveProcess new name: 'main process'.
	dropHandler := [:process | ]
]

{ #category : #private }
ProcessorScheduler >> nextReadyProcess [
	queues
		reverseDo: [:queue | queue isEmpty ifFalse: [^queue removeFirst]].
	^nil
]

{ #category : #private }
ProcessorScheduler >> schedule: aProcess [
	| process |
	prev := self enableInterrupts: false.
	queue := scheduledProcesses at: aProcess priority.
	queue add: aProcess.
	prev ifTrue: [self enableInterrupts: true]
]

{ #category : #private }
ProcessorScheduler >> unschedule: aProcess [
		| queue prev |
		prev := self enableInterrupts: false.
		self dropping: aProcess.
		queue := queues at: aProcess priority.
		queue remove: aProcess ifAbsent: nil.
		prev ifTrue: [self enableInterrupts: true]
]
