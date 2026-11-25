'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Timer category: #Kernel!
Object subclass: #Timer
	instanceVariableNames: 'milliseconds id count'
	classVariableNames: 'Timers'
	poolDictionaries: ''
	category: 'Kernel'!
!Timer commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Timer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
id
	^id
! !

!Timer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
milliseconds
	^milliseconds
! !

!Timer methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
milliseconds: anInteger
	anInteger < 0 ifTrue: [self error: 'negative timer period'].
	milliseconds := anInteger asInteger
! !

!Timer methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream
		nextPutAll: 'Timer ';
		print: id;
		nextPutAll: ', every ';
		print: milliseconds;
		nextPutAll: ' ms'
! !

!Timer methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:38'!
start
	count := 0.
	id notNil ifTrue: [(Timers includesKey: id) ifTrue: [^self stop; start]].
	id := self class startTimer: 0 milliseconds: milliseconds for: nil.
	self class addTimer: self
! !

!Timer methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:38'!
stop
	id isNil ifTrue: [^self].
	self class
		stopTimer: id for: nil;
		removeTimer: self.
	id := nil
! !

!Timer methodsFor:  'event handlers' stamp: 'KenD 28/Jun/2026 13:27:38'!
tick
	count > 2 ifTrue: [^self].
	count := count + 1.
	[
		[self triggerEvent: #tick] on: Error do: [:error | 
			milliseconds < 30000 ifTrue: [self stop].
			error pass]]
		ensure: [count := count - 1]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Timer class' category: #Kernel!
Timer class
	instanceVariableNames: 'Timers'!

!Timer class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
addTimer: aTimer
	Timers at: aTimer id put: aTimer
! !

!Timer class methodsFor:  'events' stamp: 'KenD 28/Jun/2026 13:27:38'!
availableEvents
	^super availableEvents add: #tick; yourself
! !

!Timer class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
everySecond
	^self forSeconds: 1
! !

!Timer class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
forSeconds: n
	^self new milliseconds: n * 1000
! !

!Timer class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
milliseconds: n
	^self new milliseconds: n
! !

!Timer class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
newId
	| next |
	next := 1.
	[Timers includesKey: next] whileTrue: [next := next + 1].
	^next
! !

!Timer class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeTimer: aTimer
	Timers removeKey: aTimer id ifAbsent: nil
! !

!Timer class methodsFor:  'events' stamp: 'KenD 28/Jun/2026 13:27:38'!
tick: id
	| timer |
	timer := Timers at: id ifAbsent: [^nil].
	timer tick
! !


