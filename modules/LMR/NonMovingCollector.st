"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #NonMovingCollector,
	#superclass : #GarbageCollector,
	#instVars : [
		'stack',
		'limit',
		'index',
		'scanned',
		'largeSize'
	],
	#category : #Kernel
}

{ #category : #cleaning }
NonMovingCollector >> checkReachablePropertyOf: ephemeron [
	| key |
	key := ephemeron _basicAt: 1.
	^key _isSmallInteger or: [key _hasBeenSeen]
]

{ #category : #cleaning }
NonMovingCollector >> copyOf: object [
	self error: 'non-moving collector should not copy'
]

{ #category : #cleaning }
NonMovingCollector >> copyRescuedEphemerons [
	rescuedEphemerons := memory oldSpace
		shallowCopyCommiting: rescuedEphemerons.
	^memory oldSpace shallowCopyCommiting: rescuedEphemerons contents
]

{ #category : #cleaning }
NonMovingCollector >> doCollect [
	super doCollect.
	self purgeRememberedSet
]

{ #category : #cleaning }
NonMovingCollector >> evacuate: object [
	^self error: 'non-moving collector should not evacuate'
]

{ #category : #cleaning }
NonMovingCollector >> followClosure [
	[stack notEmpty or: [stacks notEmpty]]
		whileTrue: [self followObjects; scanStacks]
]

{ #category : #cleaning }
NonMovingCollector >> followObjects [
	[stack isEmpty] whileFalse: [
		limit := stack pop.
		index := stack pop.
		scanned := stack pop.
		[index <= limit]
			whileTrue: [index = 0
				ifTrue: [self scanBehavior]
				ifFalse: [self scanSlot]]]
]

{ #category : #cleaning }
NonMovingCollector >> hasToEvacuate: anObject [
	^false
]

{ #category : #cleaning }
NonMovingCollector >> initialContainerCapacity [
	^self workSpaceSize // 1000
]

{ #category : #initialization }
NonMovingCollector >> initializeLocals [
	stack := CriticalStack emptyReserving: 64 kbytes.
	largeSize := memory largeSpaces size.
	memory old resetOccupancy.
	super initializeLocals
]

{ #category : #cleaning }
NonMovingCollector >> purgeRememberedSet [
	| object kept rs |
	rs := memory rememberedSet.
	kept := 0.
	1 to: rs size do: [:i | 
		object := rs at: i.
		object _hasBeenSeen ifTrue: [
			(self hasToEvacuate: object) ifTrue: [object := self copyOf: object].
			kept := kept + 1.
			rs at: kept put: object]].
	rs size: kept
]

{ #category : #cleaning }
NonMovingCollector >> queue: anObject from: start to: end [
	stack
		push: anObject;
		push: start;
		push: end
]

{ #category : #cleaning }
NonMovingCollector >> queueCurrent [
	stack
		push: scanned;
		push: index + 1;
		push: limit
]

{ #category : #cleaning }
NonMovingCollector >> releaseLocals [
	self sweepLargeSpaces.
	stack release.
	stack := scanned := nil.
	super releaseLocals
]

{ #category : #cleaning }
NonMovingCollector >> scan: anObject from: start to: end [
	stack
		push: anObject;
		push: start;
		push: end
]

{ #category : #cleaning }
NonMovingCollector >> scanBehavior [
	| slot evacuate |
	slot := scanned _longSlotAt: 0.
	slot _isSmallInteger ifTrue: [^index := index + 1].
	evacuate := self hasToEvacuate: slot.
	slot _hasBeenSeen ifTrue: [
		evacuate ifTrue: [
			slot := self copyOf: slot.
			scanned _longSlotAt: 0 put: slot].
		^index := index + 1].
	slot _beSeen.
	evacuate
		ifTrue: [
			slot := self evacuate: slot.
			scanned _longSlotAt: 0 put: slot]
		ifFalse: [self updateRegionOccupancy: slot].
	slot _isSpecial ifTrue: [self rememberSpecial: slot].
	index < limit ifTrue: [self queueCurrent].
	index := 0.
	limit := slot _strongPointersSize.
	scanned := slot
]

{ #category : #cleaning }
NonMovingCollector >> scanSlot [
	| slot evacuate |
	slot := scanned _basicAt: index.
	slot _isSmallInteger ifTrue: [^index := index + 1].
	evacuate := self hasToEvacuate: slot.
	slot _hasBeenSeen ifTrue: [
		evacuate ifTrue: [
			slot := self copyOf: slot.
			scanned _basicAt: index put: slot].
		^index := index + 1].
	slot _beSeen.
	evacuate
		ifTrue: [
			slot := self evacuate: slot.
			scanned _basicAt: index put: slot]
		ifFalse: [self updateRegionOccupancy: slot].
	slot _isSpecial ifTrue: [self rememberSpecial: slot].
	index < limit ifTrue: [self queueCurrent].
	index := 0.
	limit := slot _strongPointersSize.
	scanned := slot
]

{ #category : #cleaning }
NonMovingCollector >> scanThreadLocalStorage: thread [
	thread localStorageIndices
		do: [:i | self scanThreadLocalStorage: thread at: i]
]

{ #category : #cleaning }
NonMovingCollector >> scanThreadLocalStorage: thread at: i [
	| slot evacuate |
	slot := thread tlsAt: i.
	slot _isSmallInteger ifTrue: [^self].
	evacuate := self hasToEvacuate: slot.
	slot _hasBeenSeen ifTrue: [
		^evacuate ifTrue: [
			slot := self copyOf: slot.
			thread tlsAt: i put: slot]].
	slot _beSeen.
	evacuate
		ifTrue: [
			slot := self evacuate: slot.
			thread tlsAt: i put: slot]
		ifFalse: [self updateRegionOccupancy: slot].
	slot _isSpecial ifTrue: [self rememberSpecial: slot].
	self queue: slot from: 0 to: slot _strongPointersSize
]

{ #category : #cleaning }
NonMovingCollector >> scanTopSlot: stackWrapper [
	self queue: stackWrapper sp _asObject from: 1 to: 1
]

{ #category : #ephemerons }
NonMovingCollector >> sweepLargeSpaces [
	| used large registered |
	used := 0.
	large := memory largeSpaces.
	registered := memory spaces.
	1 to: largeSize do: [:i | | s |
		s := large at: i.
		s firstObject _hasBeenSeen
			ifTrue: [
				used := used + 1.
				large at: used put: s]
			ifFalse: [
				Kernel os release: s base * 2.
				registered remove: s]].
	largeSize + 1 to: large size do: [:i | | s |
		s := large at: i.
		used := used + 1.
		large at: used put: s].
	used + 1 to: large size do: [:i | large at: i put: nil].
	large size: used
]

{ #category : #cleaning }
NonMovingCollector >> updateRegionOccupancy: object [
	memory old updateRegionOccupancy: object
]

{ #category : #cleaning }
NonMovingCollector >> updateWeak: weakContainer at: i [
	| object |
	object := weakContainer _basicAt: i.
	object _isSmallInteger ifTrue: [^self].
	object _hasBeenSeen ifTrue: [^self].
	weakContainer _basicAt: i put: tombstone
]

{ #category : #cleaning }
NonMovingCollector >> workSpaceSize [
	^20 mbytes
]

