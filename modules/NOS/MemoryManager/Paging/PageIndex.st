Class {
	#name : #PageIndex,
	#superclass : #Object,
	#instVars : [
		'handle',
		'entriesCount',
		'entrySize'
	],
	#category : 'SqueakNOS-MemoryManager-Paging'
}

{ #category : #'instance creation' }
PageIndex class >> entriesCount: aNumber entrySize: anotherNumber [
	| alien |
	alien := (Alien newCPageAligned: aNumber * anotherNumber).
	^self handledBy: alien entriesCount: aNumber entrySize: anotherNumber
]

{ #category : #private }
PageIndex class >> handledBy:  externalHandle entriesCount: aNumber entrySize: anotherNumber [
	^self new handle: externalHandle; entriesCount: aNumber; entrySize: anotherNumber
]

{ #category : #accessing }
PageIndex >> contents [
	| result |
	result := ByteArray new: self entriesCount * self entrySize.
	self handle copyInto: result from: 1 to: result size in: self handle startingAt: 1.
	^result
]

{ #category : #accessing }
PageIndex >> contentsFrom: start to: stop [
	| result |
	result := ByteArray new: stop - start + 1.
	self handle copyInto: result from: 1 to: result size in: self handle startingAt: start.
	^result
]

{ #category : #accessing }
PageIndex >> entries [
	| count entries |
	count := self entriesCount.
	entries := OrderedCollection new: count.
	0 to: count - 1 do: [:index | | record | 
			entries add: (self entryFor: index)].
	^entries
]

{ #category : #accessing }
PageIndex >> entriesCount [ 
	^entriesCount
]

{ #category : #accessing }
PageIndex >> entriesCount: aNumber [
	entriesCount := aNumber
]

{ #category : #accessing }
PageIndex >> entriesFromIndex: start [ 
	| entries stop |
	stop := self entriesCount.
	entries := OrderedCollection new: stop - start + 1.
	(start to: stop) do: [:index | entries add: (self entryFor: index)].
	^entries
]

{ #category : #accessing }
PageIndex >> entriesFromIndex: start to: stop [
	| entries |
	entries := OrderedCollection new: stop - start + 1.
	(start to: stop) do: [:index | entries add: (self entryFor: index)].
	^entries
]

{ #category : #accessing }
PageIndex >> entriesUptoIndex: stop [ 
	| entries |
	entries := OrderedCollection new: stop.
	(1 to: stop) do: [:index | entries add: (self entryFor: index)].
	^entries
]

{ #category : #accessing }
PageIndex >> entryFor: anIndex [
	| address handler |
	address := self externalAddressFor: anIndex.
	handler := Alien forPointer: address. 
	^PageTableEntry handledBy: handler
]

{ #category : #accessing }
PageIndex >> entrySize [
	^entrySize
]

{ #category : #accessing }
PageIndex >> entrySize: aNumber [
	entrySize := aNumber
]

{ #category : #private }
PageIndex >> externalAddress [
	^handle address
]

{ #category : #private }
PageIndex >> externalAddressFor: anIndex [
	^self externalAddress + (self entrySize * anIndex)
]

{ #category : #private }
PageIndex >> handle [
	^handle

]

{ #category : #private }
PageIndex >> handle: anExternalHandler [
	handle := anExternalHandler
]
