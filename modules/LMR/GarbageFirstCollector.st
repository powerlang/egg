"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #GarbageFirstCollector,
	#superclass : #NonMovingCollector,
	#instVars : [
		'oldZone',
		'evacuated',
		'forwarderOffset',
		'countdown'
	],
	#category : #Kernel
}

{ #category : #cleaning }
GarbageFirstCollector >> copyOf: anObject [
	| forwarder |
	forwarder := anObject _asPointer + forwarderOffset.
	^forwarder _asObject _basicAt: 1
]

{ #category : #cleaning }
GarbageFirstCollector >> evacuate: anObject [
	| copy forwarder |
	copy := oldZone shallowCopyCommiting: anObject.
	anObject _isRemembered ifTrue: [copy _beRemembered].
	forwarder := anObject _asPointer + forwarderOffset.
	forwarder _asObject _basicAt: 1 put: copy.
	^copy
]

{ #category : #testing }
GarbageFirstCollector >> hasReachedCountdown [
	^countdown <= 0
]

{ #category : #testing }
GarbageFirstCollector >> hasToEvacuate: anObject [
	| index |
	index := oldZone regionIndexOf: anObject.
	^index notNil and: [(evacuated at: index) > 0]
]

{ #category : #initialization }
GarbageFirstCollector >> initialize [
	countdown := 25 mbytes.
	super initialize
]

{ #category : #initialization }
GarbageFirstCollector >> initializeLocals [
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
				(space !== current and: [headroom > used]) ifTrue: [
					headroom := headroom - used.
					size := space reservedSize.
					Kernel os commit: size * 2 at: space base + size * 2.
					evacuated at: i put: 1]]]].
	super initializeLocals
]

{ #category : #cleaning }
GarbageFirstCollector >> releaseLocals [
	oldZone releaseEvacuated: evacuated.
	forwarderOffset := evacuated := nil.
	self resetCountdown.
	super releaseLocals
]

{ #category : #cleaning }
GarbageFirstCollector >> resetCountdown [
	| garbage bytes available young |
	garbage := oldZone commitedBytes - oldZone occupiedBytes.
	bytes := (oldZone usedBytes * 0.25) asInteger - garbage.
	available := oldZone availableBytes * 9 // 10.
	young := memory eden reservedBytes + memory from reservedBytes.
	countdown := (25 mbytes max: bytes) min: available - young
]

{ #category : #cleaning }
GarbageFirstCollector >> tenured: anInteger [
	countdown := countdown - anInteger
]

{ #category : #cleaning }
GarbageFirstCollector >> updateWeak: weakContainer at: anInteger [
	| object updated |
	object := weakContainer _basicAt: anInteger.
	object _isSmallInteger ifTrue: [^self].
	object _hasBeenSeen
		ifFalse: [^weakContainer _basicAt: anInteger put: tombstone].
	(self hasToEvacuate: object) ifFalse: [^self].
	updated := self copyOf: object.
	weakContainer _basicAt: anInteger put: updated
]

