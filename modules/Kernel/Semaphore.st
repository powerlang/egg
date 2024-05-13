"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Semaphore,
	#superclass : #Object,
	#instVars : [
		'signals',
		'waiting'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Semaphore class >> forMutualExclusion [
	^self new signal
]

{ #category : #delaying }
Semaphore >> critical: aBlock [
	^[
		self wait.
		aBlock value]
		ensure: [self signal]
]

{ #category : #testing }
Semaphore >> hasWaitingProcesses [
	^waiting notEmpty
]

{ #category : #initialization }
Semaphore >> initialize [
	super initialize.
	waiting := OrderedCollection new.
	signals := 0
]

{ #category : #testing }
Semaphore >> isSignaled [
	^signals > 0
]

{ #category : #synchronization }
Semaphore >> signal [
	| enabled |
	enabled := Processor enableInterrupts: false.
	[waiting notEmpty and: [waiting first hasFinished]]
		whileTrue: [
			signals := signals + 1.
			waiting removeFirst].
	signals := signals + 1.
	signals < 1 ifTrue: [waiting removeFirst wakeUp].
	enabled ifTrue: [Processor enableInterrupts: true]
]

{ #category : #synchronization }
Semaphore >> wait [
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
]

{ #category : #accessing }
Semaphore >> waitingProcesses [
	^waiting
]

