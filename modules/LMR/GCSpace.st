"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #GCSpace,
	#superclass : #Object,
	#instVars : [
		'base',
		'nextFree',
		'softLimit',
		'commitedLimit',
		'reservedLimit',
		'prevBase',
		'mutex'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
GCSpace class >> copyFrom: aGCSpace [
	^self new copyFrom: aGCSpace
]

{ #category : #'instance creation' }
GCSpace class >> from: anImageSegment [
	^self new
]

{ #category : #'instance creation' }
GCSpace class >> newAt: base limit: limit [
	^self new base: base; commitedLimit: limit
]

{ #category : #'instance creation' }
GCSpace class >> newAtAddress: address size: size [
	| p |
	p := address // 2.
	^self newAt: p limit: p + (size // 2)
]

{ #category : #'instance creation' }
GCSpace class >> reservedAt: address sized: size [
	| space |
	space := self new.
	^space
		base: address // 2;
		reservedLimit: space base + (size // 2)
]

{ #category : #enumeration }
GCSpace >> addInstancesOf: aSpecies into: result [
	"
	remember not to create ANY objects here
	"
	| objectBase object end |
	objectBase := base.
	end := nextFree.
	[objectBase < end] whileTrue: [
		object := objectBase _objectFromBasePointer.
		objectBase := object _nextBasePointer.
		object == result ifTrue: [^self].
		object class == aSpecies ifTrue: [result add: object]]
]

{ #category : #enumeration }
GCSpace >> addMarkedInstancesOf: aSpecies into: result [
	"
	remember not to create ANY objects here
	"
	| objectBase object end |
	objectBase := base.
	end := nextFree.
	[objectBase < end] whileTrue: [
		object := objectBase _objectFromBasePointer.
		objectBase := object _nextBasePointer.
		object == result ifTrue: [^self].
		(object _hasBeenSeen and: [object class == aSpecies])
			ifTrue: [result add: object]]
]

{ #category : #enumeration }
GCSpace >> addReferencesTo: anObject into: aCollection [
	"
	remember not to create ANY objects here
	"
	| next object end |
	next := base.
	end := nextFree.
	[next < end] whileTrue: [
		object := next _objectFromBasePointer.
		1 to: object _strongPointersSize do: [:index | | ivar |
			ivar := object _basicAt: index.
			ivar == anObject ifTrue: [aCollection add: object]].
		next := object _nextBasePointer]
]

{ #category : #actions }
GCSpace >> allocateIfPossible: size [
	| answer |
	mutex _busyWait.
	answer := self lockedAllocateIfPossible: size.
	mutex _release.
	^answer
]

{ #category : #actions }
GCSpace >> allocateUnsafe: size [
	| answer |
	mutex _busyWait.
	answer := self lockedAllocateUnsafe: size.
	mutex _release.
	^answer
]

{ #category : #asserting }
GCSpace >> assert: aBoolean [
	aBoolean ifFalse: [self _halt]
]

{ #category : #accessing }
GCSpace >> available [
	^softLimit - nextFree
]

{ #category : #accessing }
GCSpace >> availableBytes [
	^self available * 2
]

{ #category : #accessing }
GCSpace >> base [
	^base
]

{ #category : #accessing }
GCSpace >> base: baseAddress [
	base := baseAddress.
	nextFree isNil ifTrue: [nextFree := baseAddress].
	commitedLimit isNil ifTrue: [commitedLimit := base]
]

{ #category : #actions }
GCSpace >> commit: bytes [
	| size result |
	size := commitedLimit + bytes _asPointer.
	result := self commitSized: size - base.
	result == base ifTrue: [commitedLimit := size] ifFalse: [self _halt]
]

{ #category : #actions }
GCSpace >> commitAtLeast: bytes [
	| padding size |
	padding := 16r8000.
	size := bytes + padding - 1 bitAnd: 0 - padding.
	self commit: size
]

{ #category : #accessing }
GCSpace >> commitedLimit [
	^commitedLimit
]

{ #category : #accessing }
GCSpace >> commitedLimit: anInteger [
	commitedLimit := anInteger.
	reservedLimit isNil ifTrue: [self reservedLimit: anInteger].
	softLimit isNil ifTrue: [self leaveDispenseSpace]
]

{ #category : #accessing }
GCSpace >> commitedSize [
	^commitedLimit - base
]

{ #category : #actions }
GCSpace >> commitMoreMemory [
	| newLimit padding |
	nextFree >= reservedLimit ifTrue: [self _halt].
	padding := 16r8000 _asPointer.
	newLimit := nextFree + padding bitAnd: -16r1000 _asPointer.
	(self commitSized: newLimit - base) == (base bitAnd: -16r1000 _asPointer)
		ifTrue: [commitedLimit := newLimit]
		ifFalse: [self _halt]
]

{ #category : #actions }
GCSpace >> commitSized: size [
	| result |
	result := Smalltalk os alloc: base * 2 size: size * 2 commit: true protect: #rwx.
	^result // 2
]

{ #category : #actions }
GCSpace >> copyFrom: space [
	softLimit := space softLimit.
	base := space base.
	commitedLimit := space commitedLimit.
	reservedLimit := space reservedLimit.
	nextFree := space nextFree
]

{ #category : #accessing }
GCSpace >> dataBase [
	^base * 2
]

{ #category : #accessing }
GCSpace >> dataBase: address size: anInteger [
	| p |
	p := address // 2.
	self
		base: p;
		commitedLimit: p + (anInteger // 2).
	self nextFree: self commitedLimit
]

{ #category : #accessing }
GCSpace >> dataSize [
	^reservedLimit - base * 2
]

{ #category : #actions }
GCSpace >> deepCopy: object [
	| copy class ivars |
	copy := self shallowCopy: object.
	class := copy class.
	ivars := class _instancesAreFixed ifTrue: [0] ifFalse: [self basicSize].
	class _instancesHavePointers ifTrue: [
		1 to: ivars + class instSize do: [:index | | ivar c |
			ivar := self basicInstVarAt: index.
			ivar _isSmallInteger ifFalse: [
				c := self shallowCopy: ivar.
				copy basicInstVarAt: index put: c]]].
	^copy
]

{ #category : #actions }
GCSpace >> dispenseReservedSpace [
	softLimit := commitedLimit
]

{ #category : #accessing }
GCSpace >> finalize [
	Smalltalk os free: base.
]

{ #category : #accessing }
GCSpace >> histogram [
	| sizes |
	sizes := Dictionary new.
	^self histogramInto: sizes
]

{ #category : #accessing }
GCSpace >> histogramInto: sizes [
	self objectsDo: [:object | | size association |
		size := object _sizeInBytes.
		association := sizes associationAt: object class ifAbsent: nil.
		association
			ifNil: [sizes at: object class put: size]
			ifNotNil: [association value: association value + size]].
	^sizes
]

{ #category : #testing }
GCSpace >> includes: anObject [
	^anObject _isSmallInteger not
		and: [anObject _asPointer between: base and: commitedLimit]
]

{ #category : #initialization }
GCSpace >> initialize [
	self initializeMutex
]

{ #category : #initialization }
GCSpace >> initializeMutex [
	mutex := #[16rFF 16rFF 16rFF 16rFF] shallowCopy
]

{ #category : #testing }
GCSpace >> isReferredBy: object [
	| max |
	object _isSmallInteger ifTrue: [^false].
	max := object _isBytes ifTrue: [0] ifFalse: [object _size].
	0 to: max do: [:i | | slot |
		slot := object _basicAt: i.
		(slot _isSmallInteger not and: [self includes: slot]) ifTrue: [^true]].
	^false
]

{ #category : #actions }
GCSpace >> leaveDispenseSpace [
	self leaveDispenseSpace: 4096
]

{ #category : #actions }
GCSpace >> leaveDispenseSpace: anInteger [
	self softLimit: self commitedLimit - anInteger
]

{ #category : #actions }
GCSpace >> lock [
	mutex _busyWait
]

{ #category : #actions }
GCSpace >> lockedAllocateIfPossible: size [
	| answer next |
	answer := nextFree.
	next := answer + size _asPointer.
	next > softLimit ifTrue: [^nil].
	nextFree := next.
	^answer
]

{ #category : #actions }
GCSpace >> lockedAllocateUnsafe: size [
	| answer |
	answer := nextFree.
	nextFree := nextFree + size _asPointer.
	nextFree >= commitedLimit ifTrue: [self commitMoreMemory].
	^answer
]

{ #category : #enumeration }
GCSpace >> make: anObject become: anotherObject [
	"
	should use objectsDo:, but using blocks creates
	new blockclosures, so we can't use blocks here
	"
	| objectBase object endOop |
	objectBase := base.
	endOop := nextFree.
	[objectBase < endOop] whileTrue: [
		object := objectBase _objectFromBasePointer.
		objectBase := object _nextBasePointer.
		object behavior == anObject ifTrue: [object behavior: anotherObject].
		1 to: object _pointersSize do: [:i | 
			(object _basicAt: i) == anObject
				ifTrue: [object objectAtValid: i put: anotherObject]]]
]

{ #category : #enumeration }
GCSpace >> markedDo: aBlock [
	self
		objectsDo: [:object | object _hasBeenSeen ifTrue: [aBlock value: object]]
]

{ #category : #actions }
GCSpace >> newExtendedArray: size [
	^self shallowCopy: #() growingTo: size
]

{ #category : #accessing }
GCSpace >> nextFree [
	^nextFree
]

{ #category : #accessing }
GCSpace >> nextFree: anInteger [
	nextFree := anInteger
]

{ #category : #enumeration }
GCSpace >> objectsDo: aBlock [
	| objectBase object endOop |
	objectBase := base.
	endOop := nextFree.
	[objectBase < endOop] whileTrue: [
		object := objectBase _objectFromBasePointer.
		objectBase := object _nextBasePointer.
		aBlock value: object]
]

{ #category : #accessing }
GCSpace >> percentageOfCommitedUsed [
	^self used * 100 // self commitedSize
]

{ #category : #accessing }
GCSpace >> percentageOfReservedUsed [
	^self used * 100 // self reservedSize
]

{ #category : #accessing }
GCSpace >> prevBase [
	^prevBase
]

{ #category : #accessing }
GCSpace >> prevBase: anInteger [
	prevBase := anInteger
]

{ #category : #actions }
GCSpace >> printOn: stream [
	| commited reserved used |
	commited := (self commitedSize * 2 // 1024) printString , ' kb'.
	reserved := (self reservedSize * 2 // 1024) printString , ' kb reserved'.
	used := self percentageOfReservedUsed printString , '% used'.
	stream nextPutAll: '[ ' , commited , ' (' , reserved , ') ' , used , ' ]'
]

{ #category : #actions }
GCSpace >> release [
	mutex _release
]

{ #category : #accessing }
GCSpace >> reservedLimit [
	^reservedLimit
]

{ #category : #accessing }
GCSpace >> reservedLimit: anInteger [
	reservedLimit := anInteger
]

{ #category : #accessing }
GCSpace >> reservedSize [
	^reservedLimit - base
]

{ #category : #actions }
GCSpace >> reset [
	nextFree := base
]

{ #category : #actions }
GCSpace >> shallowCopy: object [
	| size extra allocation oop copy |
	size := object _sizeInBytes.
	extra := object _headerSizeInBytes.
	allocation := self allocateIfPossible: extra + size.
	allocation _isSmallInteger ifFalse: [^0].
	oop := allocation + extra _asPointer.
	copy := oop _asObject.
	copy
		_copyHeaderSized: extra from: object;
		_replaceFrom: 1 to: (size bitShift: 0 - WordSizeShift) with: object;
		_beNotRemembered.
	^copy
]

{ #category : #actions }
GCSpace >> shallowCopy: array growingTo: newSize [
	| headerSize total buffer copy |
	headerSize := 16.
	total := headerSize + (newSize * WordSize).
	buffer := self allocateUnsafe: total.
	copy := (buffer + headerSize _asPointer) _asObject.
	copy _copyBasicHeaderFrom: array; _makeExtendedSize: newSize.
	1
		to: array _size
		do: [:index | copy _basicAt: index put: (array _basicAt: index)].
	array _size + 1 to: newSize do: [:i | copy _basicAt: i put: nil].
	copy _beNotRemembered; _beUnseen.
	^copy
]

{ #category : #accessing }
GCSpace >> size [
	^reservedLimit - base
]

{ #category : #accessing }
GCSpace >> softAvailable [
	^softLimit - nextFree
]

{ #category : #accessing }
GCSpace >> softLimit [
	^softLimit
]

{ #category : #accessing }
GCSpace >> softLimit: ptr [
	softLimit := ptr
]

{ #category : #enumeration }
GCSpace >> unmarkAll [
	self objectsDo: [:object | object _beUnseen]
]

{ #category : #enumeration }
GCSpace >> unmarkedDo: aBlock [
	self
		objectsDo: [:object | object _hasBeenSeen ifFalse: [aBlock value: object]]
]

{ #category : #accessing }
GCSpace >> used [
	^nextFree - base
]

{ #category : #accessing }
GCSpace >> usedBytes [
	^nextFree - base * 2
]

{ #category : #accessing }
GCSpace >> usedBytes: used [
	nextFree := base + (used / 2)
]

{ #category : #actions }
GCSpace >> wipeOut [
	base _asObject _zeroSlots: (self used bitShift: 0 - WordSizeShift + 1)
]

