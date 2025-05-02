"
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
"

Class {
	#name : #Process,
	#superclass : #Object,
	#instVars : [
		'name',
		'nativeStack',
		'topContext',
		'protectedFrames',
		'exceptionHandler',
		'semaphore',
		'hopping'
	],
	#category : #Kernel
}

{ #category : #services }
Process class >> sending: aSymbol to: anObject with: arguments [
	^SuspendedProcess sending: aSymbol to: anObject with: arguments
]

{ #category : #services }
Process >> beActive [
	self notAllowed
]

{ #category : #services }
Process >> beInactive [
	self notAllowed
]

{ #category : #private }
Process >> launch: aMessage [
	self notAllowed
]

{ #category : #services }
Process >> drop [
	self subclassResponsibility
]

{ #category : #initializing }
Process >> evaluating: aMessageSend [
	self notAllowed
]

{ #category : #accessing }
Process >> exceptionHandler [
	^exceptionHandler
]

{ #category : #initializing }
Process >> initialize [
	name := 'nameless process'.
	protectedFrames := OrderedCollection new: 20
]

{ #category : #private }
Process >> findHandlerFor: anException [
	| original result |
	original := exceptionHandler ifNil: [^nil].
	exceptionHandler := nil.
	result := original findHandlerFor: anException.
	exceptionHandler := original.
	^result
]

{ #category : #private }
Process >> initializeStack [
	nativeStack := ProcessStack on: self
]

{ #category : #private }
Process >> isReified [
	^topContext notNil
]

{ #category : #testing }
Process >> isScheduled [
	^Processor isScheduled: self
]

{ #category : #accessing }
Process >> name [
	^name
]

{ #category : #accessing }
Process >> name: aString [
	name := aString
]

{ #category : #accessing }
Process >> nativeStack [
	^nativeStack
]

{ #category : #errors }
Process >> notAllowed [
	self error: 'this message cannot be executed in current process state'
]

{ #category : #scheduling }
Process >> takeControl [
	self notAllowed
]

{ #category : #accessing }
Process >> topContext [
	^topContext
]

{ #category : #accessing }
Process >> topContext: aContext [
	topContext := aContext
]

{ #category : #services }
Process >> snapshot [
	self notAllowed
]

{ #category : #private }
Process >> wantsToStepInto [
	| answer |
	answer := hopping.
	answer ifTrue: [hopping := false].
	^answer
]
