'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ConduitAlarm category: 'SqueakNOS-Net-Conduits'!
MessageSend subclass: #ConduitAlarm
	instanceVariableNames: 'scheduledTime stepTime numArgs'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Net-Conduits'!
!ConduitAlarm methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
scheduledTime
	^ scheduledTime
! !

!ConduitAlarm methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
scheduledTime: time
	scheduledTime := time
! !

!ConduitAlarm methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
stepTime
	^ stepTime
! !

!ConduitAlarm methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
stepTime: msecs
	stepTime := msecs
! !

!ConduitAlarm methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:32:25'!
value: anArgument
	| nArgs |
	numArgs ifNil:[numArgs := selector numArgs].
	nArgs := arguments ifNil:[0] ifNotNil:[arguments size].
	nArgs = numArgs ifTrue:[
		"Ignore extra argument"
		^self value].
	^arguments isNil
		ifTrue: [receiver perform: selector with: anArgument]
		ifFalse: [receiver perform: selector withArguments: (arguments copyWith: anArgument)]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ConduitAlarm class' category: 'SqueakNOS-Net-Conduits'!
ConduitAlarm class
	instanceVariableNames: ''!

!ConduitAlarm class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
scheduledAt: scheduledTime receiver: aTarget selector: aSelector arguments: argArray
	^ self scheduledAt: scheduledTime stepTime: nil receiver: aTarget selector: aSelector arguments: argArray
! !

!ConduitAlarm class methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
scheduledAt: scheduledTime stepTime: msecsOrNil receiver: aTarget selector: aSelector arguments: argArray
	^(self receiver: aTarget selector: aSelector arguments: argArray)
		scheduledTime: scheduledTime;
		stepTime: msecsOrNil
! !


