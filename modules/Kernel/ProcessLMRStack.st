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
ProcessLMRStack class >> initializeConstants [
	self addNamespaceAs: #FrameSlots.
	FrameSlots
		at: #ReceiverSlot put: 1;
		at: #CodeSlot put: 2;
		at: #EnvironmentSlot put: 4;
		at: #CallerSlots put: 2;
		at: #SnapshotFrames put: 3
]

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

{ #category : #reifying }
ProcessLMRStack >> reify [
	^Context fromStack: self
]

{ #category : #reifying }
ProcessLMRStack >> receiverAt: frame [
	^self slot: ReceiverSlot below: frame
]

{ #category : #reifying }
ProcessLMRStack >> codeAt: frame [
	| code |
	code := self slot: CodeSlot below: frame.
	^code compiledCode
]

{ #category : #reifying }
ProcessLMRStack >> environmentAt: frame [
	| code |
	code := self codeAt: frame.
	(self hasEnvironment: code) ifFalse: [^nil].
	^self slot: EnvironmentSlot below: frame
]

{ #category : #reifying }
ProcessLMRStack >> stackAt: frame top: callee [
	| temps |
	temps := self tempsAt: frame.
	callee = frame ifTrue: [^temps].
	^temps , (self argumentsAbove: callee)
]

{ #category : #reifying }
ProcessLMRStack >> returnPcAt: frame [
	^nil
]

{ #category : #reifying }
ProcessLMRStack >> callerTopOf: frame [
	^frame
]

{ #category : #private }
ProcessLMRStack >> hasEnvironment: aCompiledCode [
	^aCompiledCode isBlock or: [aCompiledCode hasBlocks]
]

{ #category : #private }
ProcessLMRStack >> tempsAt: frame [
	| code first |
	code := self codeAt: frame.
	first := (self hasEnvironment: code) ifTrue: [EnvironmentSlot + 1] ifFalse: [CodeSlot + 1].
	^(0 to: code tempCount - 1) collect: [:i | self slot: first + i below: frame]
]

{ #category : #private }
ProcessLMRStack >> argumentsAbove: frame [
	| count |
	count := (self codeAt: frame) argumentCount.
	^(1 to: count) collect: [:i | self slot: i - count - CallerSlots below: frame]
]

{ #category : #private }
ProcessLMRStack >> slot: anInteger below: frame [
	^(frame - (SlotSize * anInteger) _asPointer) _asObject _basicAt: 1
]

{ #category : #services }
ProcessLMRStack >> snapshot [
	self updateBack: SnapshotFrames
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
	bp := frame
]
