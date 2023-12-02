Class {
	#name : #PageTable,
	#superclass : #PageIndex,
	#category : 'SqueakNOS-MemoryManager-Paging'
}

{ #category : #'instance creation' }
PageTable class >> fromTable: aPageTable [
	| count alien |
	count := aPageTable entriesCount * aPageTable entrySize.
	alien := Alien newCPageAligned: count.
	alien copyInto: alien from: 1 to: count in: aPageTable handle startingAt: 1.
	^self handledBy: alien entriesCount: aPageTable entriesCount entrySize: aPageTable entrySize 
]

{ #category : #'instance creation' }
PageTable class >> fromTable: aPageTable size: aNumber [
	^(self newCPageAligned: aNumber) copyInto: self from: 0 to: aNumber - 1 in: aPageTable startingAt: 0
]

{ #category : #copying }
PageTable >> deepCopy [
	| entries size count alien |
	entries := self entriesCount.
	size := self entrySize.
	count :=  entries * size.
	alien := Alien newCPageAligned: count.
	alien copyInto: alien from: 1 to: count in: self handle startingAt: 1.
	^self class handledBy: alien entriesCount: entries entrySize: size
]

{ #category : #'initialize-release' }
PageTable >> identityMappingStartingAt: address pageSize: aNumber [
	self entries withIndexDo: [:entry :index | entry clean; setPresentAndWritable; pageFrame: (index - 1) * aNumber + address]
	
]

{ #category : #testing }
PageTable >> isPresentAndAllowed:  aNumber [
	| entry |
	entry := self entryFor: aNumber.
	^entry isPresentAndAllowed
]

{ #category : #translation }
PageTable >> phisicalAddressFor: aNumber [
	| entry |
	entry := self entryFor: aNumber.
	^entry pointedAddress
]

{ #category : #printing }
PageTable >> printOn: aStream [
	self entries withIndexDo: [ :entry :index | 
		aStream nextPutAll: 'Page ', index printString, ': ', entry printString; cr.
	]
]

{ #category : #services }
PageTable >> readOnly [
	self entries do: [:entry | entry readOnly]
]
