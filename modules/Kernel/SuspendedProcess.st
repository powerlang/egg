"
    Copyright (c) 2024, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #SuspendedProcess,
	#superclass : #Process,
	#category : #Kernel
}

{ #category : #services }
SuspendedProcess class >> sending: aSymbol to: anObject with: arguments [
	| message |
	message := MessageSend receiver: anObject selector: aSymbol arguments: arguments.
	^self new evaluating: message
]

{ #category : #services }
SuspendedProcess >> beActive [
	self changeClassTo: ActiveProcess
]

{ #category : #services }
SuspendedProcess >> drop [
	"
		We are not active, just remove ourselves from the scheduler queues
	"
	
	Processor unschedule: self
]

{ #category : #initializing }
SuspendedProcess >> evaluating: aMessageSend [
	| method |
	method := ActiveProcess >> #launch:.
	method prepareForExecution.
	topContext := LaunchContext new 
		receiver: self;
		code: method executableCode method: method;
		arguments: { aMessageSend }.
]

{ #category : #executing }
SuspendedProcess >> prepareForExecution [
	self isReified ifFalse: [^self].
	nativeStack ifNil: [self initializeStack].
	nativeStack fillFrom: topContext.
	topContext := nil
]

{ #category : #scheduling }
SuspendedProcess >> takeControl [
	| current |
	self prepareForExecution.
	current := Processor activeProcess.
	current beInactive.
	Processor activeProcess: self beActive.
	current nativeStack contextSwitchTo: nativeStack
]
