'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #Memory category: #Kernel!
Object subclass: #Memory
	instanceVariableNames: 'spaces collectedSpaces genCollector pinnedSpace fromSpace toSpace oldZone meter edenSpace youngBase youngLimit rememberedSet inGC fullCollector unreachableEphemerons largeSpaces allocator'
	classVariableNames: 'Current LargeThreshold CRITICAL'
	poolDictionaries: ''
	category: 'Kernel'!
!Memory commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Memory methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addKernelSpace: aSpace
	spaces size: 1.
	spaces contents at: 1 put: aSpace.
	pinnedSpace := aSpace
! !

!Memory methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addKernelSpace: aSpace
	spaces size: 1.
	spaces contents at: 1 put: aSpace.
	pinnedSpace := aSpace
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
addMarkedInstancesOf: aSpecies into: aCollection
	| searched |
	searched := spaces asOrderedCollection.
	searched
		do: [:space | space addMarkedInstancesOf: aSpecies into: aCollection]
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
addMarkedReferencesTo: anObject into: references
	1 to: spaces size do: [:i | | space |
		space := spaces at: i.
		space addMarkedReferencesTo: anObject into: references]
! !

!Memory methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:39'!
addSpace: aSpace
	oldZone ifNotNil: [oldZone assureFree: 1000].
	spaces add: aSpace
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
adjustSpaces
	| stats rate committed limit delta |
	stats := meter runs last.
	rate := stats survivalRate.
	committed := edenSpace commitedSize.
	limit := edenSpace commitedLimit.
	stats youngSize // 2 < (0.8 * committed) ifTrue: [^self].
	rate > 0.08
		ifTrue: [
			delta := committed * (rate * 4 + 1).
			limit := limit + delta asInteger.
			edenSpace commitMoreMemory: limit]
		ifFalse: [
			delta := committed * (0.8 - rate / 2).
			edenSpace decommitIfPossible: delta asInteger].
	edenSpace resetSoftLimit: 256 kbytes _asPointer
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
adjustYoungAreaBy: anInteger
	youngBase := youngBase + anInteger.
	youngLimit := youngLimit + anInteger
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
allDeadObjects
	| collection |
	collection := LinkedCollection new: 10000.
	self
		markedEvaluate: [spaces
			do: [:space | space unmarkedDo: [:object | collection add: object]]].
	^collection
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
allExistingInstancesOf: aSpecies
	| instances marked |
	instances := LinkedCollection new: 1024.
	marked := spaces asOrderedCollection
		remove: edenSpace;
		remove: fromSpace;
		yourself.
	self
		collectYoung;
		critical: [
			marked do: [:s | s addMarkedInstancesOf: aSpecies into: instances].
			fromSpace addInstancesOf: aSpecies into: instances].
	^instances
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
allInstancesOf: aSpecies
	| instances |
	instances := LinkedCollection new: 1024.
	self markedEvaluate: [self addMarkedInstancesOf: aSpecies into: instances].
	^instances
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocate: size
	| oop |
	oop := edenSpace allocateIfPossible: size.
	oop _isSmallInteger ifTrue: [^oop].
	size > LargeThreshold ifTrue: [^self allocateLarge: size].
	^self allocateCommitting: size
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocateCommitting: size
	| oop grew |
	grew := edenSpace increaseSoftLimit: 256 kbytes _asPointer.
	CRITICAL ifFalse: [
		grew
			ifTrue: [self rescueEphemerons]
			ifFalse: [self collectYoung; collectOldIfTime]].
	oop := edenSpace allocateIfPossible: size.
	oop _isSmallInteger ifTrue: [^oop].
	oop := allocator allocateIfPossible: size.
	oop _isSmallInteger ifTrue: [^oop].
	^oldZone allocate: size
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocateLarge: size
	| space oop |
	space := self createLargeSpace: size.
	oop := space allocateIfPossible: size.
	oop _isSmallInteger
		ifFalse: [self
			_error: 'Failed to allocate large space of size ' , size printString].
	^oop
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocator
	^allocator
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocator: anObject
	allocator := anObject
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
allRecyclableByteCount
	| total |
	total := 0.
	self markedEvaluate: [
		spaces
			do: [:space | space
				unmarkedDo: [:object | total := total + object _sizeInBytes]]].
	^total
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
allSubinstancesOf: aSpecies
	| subinstances classes |
	classes := aSpecies withAllSubclasses.
	subinstances := LinkedCollection new: 1024.
	self
		markedEvaluate: [classes
			do: [:cls | self addMarkedInstancesOf: cls into: subinstances]].
	^subinstances
