'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #GarbageCollector category: #Kernel!
Object subclass: #GarbageCollector
	instanceVariableNames: 'weakContainers uncheckedEphemerons unreachedEphemerons rescuedEphemerons tombstone memory stacks currentSP workSpace'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!GarbageCollector commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!GarbageCollector methodsFor:  'ephemerons' stamp: 'KenD 28/Jun/2026 13:27:39'!
checkEphemeron: object
	
! !

!GarbageCollector methodsFor:  'ephemerons' stamp: 'KenD 28/Jun/2026 13:27:39'!
checkEphemerons
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
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
checkReachablePropertyOf: ephemeron
	^self subclassResponsibility
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
collect
	| eden |
	eden := memory eden.
	self
		resetWorkspace;
		currentSpace: workSpace;
		initializeLocals;
		updateStackAndDoCollect;
		currentSpace: eden;
		releaseLocals
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
copyRescuedEphemerons
	self subclassResponsibility
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
currentSpace: aSpace
	memory eden: aSpace
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
doCollect
	self followRoots; strenghtenAndMigrateEphemerons; scanWeakContainers
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
followClosure
	self subclassResponsibility
! !

!GarbageCollector methodsFor:  'ephemerons' stamp: 'KenD 28/Jun/2026 13:27:39'!
followEphemerons
	[| done |
		done := self followLiveEphemerons; rescueUnreacheableEphemerons.
		done] whileFalse
! !

!GarbageCollector methodsFor:  'ephemerons' stamp: 'KenD 28/Jun/2026 13:27:39'!
followEphemeronWeaks: ephemeron
	self
		scan: ephemeron from: 1 to: ephemeron _size;
		followClosure
! !

!GarbageCollector methodsFor:  'ephemerons' stamp: 'KenD 28/Jun/2026 13:27:39'!
followLiveEphemerons
	| done |
	[
		done := self checkEphemerons.
		done]
		whileFalse: [self swapUncheckedWithUnreached]
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
followRoots
	self scanThreadLocalStorages; followClosure; followEphemerons
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialContainerCapacity
	^self subclassResponsibility
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeLocals
	| size |
	size := self initialContainerCapacity.
	weakContainers := CriticalArray new growTo: size; ignoreWriteBarrier.
	uncheckedEphemerons := CriticalArray new growTo: size; ignoreWriteBarrier.
	unreachedEphemerons := CriticalArray new growTo: size; ignoreWriteBarrier.
	rescuedEphemerons := CriticalArray new growTo: size; ignoreWriteBarrier.
	stacks := CriticalArray new growTo: size; ignoreWriteBarrier
! !

!GarbageCollector methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
memory: aMemory
	memory := aMemory.
	self postInitialize
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
postInitialize
	| size address |
	size := self workSpaceSize.
	address := Kernel os reserveAndCommit: size.
	workSpace := memory newSpace address: address size: size.
	workSpace
		name: 'GC Work';
		commitedLimit: workSpace reservedLimit;
		leaveDispenseSpace: 64 * 1024 // 2
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
releaseLocals
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
! !

!GarbageCollector methodsFor:  'ephemerons' stamp: 'KenD 28/Jun/2026 13:27:39'!
rememberSpecial: object
	| collection class |
	class := object class.
	collection := class == Ephemeron
		ifTrue: [
			self checkEphemeron: object.
			uncheckedEphemerons]
		ifFalse: [class == ProcessLMRStack ifTrue: [stacks] ifFalse: [weakContainers]].
	collection unsafeAdd: object
! !

!GarbageCollector methodsFor:  'ephemerons' stamp: 'KenD 28/Jun/2026 13:27:39'!
rescueEphemeron: ephemeron
	self followEphemeronWeaks: ephemeron.
	rescuedEphemerons unsafeAdd: ephemeron
! !

!GarbageCollector methodsFor:  'ephemerons' stamp: 'KenD 28/Jun/2026 13:27:39'!
rescueUnreacheableEphemerons
	| done |
	done := unreachedEphemerons isEmpty.
	unreachedEphemerons
		do: [:ephemeron | self rescueEphemeron: ephemeron];
		reset.
	^done
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
resetWorkspace
	workSpace reset
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scan: current from: start to: limit
	self subclassResponsibility
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanFirstStackChunk: aProcessStack
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
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanNativeStackFrame: framePointer sized: size
	"
	all code is pinned for now
	self fixReturnAddressIn: framePointer _asObject sized: size.
	"
	self scanStackFrameObjects: framePointer sized: size
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanSpecialSlots: special
	self scan: special from: 1 to: special _size
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanStack: aProcessStack
	aProcessStack isValid ifFalse: [^self].
	aProcessStack isNative ifTrue: [self scanFirstStackChunk: aProcessStack].
	aProcessStack
		framesBeneathCallbackDo: [:frame :nativeSize | self
			scanNativeStackFrame: frame
			sized: nativeSize]
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanStackFrameObjects: framePointer sized: size
	self scan: framePointer _asObject from: 1 to: size
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanStacks
	[stacks isEmpty] whileFalse: [| s |
		s := stacks pop.
		self scanSpecialSlots: s; scanStack: s]
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanThreadLocalStorage: thread
	self subclassResponsibility
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanThreadLocalStorages
	Thread registeredInstances
		do: [:thread | self scanThreadLocalStorage: thread]
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanTopSlot: stackWrapper
	self subclassResponsibility
! !

!GarbageCollector methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanWeakContainers
	weakContainers
		do: [:weakContainer | self updateWeakReferencesOf: weakContainer];
		reset
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
strenghtenAndMigrateEphemerons
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
! !

!GarbageCollector methodsFor:  'ephemerons' stamp: 'KenD 28/Jun/2026 13:27:39'!
swapUncheckedWithUnreached
	| aux |
	aux := uncheckedEphemerons.
	uncheckedEphemerons := unreachedEphemerons.
	unreachedEphemerons := aux
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
updateActiveStack
	"
	We must store the stack pointer in a different var
	instead of trusting the active process. This happens
	because the process might do an FFI call and update
	it while collecting
	"
	| stack |
	stack := ActiveProcess stack lock; updateBack: 1.
	currentSP := stack sp
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
updateStackAndDoCollect
	"
	Here we assure that the current environment, stored in E register,
	is saved in the stack. Then we update the stack pointers of the
	stack wrapper. This assures that the environment is seen and
	updated when tracing the active process stack.
	"
	[self updateActiveStack; doCollect] value
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
updateStackPointer: stackWrapper
	| bp |
	bp := (currentSP _asObject _basicAt: 1) _asPointer.
	stackWrapper sp: currentSP; bp: bp
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
updateWeak: weakContainer at: index
	self subclassResponsibility
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
updateWeakReferencesOf: weakContainer
	1
		to: weakContainer _size
		do: [:index | self updateWeak: weakContainer at: index]
! !

!GarbageCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
workSpaceSize
	^self subclassResponsibility
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'GarbageCollector class' category: #Kernel!
GarbageCollector class
	instanceVariableNames: ''!

!GarbageCollector class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aMemory
	^self new memory: aMemory
! !


