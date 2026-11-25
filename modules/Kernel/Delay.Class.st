'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Delay category: #Kernel!
Object subclass: #Delay
	instanceVariableNames: 'milliseconds wait timer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Delay commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Delay methodsFor:  'delaying' stamp: 'KenD 28/Jun/2026 13:27:38'!
cancel
	timer notNil ifTrue: [timer stop].
	wait := nil
! !

!Delay methodsFor:  'delaying' stamp: 'KenD 28/Jun/2026 13:27:38'!
initTimer
	timer notNil ifTrue: [timer stop].
	timer := Timer milliseconds: milliseconds.
	timer when: #tick do: [
		timer stop.
		self resume]
! !

!Delay methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isWaiting
	wait isNil ifTrue: [^false].
	^wait isSignaled not
! !

!Delay methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
milliseconds: n
	milliseconds := n
! !

!Delay methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	'Delay of ' printOn: aStream.
	milliseconds printOn: aStream.
	' milliseconds' printOn: aStream
! !

!Delay methodsFor:  'delaying' stamp: 'KenD 28/Jun/2026 13:27:38'!
resume
	wait notNil ifTrue: [wait signal]
! !

!Delay methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
seconds: n
	milliseconds := n * 1000
! !

!Delay methodsFor:  'delaying' stamp: 'KenD 28/Jun/2026 13:27:38'!
wait
	Processor activeProcess canBeSuspended
		ifFalse: [^self error: 'The process can not be suspended at this time'].
	wait := Semaphore new.
	self initTimer.
	timer start.
	wait wait.
	self cancel
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Delay class' category: #Kernel!
Delay class
	instanceVariableNames: ''!

!Delay class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
forMilliseconds: n
	"
	Delay forMilliseconds: 5000
	"
	^self new milliseconds: n
! !

!Delay class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
forSeconds: n
	"
	(Delay forSeconds: 3) wait. 7 inspect
	"
	^self new seconds: n
! !

!Delay class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
wait: milliseconds
	(Delay forMilliseconds: milliseconds) wait
! !

!Delay class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
waitSeconds: seconds
	(Delay forSeconds: seconds) wait
! !


