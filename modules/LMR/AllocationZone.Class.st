'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #AllocationZone category: #Kernel!
Object subclass: #AllocationZone
	instanceVariableNames: 'memory base nextFree limit spaces current next emptySpaces occupancy spaceSize spaceSizeShift'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!AllocationZone commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!AllocationZone methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocate: size
	| oop |
	oop := self allocateIfPossible: size.
	oop _isSmallInteger ifTrue: [^oop].
	self _error: 'Out of memory in old space'
! !

!AllocationZone methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocateIfPossible: size
	| oop |
	oop := current allocateIfPossible: size.
	oop _isSmallInteger ifTrue: [^oop].
	self bumpSpace.
	^current allocateIfPossible: size
! !

!AllocationZone methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
assureFree: anInteger
	current availableBytes < anInteger ifTrue: [self bumpSpace]
! !

!AllocationZone methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
availableBytes
	^self usableBytes - self commitedBytes
! !

!AllocationZone methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
base
	^base
! !

!AllocationZone methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
base: anInteger
	base := anInteger.
	nextFree := anInteger
! !

!AllocationZone methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
build
	| max |
	max := self indexOfPointer: limit - 1.
	occupancy := Array new: max withAll: 0.
	spaces := CriticalArray new usePinnedAllocation; growTo: 1000.
	emptySpaces := CriticalArray new usePinnedAllocation; growTo: 20.
	self bumpSpace; bumpSpace
! !

!AllocationZone methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
bumpSpace
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
! !

!AllocationZone methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
commitedBytes
	^spaces sum: [:s | s commitedBytes]
! !

!AllocationZone methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
createEmptySpace
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
! !

!AllocationZone methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
currentSpace
	^current
! !

!AllocationZone methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
indexOfPointer: anInteger
	^(anInteger - base _bitShiftRight: spaceSizeShift) + 1
! !

!AllocationZone methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
indexOfSpace: aGCSpace
	^self indexOfPointer: aGCSpace base
! !

!AllocationZone methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	spaceSize := 256 kbytes // 2.
	spaceSizeShift := spaceSize highBit
! !

!AllocationZone methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
limit
	^limit
! !

!AllocationZone methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
limit: anInteger
	limit := anInteger
! !

!AllocationZone methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
markAsFull: aGCSpace
	"
	We mark spaces as fully occupied so that
	the GC doesn't see them as ready to be freed.
	"
	| index |
	index := self indexOfSpace: aGCSpace.
	occupancy at: index put: spaceSize * 2
! !

!AllocationZone methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
markedDo: aBlock
	spaces do: [:s | s markedDo: aBlock]
! !

!AllocationZone methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
memory: aMemory
	memory := aMemory
! !

!AllocationZone methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectsDo: aBlock
	spaces do: [:s | s objectsDo: aBlock]
! !

!AllocationZone methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
occupancy
	^occupancy
! !

!AllocationZone methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
occupiedBytes
	^occupancy sum
! !

!AllocationZone methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
recycleSpace: aGCSpace
	emptySpaces add: aGCSpace
! !

!AllocationZone methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
regionCount
	^self indexOfPointer: nextFree - 1
! !

!AllocationZone methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
regionIndexOf: object
	| pointer |
	pointer := object _asPointer.
	pointer < base ifTrue: [^nil].
	pointer >= limit ifTrue: [^nil].
	^self indexOfPointer: pointer
! !

!AllocationZone methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
regionSize
	^spaceSize
! !

!AllocationZone methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
releaseEvacuated: evacuated
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
! !

!AllocationZone methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
relocate: anInteger
	base := base + anInteger.
	nextFree := nextFree + anInteger.
	limit := limit + anInteger
! !

!AllocationZone methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
reservedBytes
	^limit - base * 2
! !

!AllocationZone methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
resetOccupancy
	occupancy atAllPut: 0.
	self markAsFull: current; markAsFull: next
! !

!AllocationZone methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
shallowCopyCommiting: object
	| copy size space |
	copy := current shallowCopyCommiting: object.
	copy == nil ifFalse: [^copy].
	size := object _sizeInBytes.
	size > Memory largeThreshold ifTrue: [
		space := memory createLargeSpace: size.
		^space shallowCopyCommiting: object].
	self bumpSpace.
	^current shallowCopyCommiting: object
! !

!AllocationZone methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
size
	^limit - base
! !

!AllocationZone methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
spaces
	^spaces
! !

!AllocationZone methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
unmarkedDo: aBlock
	spaces do: [:s | s unmarkedDo: aBlock]
! !

!AllocationZone methodsFor:  'updating' stamp: 'KenD 28/Jun/2026 13:27:39'!
updateRegionOccupancy: object
	| index bytes |
	index := self regionIndexOf: object.
	index ifNil: [^self].
	bytes := occupancy at: index.
	occupancy at: index put: bytes + object _sizeInBytes
! !

!AllocationZone methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
usableBytes
	"
	half of each reserved area is held for evacuation purposes only and not directly usable
	"
	^self reservedBytes // 2
! !

!AllocationZone methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
usedBytes
	| count |
	count := 0.
	spaces do: [:s | count := count + s usedBytes].
	^count
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AllocationZone class' category: #Kernel!
AllocationZone class
	instanceVariableNames: ''!

!AllocationZone class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
new
	^super new initialize
! !


AllocationZone initialize!

