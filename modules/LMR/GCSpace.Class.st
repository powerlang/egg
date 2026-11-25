'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #GCSpace category: #Kernel!
Object subclass: #GCSpace
	instanceVariableNames: 'base nextFree softLimit commitedLimit reservedLimit prevBase memory name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!GCSpace commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!GCSpace methodsFor:  'enumeration' stamp: 'KenD 28/Jun/2026 13:27:39'!
addInstancesOf: aSpecies into: result
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
! !

!GCSpace methodsFor:  'enumeration' stamp: 'KenD 28/Jun/2026 13:27:39'!
addMarkedInstancesOf: aSpecies into: result
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
! !

!GCSpace methodsFor:  'enumeration' stamp: 'KenD 28/Jun/2026 13:27:39'!
addMarkedReferencesTo: anObject into: aCollection
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
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
address: address size: size
	| p |
	p := address // 2.
	^self
		base: p;
		reservedLimit: p + (size // 2)
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocateCommittingIfNeeded: size
	| answer |
	"	mutex _busyWait."
	answer := self lockedAllocateCommittingIfNeeded: size.
	"	mutex _release."
	^answer
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocateIfPossible: size
	| answer |
	"	mutex _busyWait."
	answer := self lockedAllocateIfPossible: size.
	"	mutex _release."
	^answer
! !

!GCSpace methodsFor:  'asserting' stamp: 'KenD 28/Jun/2026 13:27:39'!
assert: aBoolean
	aBoolean ifFalse: [self _halt]
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
available
	^softLimit - nextFree
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
availableBytes
	^self available * 2
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
base
	^base
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
base: baseAddress
	base := baseAddress.
	nextFree ifNil: [nextFree := base].
	softLimit ifNil: [softLimit := base].
	commitedLimit ifNil: [commitedLimit := base]
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
commit: bytes
	| newLimit result |
	newLimit := commitedLimit + bytes _asPointer.
	result := self commitSized: newLimit - base.
	result == base
		ifFalse: [self _error: 'GC space could not commit as requested'].
	softLimit := nextFree max: newLimit - 16r4000 _asPointer.
	commitedLimit := newLimit
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
commitAtLeast: bytes
	| padding size |
	padding := 16r8000.
	size := bytes + padding - 1 bitAnd: 0 - padding.
	self commit: size
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
commitedBytes
	^commitedLimit - base * 2
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
commitedLimit
	^commitedLimit
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
commitedLimit: anInteger
	commitedLimit := anInteger.
	reservedLimit isNil ifTrue: [reservedLimit := anInteger].
	softLimit isNil ifTrue: [softLimit := anInteger]
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
commitedSize
	^commitedLimit - base
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
commitMoreMemory: anInteger
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
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
commitSized: size
	| result |
	size = 0 ifTrue: [^base].
	result := Kernel os commit: size * 2 at: base * 2.
	result = 0 ifTrue: [Kernel os lastError].
	^result // 2
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
copyFrom: space
	softLimit := space softLimit.
	base := space base.
	commitedLimit := space commitedLimit.
	reservedLimit := space reservedLimit.
	nextFree := space nextFree.
	memory := space memory
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
dataBase
	^base * 2
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
dataBase: address size: anInteger
	| p |
	p := address // 2.
	self
		base: p;
		commitedLimit: p + (anInteger // 2);
		nextFree: self commitedLimit
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
dataSize
	^reservedLimit - base * 2
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
decommitIfPossible: anInteger
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
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
dispenseReservedSpace
	softLimit := commitedLimit
! !

!GCSpace methodsFor:  'finalization' stamp: 'KenD 28/Jun/2026 13:27:39'!
finalize
	Kernel os release: base
! !

!GCSpace methodsFor:  'enumeration' stamp: 'KenD 28/Jun/2026 13:27:39'!
firstObject
	^base _objectFromBasePointer
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
histogram
	| sizes |
	sizes := Dictionary new.
	^self histogramInto: sizes
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
histogramInto: sizes
	self objectsDo: [:object | | size association |
		size := object _bodySizeInBytes.
		association := sizes associationAt: object class ifAbsent: nil.
		association
			ifNil: [sizes at: object class put: size]
			ifNotNil: [association value: association value + size]].
	^sizes
! !

!GCSpace methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
includes: anObject
	^anObject _isSmallInteger not
		and: [anObject _asPointer between: base and: commitedLimit]
! !

!GCSpace methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
includesAddress: anInteger
	^anInteger between: base and: commitedLimit
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
increaseSoftLimit: anInteger
	| available |
	available := commitedLimit - softLimit.
	available <= 0x8000 _asPointer ifTrue: [^false].
	softLimit := softLimit + (anInteger min: available - 0x4000 _asPointer).
	^true
! !

!GCSpace methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isReferredBy: object
	| max |
	object _isSmallInteger ifTrue: [^false].
	max := object _isBytes ifTrue: [0] ifFalse: [object _size].
	0 to: max do: [:i | | slot |
		slot := object _basicAt: i.
		(slot _isSmallInteger not and: [self includes: slot]) ifTrue: [^true]].
	^false
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
leaveDispenseSpace: anInteger
	softLimit := commitedLimit - anInteger.
	softLimit >= nextFree
		ifFalse: [self _error: 'GC space was asked for too much dispensed space']
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
lockedAllocateCommittingIfNeeded: size
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
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
lockedAllocateIfPossible: size
	| answer next |
	answer := nextFree.
	next := answer + size _asPointer.
	next > softLimit ifTrue: [^nil].
	nextFree := next.
	^answer
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
make: anObject become: anotherObject
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
! !

!GCSpace methodsFor:  'enumeration' stamp: 'KenD 28/Jun/2026 13:27:39'!
markedDo: aBlock
	self
		objectsDo: [:object | object _hasBeenSeen ifTrue: [aBlock value: object]]
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
memory
	^memory
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
memory: aMemory
	memory := aMemory
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
name
	^name
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
name: aString
	name := aString
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextFree
	^nextFree
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
nextFree: anInteger
	nextFree := anInteger
! !

!GCSpace methodsFor:  'enumeration' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectsDo: aBlock
	| objectBase object endOop |
	objectBase := base.
	endOop := nextFree.
	[objectBase < endOop] whileTrue: [
		object := objectBase _objectFromBasePointer.
		objectBase := object _nextBasePointer.
		aBlock value: object]
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
percentageOfCommitedUsed
	^self used * 100 // self commitedSize
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
percentageOfReservedUsed
	^self used * 100 // self reservedSize
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
prevBase
	^prevBase
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
prevBase: address
	prevBase := address
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
prevOffset
	^base - prevBase
! !

!GCSpace methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: stream
	| commited reserved used |
	commited := (self commitedSize * 2 // 1024) printString , ' kb'.
	reserved := (self reservedSize * 2 // 1024) printString , ' kb reserved'.
	used := self percentageOfReservedUsed printString , '% used'.
	name printOn: stream.
	stream nextPutAll: ' [ ' , commited , ' (' , reserved , ') ' , used , ' ]'
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
relocate: offset
	prevBase := base.
	base := base + offset.
	commitedLimit := commitedLimit + offset.
	nextFree := nextFree + offset.
	reservedLimit := reservedLimit + offset.
	softLimit := softLimit + offset
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
relocatingSetUp
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
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
reservedBytes
	^reservedLimit - base * 2
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
reservedLimit
	^reservedLimit
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
reservedLimit: anInteger
	reservedLimit := anInteger
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
reservedSize
	^reservedLimit - base
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
reset
	nextFree := base
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
resetSoftLimit: anInteger
	softLimit := nextFree + anInteger min: commitedLimit
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
shallowCopy: object
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
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
shallowCopyCommiting: object
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
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
size
	^reservedLimit - base
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
softAvailable
	^softLimit - nextFree
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
softLimit
	^softLimit
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
softLimit: ptr
	softLimit := ptr
! !

!GCSpace methodsFor:  'enumeration' stamp: 'KenD 28/Jun/2026 13:27:39'!
unmarkAll
	self objectsDo: [:object | object _beUnseen]
! !

!GCSpace methodsFor:  'enumeration' stamp: 'KenD 28/Jun/2026 13:27:39'!
unmarkedDo: aBlock
	self
		objectsDo: [:object | object _hasBeenSeen ifFalse: [aBlock value: object]]
! !

!GCSpace methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
used
	^nextFree - base
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
usedBytes
	^nextFree - base * 2
! !

!GCSpace methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
usedBytes: used
	nextFree := base + (used / 2)
! !

!GCSpace methodsFor:  'actions' stamp: 'KenD 28/Jun/2026 13:27:39'!
wipeOut
	base _asObject _zeroSlots: (self used bitShift: 0 - WordSizeShift + 1)
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'GCSpace class' category: #Kernel!
GCSpace class
	instanceVariableNames: ''!

!GCSpace class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
copyFrom: aGCSpace
	^self new copyFrom: aGCSpace
! !


