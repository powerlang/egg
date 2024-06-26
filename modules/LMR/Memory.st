"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Memory,
	#superclass : #Object,
	#instVars : [
		'spaces',
		'collectedSpaces',
		'genCollector',
		'pinnedSpace',
		'fromSpace',
		'toSpace',
		'oldZone',
		'meter',
		'edenSpace',
		'youngBase',
		'youngLimit',
		'rememberedSet',
		'inGC',
		'fullCollector',
		'unreachableEphemerons',
		'largeSpaces',
		'allocator'
	],
	#classVars : [
		'Current',
		'LargeThreshold',
		'CRITICAL'
	],
	#category : #Kernel
}

{ #category : #errors }
Memory class >> allocateMemory: size near: address [
	| limit |
	limit := (1 bitShift: WordSize * 8 - 2) - size.
	^self allocateMemory: size near: address limit: limit
]

{ #category : #errors }
Memory class >> allocateMemory: size near: address limit: limit [
	^Smalltalk os allocate: size near: address limit: limit.
]

{ #category : #accessing }
Memory class >> current [
	^Current
]

{ #category : #accessing }
Memory class >> current: current [
	Current := current
]

{ #category : #errors }
Memory class >> nativeAllocate: size [
	Smalltalk os nativeAllocate: size
	
]

{ #category : #copying }
Memory class >> shallowCopy: anObject [
	^Current shallowCopy: anObject
]

{ #category : #'adding / removing' }
Memory >> addKernelSpace: aSpace [
	spaces size: 1.
	spaces contents at: 1 put: aSpace.
	pinnedSpace := aSpace
]

{ #category : #'adding / removing' }
Memory >> addKernelSpace: aSpace [
	spaces size: 1.
	spaces contents at: 1 put: aSpace.
	pinnedSpace := aSpace
]

{ #category : #allocation }
Memory >> addMarkedInstancesOf: aSpecies into: aCollection [
	| searched |
	searched := spaces asOrderedCollection.
	searched
		do: [:space | space addMarkedInstancesOf: aSpecies into: aCollection]
]

{ #category : #allocation }
Memory >> addMarkedReferencesTo: anObject into: references [
	1 to: spaces size do: [:i | | space |
		space := spaces at: i.
		space addMarkedReferencesTo: anObject into: references]
]

{ #category : #'adding / removing' }
Memory >> addSpace: aSpace [
	oldZone ifNotNil: [oldZone assureFree: 1000].
	spaces add: aSpace
]

{ #category : #private }
Memory >> adjustSpaces [
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
]

{ #category : #private }
Memory >> adjustYoungAreaBy: anInteger [
	youngBase := youngBase + anInteger.
	youngLimit := youngLimit + anInteger
]

{ #category : #services }
Memory >> allDeadObjects [
	| collection |
	collection := LinkedCollection new: 10000.
	self
		markedEvaluate: [spaces
			do: [:space | space unmarkedDo: [:object | collection add: object]]].
	^collection
]

{ #category : #allocation }
Memory >> allExistingInstancesOf: aSpecies [
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
]

{ #category : #allocation }
Memory >> allInstancesOf: aSpecies [
	| instances |
	instances := LinkedCollection new: 1024.
	self markedEvaluate: [self addMarkedInstancesOf: aSpecies into: instances].
	^instances
]

{ #category : #allocation }
Memory >> allocate: size [
	| oop |
	oop := edenSpace allocateIfPossible: size.
	oop _isSmallInteger ifTrue: [^oop].
	size > LargeThreshold ifTrue: [^self allocateLarge: size].
	^self allocateCommitting: size
]

{ #category : #allocation }
Memory >> allocateCommitting: size [
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
]

{ #category : #allocation }
Memory >> allocateLarge: size [
	| space oop |
	space := self createLargeSpace: size.
	oop := space allocateIfPossible: size.
	oop _isSmallInteger
		ifFalse: [self
			_error: 'Failed to allocate large space of size ' , size printString].
	^oop
]

{ #category : #allocation }
Memory >> allocator [
	^allocator
]

{ #category : #allocation }
Memory >> allocator: anObject [
	allocator := anObject
]

{ #category : #services }
Memory >> allRecyclableByteCount [
	| total |
	total := 0.
	self markedEvaluate: [
		spaces
			do: [:space | space
				unmarkedDo: [:object | total := total + object _sizeInBytes]]].
	^total
]

{ #category : #allocation }
Memory >> allSubinstancesOf: aSpecies [
	| subinstances classes |
	classes := aSpecies withAllSubclasses.
	subinstances := LinkedCollection new: 1024.
	self
		markedEvaluate: [classes
			do: [:cls | self addMarkedInstancesOf: cls into: subinstances]].
	^subinstances
]

{ #category : #inquiries }
Memory >> arenaBytes [
	^oldZone size + edenSpace size + toSpace size * 2
]

{ #category : #services }
Memory >> assureFree: size [
	edenSpace availableBytes < size ifTrue: [self collectYoung]
]

{ #category : #inquiries }
Memory >> available [
	^edenSpace availableBytes
]

{ #category : #inquiries }
Memory >> baseAddress [
	^spaces first dataBase
]

{ #category : #private }
Memory >> classMortalityHistogram [
	| histogram |
	histogram := Dictionary new.
	self markedEvaluate: [
		oldZone
			unmarkedDo: [:object | histogram
				at: object class
				put: 1
				ifPresent: [:count | count + 1]]].
	^histogram
]

{ #category : #private }
Memory >> collect [
	self collectYoung; collectOld
]

{ #category : #allocation }
Memory >> collectOld [
	self markedEvaluate: []
]

{ #category : #allocation }
Memory >> collectOldIfTime [
	fullCollector hasReachedCountdown ifTrue: [self collectOld]
]

{ #category : #private }
Memory >> collectYoung [
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
]

{ #category : #private }
Memory >> collectYoungMeasuring [
	meter
		measure: [[
			self verifyMemory.
			genCollector collect.
			self verifyMemory] evaluateAtomically].
	fullCollector tenured: meter runs last tenured
]

{ #category : #inquiries }
Memory >> commitedSize [
	^spaces inject: 0 into: [:sum :space | sum + (space commitedSize * 2)]
]

{ #category : #private }
Memory >> createLargeSpace: size [
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
]

{ #category : #private }
Memory >> createPinnedSpace [
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
]

{ #category : #private }
Memory >> createRememberedSet [
	rememberedSet := RememberedSet new initialize: 16 kbytes
]

{ #category : #private }
Memory >> createSpaces [
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
]

{ #category : #private }
Memory >> critical: aBlock [
	^[| prev result |
		prev := CRITICAL.
		CRITICAL := true.
		result := aBlock value.
		CRITICAL := prev.
		result] evaluateAtomically
]

{ #category : #allocation }
Memory >> debugMode [
	^false
]

{ #category : #accessing }
Memory >> eden [
	^edenSpace
]

{ #category : #accessing }
Memory >> eden: aSpace [
	allocator := edenSpace := aSpace
]

{ #category : #system }
Memory >> edenCollector [
	^genCollector
]

{ #category : #accessing }
Memory >> from [
	^fromSpace
]

{ #category : #accessing }
Memory >> fromSpace: aSpace [
	fromSpace := aSpace
]

{ #category : #private }
Memory >> fullClassMortalityHistogram [
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
]

{ #category : #private }
Memory >> garbageCollectTest2 [
	| space broken |
	space := GCSpace copyFrom: fromSpace.
	space nextFree: space softLimit.
	broken := self collectYoung; objectsReferencing: space.
	broken size > 0 ifTrue: [broken halt]
]

{ #category : #testing }
Memory >> hasMarkedReferencesTo: aGCSpace in: aCollection [
	aCollection do: [:space | 
		space markedDo: [:object | 
			(aGCSpace includesAddress: object behavior) ifTrue: [^true].
			1 to: object _pointersSize do: [:index | | reference |
				reference := object _basicAt: index.
				(aGCSpace includesAddress: reference) ifTrue: [^true]]]].
	^false
]

{ #category : #testing }
Memory >> hasReferencesToSpace: aGCSpace [
	| searched |
	searched := spaces copyWithout: aGCSpace.
	^self markedEvaluate: [self hasMarkedReferencesTo: aGCSpace in: searched]
]

{ #category : #statistics }
Memory >> histogram [
	"
	Memory current histogram
	"
	| sizes |
	sizes := Dictionary new: 3000.
	self critical: [| original |
		original := spaces asOrderedCollection collect: #copy.
		original do: [:space | space histogramInto: sizes]].
	^sizes associations asArray sortBy: [:a :b | a value > b value]
]

{ #category : #accessing }
Memory >> inGC [
	^inGC
]

{ #category : #initialization }
Memory >> initialize [
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
]

{ #category : #initialization }
Memory >> initializeCollectors [
	| movable |
	movable := EdenCollector on: self.
	genCollector := self kernelSpace shallowCopy: movable.
	self rememberIfNeeded: genCollector.
	movable := GarbageFirstCollector on: self.
	fullCollector := self kernelSpace shallowCopy: movable.
	self rememberIfNeeded: fullCollector
]

{ #category : #testing }
Memory >> isYoung: anObject [
	^false == anObject _isSmallInteger
		and: [anObject _asPointer between: youngBase and: youngLimit]
]

{ #category : #testing }
Memory >> isYoungSafe: anObject [
	^anObject _asPointer between: youngBase and: youngLimit
]

{ #category : #inquiries }
Memory >> kernelSpace [
	^spaces first
]

{ #category : #private }
Memory >> largeSpaces [
	^largeSpaces
]

{ #category : #services }
Memory >> make: anObject become: anotherObject [
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
]

{ #category : #allocation }
Memory >> markedEvaluate: aClosure [
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
]

{ #category : #inquiries }
Memory >> meterRuns [
	^meter runs
]

{ #category : #allocation }
Memory >> newLargeArray: size [
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
]

{ #category : #private }
Memory >> newSpace [
	| space |
	space := self pinnedCopy: GCSpace new.
	^space _beSeen
]

{ #category : #private }
Memory >> newSpaceAt: base limit: limit [
	^self newSpace
		base: base;
		reservedLimit: limit;
		memory: self
]

{ #category : #private }
Memory >> newSpaceAt: base size: size [
	^self newSpaceAt: base limit: base + (size // 2)
]

{ #category : #inquiries }
Memory >> objectsReferencing: targetSpace [
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
]

{ #category : #inquiries }
Memory >> objectsSurviving: aBlock [
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
]

{ #category : #accessing }
Memory >> old [
	^oldZone
]

{ #category : #inquiries }
Memory >> oldBase [
	^oldZone base
]

{ #category : #inquiries }
Memory >> oldLimit [
	^oldZone limit
]

{ #category : #services }
Memory >> oldRecyclableByteCount [
	| total |
	total := 0.
	self
		markedEvaluate: [oldZone
			unmarkedDo: [:object | total := total + object _sizeInBytes]].
	^total
]

{ #category : #services }
Memory >> oldSizesHistogram [
	| histogram |
	histogram := Dictionary new.
	self critical: [
		oldZone
			objectsDo: [:object | histogram
				at: object _sizeInBytes
				put: 1
				ifPresent: [:count | count + 1]]].
	^histogram
]

{ #category : #accessing }
Memory >> oldSpace [
	^oldZone
]

{ #category : #services }
Memory >> pinnedAllocate: anInteger [
	| pointer |
	pointer := pinnedSpace allocateIfPossible: anInteger.
	pointer _isSmallInteger ifFalse: [
		^anInteger > LargeThreshold
			ifTrue: [self allocateLarge: anInteger]
			ifFalse: [
				pinnedSpace dispenseReservedSpace.
				self createPinnedSpace; pinnedAllocate: anInteger]].
	^pointer
]

{ #category : #services }
Memory >> pinnedCopy: anObject [
	| copy |
	copy := pinnedSpace shallowCopy: anObject.
	copy _isSmallInteger ifTrue: [
		pinnedSpace dispenseReservedSpace.
		^self createPinnedSpace; pinnedCopy: anObject].
	(self shouldBeInRememberedSet: anObject) ifTrue: [self remember: copy].
	^copy
]

{ #category : #testing }
Memory >> pointsToYoungObjects: anObject [
	(self isYoung: anObject behavior) ifTrue: [^true].
	1 to: anObject _pointersSize do: [:index | | ivar |
		ivar := anObject _basicAt: index.
		ivar _isSmallInteger ifFalse: [(self isYoung: ivar) ifTrue: [^true]]].
	^false
]

{ #category : #printing }
Memory >> printOn: stream [
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
]

{ #category : #services }
Memory >> queueEphemerons: aCriticalArray [
	unreachableEphemerons addAll: aCriticalArray
]

{ #category : #private }
Memory >> recyclableSimpleHistogram [
	| histogram |
	histogram := Dictionary new.
	self markedEvaluate: [
		oldZone
			unmarkedDo: [:object | histogram
				at: object _sizeInBytes
				put: 1
				ifPresent: [:count | count + 1]]].
	^histogram
]

{ #category : #allocation }
Memory >> referencesTo: anObject [
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
]

{ #category : #services }
Memory >> remember: anObject [
	anObject _beRemembered.
	rememberedSet add: anObject
]

{ #category : #accessing }
Memory >> rememberedSet [
	^rememberedSet
]

{ #category : #accessing }
Memory >> rememberedSet: aRememberedSet [
	rememberedSet := aRememberedSet
]

{ #category : #services }
Memory >> rememberIfNeeded: anObject [
	(self shouldBeInRememberedSet: anObject) ifTrue: [self remember: anObject]
]

{ #category : #services }
Memory >> rememberIfNotYoung: anObject [
	(self isYoung: anObject) ifFalse: [self remember: anObject]
]

{ #category : #services }
Memory >> removeSpace: aCodeImageSegment [
	"
	The spaces array could grow while executing. This could happen if a send site
	cache is fetched and indirectly causes a large space or pinned space to be created.
	To avoid that from happening we ensure there is a good amount of them free
	"
	self critical: [
		SendSite ensureEnoughFreeCaches: 100.
		spaces remove: aCodeImageSegment space]
]

{ #category : #services }
Memory >> rescueEphemerons [
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
]

{ #category : #private }
Memory >> reserveSpaceSized: reserved commiting: commited [
	| space address |
	address := Kernel os reserve: reserved.
	space := self newSpace address: address size: reserved.
	^space commit: commited
]

{ #category : #private }
Memory >> reserveZoneSized: size near: start [
	| address |
	address := Kernel os reserve: size near: start.
	^AllocationZone new
		memory: self;
		base: address // 2;
		limit: address + size // 2;
		build
]

{ #category : #inquiries }
Memory >> roots [
	^{Processor activeProcess}
]

{ #category : #copying }
Memory >> shallowCopy: object [
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
]

{ #category : #testing }
Memory >> shouldBeInRememberedSet: anObject [
	(self isYoung: anObject) ifTrue: [^false].
	^self pointsToYoungObjects: anObject
]

{ #category : #accessing }
Memory >> spaces [
	^spaces
]

{ #category : #initialization }
Memory >> startUp [
	fromSpace == self kernelSpace
		ifTrue: [self createRememberedSet; createSpaces; createPinnedSpace].
	self initializeCollectors
]

{ #category : #accessing }
Memory >> to [
	^toSpace
]

{ #category : #accessing }
Memory >> unreachableEphemerons [
	^unreachableEphemerons
]

{ #category : #inquiries }
Memory >> usedSpace [
	"
	Memory current usedSpace
	"
	^spaces inject: 0 into: [:sum :space | sum + (space used * 2)]
]

{ #category : #allocation }
Memory >> verifyMemory [
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
]

{ #category : #accessing }
Memory >> youngBase [
	^youngBase
]

{ #category : #accessing }
Memory >> youngLimit [
	^youngLimit
]
