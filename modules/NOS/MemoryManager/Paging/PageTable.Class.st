'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PageTable category: 'SqueakNOS-MemoryManager-Paging'!
PageIndex subclass: #PageTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-MemoryManager-Paging'!
!PageTable methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:32:24'!
deepCopy
	| entries size count alien |
	entries := self entriesCount.
	size := self entrySize.
	count :=  entries * size.
	alien := Alien newCPageAligned: count.
	alien copyInto: alien from: 1 to: count in: self handle startingAt: 1.
	^self class handledBy: alien entriesCount: entries entrySize: size
! !

!PageTable methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:24'!
identityMappingStartingAt: address pageSize: aNumber
	self entries withIndexDo: [:entry :index | entry clean; setPresentAndWritable; pageFrame: (index - 1) * aNumber + address]
	
! !

!PageTable methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isPresentAndAllowed: aNumber
	| entry |
	entry := self entryFor: aNumber.
	^entry isPresentAndAllowed
! !

!PageTable methodsFor:  'translation' stamp: 'KenD 28/Jun/2026 13:32:24'!
phisicalAddressFor: aNumber
	| entry |
	entry := self entryFor: aNumber.
	^entry pointedAddress
! !

!PageTable methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream
	self entries withIndexDo: [ :entry :index | 
		aStream nextPutAll: 'Page ', index printString, ': ', entry printString; cr.
	]
! !

!PageTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
readOnly
	self entries do: [:entry | entry readOnly]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PageTable class' category: 'SqueakNOS-MemoryManager-Paging'!
PageTable class
	instanceVariableNames: ''!

!PageTable class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
fromTable: aPageTable
	| count alien |
	count := aPageTable entriesCount * aPageTable entrySize.
	alien := Alien newCPageAligned: count.
	alien copyInto: alien from: 1 to: count in: aPageTable handle startingAt: 1.
	^self handledBy: alien entriesCount: aPageTable entriesCount entrySize: aPageTable entrySize 
! !

!PageTable class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
fromTable: aPageTable size: aNumber
	^(self newCPageAligned: aNumber) copyInto: self from: 0 to: aNumber - 1 in: aPageTable startingAt: 0
! !


