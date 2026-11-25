'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PageDirectory category: 'SqueakNOS-MemoryManager-Paging'!
PageIndex subclass: #PageDirectory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-MemoryManager-Paging'!
!PageDirectory methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:32:24'!
deepCopy
	| pageTables readOnlyTables |
	pageTables := self pageTables.
	readOnlyTables := OrderedCollection new: pageTables size.
	pageTables do: [:table | readOnlyTables add: (PageTable fromTable: table)].
	^self class entriesCount: self entriesCount entrySize: self entrySize pageTables: readOnlyTables
! !

!PageDirectory methodsFor:  'memory management' stamp: 'KenD 28/Jun/2026 13:32:24'!
free
	self halt.
	self entries do: [:entry | entry free].
	super free.
! !

!PageDirectory methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	"self entries withIndexDo: [:entry :index | entry clean. entry setPresentAndSupervisor]"
! !

!PageDirectory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageTableAtIndex: aNumber
	| entry |
	entry := self entryFor: aNumber.
	^entry isPresentAndAllowed ifTrue: [ | alien |
		alien := Alien forPointer: entry pointedAddress. 
		PageTable handledBy: alien entriesCount: self entriesCount entrySize: self entrySize. 
	] ifFalse: [(self error: 'PageFault')]
! !

!PageDirectory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageTables
	| records tables size entries |
	tables := OrderedCollection new: self entriesCount.
	1 to: self entriesCount do: [:index | tables add: (self pageTableAtIndex: index - 1)].
	^tables
! !

!PageDirectory methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageTables: anOrderedCollection
	(self entries first: anOrderedCollection size) withIndexDo: [:entry : index | entry pageFrame: (anOrderedCollection at: index) externalAddress; setPresentAndWritable]
! !

!PageDirectory methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:32:24'!
printOn: aStream
	self entries withIndexDo: [ :entry :index | 
		aStream nextPutAll: 'Table ', index printString, ': ', entry printString; cr.
	]
! !

!PageDirectory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
readOnly
	self pageTables do: [:pageTable | pageTable readOnly]
! !

!PageDirectory methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
readOnlyFrom: start to: end
	| interval |
	interval := start to: end.
	self pageTables select: [:pageTable | interval rangeIncludes: pageTable ] thenDo: [:pageTable | pageTable readOnly]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PageDirectory class' category: 'SqueakNOS-MemoryManager-Paging'!
PageDirectory class
	instanceVariableNames: ''!

!PageDirectory class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
entriesCount: aNumber entrySize: anotherNumber pageTables: anOrderedCollection
	^(super entriesCount: aNumber entrySize: anotherNumber) pageTables: anOrderedCollection
! !


PageDirectory initialize!