! !

!Memory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
arenaBytes
	^oldZone size + edenSpace size + toSpace size * 2
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
assureFree: size
	edenSpace availableBytes < size ifTrue: [self collectYoung]
! !

!Memory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
available
	^edenSpace availableBytes
! !

!Memory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
baseAddress
	^spaces first dataBase
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
classMortalityHistogram
	| histogram |
	histogram := Dictionary new.
	self markedEvaluate: [
		oldZone
			unmarkedDo: [:object | histogram
				at: object class
				put: 1
				ifPresent: [:count | count + 1]]].
	^histogram
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
collect
	self collectYoung; collectOld
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
collectOld
	self markedEvaluate: []
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
collectOldIfTime
	fullCollector hasReachedCountdown ifTrue: [self collectOld]
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
collectYoung
	"
	This method cannot have a home environment. Else, the environment
	would be created before setting CRITICAL to true, and that may trigger
	a infinite chain of recursive collectYoung sends
	"
	CRITICAL
		ifTrue: [self
			_error: 'Attempted to collect young memory during a critical section'].
	CRITICAL := inGC := true.
	SendSite ensureEnoughFreeCaches: 100.
	self collectYoungMeasuring.
	CRITICAL := inGC := false.
	self adjustSpaces; rescueEphemerons
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
collectYoungMeasuring
	meter
		measure: [[
			self verifyMemory.
			genCollector collect.
			self verifyMemory] evaluateAtomically].
	fullCollector tenured: meter runs last tenured
! !

!Memory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
commitedSize
	^spaces inject: 0 into: [:sum :space | sum + (space commitedSize * 2)]
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
createLargeSpace: size
	"
	We might be in GC, so the new GCSpace created must not be
	placed in the current eden, which is the GC work space. We assure
	that by using instead the current space in the old zone
	"
	| address space limit |
	address := Kernel os reserveAndCommit: size.
	address = 0
		ifTrue: [self
			_error: 'Not enough memory to allocate ' , size printString , ' bytes'].
	space := self newSpace address: address size: size.
	limit := space reservedLimit.
	space
		name: 'Large';
		commitedLimit: limit;
		softLimit: limit.
	self addSpace: space.
	largeSpaces add: space.
	^space
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
createPinnedSpace
	"
	We limit the pinned space to 32 bits so that
	we can use for safely storing behaviors
	"
	| size address |
	size := 4096 + 64 * 1024.
	address := Kernel os reserveAndCommit: size near: 0 limit: 0x100000000.
	pinnedSpace := self newSpace address: address size: size.
	pinnedSpace
		name: 'Pinned Object';
		commitedLimit: pinnedSpace reservedLimit;
		leaveDispenseSpace: 1024.
	self addSpace: pinnedSpace
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
createRememberedSet
	rememberedSet := RememberedSet new initialize: 16 kbytes
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
createSpaces
	| allocation eden |
	allocation := self reserveSpaceSized: 256 * 1024 * 1024 commiting: 0.
	fromSpace := self newSpaceAt: allocation base size: 16 * 1024 * 1024.
	fromSpace name: 'From'.
	toSpace := self newSpaceAt: fromSpace reservedLimit size: 16 * 1024 * 1024.
	toSpace name: 'To'.
	eden := self
		newSpaceAt: toSpace reservedLimit
		limit: allocation reservedLimit.
	eden name: 'Eden'; commit: 4 mbytes.
	youngBase := fromSpace base.
	youngLimit := eden reservedLimit.
	self addSpace: fromSpace; addSpace: eden.
	oldZone := self reserveZoneSized: 12 * 1024 * 1024 * 1024 near: 0x100000000.
	allocator := edenSpace := eden.
	largeSpaces := CriticalArray new usePinnedAllocation; growTo: 1000.
	unreachableEphemerons := CriticalArray new growTo: 1000
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
critical: aBlock
	^[| prev result |
		prev := CRITICAL.
		CRITICAL := true.
		result := aBlock value.
		CRITICAL := prev.
		result] evaluateAtomically
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
debugMode
	^false
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
eden
	^edenSpace
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
eden: aSpace
	allocator := edenSpace := aSpace
