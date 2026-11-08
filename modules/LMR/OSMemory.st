"
	Copyright (c) 2026, Javier Pimas.
	See (MIT) license in root directory.
"

Class {
	#name : #OSMemory,
	#superclass : #Object,
	#instVars : [
		'reservations',
		'released'
	],
	#classVars : [
		'Current'
	],
	#category : #Kernel
}

{ #category : #accessing }
OSMemory class >> current [
	^Current
]

{ #category : #initialization }
OSMemory class >> initializeCurrent [
	Current := self new initialize
]

{ #category : #services }
OSMemory >> commit: size at: address [
	^Kernel host commit: size at: address
]

{ #category : #services }
OSMemory >> decommit: address [
	^self decommit: address size: (self sizeAt: address)
]

{ #category : #services }
OSMemory >> decommit: address size: size [
	^Kernel host decommit: address size: size
]

{ #category : #initialization }
OSMemory >> initialize [
	reservations := Array new: 256.
	released := Array new: 256
]

{ #category : #services }
OSMemory >> lastError [
	^self _error: 'the heap block is exhausted'
]

{ #category : #private }
OSMemory >> pairAt: anObject in: anArray ifAbsent: aBlock [
	1 to: anArray size by: 2 do: [:i | (anArray at: i) = anObject ifTrue: [^i]].
	^aBlock value
]

{ #category : #services }
OSMemory >> release: address [
	| index size free |
	index := self pairAt: address in: reservations ifAbsent: [^false].
	size := reservations at: index + 1.
	(self decommit: address size: size) ifFalse: [^false].
	reservations
		at: index put: nil;
		at: index + 1 put: nil.
	free := self pairAt: nil in: released ifAbsent: [^true].
	released
		at: free put: address;
		at: free + 1 put: size.
	^true
]

{ #category : #services }
OSMemory >> reserve: size [
	| bytes index address |
	bytes := size alignedTo: self reservationAlignment.
	index := self pairAt: nil in: reservations ifAbsent: [^0].
	address := self takeReleased: bytes.
	address = 0 ifTrue: [address := self takeFree: bytes].
	address = 0 ifTrue: [^0].
	reservations
		at: index put: address;
		at: index + 1 put: bytes.
	^address
]

{ #category : #services }
OSMemory >> reserveAndCommit: size [
	| reserved |
	reserved := self reserve: size.
	reserved = 0 ifTrue: [^0].
	^self commit: (self sizeAt: reserved) at: reserved
]

{ #category : #private }
OSMemory >> reservationAlignment [
	^16r10000
]

{ #category : #private }
OSMemory >> sizeAt: address [
	^reservations
		at: (self pairAt: address in: reservations ifAbsent: [^self _error: 'no memory was reserved there'])
			+ 1
]

{ #category : #private }
OSMemory >> takeFree: bytes [
	| address next |
	address := (HostLinkage at: 4) alignedTo: self reservationAlignment.
	next := address + bytes.
	next > (HostLinkage at: 5) ifTrue: [^0].
	HostLinkage at: 4 put: next.
	^address
]

{ #category : #private }
OSMemory >> takeReleased: bytes [
	1 to: released size by: 2 do: [:i | | address size |
		address := released at: i.
		size := released at: i + 1.
		(address notNil and: [size >= bytes]) ifTrue: [
			size = bytes
				ifTrue: [released at: i put: nil; at: i + 1 put: nil]
				ifFalse: [released at: i put: address + bytes; at: i + 1 put: size - bytes].
			^address]].
	^0
]
