"
    Copyright (c) 2020 Aucerna.
    See (MIT) license in root directory.
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

{ #category : #initializing }
Process >> initialize [
	name := 'nameless process'.
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
Process >> isReified [
	^topContext notNil
]

{ #category : #testing }
Process >> isScheduled [
	^Processor isScheduled: self
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

{ #category : #private }
Process >> wantsToStepInto [
	| answer |
	answer := hopping.
	answer ifTrue: [hopping := false].
	^answer
]