! !

!Memory methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:39'!
edenCollector
	^genCollector
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
from
	^fromSpace
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
fromSpace: aSpace
	fromSpace := aSpace
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
fullClassMortalityHistogram
	| histogram |
	histogram := Dictionary new.
	self markedEvaluate: [
		spaces do: [:space | 
			space
				unmarkedDo: [:object | histogram
					at: object class
					put: 1
					ifPresent: [:count | count + 1]]]].
	^histogram
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
garbageCollectTest2
	| space broken |
	space := GCSpace copyFrom: fromSpace.
	space nextFree: space softLimit.
	broken := self collectYoung; objectsReferencing: space.
	broken size > 0 ifTrue: [broken halt]
! !

!Memory methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasMarkedReferencesTo: aGCSpace in: aCollection
	aCollection do: [:space | 
		space markedDo: [:object | 
			(aGCSpace includesAddress: object behavior) ifTrue: [^true].
			1 to: object _pointersSize do: [:index | | reference |
				reference := object _basicAt: index.
				(aGCSpace includesAddress: reference) ifTrue: [^true]]]].
	^false
! !

!Memory methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasReferencesToSpace: aGCSpace
	| searched |
	searched := spaces copyWithout: aGCSpace.
	^self markedEvaluate: [self hasMarkedReferencesTo: aGCSpace in: searched]
! !

!Memory methodsFor:  'statistics' stamp: 'KenD 28/Jun/2026 13:27:39'!
histogram
	"
	Memory current histogram
	"
	| sizes |
	sizes := Dictionary new: 3000.
	self critical: [| original |
		original := spaces asOrderedCollection collect: #copy.
		original do: [:space | space histogramInto: sizes]].
	^sizes associations asArray sortBy: [:a :b | a value > b value]
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
inGC
	^inGC
! !

!Memory methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	"
	initialization of the spaces array is done manually because
	this code is executed during bootstrap.
	youngLimit is set to a high watermark so that all objects are
	initially considered young. Until the young spaces are created
	and this variable is reset, 	no object will be added to the
	remembered set (specially closures, which are added just in
	case when not young)
	"
	| empty |
	super initialize.
	inGC := false.
	empty := Array new: 1000.
	spaces := CriticalArray new usePinnedAllocation; contents: empty.
	spaces allocator memory: self.
	collectedSpaces := OrderedCollection new.
	youngBase := 0.
	youngLimit := 0xFFFFFFFFFFFFFFF.
	meter := MemoryMeter new memory: self
! !

!Memory methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeCollectors
	| movable |
	movable := EdenCollector on: self.
	genCollector := self kernelSpace shallowCopy: movable.
	self rememberIfNeeded: genCollector.
	movable := GarbageFirstCollector on: self.
	fullCollector := self kernelSpace shallowCopy: movable.
	self rememberIfNeeded: fullCollector
! !

!Memory methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isYoung: anObject
	^false == anObject _isSmallInteger
		and: [anObject _asPointer between: youngBase and: youngLimit]
! !

!Memory methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isYoungSafe: anObject
	^anObject _asPointer between: youngBase and: youngLimit
! !

