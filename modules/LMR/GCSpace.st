"
	Copyright (c) 2020-2022 Quorum Software.
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
		'memory',
		'name'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
GCSpace class >> copyFrom: aGCSpace [
	^self new copyFrom: aGCSpace
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
GCSpace >> addMarkedReferencesTo: anObject into: aCollection [
	| next object end |
	next := base.
	end := nextFree.
	[next < end] whileTrue: [| index limit |
		object := next _objectFromBasePointer.
		index := 1.
		limit := object _strongPointersSize.
		object _hasBeenSeen ifTrue: [
			[index <= limit] whileTrue: [| ivar |
				ivar := object _basicAt: index.
				ivar == anObject ifTrue: [
					aCollection add: object.
					index := limit].
				index := index + 1]].
		next := object _nextBasePointer]
]

{ #category : #accessing }
GCSpace >> address: address size: size [
	| p |
	p := address // 2.
	^self
		base: p;
		reservedLimit: p + (size // 2)
]

{ #category : #actions }
GCSpace >> allocateCommittingIfNeeded: size [
	| answer |
	"	mutex _busyWait."
	answer := self lockedAllocateCommittingIfNeeded: size.
	"	mutex _release."
	^answer
]

{ #category : #actions }
GCSpace >> allocateIfPossible: size [
	| answer |
	"	mutex _busyWait."
	answer := self lockedAllocateIfPossible: size.
	"	mutex _release."
	^answer
]

{ #category : #asserting }
GCSpace >> assert: aBoolean [
	aBoolean ifFalse: [self _halt]
]

{ #category : #inquiries }
GCSpace >> available [
	^softLimit - nextFree
]

{ #category : #inquiries }
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
	nextFree ifNil: [nextFree := base].
	softLimit ifNil: [softLimit := base].
	commitedLimit ifNil: [commitedLimit := base]
]

{ #category : #actions }
GCSpace >> commit: bytes [
	| newLimit result |
	newLimit := commitedLimit + bytes _asPointer.
	result := self commitSized: newLimit - base.
	result == base
		ifFalse: [self _error: 'GC space could not commit as requested'].
	softLimit := nextFree max: newLimit - 16r4000 _asPointer.
	commitedLimit := newLimit
]

{ #category : #actions }
GCSpace >> commitAtLeast: bytes [
	| padding size |
	padding := 16r8000.
	size := bytes + padding - 1 bitAnd: 0 - padding.
	self commit: size
]

{ #category : #inquiries }
GCSpace >> commitedBytes [
	^commitedLimit - base * 2
]

{ #category : #accessing }
GCSpace >> commitedLimit [
	^commitedLimit
]

{ #category : #accessing }
GCSpace >> commitedLimit: anInteger [
	commitedLimit := anInteger.
	reservedLimit isNil ifTrue: [reservedLimit := anInteger].
	softLimit isNil ifTrue: [softLimit := anInteger]
]

{ #category : #inquiries }
GCSpace >> commitedSize [
	^commitedLimit - base
]

{ #category : #actions }
GCSpace >> commitMoreMemory: anInteger [
	"
	This method may temporarily switch allocation space to old, which
	is guaranteed to have dispense space. This is needed to assure
	there is space for the extra objects allocated by the commit ffi call.
	"
	| new padded old critical original |
	new := anInteger + 16r8000 _asPointer.
	new >= reservedLimit ifTrue: [^self].
	critical := CRITICAL.
	CRITICAL := true.
	padded := new bitAnd: -16r1000 _asPointer.
	original := memory allocator.
	original available < 16r1000 _asPointer ifTrue: [
		old := memory old.
		self == old ifTrue: [self dispenseReservedSpace].
		memory allocator: old].
	(self commitSized: padded - base) == base
		ifFalse: [self _error: 'GC space could not commit as requested'].
	softLimit := padded - 16r4000 _asPointer.
	commitedLimit := padded.
	memory allocator: original.
	CRITICAL := critical
]

{ #category : #actions }
GCSpace >> commitSized: size [
	| result |
	size = 0 ifTrue: [^base].
	result := Kernel os commit: size * 2 at: base * 2.
	result = 0 ifTrue: [Kernel os lastError].
	^result // 2
]

{ #category : #actions }
GCSpace >> copyFrom: space [
	softLimit := space softLimit.
	base := space base.
	commitedLimit := space commitedLimit.
	reservedLimit := space reservedLimit.
	nextFree := space nextFree.
	memory := space memory
]

{ #category : #inquiries }
GCSpace >> dataBase [
	^base * 2
]

{ #category : #accessing }
GCSpace >> dataBase: address size: anInteger [
	| p |
	p := address // 2.
	self
		base: p;
		commitedLimit: p + (anInteger // 2);
		nextFree: self commitedLimit
]

{ #category : #inquiries }
GCSpace >> dataSize [
	^reservedLimit - base * 2
]

{ #category : #actions }
GCSpace >> decommitIfPossible: anInteger [
	| delta dispense limit min newsoft |
	delta := anInteger bitAnd: -0x1000 _asPointer.
	dispense := 64 kbytes.
	limit := commitedLimit - delta.
	min := base + 2 mbytes _asPointer.
	commitedLimit <= min ifTrue: [^self].
	limit := limit max: min.
	newsoft := limit - dispense.
	newsoft < nextFree ifTrue: [^self].
	Kernel os decommit: limit * 2 size: delta * 2.
	softLimit := newsoft.
	commitedLimit := limit
]

{ #category : #actions }
GCSpace >> dispenseReservedSpace [
	softLimit := commitedLimit
]

{ #category : #finalization }
GCSpace >> finalize [
	Kernel os release: base
]

{ #category : #enumeration }
GCSpace >> firstObject [
	^base _objectFromBasePointer
]

{ #category : #inquiries }
GCSpace >> histogram [
	| sizes |
	sizes := Dictionary new.
	^self histogramInto: sizes
]

{ #category : #inquiries }
GCSpace >> histogramInto: sizes [
	self objectsDo: [:object | | size association |
		size := object _bodySizeInBytes.
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

{ #category : #testing }
GCSpace >> includesAddress: anInteger [
	^anInteger between: base and: commitedLimit
]

{ #category : #actions }
GCSpace >> increaseSoftLimit: anInteger [
	| available |
	available := commitedLimit - softLimit.
	available <= 0x8000 _asPointer ifTrue: [^false].
	softLimit := softLimit + (anInteger min: available - 0x4000 _asPointer).
	^true
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
GCSpace >> leaveDispenseSpace: anInteger [
	softLimit := commitedLimit - anInteger.
	softLimit >= nextFree
		ifFalse: [self _error: 'GC space was asked for too much dispensed space']
]

{ #category : #actions }
GCSpace >> lockedAllocateCommittingIfNeeded: size [
	"
	take into account that committing more memory could cause
	 allocation, so after doing it we recalculate our answer
	"
	| answer next |
	answer := nextFree.
	next := answer + size _asPointer.
	next <= softLimit ifTrue: [
		nextFree := next.
		^answer].
	self commitMoreMemory: next.
	answer := nextFree.
	next := answer + size _asPointer.
	^next <= softLimit
		ifTrue: [
			nextFree := next.
			answer]
		ifFalse: [nil]
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

{ #category : #accessing }
GCSpace >> memory [
	^memory
]

{ #category : #accessing }
GCSpace >> memory: aMemory [
	memory := aMemory
]

{ #category : #accessing }
GCSpace >> name [
	^name
]

{ #category : #accessing }
GCSpace >> name: aString [
	name := aString
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

{ #category : #inquiries }
GCSpace >> percentageOfCommitedUsed [
	^self used * 100 // self commitedSize
]

{ #category : #inquiries }
GCSpace >> percentageOfReservedUsed [
	^self used * 100 // self reservedSize
]

{ #category : #accessing }
GCSpace >> prevBase [
	^prevBase
]

{ #category : #accessing }
GCSpace >> prevBase: address [
	prevBase := address
]

{ #category : #inquiries }
GCSpace >> prevOffset [
	^base - prevBase
]

{ #category : #printing }
GCSpace >> printOn: stream [
	| commited reserved used |
	commited := (self commitedSize * 2 // 1024) printString , ' kb'.
	reserved := (self reservedSize * 2 // 1024) printString , ' kb reserved'.
	used := self percentageOfReservedUsed printString , '% used'.
	name printOn: stream.
	stream nextPutAll: ' [ ' , commited , ' (' , reserved , ') ' , used , ' ]'
]

{ #category : #actions }
GCSpace >> relocate: offset [
	prevBase := base.
	base := base + offset.
	commitedLimit := commitedLimit + offset.
	nextFree := nextFree + offset.
	reservedLimit := reservedLimit + offset.
	softLimit := softLimit + offset
]

{ #category : #actions }
GCSpace >> relocatingSetUp [
	| reserved committed address offset limit |
	reserved := reservedLimit - base * 2.
	committed := commitedLimit - base * 2.
	prevBase := base.
	address := Kernel os reserve: reserved at: base * 2.
	address = 0 ifTrue: [
		limit := prevBase < 4 gbytes ifTrue: [4 gbytes] ifFalse: [1 << 64].
		address := Kernel os reserve: reserved near: prevBase limit: limit.
		address = 0 ifTrue: [Kernel os lastError]].
	base := address // 2.
	offset := base - prevBase.
	commitedLimit := commitedLimit + offset.
	nextFree := nextFree + offset.
	reservedLimit := reservedLimit + offset.
	softLimit := softLimit + offset.
	address := Kernel os commit: committed at: base * 2.
	address = 0 ifTrue: [Kernel os lastError]
]

{ #category : #inquiries }
GCSpace >> reservedBytes [
	^reservedLimit - base * 2
]

{ #category : #accessing }
GCSpace >> reservedLimit [
	^reservedLimit
]

{ #category : #accessing }
GCSpace >> reservedLimit: anInteger [
	reservedLimit := anInteger
]

{ #category : #inquiries }
GCSpace >> reservedSize [
	^reservedLimit - base
]

{ #category : #actions }
GCSpace >> reset [
	nextFree := base
]

{ #category : #actions }
GCSpace >> resetSoftLimit: anInteger [
	softLimit := nextFree + anInteger min: commitedLimit
]

{ #category : #actions }
GCSpace >> shallowCopy: object [
	| size extra allocation oop copy |
	size := object _bodySizeInBytes.
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
GCSpace >> shallowCopyCommiting: object [
	| size extra allocation oop copy |
	size := object _bodySizeInBytes.
	extra := object _headerSizeInBytes.
	allocation := self allocateCommittingIfNeeded: extra + size.
	allocation _isSmallInteger ifFalse: [^nil].
	oop := allocation + extra _asPointer.
	copy := oop _asObject.
	copy
		_copyHeaderSized: extra from: object;
		_replaceFrom: 1 to: (size bitShift: 0 - WordSizeShift) with: object;
		_beNotRemembered.
	^copy
]

{ #category : #inquiries }
GCSpace >> size [
	^reservedLimit - base
]

{ #category : #inquiries }
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

{ #category : #inquiries }
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

