"
    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
"

Class {
	#name : #ProcessLMRStack,
	#superclass : #ProcessStack,
	#instVars : [
		'locked',
		'chunk',
		'spare'
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

{ #category : #callouts }
ProcessLMRStack class >> calloutTop: top frame: frame [
	Processor activeProcess nativeStack calloutTop: top frame: frame
]

{ #category : #callbacks }
ProcessLMRStack class >> enterCallback [
	Processor activeProcess nativeStack enterCallback
]

{ #category : #callbacks }
ProcessLMRStack class >> exitCallback [
	Processor activeProcess nativeStack exitCallback
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

{ #category : #callouts }
ProcessLMRStack >> calloutTop: top frame: frame [
	spare ifNil: [spare := ProcessStackChunk new].
	chunk sp: top; bp: frame
]

{ #category : #callbacks }
ProcessLMRStack >> enterCallback [
	spare prev: chunk.
	chunk := spare.
	spare := nil
]

{ #category : #callbacks }
ProcessLMRStack >> exitCallback [
	| exited |
	exited := chunk.
	chunk := exited prev.
	exited invalidate; prev: nil.
	spare := exited
]

{ #category : #private }
ProcessLMRStack >> callerOf: frame [
	^(frame _asObject _basicAt: 1) _asPointer
]

{ #category : #enumerating }
ProcessLMRStack >> framesDo: aBlock [
	| suspended |
	self framesFrom: sp do: aBlock.
	suspended := chunk prev.
	[suspended isForCallback] whileTrue: [
		self framesOf: suspended do: aBlock.
		suspended := suspended prev]
]

{ #category : #enumerating }
ProcessLMRStack >> framesFrom: top do: aBlock [
	| frame caller |
	frame := top.
	[(caller := self callerOf: frame) = 0] whileFalse: [
		self slotsFrom: frame + (SlotSize * 2) _asPointer to: caller do: aBlock.
		frame := caller]
]

{ #category : #enumerating }
ProcessLMRStack >> framesOf: aProcessStackChunk do: aBlock [
	| frame |
	frame := aProcessStackChunk bp.
	self slotsFrom: aProcessStackChunk sp to: frame do: aBlock.
	self framesFrom: frame do: aBlock
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
ProcessLMRStack >> lastArgumentOf: frame [
	^(frame + (SlotSize * 2) _asPointer) _asObject _basicAt: 1
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
	locked := false.
	chunk := ProcessStackChunk new.
	spare := ProcessStackChunk new
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