!Memory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
kernelSpace
	^spaces first
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
largeSpaces
	^largeSpaces
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
make: anObject become: anotherObject
	"
	We cannot create closures here: the become action might be
	applied to the closure elements before finishing and afterwards
	we wouldn't find anObject anymore
	"
	| prev |
	prev := CRITICAL.
	CRITICAL := true.
	1 to: spaces size do: [:i | | space |
		space := spaces at: i.
		space make: anObject become: anotherObject].
	self rememberAfterBecome: anObject.
	Processor activeProcess make: anObject become: anotherObject.
	CRITICAL := prev
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
markedEvaluate: aClosure
	"
	We can leave not-young objects marked, but young ones
	must be left unmarked. This is because young space scavenges
	assume non-marked youngs to distinguish traced vs untraced
	objects.
	"
	| marked result prev |
	marked := spaces asOrderedCollection.
	marked remove: edenSpace; remove: fromSpace.
	prev := CRITICAL.
	CRITICAL := inGC := true.
	[
		marked do: [:space | space unmarkAll].
		fullCollector collect.
		result := aClosure evaluate.
		edenSpace unmarkAll.
		fromSpace unmarkAll] evaluateAtomically.
	inGC := false.
	CRITICAL := prev.
	self rescueEphemerons.
	^result
! !

