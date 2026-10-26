'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ConduitTimer category: 'SqueakNOS-Net-Conduits'!
Object subclass: #ConduitTimer
	instanceVariableNames: 'process alarms'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Conduits'!
!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
addAlarm: aConduitAlarm
	Transcript cr; show: 'New alarm: ', aConduitAlarm printString.
	alarms add: aConduitAlarm.
	process isNil ifTrue: [self up].
	^ aConduitAlarm
! !

!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
after: msecs send: aSelector to: anObject
	self at: self time + msecs send: aSelector to: anObject
! !

!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
after: msecs send: aSelector to: anObject with: anArgument
	self at: self time + msecs send: aSelector to: anObject with: anArgument
! !

!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
after: msecs send: aSelector to: anObject withArguments: anArray
	self at: self time + msecs send: aSelector to: anObject withArguments: anArray
! !

!ConduitTimer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
alarmSortBlock
	^ [ :alarm1 :alarm2 | 
		| answer |
		answer := alarm1 scheduledTime < alarm2 scheduledTime.
		answer]
! !

!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: scheduledTime send: aSelector to: anObject
	self addAlarm:
		(ConduitAlarm
			scheduledAt: scheduledTime
			receiver: anObject
			selector: aSelector
			arguments: #())
! !

!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: scheduledTime send: aSelector to: anObject with: anArgument
	self addAlarm:
		(ConduitAlarm
			scheduledAt: scheduledTime
			receiver: anObject
			selector: aSelector
			arguments: (Array with: anArgument))
! !

!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: scheduledTime send: aSelector to: anObject withArguments: anArray
	self addAlarm:
		(ConduitAlarm
			scheduledAt: scheduledTime
			receiver: anObject
			selector: aSelector
			arguments: anArray)
! !

!ConduitTimer methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
down
	process ifNotNil: [process terminate].
	process := nil
! !

!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
every: msecs send: aSelector to: anObject
	self addAlarm:
		(ConduitAlarm
			scheduledAt: self time
			stepTime: msecs
			receiver: anObject
			selector: aSelector
			arguments: #())
! !

!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
every: msecs send: aSelector to: anObject with: anArgument
	self addAlarm:
		(ConduitAlarm
			scheduledAt: self time
			stepTime: msecs
			receiver: anObject
			selector: aSelector
			arguments: (Array with: anArgument))
! !

!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
every: msecs send: aSelector to: anObject withArguments: anArray
	self addAlarm:
		(ConduitAlarm
			scheduledAt: self time
			stepTime: msecs
			receiver: anObject
			selector: aSelector
			arguments: anArray)
! !

!ConduitTimer methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	alarms := self newAlarmsHeap
! !

!ConduitTimer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
loop
	self triggerPendingAlarms.
	self sleep
! !

!ConduitTimer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
newAlarmsHeap
	^ Heap sortBlock: self alarmSortBlock
! !

!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
removeAlarm: aSelector for: anObject
	| oldAlarms |
	oldAlarms := alarms.
	alarms := self newAlarmsHeap.
	oldAlarms do: [ :each |
		(each receiver == anObject and: [each selector == aSelector])
			ifFalse: [alarms add: each]].
	alarms isEmpty ifTrue: [self down]
! !

!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
removeAlarmsFor: anObject
	| oldAlarms |
	oldAlarms := alarms.
	alarms := self newAlarmsHeap.
	oldAlarms do: [ :each | each receiver == anObject ifFalse: [alarms add: each]].
	alarms isEmpty ifTrue: [self down]
! !

!ConduitTimer methodsFor:  'world state' stamp: 'KenD 28/Jun/2026 13:32:25'!
sleep
	| msecs |
	alarms isEmpty
		ifTrue: [msecs := 1000]
		ifFalse: [msecs := alarms first scheduledTime - self time].
	msecs > 0 ifFalse: [^ self].
	(Delay forMilliseconds: (msecs min: 1000)) wait
! !

!ConduitTimer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
time
	^ Time millisecondClockValue
! !

!ConduitTimer methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
triggerPendingAlarms
	"Trigger all pending alarms."
	| alarm time |
	time := self time.
	[alarms isEmpty not and:[alarms first scheduledTime < time]]
		whileTrue: [alarm := alarms removeFirst.
					alarm value: time.
					alarm stepTime notNil
						ifTrue: [alarm scheduledTime: time + alarm stepTime.
								alarms add: alarm]]
! !

!ConduitTimer methodsFor:  'control' stamp: 'KenD 28/Jun/2026 13:32:25'!
up
	self down.
	process := [[self loop] repeat] fork
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ConduitTimer class' category: 'SqueakNOS-Net-Conduits'!
ConduitTimer class
	instanceVariableNames: ''!

!ConduitTimer class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
new
	^ super new initialize
! !


ConduitTimer initialize!

