Class {
	#name : #ConduitAlarm,
	#superclass : #MessageSend,
	#instVars : [
		'scheduledTime',
		'stepTime',
		'numArgs'
	],
	#category : 'SqueakNOS-Net-Conduits'
}

{ #category : #'as yet unclassified' }
ConduitAlarm class >> scheduledAt: scheduledTime receiver: aTarget selector: aSelector arguments: argArray [
	^ self scheduledAt: scheduledTime stepTime: nil receiver: aTarget selector: aSelector arguments: argArray
]

{ #category : #'as yet unclassified' }
ConduitAlarm class >> scheduledAt: scheduledTime stepTime: msecsOrNil receiver: aTarget selector: aSelector arguments: argArray [
	^(self receiver: aTarget selector: aSelector arguments: argArray)
		scheduledTime: scheduledTime;
		stepTime: msecsOrNil
]

{ #category : #'as yet unclassified' }
ConduitAlarm >> scheduledTime [
	^ scheduledTime
]

{ #category : #accessing }
ConduitAlarm >> scheduledTime: time [
	scheduledTime := time
]

{ #category : #'as yet unclassified' }
ConduitAlarm >> stepTime [
	^ stepTime
]

{ #category : #accessing }
ConduitAlarm >> stepTime: msecs [
	stepTime := msecs
]

{ #category : #evaluating }
ConduitAlarm >> value: anArgument [
	| nArgs |
	numArgs ifNil:[numArgs := selector numArgs].
	nArgs := arguments ifNil:[0] ifNotNil:[arguments size].
	nArgs = numArgs ifTrue:[
		"Ignore extra argument"
		^self value].
	^arguments isNil
		ifTrue: [receiver perform: selector with: anArgument]
		ifFalse: [receiver perform: selector withArguments: (arguments copyWith: anArgument)]
]
