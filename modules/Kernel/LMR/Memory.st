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
		'collector',
		'pinnedSpace',
		'fromSpace',
		'toSpace',
		'oldSpace',
		'meter',
		'edenSpace',
		'youngBase',
		'youngLimit',
		'rememberedSet'
	],
	#classVars : [
		'Current',
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
Memory >> addSpace: aSpace [
	spaces := spaces copyWith: aSpace
]

{ #category : #services }
Memory >> allDeadObjects [
	| collection tracer |
	collection := LinkedCollection new: 10000.
	tracer := ObjectGraph new.
	CRITICAL := true.
	tracer updateAndFollow: self roots.
	spaces
		do: [:space | space unmarkedDo: [:object | collection add: object]];
		do: #unmarkAll.
	CRITICAL := false.
	^collection
]

{ #category : #allocation }
Memory >> allInstancesOf: aSpecies [
	| searched instances |
	edenSpace percentageOfCommitedUsed > 60 ifTrue: [self scavengeYoungObjects].
	searched := spaces shallowCopy.
	ObjectGraph new updateAndFollow: self roots.
	instances := LinkedCollection new: 1024.
	CRITICAL := true.
	searched
		do: [:space | space
			addMarkedInstancesOf: aSpecies into: instances;
			unmarkAll].
	CRITICAL := false.
	^instances
]

{ #category : #allocation }
Memory >> allocate: size [
	| answer |
	answer := edenSpace allocateIfPossible: size.
	^answer _isSmallInteger ifTrue: [answer] ifFalse: [
		self
			dispenseReservedSpace;
			scavengeYoungObjects;
			allocateAfterScavenge: size]
]

{ #category : #allocation }
Memory >> allocateAfterCollectingOldSpace: size [
	| answer |
	answer := oldSpace allocateIfPossible: size.
	^answer _isSmallInteger ifTrue: [answer] ifFalse: [
		oldSpace commitAtLeast: size.
		self allocateAfterGrowingOldSpace: size]
]

{ #category : #allocation }
Memory >> allocateAfterGrowingOldSpace: size [
	| answer |
	answer := oldSpace allocateIfPossible: size.
	^answer _isSmallInteger ifTrue: [answer] ifFalse: [
		self
			error: 'not enough free space to allocate an object of size '
				, size printString]
]

{ #category : #allocation }
Memory >> allocateAfterScavenge: size [
	| answer |
	answer := edenSpace allocateIfPossible: size.
	^answer _isSmallInteger
		ifTrue: [answer]
		ifFalse: [self allocateInOldSpace: size]
]

{ #category : #allocation }
Memory >> allocateInOldSpace: size [
	| answer |
	answer := oldSpace allocateIfPossible: size.
	^answer _isSmallInteger
		ifTrue: [answer]
		ifFalse: [self
			collectAndCompactOldSpace;
			allocateAfterCollectingOldSpace: size]
]

{ #category : #allocation }
Memory >> allocateMemory: size [
	^Smalltalk os allocate: size
]

{ #category : #services }
Memory >> assureFree: size [
	edenSpace softAvailable * 2 < size
		ifTrue: [self dispenseReservedSpace; scavengeYoungObjects]
]

{ #category : #accessing }
Memory >> available [
	^edenSpace availableBytes
]

{ #category : #accessing }
Memory >> baseAddress [
	^spaces first dataBase
]

{ #category : #services }
Memory >> collectAndCompactOldSpace [
	"
	nothing for now
	"
	
]

{ #category : #services }
Memory >> commitMoreSpace [
	oldSpace
		commit: 4 * 1024 * 1024;
		leaveDispenseSpace
]

{ #category : #private }
Memory >> createPinnedSpace [
	pinnedSpace := self newSpaceSized: 4096 + 64 * 1024.
	pinnedSpace := self kernelSpace deepCopy: pinnedSpace.
	pinnedSpace leaveDispenseSpace: 1024.
	self addSpace: pinnedSpace
]

{ #category : #private }
Memory >> createSpaces [
	| allocation eden |
	allocation := self reserveSpaceSized: 64 * 1024 * 1024.
	fromSpace := self newSpaceAt: allocation base sized: 4 * 1024 * 1024.
	toSpace := self newSpaceAt: fromSpace reservedLimit sized: 4 * 1024 * 1024.
	eden := self
		newSpaceAt: toSpace reservedLimit
		limit: allocation reservedLimit.
	youngBase := fromSpace base.
	youngLimit := eden reservedLimit.
	oldSpace := self
		reserveSpaceSized: 256 * 1024 * 1024
		commiting: 4 * 1024 * 1024.
	self
		addSpace: fromSpace;
		addSpace: eden;
		addSpace: oldSpace.
	collectedSpaces add: fromSpace.
	edenSpace := eden.
	self pinRememberedSet
]

{ #category : #private }
Memory >> critical: aBlock [
	^[| result |
		self available < 5000 ifTrue: [self scavengeYoungObjects].
		CRITICAL := true.
		result := aBlock value.
		CRITICAL := false.
		result] evaluateAtomically
]

{ #category : #private }
Memory >> dispenseReservedSpace [
	edenSpace dispenseReservedSpace
]

{ #category : #accessing }
Memory >> eden [
	^edenSpace
]

{ #category : #accessing }
Memory >> eden: aSpace [
	edenSpace := aSpace
]

{ #category : #system }
Memory >> edenCollector [
	^collector
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
Memory >> fullGC [
	self scavengeYoungObjects
]

{ #category : #system }
Memory >> garbageCollectTest2 [
	| space broken |
	space := GCSpace copyFrom: fromSpace.
	space nextFree: space softLimit.
	broken := self scavengeYoungObjects; objectsReferencing: space.
	broken size > 0 ifTrue: [broken halt]
]

{ #category : #system }
Memory >> garbageCollectTest3 [
	| broken |
	broken := self garbageCollectHeap; objectsReferencing: collector workSpace.
	broken size > 0 ifTrue: [broken halt]
]

{ #category : #private }
Memory >> growIfTime [
	oldSpace percentageOfCommitedUsed > 90 ifTrue: [self commitMoreSpace]
]

{ #category : #inquiries }
Memory >> hasReferencesToSegment: anImageSegment [
	| tracer target searched |
	tracer := ObjectGraph new.
	target := anImageSegment space.
	CRITICAL := true.
	tracer updateAndFollow: self roots.
	searched := spaces copyWithout: target.
	searched
		do: [:space | 
			space markedDo: [:object | 
				(space includesAddress: object behavior) ifTrue: [^true].
				1 to: object _pointersSize do: [:index | | reference |
					reference := object _basicAt: index.
					(space includesAddress: reference) ifTrue: [^true]]]];
		do: [:space | space unmarkAll].
	CRITICAL := false.
	^false
]

{ #category : #statistics }
Memory >> histogram [
	| sizes |
	sizes := Dictionary new: 3000.
	spaces do: [:space | space histogramInto: sizes].
	^sizes associations asArray sortBy: [:a :b | a value > b value]
]

{ #category : #services }
Memory >> holdReferenceToObject: oop [
	| object |
	object := oop _asNative.
	(self isYoungSafe: object) ifFalse: [self remember: object]
]

{ #category : #initialization }
Memory >> initialize [
	super initialize.
	spaces := Array new.
	collectedSpaces := OrderedCollection new.
	youngBase := 0.
	youngLimit := 0.
	meter := MemoryMeter new memory: self
]

{ #category : #initialization }
Memory >> initializeCollector [
	| movable |
	movable := EdenCollector on: self.
	collector := self kernelSpace shallowCopy: movable.
	collector shouldBeInRememberedSet ifTrue: [self remember: collector]
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

{ #category : #accessing }
Memory >> kernelSpace [
	^spaces first
]

{ #category : #services }
Memory >> make: anObject become: anotherObject [
	| vm |
	vm := Smalltalk vm.
	1 to: spaces size do: [:i | | space |
		space := spaces at: i.
		vm make: anObject become: anotherObject in: space with: self].
	self rememberAfterBecome: anObject.
	Processor activeProcess make: anObject become: anotherObject
]

{ #category : #private }
Memory >> newSpaceAt: base limit: limit [
	^GCSpace newAt: base limit: limit
]

{ #category : #private }
Memory >> newSpaceAt: base sized: size [
	^self newSpaceAt: base limit: base * 2 + size // 2
]

{ #category : #services }
Memory >> newSpaceSized: anInteger [
	| memory |
	memory := self allocateMemory: anInteger.
	^GCSpace newAtAddress: memory size: anInteger
]

{ #category : #inquiries }
Memory >> objectsReferencing: targetSpace [
	| collection tracer |
	collection := LinkedCollection new: 10000.
	tracer := ObjectGraph new.
	CRITICAL := true.
	tracer updateAndFollow: self roots.
	spaces
		do: [:space | 
			space markedDo: [:object | | index slots |
				(targetSpace includes: object behavior) ifTrue: [collection add: object].
				index := 1.
				slots := object _strongPointersSize.
				[index <= slots] whileTrue: [| reference |
					reference := object _basicAt: index.
					(targetSpace includes: reference) ifTrue: [collection add: object].
					index := index + 1]]];
		do: #unmarkAll.
	CRITICAL := false.
	^collection
]

{ #category : #accessing }
Memory >> old [
	^oldSpace
]

{ #category : #accessing }
Memory >> oldSpace [
	^oldSpace
]

{ #category : #services }
Memory >> pinnedCopy: anObject [
	| copy |
	copy := pinnedSpace shallowCopy: anObject.
	copy _isSmallInteger
		ifTrue: [^self createPinnedSpace; pinnedCopy: anObject].
	copy shouldBeInRememberedSet ifTrue: [self remember: copy].
	^copy
]

{ #category : #private }
Memory >> pinRememberedSet [
	"
	remembered set must not be moved during collection, because it is modified by the
	collector itself. Moving it while collecting may cause the modifications incorrectly be
	done to the original array instead of the copy.
	"
	rememberedSet space: oldSpace
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
		nextPutAll: 'old: ' , oldSpace printString;
		cr;
		nextPutAll: 'eden: ' , edenSpace printString;
		cr;
		nextPutAll: 'from: ' , fromSpace printString.
	^stream
]

{ #category : #allocation }
Memory >> referencesTo: anObject [
	| references |
	edenSpace percentageOfCommitedUsed > 60 ifTrue: [self scavengeYoungObjects].
	references := LinkedCollection new: 1024.
	CRITICAL := true.
	1 to: spaces size do: [:i | | space |
		space := spaces at: i.
		space addReferencesTo: anObject into: references].
	CRITICAL := false.
	^references
]

{ #category : #services }
Memory >> remember: anObject [
	anObject _beRemembered.
	rememberedSet unsafeAdd: anObject
]

{ #category : #services }
Memory >> rememberAfterBecome: anObject [
	"
	When a remembered object is becomed into another, it
	is implicitly removed from the remembered set. It will
	not be updated during GC any more, which should be ok
	as the original object should be unreachable and therefore
	considered dead. However, current bee doesn't become
	references in native code, and also resurrects dead objects
	in some places (allInstances), so we rather keep updating
	the old object for now.
	"
	anObject _isRemembered ifTrue: [self remember: anObject _beNotRemembered]
]

{ #category : #accessing }
Memory >> rememberedSet [
	^rememberedSet
]

{ #category : #accessing }
Memory >> rememberedSet: aGCArray [
	rememberedSet := aGCArray.
	rememberedSet ignoreWriteBarrier
]

{ #category : #system }
Memory >> rescuedEphemerons [
	^collector rescuedEphemerons
]

{ #category : #services }
Memory >> rescueEphemerons [
	collector rescuedEphemerons do: [:e | [e rescue] ifCurtailed: [e activate]]
]

{ #category : #private }
Memory >> reserveMemory: size [
	^Smalltalk os reserve: size
]

{ #category : #private }
Memory >> reserveSpaceSized: size [
	^self reserveSpaceSized: size commiting: size
]

{ #category : #private }
Memory >> reserveSpaceSized: reserved commiting: commited [
	| space address |
	address := self reserveMemory: reserved.
	space := GCSpace reservedAt: address sized: reserved.
	^space commit: commited; leaveDispenseSpace
]

{ #category : #inquiries }
Memory >> roots [
	^{ActiveProcess}
]

{ #category : #services }
Memory >> scavengeYoungObjects [
	CRITICAL ifTrue: [self stop].
	meter
		measure: [[
			CRITICAL := true.
			collector collect.
			CRITICAL := false] evaluateAtomically].
	self rescueEphemerons.
	Smalltalk transcript cr; print: meter statistics.
	[ActiveProcess gcFlipInterrupt]
]

{ #category : #copying }
Memory >> shallowCopy: object [
	| headerSize answer size allocation objectPointer |
	size := object _sizeInBytes.
	headerSize := object _headerSizeInBytes.
	allocation := self allocate: headerSize + size.
	objectPointer := allocation + headerSize _asPointer.
	answer := objectPointer _asObject.
	answer _copyHeaderSized: headerSize from: object.
	answer _replaceFrom: 1 to: (size bitShift: 0 - WordSizeShift) with: object.
	answer _beNotRemembered.
	^answer
]

{ #category : #copying }
Memory >> shallowCopy: array growingTo: newSize [
	| headerSize total buffer copy |
	headerSize := 16.
	total := headerSize + (newSize * WordSize).
	buffer := self allocate: total.
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
Memory >> spaces [
	^spaces
]

{ #category : #initialization }
Memory >> startUp [
	self createSpaces; initializeCollector; createPinnedSpace.
	CRITICAL := false.
]

{ #category : #services }
Memory >> stop [
	self _halt
]

{ #category : #accessing }
Memory >> to [
	^toSpace
]

{ #category : #accessing }
Memory >> youngBase [
	^youngBase
]

{ #category : #accessing }
Memory >> youngLimit [
	^youngLimit
]

