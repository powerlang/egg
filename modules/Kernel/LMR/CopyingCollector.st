"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #CopyingCollector,
	#superclass : #Object,
	#instVars : [
		'fromSpace',
		'toSpace',
		'workSpace',
		'forwarders',
		'scan',
		'externals',
		'weakContainers',
		'uncheckedEphemerons',
		'unreachedEphemerons',
		'rescuedEphemerons',
		'tombstone',
		'memory',
		'stacks'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
CopyingCollector class >> on: aMemory [
	^self new memory: aMemory
]

{ #category : #'adding / removing' }
CopyingCollector >> addExternal: object [
	object _hasBeenSeen ifFalse: [
		object _beSeen.
		externals unsafeAdd: object]
]

{ #category : #ephemerons }
CopyingCollector >> checkEphemerons [
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

{ #category : #ephemerons }
CopyingCollector >> checkReachablePropertyOf: ephemeron [
	| key |
	key := ephemeron _basicAt: 1.
	^(self newspaceIncludes: key) not or: [key _isProxy]
]

{ #category : #cleaning }
CopyingCollector >> collect [
	self
		updateActiveStack;
		resetWorkspace;
		currentSpace: workSpace;
		initializeLocals;
		doCollect;
		swapMemoryFromAndTo;
		currentSpace: self nextEden;
		releaseLocals;
		unmarkAll
]

{ #category : #cleaning }
CopyingCollector >> copyOf: anObject [
	^anObject _isProxy
		ifTrue: [self proxeeOf: anObject]
		ifFalse: [self doCopy: anObject]
]

{ #category : #cleaning }
CopyingCollector >> currentSpace: aSpace [
	Memory current eden: aSpace
]

{ #category : #cleaning }
CopyingCollector >> doCollect [
	self
		saveEnvironmentAndFollowRoots;
		strenghtenAndMigrateEphemerons;
		scanWeakContainers
]

{ #category : #cleaning }
CopyingCollector >> fixReturnAddressIn: frame sized: size [
	| return method original moved |
	return := frame _basicAt: 0.
	method := frame _basicAt: size - 1.
	original := method nativeCode code.
	(self newspaceIncludes: original) ifTrue: [
		moved := self copyOf: original.
		return := return _asSmallInteger - original _asSmallInteger
			+ moved _asSmallInteger.
		frame _basicAt: 0 put: return _asNative]
]

{ #category : #cleaning }
CopyingCollector >> followClosure [
	[scan < toSpace nextFree or: [self unscannedExternalsRemain]]
		whileTrue: [self scanExternals; scanInternals; scanStacks]
]

{ #category : #ephemerons }
CopyingCollector >> followEphemerons [
	[| done |
		done := self followLiveEphemerons; rescueUnreacheableEphemerons.
		done] whileFalse
]

{ #category : #ephemerons }
CopyingCollector >> followEphemeronWeaks: ephemeron [
	self
		scan: ephemeron from: 1 to: ephemeron _size;
		followClosure
]

{ #category : #ephemerons }
CopyingCollector >> followLiveEphemerons [
	| done |
	[
		done := self checkEphemerons.
		done]
		whileFalse: [self swapUncheckedWithUnreached]
]

{ #category : #cleaning }
CopyingCollector >> followNativeCodeObject: offset from: bytes [
	| object moved |
	object := bytes _objectAtOffset: offset.
	object _isSmallInteger ifTrue: [^self].
	(fromSpace includes: object)
		ifTrue: [
			moved := self copyOf: object.
			bytes _objectAtOffset: offset put: moved]
		ifFalse: [self addExternal: object]
]

{ #category : #cleaning }
CopyingCollector >> followRoots [
	self scanThreadLocalStorages; followClosure; followEphemerons
]

{ #category : #cleaning }
CopyingCollector >> forward: object to: copy [
	| index |
	index := self forwardingIndexOf: object.
	index > forwarders _size ifTrue: [self _halt].
	forwarders _basicAt: index put: copy.
	object _beSeen
]

{ #category : #cleaning }
CopyingCollector >> forwardersSize [
	^memory youngLimit - memory youngBase * 2
]

{ #category : #cleaning }
CopyingCollector >> forwardingIndexOf: anObject [
	^(anObject _asPointer - fromSpace base bitShift: 0 - WordSizeShift + 1) + 1
]

{ #category : #cleaning }
CopyingCollector >> initialize [
	
]

{ #category : #cleaning }
CopyingCollector >> initializeLocals [
	fromSpace := GCSpace copyFrom: memory from.
	toSpace := GCSpace copyFrom: memory to.
	scan := toSpace nextFree.
	forwarders := Array new: self forwardersSize // WordSize.
	externals := CriticalArray emptyReserving: 128 * 1024.
	externals ignoreWriteBarrier.
	weakContainers := CriticalArray emptyReserving: 1024.
	weakContainers ignoreWriteBarrier.
	uncheckedEphemerons := CriticalArray emptyReserving: 1024.
	uncheckedEphemerons ignoreWriteBarrier.
	unreachedEphemerons := CriticalArray emptyReserving: 1024.
	unreachedEphemerons ignoreWriteBarrier.
	rescuedEphemerons := CriticalArray emptyReserving: 1024.
	rescuedEphemerons ignoreWriteBarrier.
	stacks := CriticalArray emptyReserving: 1024.
	stacks ignoreWriteBarrier
]

{ #category : #accessing }
CopyingCollector >> memory: aMemory [
	memory := aMemory.
	self postInitialize
]

{ #category : #cleaning }
CopyingCollector >> newspaceIncludes: object [
	^fromSpace includes: object
]

{ #category : #cleaning }
CopyingCollector >> nextEden [
	^memory from
]

{ #category : #cleaning }
CopyingCollector >> postInitialize [
	| space |
	space := memory newSpaceSized: self workSpaceSize.
	workSpace := memory kernelSpace deepCopy: space.
	workSpace leaveDispenseSpace: 64 * 1024 // 2
]

{ #category : #cleaning }
CopyingCollector >> proxeeOf: object [
	| index |
	index := self forwardingIndexOf: object.
	^forwarders _basicAt: index
]

{ #category : #cleaning }
CopyingCollector >> releaseLocals [
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
	| contents |
	fromSpace := nil.
	toSpace := nil.
	scan := nil.
	forwarders := nil.
	externals := nil.
	weakContainers := nil.
	uncheckedEphemerons := nil.
	unreachedEphemerons := nil.
	rescuedEphemerons := memory shallowCopy: rescuedEphemerons.
	contents := memory shallowCopy: rescuedEphemerons contents.
	rescuedEphemerons space: memory; contents: contents.
	stacks := nil
]

{ #category : #ephemerons }
CopyingCollector >> rememberIfWeak: object [
	| collection |
	object _isWeak ifFalse: [^self].
	collection := object behavior = Ephemeron instanceBehavior
		ifTrue: [uncheckedEphemerons]
		ifFalse: [weakContainers].
	collection unsafeAdd: object
]

{ #category : #ephemerons }
CopyingCollector >> rememberSpecial: object [
	| collection class |
	class := object class.
	collection := class == Ephemeron
		ifTrue: [uncheckedEphemerons]
		ifFalse: [class == StackWrapper ifTrue: [stacks] ifFalse: [weakContainers]].
	collection unsafeAdd: object
]

{ #category : #ephemerons }
CopyingCollector >> rescuedEphemerons [
	^rescuedEphemerons
]

{ #category : #ephemerons }
CopyingCollector >> rescueEphemeron: ephemeron [
	self followEphemeronWeaks: ephemeron.
	rescuedEphemerons unsafeAdd: ephemeron
]

{ #category : #ephemerons }
CopyingCollector >> rescueUnreacheableEphemerons [
	| done |
	done := unreachedEphemerons isEmpty.
	unreachedEphemerons
		do: [:ephemeron | self rescueEphemeron: ephemeron];
		reset.
	^done
]

{ #category : #cleaning }
CopyingCollector >> resetWorkspace [
	workSpace reset
]

{ #category : #cleaning }
CopyingCollector >> saveEnvironmentAndFollowRoots [
	"
	Here we assure that the current environment, stored
	in E register, is saved in the stack, so that it is seen
	when tracing the active process stack.
	"
	[self followRoots] value
]

{ #category : #cleaning }
CopyingCollector >> scan: current [
	current behavior == NativeCode instanceBehavior
		ifTrue: [self scanNativeCode: current].
	current _isWeak ifTrue: [self rememberSpecial: current].
	self
		scanBehavior: current;
		scan: current from: 1 to: current _strongPointersSize
]

{ #category : #cleaning }
CopyingCollector >> scan: current from: start to: limit [
	| index |
	index := start.
	[index <= limit] whileTrue: [
		self update: current at: index.
		index := index + 1]
]

{ #category : #cleaning }
CopyingCollector >> scanBehavior: current [
	| behavior moved |
	behavior := current _basicULongAt: 0.
	behavior _isSmallInteger ifTrue: [^behavior].
	(self newspaceIncludes: behavior)
		ifTrue: [
			moved := self copyOf: behavior.
			^current _basicULongAt: 0 put: moved]
		ifFalse: [(workSpace includes: behavior)
			ifFalse: [self addExternal: behavior]].
	^behavior
]

{ #category : #cleaning }
CopyingCollector >> scanExternals [
	[externals isEmpty] whileFalse: [| object |
		object := externals pop.
		self scan: object]
]

{ #category : #cleaning }
CopyingCollector >> scanInternals [
	[scan < toSpace nextFree] whileTrue: [| current |
		current := scan _objectFromBasePointer.
		self scan: current.
		scan := current _nextBasePointer]
]

{ #category : #cleaning }
CopyingCollector >> scanNativeCode: nativeCode [
	| code |
	nativeCode isFresh ifFalse: [^self].
	code := nativeCode code.
	nativeCode references do: [:encoded | 
		(nativeCode isObjectReference: encoded)
			ifTrue: [self followNativeCodeObject: encoded from: code]]
]

{ #category : #cleaning }
CopyingCollector >> scanNativeStack: stackWrapper [
	stackWrapper
		nativeFramesDo: [:frame :size | self
			scanNativeStackFrame: frame
			sized: size]
]

{ #category : #cleaning }
CopyingCollector >> scanNativeStackFrame: framePointer sized: size [
	self fixReturnAddressIn: framePointer _asObject sized: size.
	self scanStackFrameObjects: framePointer sized: size
]

{ #category : #cleaning }
CopyingCollector >> scanReifiedStack: stackWrapper [
	| top size |
	top := stackWrapper top.
	size := stackWrapper reifiedSize.
	self scan: top _asObject from: 1 to: size.
	stackWrapper
		framesBeneathCallbackDo: [:frame :nativeSize | self
			scanNativeStackFrame: frame
			sized: nativeSize]
]

{ #category : #cleaning }
CopyingCollector >> scanSpecialSlots: special [
	self scan: special from: 1 to: special _size
]

{ #category : #cleaning }
CopyingCollector >> scanStack: aStackWrapper [
	aStackWrapper isValid ifFalse: [^self].
	aStackWrapper isNative
		ifTrue: [self
			scanTopSlotIfInactive: aStackWrapper;
			scanNativeStack: aStackWrapper]
		ifFalse: [self scanReifiedStack: aStackWrapper]
]

{ #category : #cleaning }
CopyingCollector >> scanStackFrameObjects: framePointer sized: size [
	self scan: framePointer _asObject from: 1 to: size
]

{ #category : #cleaning }
CopyingCollector >> scanStacks [
	[stacks isEmpty] whileFalse: [| s |
		s := stacks pop.
		self scanSpecialSlots: s; scanStack: s]
]

{ #category : #cleaning }
CopyingCollector >> scanThreadLocalStorage: thread [
	thread localStorageIndices do: [:index | | object moved |
		object := thread tlsAt: index.
		object _isSmallInteger ifTrue: [^object].
		(fromSpace includes: object)
			ifTrue: [
				moved := self copyOf: object.
				thread tlsAt: index put: moved]
			ifFalse: [(workSpace includes: object) ifFalse: [self addExternal: object]]]
]

{ #category : #cleaning }
CopyingCollector >> scanThreadLocalStorages [
	Thread registeredInstances
		do: [:thread | self scanThreadLocalStorage: thread]
]

{ #category : #cleaning }
CopyingCollector >> scanTopSlotIfInactive: stackWrapper [
	stackWrapper isActive
		ifFalse: [self update: stackWrapper top _asObject at: 1]
]

{ #category : #private }
CopyingCollector >> scanWeakContainers [
	weakContainers
		do: [:weakContainer | self scanWeakReferencesOf: weakContainer];
		reset
]

{ #category : #private }
CopyingCollector >> scanWeakReferencesOf: weakContainer [
	1 to: weakContainer _size do: [:index | | object moved |
		object := weakContainer _basicAt: index.
		(self newspaceIncludes: object) ifTrue: [
			moved := object _isProxy
				ifTrue: [self proxeeOf: object]
				ifFalse: [tombstone].
			weakContainer _basicAt: index put: moved]]
]

{ #category : #ephemerons }
CopyingCollector >> strenghtenAndMigrateEphemerons [
	rescuedEphemerons := toSpace shallowCopy: rescuedEphemerons.
	rescuedEphemerons do: [:ephemeron | ephemeron _beStrong]
]

{ #category : #cleaning }
CopyingCollector >> swapMemoryFromAndTo [
	memory from wipeOut; copyFrom: toSpace.
	memory to copyFrom: fromSpace; reset; leaveDispenseSpace
]

{ #category : #ephemerons }
CopyingCollector >> swapUncheckedWithUnreached [
	| aux |
	aux := uncheckedEphemerons.
	uncheckedEphemerons := unreachedEphemerons.
	unreachedEphemerons := aux
]

{ #category : #cleaning }
CopyingCollector >> unmarkAll [
	memory spaces do: #unmarkAll
]

{ #category : #cleaning }
CopyingCollector >> unscannedExternalsRemain [
	^externals isEmpty not
]

{ #category : #cleaning }
CopyingCollector >> update: current at: index [
	| object moved |
	object := current _basicAt: index.
	object _isSmallInteger ifTrue: [^object].
	(self newspaceIncludes: object)
		ifTrue: [
			moved := self copyOf: object.
			^current _basicAt: index put: moved]
		ifFalse: [(workSpace includes: object) ifFalse: [self addExternal: object]].
	^object
]

{ #category : #cleaning }
CopyingCollector >> updateActiveStack [
	ActiveProcess stack update
]

{ #category : #cleaning }
CopyingCollector >> workSpace [
	^workSpace
]

{ #category : #private }
CopyingCollector >> workSpaceSize [
	^self forwardersSize * 2
]

