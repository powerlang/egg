'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #GarbageFirstCollector category: #Kernel!
NonMovingCollector subclass: #GarbageFirstCollector
	instanceVariableNames: 'oldZone evacuated forwarderOffset countdown'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!GarbageFirstCollector commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
!

!GarbageFirstCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
copyOf: anObject
	| forwarder |
	forwarder := anObject _asPointer + forwarderOffset.
	^forwarder _asObject _basicAt: 1
! !

!GarbageFirstCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
evacuate: anObject
	| copy forwarder |
	copy := oldZone shallowCopyCommiting: anObject.
	anObject _isRemembered ifTrue: [copy _beRemembered].
	forwarder := anObject _asPointer + forwarderOffset.
	forwarder _asObject _basicAt: 1 put: copy.
	^copy
! !

!GarbageFirstCollector methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasReachedCountdown
	^countdown <= 0
! !

!GarbageFirstCollector methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
hasToEvacuate: anObject
	| index |
	index := oldZone regionIndexOf: anObject.
	^index notNil and: [(evacuated at: index) > 0]
! !

!GarbageFirstCollector methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	countdown := 25 mbytes.
	super initialize
! !

!GarbageFirstCollector methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeLocals
	| threshold occupancy first max current headroom |
	first := oldZone == nil.
	oldZone := memory old.
	forwarderOffset := oldZone regionSize.
	threshold := (forwarderOffset * 2 * 0.8) asInteger.
	occupancy := oldZone occupancy.
	max := oldZone regionCount.
	headroom := oldZone availableBytes * 9 // 10.
	evacuated := ByteArray new: occupancy size.
	first ifFalse: [
		current := oldZone currentSpace.
		1 to: max do: [:i | | used space size |
			used := occupancy at: i.
			(0 < used and: [used < threshold]) ifTrue: [
				space := oldZone spaces at: i.
				used := space usedBytes.
				(space !!== current and: [headroom > used]) ifTrue: [
					headroom := headroom - used.
					size := space reservedSize.
					Kernel os commit: size * 2 at: space base + size * 2.
					evacuated at: i put: 1]]]].
	super initializeLocals
! !

!GarbageFirstCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
releaseLocals
	oldZone releaseEvacuated: evacuated.
	forwarderOffset := evacuated := nil.
	self resetCountdown.
	super releaseLocals
! !

!GarbageFirstCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
resetCountdown
	| garbage bytes available young |
	garbage := oldZone commitedBytes - oldZone occupiedBytes.
	bytes := (oldZone usedBytes * 0.25) asInteger - garbage.
	available := oldZone availableBytes * 9 // 10.
	young := memory eden reservedBytes + memory from reservedBytes.
	countdown := (25 mbytes max: bytes) min: available - young
! !

!GarbageFirstCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
tenured: anInteger
	countdown := countdown - anInteger
! !

!GarbageFirstCollector methodsFor:  'cleaning' stamp: 'KenD 28/Jun/2026 13:27:39'!
updateWeak: weakContainer at: anInteger
	| object updated |
	object := weakContainer _basicAt: anInteger.
	object _isSmallInteger ifTrue: [^self].
	object _hasBeenSeen
		ifFalse: [^weakContainer _basicAt: anInteger put: tombstone].
	(self hasToEvacuate: object) ifFalse: [^self].
	updated := self copyOf: object.
	weakContainer _basicAt: anInteger put: updated
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'GarbageFirstCollector class' category: #Kernel!
GarbageFirstCollector class
	instanceVariableNames: ''!


GarbageFirstCollector initialize!

