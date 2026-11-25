'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #CopyingCollector category: #Kernel!
GarbageCollector subclass: #CopyingCollector
	instanceVariableNames: 'fromSpace toSpace forwarders scan'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!CopyingCollector commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!CopyingCollector methodsFor:  'ephemerons' stamp: 'KenD 28/Jun/2026 13:27:39'!
checkReachablePropertyOf: ephemeron
	| key |
	key := ephemeron _basicAt: 1.
	key _isSmallInteger ifTrue: [^true].
	^(self newspaceIncludes: key) not or: [key _hasBeenSeen]
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
copyOf: anObject
	^anObject _isProxy
		ifTrue: [self proxeeOf: anObject]
		ifFalse: [self doCopy: anObject]
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
fixReturnAddressIn: frame sized: size
	| return method original moved |
	return := frame _basicAt: 0.
	method := frame _basicAt: size - 1.
	original := method nativeCode code.
	(self newspaceIncludes: original) ifTrue: [
		moved := self copyOf: original.
		return := return _asSmallInteger - original _asSmallInteger
			+ moved _asSmallInteger.
		frame _basicAt: 0 put: return _asNative]
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
followClosure
	[scan < toSpace nextFree or: [self unscannedExternalsRemain]]
		whileTrue: [self scanExternals; scanInternals; scanStacks]
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
forward: object to: copy
	| index |
	index := self forwardingIndexOf: object.
	forwarders _asObject _basicAt: index put: copy.
	object _beSeen
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
forwardersSize
	^self subclassResponsibility
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
forwardingIndexOf: anObject
	^self subclassResponsibility
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialContainerCapacity
	^(10 raisedTo: (self movableBytes log: 1000)) asInteger
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeForwarders
	self subclassResponsibility
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeLocals
	fromSpace := GCSpace copyFrom: memory from.
	toSpace := GCSpace copyFrom: memory to.
	scan := toSpace nextFree.
	self initializeForwarders.
	super initializeLocals
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
movableBytes
	self subclassResponsibility
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
newspaceIncludes: object
	^self subclassResponsibility
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
proxeeOf: object
	| index |
	index := self forwardingIndexOf: object.
	^forwarders _asObject _basicAt: index
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
releaseLocals
	fromSpace := toSpace := scan := nil.
	super releaseLocals
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scan: current
	current _isSpecial ifTrue: [self rememberSpecial: current].
	self
		scanBehavior: current;
		scan: current from: 1 to: current _strongPointersSize
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scan: current from: start to: limit
	| index |
	index := start.
	[index <= limit] whileTrue: [
		self update: current at: index.
		index := index + 1]
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanBehavior: current
	self subclassResponsibility
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanExternals
	self subclassResponsibility
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanInternals
	[scan < toSpace nextFree] whileTrue: [| current |
		current := scan _objectFromBasePointer.
		self scan: current.
		scan := current _nextBasePointer]
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanTopSlot: stackWrapper
	self update: stackWrapper sp _asObject at: 1
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
update: current at: index
	^self subclassResponsibility
! !

!CopyingCollector methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
updateWeak: weakContainer at: index
	| object moved |
	object := weakContainer _basicAt: index.
	object _isSmallInteger ifTrue: [^self].
	(self newspaceIncludes: object) ifFalse: [^self].
	moved := object _hasBeenSeen
		ifTrue: [self proxeeOf: object]
		ifFalse: [tombstone].
	weakContainer _basicAt: index put: moved
! !

!CopyingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
workSpace
	^workSpace
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CopyingCollector class' category: #Kernel!
CopyingCollector class
	instanceVariableNames: ''!


