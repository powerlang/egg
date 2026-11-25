'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PageIndex category: 'SqueakNOS-MemoryManager-Paging'!
Object subclass: #PageIndex
	instanceVariableNames: 'handle entriesCount entrySize'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-MemoryManager-Paging'!
!PageIndex methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
contents
	| result |
	result := ByteArray new: self entriesCount * self entrySize.
	self handle copyInto: result from: 1 to: result size in: self handle startingAt: 1.
	^result
! !

!PageIndex methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
contentsFrom: start to: stop
	| result |
	result := ByteArray new: stop - start + 1.
	self handle copyInto: result from: 1 to: result size in: self handle startingAt: start.
	^result
! !

!PageIndex methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
entries
	| count entries |
	count := self entriesCount.
	entries := OrderedCollection new: count.
	0 to: count - 1 do: [:index | | record | 
			entries add: (self entryFor: index)].
	^entries
! !

!PageIndex methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
entriesCount
	^entriesCount
! !

!PageIndex methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
entriesCount: aNumber
	entriesCount := aNumber
! !

!PageIndex methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
entriesFromIndex: start
	| entries stop |
	stop := self entriesCount.
	entries := OrderedCollection new: stop - start + 1.
	(start to: stop) do: [:index | entries add: (self entryFor: index)].
	^entries
! !

!PageIndex methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
entriesFromIndex: start to: stop
	| entries |
	entries := OrderedCollection new: stop - start + 1.
	(start to: stop) do: [:index | entries add: (self entryFor: index)].
	^entries
! !

!PageIndex methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
entriesUptoIndex: stop
	| entries |
	entries := OrderedCollection new: stop.
	(1 to: stop) do: [:index | entries add: (self entryFor: index)].
	^entries
! !

!PageIndex methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
entryFor: anIndex
	| address handler |
	address := self externalAddressFor: anIndex.
	handler := Alien forPointer: address. 
	^PageTableEntry handledBy: handler
! !

!PageIndex methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
entrySize
	^entrySize
! !

!PageIndex methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
entrySize: aNumber
	entrySize := aNumber
! !

!PageIndex methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
externalAddress
	^handle address
! !

!PageIndex methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
externalAddressFor: anIndex
	^self externalAddress + (self entrySize * anIndex)
! !

!PageIndex methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
handle
	^handle

! !

!PageIndex methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
handle: anExternalHandler
	handle := anExternalHandler
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PageIndex class' category: 'SqueakNOS-MemoryManager-Paging'!
PageIndex class
	instanceVariableNames: ''!

!PageIndex class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
entriesCount: aNumber entrySize: anotherNumber
	| alien |
	alien := (Alien newCPageAligned: aNumber * anotherNumber).
	^self handledBy: alien entriesCount: aNumber entrySize: anotherNumber
! !

!PageIndex class methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
handledBy: externalHandle entriesCount: aNumber entrySize: anotherNumber
	^self new handle: externalHandle; entriesCount: aNumber; entrySize: anotherNumber
! !


