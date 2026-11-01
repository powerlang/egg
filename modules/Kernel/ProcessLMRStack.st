"
    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #ProcessLMRStack,
	#superclass : #ProcessStack,
	#instVars : [
		'locked'
	],
	#classVars : [
		'Instances',
		'SlotSize'
	],
	#category : #Kernel
}

{ #category : #initialization }
ProcessLMRStack class >> initializeInstances [
	Instances := WeakIdentitySet new
]

{ #category : #'instance creation' }
ProcessLMRStack class >> on: aProcess [
	| stack |
	stack := self new process: aProcess.
	stack _beSpecial.
	Instances add: stack.
	^stack
]

{ #category : #accessing }
ProcessLMRStack class >> registeredInstances [
	^Instances
]

{ #category : #initialization }
ProcessLMRStack class >> slotSize: anInteger [
	SlotSize := anInteger
]

{ #category : #accessing }
ProcessLMRStack >> bp: aPointer [
	bp := aPointer
]

{ #category : #private }
ProcessLMRStack >> callerOf: frame [
	^(frame _asObject _basicAt: 1) _asPointer
]

{ #category : #enumerating }
ProcessLMRStack >> framesDo: aBlock [
	self framesFrom: sp do: aBlock
]

{ #category : #enumerating }
ProcessLMRStack >> framesFrom: top do: aBlock [
	| frame caller |
	frame := top.
	[(caller := self callerOf: frame) = 0] whileFalse: [
		self slotsFrom: frame + (SlotSize * 2) _asPointer to: caller do: aBlock.
		frame := caller]
]

{ #category : #testing }
ProcessLMRStack >> isActive [
	^process isActive
]

{ #category : #testing }
ProcessLMRStack >> isNative [
	^true
]

{ #category : #testing }
ProcessLMRStack >> isValid [
	^process notNil
]

{ #category : #services }
ProcessLMRStack >> lock [
	locked := true
]

{ #category : #enumerating }
ProcessLMRStack >> objectsDo: aBlock [
	self framesDo: [:start :count |
		1 to: count do: [:i | aBlock value: (start _asObject _basicAt: i)]]
]

{ #category : #accessing }
ProcessLMRStack >> process: aProcess [
	super process: aProcess.
	locked := false
]

{ #category : #enumerating }
ProcessLMRStack >> slotsFrom: start to: end do: aBlock [
	| count |
	count := end - start // SlotSize _asPointer.
	SlotSize = WordSize
		ifTrue: [aBlock value: start value: count]
		ifFalse: [0 to: count - 1 do: [:i | aBlock value: start + (i * SlotSize) _asPointer value: 1]]
]

{ #category : #accessing }
ProcessLMRStack >> sp: aPointer [
	sp := aPointer
]

{ #category : #services }
ProcessLMRStack >> unlock [
	locked := false
]

{ #category : #services }
ProcessLMRStack >> updateBack: anInteger [
	| frame |
	frame := self _framePointer _asPointer.
	anInteger - 1 timesRepeat: [frame := self callerOf: frame].
	sp := frame.
	bp := self callerOf: frame
]
