"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Delay,
	#superclass : #Object,
	#instVars : [
		'milliseconds',
		'wait',
		'timer'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Delay class >> forMilliseconds: n [
	"
	Delay forMilliseconds: 5000
	"
	^self new milliseconds: n
]

{ #category : #'instance creation' }
Delay class >> forSeconds: n [
	"
	(Delay forSeconds: 3) wait. 7 inspect
	"
	^self new seconds: n
]

{ #category : #'instance creation' }
Delay class >> wait: milliseconds [
	(Delay forMilliseconds: milliseconds) wait
]

{ #category : #'instance creation' }
Delay class >> waitSeconds: seconds [
	(Delay forSeconds: seconds) wait
]

{ #category : #delaying }
Delay >> cancel [
	timer notNil ifTrue: [timer stop].
	wait := nil
]

{ #category : #delaying }
Delay >> initTimer [
	timer notNil ifTrue: [timer stop].
	timer := Timer milliseconds: milliseconds.
	timer when: #tick do: [
		timer stop.
		self resume]
]

{ #category : #testing }
Delay >> isWaiting [
	wait isNil ifTrue: [^false].
	^wait isSignaled not
]

{ #category : #accessing }
Delay >> milliseconds: n [
	milliseconds := n
]

{ #category : #printing }
Delay >> printOn: aStream [
	'Delay of ' printOn: aStream.
	milliseconds printOn: aStream.
	' milliseconds' printOn: aStream
]

{ #category : #delaying }
Delay >> resume [
	wait notNil ifTrue: [wait signal]
]

{ #category : #accessing }
Delay >> seconds: n [
	milliseconds := n * 1000
]

{ #category : #delaying }
Delay >> wait [
	ActiveProcess canBeSuspended
		ifFalse: [^self error: 'The process can not be suspended at this time'].
	wait := Semaphore new.
	self initTimer.
	timer start.
	wait wait.
	self cancel
]

