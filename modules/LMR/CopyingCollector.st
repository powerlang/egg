"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #CopyingCollector,
	#superclass : #GarbageCollector,
	#instVars : [
		'fromSpace',
		'toSpace',
		'forwarders',
		'scan'
	],
	#category : #Kernel
}

{ #category : #ephemerons }
CopyingCollector >> checkReachablePropertyOf: ephemeron [
	| key |
	key := ephemeron _basicAt: 1.
	key _isSmallInteger ifTrue: [^true].
	^(self newspaceIncludes: key) not or: [key _hasBeenSeen]
]

{ #category : #cleaning }
CopyingCollector >> copyOf: anObject [
	^anObject _isProxy
		ifTrue: [self proxeeOf: anObject]
		ifFalse: [self doCopy: anObject]
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

{ #category : #cleaning }
CopyingCollector >> forward: object to: copy [
	| index |
	index := self forwardingIndexOf: object.
	forwarders _asObject _basicAt: index put: copy.
	object _beSeen
]

{ #category : #cleaning }
CopyingCollector >> forwardersSize [
	^self subclassResponsibility
]

{ #category : #cleaning }
CopyingCollector >> forwardingIndexOf: anObject [
	^self subclassResponsibility
]

{ #category : #cleaning }
CopyingCollector >> initialContainerCapacity [
	^(10 raisedTo: (self movableBytes log: 1000)) asInteger
]

{ #category : #cleaning }
CopyingCollector >> initializeForwarders [
	self subclassResponsibility
]

{ #category : #cleaning }
CopyingCollector >> initializeLocals [
	fromSpace := GCSpace copyFrom: memory from.
	toSpace := GCSpace copyFrom: memory to.
	scan := toSpace nextFree.
	self initializeForwarders.
	super initializeLocals
]

{ #category : #cleaning }
CopyingCollector >> movableBytes [
	self subclassResponsibility
]

{ #category : #cleaning }
CopyingCollector >> newspaceIncludes: object [
	^self subclassResponsibility
]

{ #category : #cleaning }
CopyingCollector >> proxeeOf: object [
	| index |
	index := self forwardingIndexOf: object.
	^forwarders _asObject _basicAt: index
]

{ #category : #cleaning }
CopyingCollector >> releaseLocals [
	fromSpace := toSpace := scan := nil.
	super releaseLocals
]

{ #category : #cleaning }
CopyingCollector >> scan: current [
	current _isSpecial ifTrue: [self rememberSpecial: current].
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
	self subclassResponsibility
]

{ #category : #cleaning }
CopyingCollector >> scanExternals [
	self subclassResponsibility
]

{ #category : #cleaning }
CopyingCollector >> scanInternals [
	[scan < toSpace nextFree] whileTrue: [| current |
		current := scan _objectFromBasePointer.
		self scan: current.
		scan := current _nextBasePointer]
]

{ #category : #cleaning }
CopyingCollector >> scanTopSlot: stackWrapper [
	self update: stackWrapper sp _asObject at: 1
]

{ #category : #cleaning }
CopyingCollector >> update: current at: index [
	^self subclassResponsibility
]

{ #category : #private }
CopyingCollector >> updateWeak: weakContainer at: index [
	| object moved |
	object := weakContainer _basicAt: index.
	object _isSmallInteger ifTrue: [^self].
	(self newspaceIncludes: object) ifFalse: [^self].
	moved := object _hasBeenSeen
		ifTrue: [self proxeeOf: object]
		ifFalse: [tombstone].
	weakContainer _basicAt: index put: moved
]

{ #category : #cleaning }
CopyingCollector >> workSpace [
	^workSpace
]

