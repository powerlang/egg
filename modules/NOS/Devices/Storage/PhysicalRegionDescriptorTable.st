Class {
	#name : #PhysicalRegionDescriptorTable,
	#superclass : #Object,
	#instVars : [
		'address',
		'nextEntry'
	],
	#category : #'SqueakNOS-Devices-Storage'
}

{ #category : #initialization }
PhysicalRegionDescriptorTable >> address [
	^address asInteger 

]

{ #category : #initialization }
PhysicalRegionDescriptorTable >> advanceEntry [
	nextEntry := nextEntry = self size ifTrue: [ 1 ] ifFalse: [ nextEntry + 1 ].
 
]

{ #category : #initialization }
PhysicalRegionDescriptorTable >> atNextFreeEntryPutSize: size address: target [
	| offset encoded |
	offset := self offsetOfEntry: nextEntry.
	encoded := size = 65536 ifTrue: [ 0 ] ifFalse:  [ size ].
	address unsignedLongAt: 1 + offset put: target; unsignedLongAt: 1 + offset + 4 put: encoded.
]

{ #category : #initialization }
PhysicalRegionDescriptorTable >> beEndOfTransferAt: entry [
	| offset |
	offset := self offsetOfEntry: entry.
	address byteAt: 1 + offset + 7 put: 16r80.
]

{ #category : #initialization }
PhysicalRegionDescriptorTable >> initialize [
	| size aligned |
	nextEntry := 1.
	size := 64 * 1024.
	address := ExternalAddress allocate: size * 2 - 1.
	aligned := address asInteger alignedTo: size.
	address fromInteger: aligned.
	"1 to: size do: [:i | address byteAt: i put: 0 ]"
]

{ #category : #initialization }
PhysicalRegionDescriptorTable >> markEndOfTransfer [
	| entry |
	entry := nextEntry = 1 ifTrue: [ self size ] ifFalse: [ nextEntry - 1 ].
	self beEndOfTransferAt: entry 
]

{ #category : #initialization }
PhysicalRegionDescriptorTable >> offsetOfEntry: entry [
	^entry - 1 * 8
]

{ #category : #initialization }
PhysicalRegionDescriptorTable >> reset [
	nextEntry := 1.

]

{ #category : #initialization }
PhysicalRegionDescriptorTable >> size [
	^64 * 1024 // 8
	
]
