'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #NonMovingCollector category: #Kernel!
GarbageCollector subclass: #NonMovingCollector
	instanceVariableNames: 'stack limit index scanned largeSize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!NonMovingCollector commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
checkReachablePropertyOf: ephemeron
	| key |
	key := ephemeron _basicAt: 1.
	^key _isSmallInteger or: [key _hasBeenSeen]
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
copyOf: object
	self error: 'non-moving collector should not copy'
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
copyRescuedEphemerons
	rescuedEphemerons := memory oldSpace
		shallowCopyCommiting: rescuedEphemerons.
	^memory oldSpace shallowCopyCommiting: rescuedEphemerons contents
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
doCollect
	super doCollect.
	self purgeRememberedSet
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
evacuate: object
	^self error: 'non-moving collector should not evacuate'
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
followClosure
	[stack notEmpty or: [stacks notEmpty]]
		whileTrue: [self followObjects; scanStacks]
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
followObjects
	[stack isEmpty] whileFalse: [
		limit := stack pop.
		index := stack pop.
		scanned := stack pop.
		[index <= limit]
			whileTrue: [index = 0
				ifTrue: [self scanBehavior]
				ifFalse: [self scanSlot]]]
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasToEvacuate: anObject
	^false
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialContainerCapacity
	^self workSpaceSize // 1000
! !

!NonMovingCollector methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeLocals
	stack := CriticalStack emptyReserving: 64 kbytes.
	largeSize := memory largeSpaces size.
	memory old resetOccupancy.
	super initializeLocals
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
purgeRememberedSet
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
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
queue: anObject from: start to: end
	stack
		push: anObject;
		push: start;
		push: end
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
queueCurrent
	stack
		push: scanned;
		push: index + 1;
		push: limit
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
releaseLocals
	self sweepLargeSpaces.
	stack release.
	stack := scanned := nil.
	super releaseLocals
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scan: anObject from: start to: end
	stack
		push: anObject;
		push: start;
		push: end
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanBehavior
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
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanSlot
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
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanThreadLocalStorage: thread
	thread localStorageIndices
		do: [:i | self scanThreadLocalStorage: thread at: i]
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanThreadLocalStorage: thread at: i
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
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
scanTopSlot: stackWrapper
	self queue: stackWrapper sp _asObject from: 1 to: 1
! !

!NonMovingCollector methodsFor:  'ephemerons' stamp: 'KenD 28/Jun/2026 13:27:39'!
sweepLargeSpaces
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
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
updateRegionOccupancy: object
	memory old updateRegionOccupancy: object
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
updateWeak: weakContainer at: i
	| object |
	object := weakContainer _basicAt: i.
	object _isSmallInteger ifTrue: [^self].
	object _hasBeenSeen ifTrue: [^self].
	weakContainer _basicAt: i put: tombstone
! !

!NonMovingCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
workSpaceSize
	^20 mbytes
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NonMovingCollector class' category: #Kernel!
NonMovingCollector class
	instanceVariableNames: ''!


