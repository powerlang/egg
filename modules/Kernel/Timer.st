"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Timer,
	#superclass : #Object,
	#instVars : [
		'milliseconds',
		'id',
		'count'
	],
	#classVars : [
		'Timers'
	],
	#category : #Kernel
}

{ #category : #accessing }
Timer class >> addTimer: aTimer [
	Timers at: aTimer id put: aTimer
]

{ #category : #events }
Timer class >> availableEvents [
	^super availableEvents add: #tick; yourself
]

{ #category : #'instance creation' }
Timer class >> everySecond [
	^self forSeconds: 1
]

{ #category : #'instance creation' }
Timer class >> forSeconds: n [
	^self new milliseconds: n * 1000
]

{ #category : #'instance creation' }
Timer class >> milliseconds: n [
	^self new milliseconds: n
]

{ #category : #accessing }
Timer class >> newId [
	| next |
	next := 1.
	[Timers includesKey: next] whileTrue: [next := next + 1].
	^next
]

{ #category : #accessing }
Timer class >> removeTimer: aTimer [
	Timers removeKey: aTimer id ifAbsent: nil
]

{ #category : #events }
Timer class >> tick: id [
	| timer |
	timer := Timers at: id ifAbsent: [^nil].
	timer tick
]

{ #category : #accessing }
Timer >> id [
	^id
]

{ #category : #accessing }
Timer >> milliseconds [
	^milliseconds
]

{ #category : #accessing }
Timer >> milliseconds: anInteger [
	anInteger < 0 ifTrue: [self error: 'negative timer period'].
	milliseconds := anInteger asInteger
]

{ #category : #printing }
Timer >> printOn: aStream [
	aStream
		nextPutAll: 'Timer ';
		print: id;
		nextPutAll: ', every ';
		print: milliseconds;
		nextPutAll: ' ms'
]

{ #category : #actions }
Timer >> start [
	count := 0.
	id notNil ifTrue: [(Timers includesKey: id) ifTrue: [^self stop; start]].
	id := self class startTimer: 0 milliseconds: milliseconds for: nil.
	self class addTimer: self
]

{ #category : #actions }
Timer >> stop [
	id isNil ifTrue: [^self].
	self class
		stopTimer: id for: nil;
		removeTimer: self.
	id := nil
]

{ #category : #'event handlers' }
Timer >> tick [
	count > 2 ifTrue: [^self].
	count := count + 1.
	[
		[self triggerEvent: #tick] on: Error do: [:error | 
			milliseconds < 30000 ifTrue: [self stop].
			error pass]]
		ensure: [count := count - 1]
]

