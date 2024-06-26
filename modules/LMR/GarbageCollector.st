"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #GarbageCollector,
	#superclass : #Object,
	#instVars : [
		'weakContainers',
		'uncheckedEphemerons',
		'unreachedEphemerons',
		'rescuedEphemerons',
		'tombstone',
		'memory',
		'stacks',
		'currentSP',
		'workSpace'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
GarbageCollector class >> on: aMemory [
	^self new memory: aMemory
]

{ #category : #ephemerons }
GarbageCollector >> checkEphemeron: object [
	
]

{ #category : #ephemerons }
GarbageCollector >> checkEphemerons [
	| done |
	done := true.
	[uncheckedEphemerons isEmpty] whileFalse: [| ephemeron |
		ephemeron := uncheckedEphemerons pop.
		(self checkReachablePropertyOf: ephemeron)
			ifTrue: [
				self followEphemeronWeaks: ephemeron.
				done := false]
			ifFalse: [unreachedEphemerons unsafeAdd: ephemeron]].
	^done
]

{ #category : #cleaning }
GarbageCollector >> checkReachablePropertyOf: ephemeron [
	^self subclassResponsibility
]

{ #category : #cleaning }
GarbageCollector >> collect [
	| eden |
	eden := memory eden.
	self
		resetWorkspace;
		currentSpace: workSpace;
		initializeLocals;
		updateStackAndDoCollect;
		currentSpace: eden;
		releaseLocals
]

{ #category : #cleaning }
GarbageCollector >> copyRescuedEphemerons [
	self subclassResponsibility
]

{ #category : #cleaning }
GarbageCollector >> currentSpace: aSpace [
	memory eden: aSpace
]

{ #category : #cleaning }
GarbageCollector >> doCollect [
	self followRoots; strenghtenAndMigrateEphemerons; scanWeakContainers
]

{ #category : #cleaning }
GarbageCollector >> followClosure [
	self subclassResponsibility
]

{ #category : #ephemerons }
GarbageCollector >> followEphemerons [
	[| done |
		done := self followLiveEphemerons; rescueUnreacheableEphemerons.
		done] whileFalse
]

{ #category : #ephemerons }
GarbageCollector >> followEphemeronWeaks: ephemeron [
	self
		scan: ephemeron from: 1 to: ephemeron _size;
		followClosure
]

{ #category : #ephemerons }
GarbageCollector >> followLiveEphemerons [
	| done |
	[
		done := self checkEphemerons.
		done]
		whileFalse: [self swapUncheckedWithUnreached]
]

{ #category : #cleaning }
GarbageCollector >> followRoots [
	self scanThreadLocalStorages; followClosure; followEphemerons
]

{ #category : #cleaning }
GarbageCollector >> initialContainerCapacity [
	^self subclassResponsibility
]

{ #category : #cleaning }
GarbageCollector >> initializeLocals [
	| size |
	size := self initialContainerCapacity.
	weakContainers := CriticalArray new growTo: size; ignoreWriteBarrier.
	uncheckedEphemerons := CriticalArray new growTo: size; ignoreWriteBarrier.
	unreachedEphemerons := CriticalArray new growTo: size; ignoreWriteBarrier.
	rescuedEphemerons := CriticalArray new growTo: size; ignoreWriteBarrier.
	stacks := CriticalArray new growTo: size; ignoreWriteBarrier
]

{ #category : #accessing }
GarbageCollector >> memory: aMemory [
	memory := aMemory.
	self postInitialize
]

{ #category : #cleaning }
GarbageCollector >> postInitialize [
	| size address |
	size := self workSpaceSize.
	address := Kernel os reserveAndCommit: size.
	workSpace := memory newSpace address: address size: size.
	workSpace
		name: 'GC Work';
		commitedLimit: workSpace reservedLimit;
		leaveDispenseSpace: 64 * 1024 // 2
]

{ #category : #cleaning }
GarbageCollector >> releaseLocals [
	"
	The collector is reachable while tracing the object graph
	and so my ivars. That shall not be a problem as the pointers
	to either my workspace or either the young space are going
	to be up-to-date until next GC (where the ivars are reseted
	again). However, this adds innecesary tracing overhead. The
	only object that needs moving is the ephemerons array, as it
	can happen that rescueing ephemerons triggers a GC and the
	array is overrun as it lives in the workspace.
	"
	memory queueEphemerons: rescuedEphemerons.
	weakContainers := uncheckedEphemerons := unreachedEphemerons := rescuedEphemerons := nil.
	stacks := nil.
	Processor activeProcess stack unlock
]

{ #category : #ephemerons }
GarbageCollector >> rememberSpecial: object [
	| collection class |
	class := object class.
	collection := class == Ephemeron
		ifTrue: [
			self checkEphemeron: object.
			uncheckedEphemerons]
		ifFalse: [class == ProcessLMRStack ifTrue: [stacks] ifFalse: [weakContainers]].
	collection unsafeAdd: object
]

{ #category : #ephemerons }
GarbageCollector >> rescueEphemeron: ephemeron [
	self followEphemeronWeaks: ephemeron.
	rescuedEphemerons unsafeAdd: ephemeron
]

{ #category : #ephemerons }
GarbageCollector >> rescueUnreacheableEphemerons [
	| done |
	done := unreachedEphemerons isEmpty.
	unreachedEphemerons
		do: [:ephemeron | self rescueEphemeron: ephemeron];
		reset.
	^done
]

{ #category : #cleaning }
GarbageCollector >> resetWorkspace [
	workSpace reset
]

{ #category : #cleaning }
GarbageCollector >> scan: current from: start to: limit [
	self subclassResponsibility
]

{ #category : #cleaning }
GarbageCollector >> scanFirstStackChunk: aProcessStack [
	| start end |
	aProcessStack isActive
		ifTrue: [self updateStackPointer: aProcessStack]
		ifFalse: [self scanTopSlot: aProcessStack].
	start := aProcessStack sp + (WordSize * 2) _asPointer.
	end := aProcessStack bp.
	aProcessStack
		nativeFramesDo: [:frame :size | self
			scanNativeStackFrame: frame
			sized: size]
		startingAt: start
		base: end
]

{ #category : #cleaning }
GarbageCollector >> scanNativeStackFrame: framePointer sized: size [
	"
	all code is pinned for now
	self fixReturnAddressIn: framePointer _asObject sized: size.
	"
	self scanStackFrameObjects: framePointer sized: size
]

{ #category : #cleaning }
GarbageCollector >> scanSpecialSlots: special [
	self scan: special from: 1 to: special _size
]

{ #category : #cleaning }
GarbageCollector >> scanStack: aProcessStack [
	aProcessStack isValid ifFalse: [^self].
	aProcessStack isNative ifTrue: [self scanFirstStackChunk: aProcessStack].
	aProcessStack
		framesBeneathCallbackDo: [:frame :nativeSize | self
			scanNativeStackFrame: frame
			sized: nativeSize]
]

{ #category : #cleaning }
GarbageCollector >> scanStackFrameObjects: framePointer sized: size [
	self scan: framePointer _asObject from: 1 to: size
]

{ #category : #cleaning }
GarbageCollector >> scanStacks [
	[stacks isEmpty] whileFalse: [| s |
		s := stacks pop.
		self scanSpecialSlots: s; scanStack: s]
]

{ #category : #cleaning }
GarbageCollector >> scanThreadLocalStorage: thread [
	self subclassResponsibility
]

{ #category : #cleaning }
GarbageCollector >> scanThreadLocalStorages [
	Thread registeredInstances
		do: [:thread | self scanThreadLocalStorage: thread]
]

{ #category : #cleaning }
GarbageCollector >> scanTopSlot: stackWrapper [
	self subclassResponsibility
]

{ #category : #private }
GarbageCollector >> scanWeakContainers [
	weakContainers
		do: [:weakContainer | self updateWeakReferencesOf: weakContainer];
		reset
]

{ #category : #cleaning }
GarbageCollector >> strenghtenAndMigrateEphemerons [
	"
	Hereby the rescued critical array contents is moved to the old region. 
	As it may have grown after being traced, the contents could be unmarked.
	If that happened, and the contents was copied to a large space, the memory
	area would be incorrectly freed. 
	To avoid that from happening, we mark the contents as seen.
	"
	| contents |
	contents := self copyRescuedEphemerons.
	contents ifNil: [
		^self
			_error: 'Rescued ephemerons could not be copied outside of GC work space'].
	contents _beSeen.
	memory rememberIfNeeded: contents.
	rescuedEphemerons
		contents: contents;
		do: [:ephemeron | ephemeron _beNotSpecial]
]

{ #category : #ephemerons }
GarbageCollector >> swapUncheckedWithUnreached [
	| aux |
	aux := uncheckedEphemerons.
	uncheckedEphemerons := unreachedEphemerons.
	unreachedEphemerons := aux
]

{ #category : #cleaning }
GarbageCollector >> updateActiveStack [
	"
	We must store the stack pointer in a different var
	instead of trusting the active process. This happens
	because the process might do an FFI call and update
	it while collecting
	"
	| stack |
	stack := ActiveProcess stack lock; updateBack: 1.
	currentSP := stack sp
]

{ #category : #cleaning }
GarbageCollector >> updateStackAndDoCollect [
	"
	Here we assure that the current environment, stored in E register,
	is saved in the stack. Then we update the stack pointers of the
	stack wrapper. This assures that the environment is seen and
	updated when tracing the active process stack.
	"
	[self updateActiveStack; doCollect] value
]

{ #category : #cleaning }
GarbageCollector >> updateStackPointer: stackWrapper [
	| bp |
	bp := (currentSP _asObject _basicAt: 1) _asPointer.
	stackWrapper sp: currentSP; bp: bp
]

{ #category : #cleaning }
GarbageCollector >> updateWeak: weakContainer at: index [
	self subclassResponsibility
]

{ #category : #cleaning }
GarbageCollector >> updateWeakReferencesOf: weakContainer [
	1
		to: weakContainer _size
		do: [:index | self updateWeak: weakContainer at: index]
]

{ #category : #cleaning }
GarbageCollector >> workSpaceSize [
	^self subclassResponsibility
]

