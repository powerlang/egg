Class {
	#name : #ConduitTimer,
	#superclass : #Object,
	#instVars : [
		'process',
		'alarms'
	],
	#category : 'SqueakNOS-Net-Conduits'
}

{ #category : #'instance creation' }
ConduitTimer class >> new [
	^ super new initialize
]

{ #category : #accessing }
ConduitTimer >> addAlarm: aConduitAlarm [
	Transcript cr; show: 'New alarm: ', aConduitAlarm printString.
	alarms add: aConduitAlarm.
	process isNil ifTrue: [self up].
	^ aConduitAlarm
]

{ #category : #accessing }
ConduitTimer >> after: msecs send: aSelector to: anObject [
	self at: self time + msecs send: aSelector to: anObject
]

{ #category : #accessing }
ConduitTimer >> after: msecs send: aSelector to: anObject with: anArgument [
	self at: self time + msecs send: aSelector to: anObject with: anArgument
]

{ #category : #accessing }
ConduitTimer >> after: msecs send: aSelector to: anObject withArguments: anArray [
	self at: self time + msecs send: aSelector to: anObject withArguments: anArray
]

{ #category : #private }
ConduitTimer >> alarmSortBlock [
	^ [ :alarm1 :alarm2 | 
		| answer |
		answer := alarm1 scheduledTime < alarm2 scheduledTime.
		answer]
]

{ #category : #accessing }
ConduitTimer >> at: scheduledTime send: aSelector to: anObject [
	self addAlarm:
		(ConduitAlarm
			scheduledAt: scheduledTime
			receiver: anObject
			selector: aSelector
			arguments: #())
]

{ #category : #accessing }
ConduitTimer >> at: scheduledTime send: aSelector to: anObject with: anArgument [
	self addAlarm:
		(ConduitAlarm
			scheduledAt: scheduledTime
			receiver: anObject
			selector: aSelector
			arguments: (Array with: anArgument))
]

{ #category : #accessing }
ConduitTimer >> at: scheduledTime send: aSelector to: anObject withArguments: anArray [
	self addAlarm:
		(ConduitAlarm
			scheduledAt: scheduledTime
			receiver: anObject
			selector: aSelector
			arguments: anArray)
]

{ #category : #control }
ConduitTimer >> down [
	process ifNotNil: [process terminate].
	process := nil
]

{ #category : #accessing }
ConduitTimer >> every: msecs send: aSelector to: anObject [
	self addAlarm:
		(ConduitAlarm
			scheduledAt: self time
			stepTime: msecs
			receiver: anObject
			selector: aSelector
			arguments: #())
]

{ #category : #accessing }
ConduitTimer >> every: msecs send: aSelector to: anObject with: anArgument [
	self addAlarm:
		(ConduitAlarm
			scheduledAt: self time
			stepTime: msecs
			receiver: anObject
			selector: aSelector
			arguments: (Array with: anArgument))
]

{ #category : #accessing }
ConduitTimer >> every: msecs send: aSelector to: anObject withArguments: anArray [
	self addAlarm:
		(ConduitAlarm
			scheduledAt: self time
			stepTime: msecs
			receiver: anObject
			selector: aSelector
			arguments: anArray)
]

{ #category : #initialization }
ConduitTimer >> initialize [
	alarms := self newAlarmsHeap
]

{ #category : #private }
ConduitTimer >> loop [
	self triggerPendingAlarms.
	self sleep
]

{ #category : #private }
ConduitTimer >> newAlarmsHeap [
	^ Heap sortBlock: self alarmSortBlock
]

{ #category : #accessing }
ConduitTimer >> removeAlarm: aSelector for: anObject [
	| oldAlarms |
	oldAlarms := alarms.
	alarms := self newAlarmsHeap.
	oldAlarms do: [ :each |
		(each receiver == anObject and: [each selector == aSelector])
			ifFalse: [alarms add: each]].
	alarms isEmpty ifTrue: [self down]
]

{ #category : #accessing }
ConduitTimer >> removeAlarmsFor: anObject [
	| oldAlarms |
	oldAlarms := alarms.
	alarms := self newAlarmsHeap.
	oldAlarms do: [ :each | each receiver == anObject ifFalse: [alarms add: each]].
	alarms isEmpty ifTrue: [self down]
]

{ #category : #'world state' }
ConduitTimer >> sleep [
	| msecs |
	alarms isEmpty
		ifTrue: [msecs := 1000]
		ifFalse: [msecs := alarms first scheduledTime - self time].
	msecs > 0 ifFalse: [^ self].
	(Delay forMilliseconds: (msecs min: 1000)) wait
]

{ #category : #accessing }
ConduitTimer >> time [
	^ Time millisecondClockValue
]

{ #category : #private }
ConduitTimer >> triggerPendingAlarms [
	"Trigger all pending alarms."
	| alarm time |
	time := self time.
	[alarms isEmpty not and:[alarms first scheduledTime < time]]
		whileTrue: [alarm := alarms removeFirst.
					alarm value: time.
					alarm stepTime notNil
						ifTrue: [alarm scheduledTime: time + alarm stepTime.
								alarms add: alarm]]
]

{ #category : #control }
ConduitTimer >> up [
	self down.
	process := [[self loop] repeat] fork
]