!Memory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
meterRuns
	^meter runs
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
newLargeArray: size
	| headerSize bodySize totalSize buffer object |
	#atomic.
	headerSize := 16.
	bodySize := size * WordSize.
	totalSize := headerSize + bodySize.
	buffer := self allocateLarge: totalSize.
	object := (buffer + headerSize _asPointer) _asObject.
	object
		_longSlotAt: _Behavior put: Array instanceBehavior;
		initializeExtended: true contentSize: size.
	^object _beArrayed; _nilSlots: size; yourself
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
newSpace
	| space |
	space := self pinnedCopy: GCSpace new.
	^space _beSeen
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
newSpaceAt: base limit: limit
	^self newSpace
		base: base;
		reservedLimit: limit;
		memory: self
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
newSpaceAt: base size: size
	^self newSpaceAt: base limit: base + (size // 2)
! !

!Memory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectsReferencing: targetSpace
	| marked result prev |
	marked := spaces asOrderedCollection.
	marked remove: edenSpace; remove: fromSpace.
	prev := CRITICAL.
	CRITICAL := true.
	[| tracer |
		marked do: [:space | space unmarkAll].
		tracer := SpaceReferencesTracer new.
		result := tracer
			space: targetSpace;
			updateAndFollow: ActiveProcess;
			result.
		edenSpace unmarkAll.
		fromSpace unmarkAll] evaluateAtomically.
	CRITICAL := prev.
	^result
! !

!Memory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
objectsSurviving: aBlock
	| set finalizable |
	set := WeakIdentitySet new: 1000.
	finalizable := Smalltalk finalizer copy.
	self collectYoung; collectYoung.
	self ASSERT: CRITICAL == false.
	CRITICAL := true.
	aBlock value.
	CRITICAL := false.
	self collectYoung.
	fromSpace objectsDo: [:o | set add: o].
	self collect; collect.
	set
		removeAll: finalizable ifAbsent: nil;
		removeAllSuchThat: [:o | o class == GenGCPass].
	^set
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
old
	^oldZone
! !

!Memory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
oldBase
	^oldZone base
! !

!Memory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
oldLimit
	^oldZone limit
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
oldRecyclableByteCount
	| total |
	total := 0.
	self
		markedEvaluate: [oldZone
			unmarkedDo: [:object | total := total + object _sizeInBytes]].
	^total
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
oldSizesHistogram
	| histogram |
	histogram := Dictionary new.
	self critical: [
		oldZone
			objectsDo: [:object | histogram
				at: object _sizeInBytes
				put: 1
				ifPresent: [:count | count + 1]]].
	^histogram
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
oldSpace
	^oldZone
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
pinnedAllocate: anInteger
	| pointer |
	pointer := pinnedSpace allocateIfPossible: anInteger.
	pointer _isSmallInteger ifFalse: [
		^anInteger > LargeThreshold
			ifTrue: [self allocateLarge: anInteger]
			ifFalse: [
				pinnedSpace dispenseReservedSpace.
				self createPinnedSpace; pinnedAllocate: anInteger]].
	^pointer
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
pinnedCopy: anObject
	| copy |
	copy := pinnedSpace shallowCopy: anObject.
	copy _isSmallInteger ifTrue: [
		pinnedSpace dispenseReservedSpace.
		^self createPinnedSpace; pinnedCopy: anObject].
	(self shouldBeInRememberedSet: anObject) ifTrue: [self remember: copy].
	^copy
! !

!Memory methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
pointsToYoungObjects: anObject
	(self isYoung: anObject behavior) ifTrue: [^true].
	1 to: anObject _pointersSize do: [:index | | ivar |
		ivar := anObject _basicAt: index.
		ivar _isSmallInteger ifFalse: [(self isYoung: ivar) ifTrue: [^true]]].
	^false
! !

!Memory methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: stream
	| reserved commited used |
	reserved := spaces
		inject: 0
		into: [:sum :space | sum + (space reservedSize * 2)].
	commited := spaces
		inject: 0
		into: [:sum :space | sum + (space commitedSize * 2)].
	used := spaces inject: 0 into: [:sum :space | sum + (space used * 2)].
	stream
		nextPutAll: '===============';
		cr;
		nextPutAll: 'Bee Memory:';
		cr;
		nextPutAll: used printString , ' used';
		cr;
		nextPutAll: commited printString , ' commited';
		cr;
		nextPutAll: reserved printString , ' reserved';
		cr;
		nextPutAll: meter statistics;
		cr;
		cr;
		nextPutAll: 'spaces -> ';
		cr;
		nextPutAll: 'old: ' , oldZone printString;
		cr;
		nextPutAll: 'eden: ' , edenSpace printString;
		cr;
		nextPutAll: 'from: ' , fromSpace printString.
	^stream
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
queueEphemerons: aCriticalArray
	unreachableEphemerons addAll: aCriticalArray
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
recyclableSimpleHistogram
	| histogram |
	histogram := Dictionary new.
	self markedEvaluate: [
		oldZone
			unmarkedDo: [:object | histogram
				at: object _sizeInBytes
				put: 1
				ifPresent: [:count | count + 1]]].
	^histogram
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
referencesTo: anObject
	"
	The closure used for markedEvaluate: captures anObject, thus it
	will be added to the reference list. We remove it from the result.
	"
	| references closure |
	references := OrderedCollection new.
	closure := [self addMarkedReferencesTo: anObject into: references].
	self markedEvaluate: closure.
	references remove: closure.
	^references
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
remember: anObject
	anObject _beRemembered.
	rememberedSet add: anObject
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
rememberedSet
	^rememberedSet
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
rememberedSet: aRememberedSet
	rememberedSet := aRememberedSet
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
rememberIfNeeded: anObject
	(self shouldBeInRememberedSet: anObject) ifTrue: [self remember: anObject]
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
rememberIfNotYoung: anObject
	(self isYoung: anObject) ifFalse: [self remember: anObject]
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
removeSpace: aCodeImageSegment
	"
	The spaces array could grow while executing. This could happen if a send site
	cache is fetched and indirectly causes a large space or pinned space to be created.
	To avoid that from happening we ensure there is a good amount of them free
	"
	self critical: [
		SendSite ensureEnoughFreeCaches: 100.
		spaces remove: aCodeImageSegment space]
! !

!Memory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
rescueEphemerons
	"
	Rescuing ephemerons can trigger all kinds of behavior (i.e. process switches,
	full GCs, etc). For that reason, in critical moments or when interrupts are disabled
	we don't rescue them instantly. They won't be lost, but will be rescued after the
	next GC. 
	Each time an ephemeron being rescued causes GC, that GC pass will recusively
	send rescueEphemerons. If not careful, that recursion can chain and quickly consume
	all the stack space. For that reason, we remove all currently unreachable from the
	list, so that recursive GCs end up sooner (once an ephemeron is found unreachable
	it is deactivated, so it won't be added again to the unreachable list)
	"
	| work |
	CRITICAL ifTrue: [^self].
	Processor areInterruptsEnabled ifFalse: [^self].
	work := unreachableEphemerons.
	work isEmpty ifTrue: [^self].
	unreachableEphemerons := CriticalArray new growTo: 1000.
	work do: [:e | [e rescue] ifCurtailed: [e activate]]
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
reserveSpaceSized: reserved commiting: commited
	| space address |
	address := Kernel os reserve: reserved.
	space := self newSpace address: address size: reserved.
	^space commit: commited
! !

!Memory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
reserveZoneSized: size near: start
	| address |
	address := Kernel os reserve: size near: start.
	^AllocationZone new
		memory: self;
		base: address // 2;
		limit: address + size // 2;
		build
! !

!Memory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
roots
	^{Processor activeProcess}
! !

!Memory methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:39'!
shallowCopy: object
	| headerSize answer size allocation objectPointer |
	size := object _bodySizeInBytes.
	headerSize := object _headerSizeInBytes.
	allocation := self allocate: headerSize + size.
	objectPointer := allocation + headerSize _asPointer.
	answer := objectPointer _asObject.
	answer _copyHeaderSized: headerSize from: object.
	answer _replaceFrom: 1 to: (size bitShift: 0 - WordSizeShift) with: object.
	answer _beNotRemembered.
	^answer
! !

!Memory methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
shouldBeInRememberedSet: anObject
	(self isYoung: anObject) ifTrue: [^false].
	^self pointsToYoungObjects: anObject
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
spaces
	^spaces
! !

!Memory methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
startUp
	fromSpace == self kernelSpace
		ifTrue: [self createRememberedSet; createSpaces; createPinnedSpace].
	self initializeCollectors
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
to
	^toSpace
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
unreachableEphemerons
	^unreachableEphemerons
! !

!Memory methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:39'!
usedSpace
	"
	Memory current usedSpace
	"
	^spaces inject: 0 into: [:sum :space | sum + (space used * 2)]
! !

!Memory methodsFor:  'allocation' stamp: 'KenD 28/Jun/2026 13:27:39'!
verifyMemory
	| stacks |
	self debugMode ifFalse: [^self].
	stacks := LinkedCollection new: 100.
	self markedEvaluate: [
		spaces do: [:space | 
			space markedDo: [:object | | index slots |
				(toSpace includes: object behavior) ifTrue: [self _halt].
				index := 1.
				slots := object _strongPointersSize.
				[index <= slots] whileTrue: [| reference |
					reference := object _basicAt: index.
					(toSpace includes: reference) ifTrue: [self _halt].
					index := index + 1].
				object class == ProcessLMRStack ifTrue: [stacks add: object]]]].
	^stacks
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
youngBase
	^youngBase
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
youngLimit
	^youngLimit
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Memory class' category: #Kernel!
Memory class
	instanceVariableNames: 'Current LargeThreshold CRITICAL'!

!Memory class methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocateMemory: size near: address
	| limit |
	limit := (1 bitShift: WordSize * 8 - 2) - size.
	^self allocateMemory: size near: address limit: limit
! !

!Memory class methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:39'!
allocateMemory: size near: address limit: limit
	^Smalltalk os allocate: size near: address limit: limit.
! !

!Memory class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
current
	^Current
! !

!Memory class methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
current: current
	Current := current
! !

!Memory class methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:39'!
nativeAllocate: size
	Smalltalk os nativeAllocate: size
	
! !

!Memory class methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:39'!
shallowCopy: anObject
	^Current shallowCopy: anObject
! !


Memory initialize!

