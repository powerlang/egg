"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #AllocationZone,
	#superclass : #Object,
	#instVars : [
		'memory',
		'base',
		'nextFree',
		'limit',
		'spaces',
		'current',
		'next',
		'emptySpaces',
		'occupancy',
		'spaceSize',
		'spaceSizeShift'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
AllocationZone class >> new [
	^super new initialize
]

{ #category : #services }
AllocationZone >> allocate: size [
	| oop |
	oop := self allocateIfPossible: size.
	oop _isSmallInteger ifTrue: [^oop].
	self _error: 'Out of memory in old space'
]

{ #category : #services }
AllocationZone >> allocateIfPossible: size [
	| oop |
	oop := current allocateIfPossible: size.
	oop _isSmallInteger ifTrue: [^oop].
	self bumpSpace.
	^current allocateIfPossible: size
]

{ #category : #services }
AllocationZone >> assureFree: anInteger [
	current availableBytes < anInteger ifTrue: [self bumpSpace]
]

{ #category : #inquiries }
AllocationZone >> availableBytes [
	^self usableBytes - self commitedBytes
]

{ #category : #accessing }
AllocationZone >> base [
	^base
]

{ #category : #accessing }
AllocationZone >> base: anInteger [
	base := anInteger.
	nextFree := anInteger
]

{ #category : #private }
AllocationZone >> build [
	| max |
	max := self indexOfPointer: limit - 1.
	occupancy := Array new: max withAll: 0.
	spaces := CriticalArray new usePinnedAllocation; growTo: 1000.
	emptySpaces := CriticalArray new usePinnedAllocation; growTo: 20.
	self bumpSpace; bumpSpace
]

{ #category : #private }
AllocationZone >> bumpSpace [
	"
	We first assign a new space, so that we don't get out of memory,
	then we assure leaving another empty one for the next call
	"
	current := next.
	emptySpaces isEmpty ifTrue: [self createEmptySpace].
	next := emptySpaces pop.
	next commit: next reservedSize * 2.
	self markAsFull: next.
	^next
]

{ #category : #inquiries }
AllocationZone >> commitedBytes [
	^spaces sum: [:s | s commitedBytes]
]

{ #category : #private }
AllocationZone >> createEmptySpace [
	| start s end |
	nextFree == limit ifTrue: [self _error: 'Out of space in old zone'].
	start := nextFree.
	end := nextFree + spaceSize.
	nextFree := end + spaceSize.
	s := memory newSpace
		base: start;
		reservedLimit: end;
		name: 'Old'.
	spaces add: s.
	emptySpaces add: s.
	memory addSpace: s.
	^s
]

{ #category : #accessing }
AllocationZone >> currentSpace [
	^current
]

{ #category : #inquiries }
AllocationZone >> indexOfPointer: anInteger [
	^(anInteger - base _bitShiftRight: spaceSizeShift) + 1
]

{ #category : #private }
AllocationZone >> indexOfSpace: aGCSpace [
	^self indexOfPointer: aGCSpace base
]

{ #category : #initialization }
AllocationZone >> initialize [
	spaceSize := 256 kbytes // 2.
	spaceSizeShift := spaceSize highBit
]

{ #category : #accessing }
AllocationZone >> limit [
	^limit
]

{ #category : #accessing }
AllocationZone >> limit: anInteger [
	limit := anInteger
]

{ #category : #private }
AllocationZone >> markAsFull: aGCSpace [
	"
	We mark spaces as fully occupied so that
	the GC doesn't see them as ready to be freed.
	"
	| index |
	index := self indexOfSpace: aGCSpace.
	occupancy at: index put: spaceSize * 2
]

{ #category : #services }
AllocationZone >> markedDo: aBlock [
	spaces do: [:s | s markedDo: aBlock]
]

{ #category : #accessing }
AllocationZone >> memory: aMemory [
	memory := aMemory
]

{ #category : #services }
AllocationZone >> objectsDo: aBlock [
	spaces do: [:s | s objectsDo: aBlock]
]

{ #category : #accessing }
AllocationZone >> occupancy [
	^occupancy
]

{ #category : #inquiries }
AllocationZone >> occupiedBytes [
	^occupancy sum
]

{ #category : #private }
AllocationZone >> recycleSpace: aGCSpace [
	emptySpaces add: aGCSpace
]

{ #category : #private }
AllocationZone >> regionCount [
	^self indexOfPointer: nextFree - 1
]

{ #category : #inquiries }
AllocationZone >> regionIndexOf: object [
	| pointer |
	pointer := object _asPointer.
	pointer < base ifTrue: [^nil].
	pointer >= limit ifTrue: [^nil].
	^self indexOfPointer: pointer
]

{ #category : #accessing }
AllocationZone >> regionSize [
	^spaceSize
]

{ #category : #private }
AllocationZone >> releaseEvacuated: evacuated [
	1 to: spaces size do: [:i | | space used recycle base size |
		space := spaces at: i.
		used := occupancy at: i.
		recycle := (evacuated at: i) > 0
			or: [used == 0 and: [space commitedSize > 0]].
		recycle ifTrue: [
			base := space base.
			size := space reservedSize.
			space
				nextFree: base;
				commitedLimit: base;
				softLimit: base.
			Kernel os decommit: base * 2 size: size * 2 * 2.
			self recycleSpace: space]]
]

{ #category : #services }
AllocationZone >> relocate: anInteger [
	base := base + anInteger.
	nextFree := nextFree + anInteger.
	limit := limit + anInteger
]

{ #category : #inquiries }
AllocationZone >> reservedBytes [
	^limit - base * 2
]

{ #category : #private }
AllocationZone >> resetOccupancy [
	occupancy atAllPut: 0.
	self markAsFull: current; markAsFull: next
]

{ #category : #services }
AllocationZone >> shallowCopyCommiting: object [
	| copy size space |
	copy := current shallowCopyCommiting: object.
	copy == nil ifFalse: [^copy].
	size := object _sizeInBytes.
	size > Memory largeThreshold ifTrue: [
		space := memory createLargeSpace: size.
		^space shallowCopyCommiting: object].
	self bumpSpace.
	^current shallowCopyCommiting: object
]

{ #category : #inquiries }
AllocationZone >> size [
	^limit - base
]

{ #category : #accessing }
AllocationZone >> spaces [
	^spaces
]

{ #category : #services }
AllocationZone >> unmarkedDo: aBlock [
	spaces do: [:s | s unmarkedDo: aBlock]
]

{ #category : #updating }
AllocationZone >> updateRegionOccupancy: object [
	| index bytes |
	index := self regionIndexOf: object.
	index ifNil: [^self].
	bytes := occupancy at: index.
	occupancy at: index put: bytes + object _sizeInBytes
]

{ #category : #inquiries }
AllocationZone >> usableBytes [
	"
	half of each reserved area is held for evacuation purposes only and not directly usable
	"
	^self reservedBytes // 2
]

{ #category : #inquiries }
AllocationZone >> usedBytes [
	| count |
	count := 0.
	spaces do: [:s | count := count + s usedBytes].
	^count
]

