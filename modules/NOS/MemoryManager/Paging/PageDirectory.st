Class {
	#name : #PageDirectory,
	#superclass : #PageIndex,
	#category : 'SqueakNOS-MemoryManager-Paging'
}

{ #category : #'instance creation' }
PageDirectory class >> entriesCount: aNumber entrySize: anotherNumber pageTables: anOrderedCollection [
	^(super entriesCount: aNumber entrySize: anotherNumber) pageTables: anOrderedCollection
]

{ #category : #copying }
PageDirectory >> deepCopy [
	| pageTables readOnlyTables |
	pageTables := self pageTables.
	readOnlyTables := OrderedCollection new: pageTables size.
	pageTables do: [:table | readOnlyTables add: (PageTable fromTable: table)].
	^self class entriesCount: self entriesCount entrySize: self entrySize pageTables: readOnlyTables
]

{ #category : #'memory management' }
PageDirectory >> free [
	self halt.
	self entries do: [:entry | entry free].
	super free.
]

{ #category : #'initialize-release' }
PageDirectory >> initialize [ 
	super initialize.
	"self entries withIndexDo: [:entry :index | entry clean. entry setPresentAndSupervisor]"
]

{ #category : #accessing }
PageDirectory >> pageTableAtIndex: aNumber [
	| entry |
	entry := self entryFor: aNumber.
	^entry isPresentAndAllowed ifTrue: [ | alien |
		alien := Alien forPointer: entry pointedAddress. 
		PageTable handledBy: alien entriesCount: self entriesCount entrySize: self entrySize. 
	] ifFalse: [(self error: 'PageFault')]
]

{ #category : #private }
PageDirectory >> pageTables [
	| records tables size entries |
	tables := OrderedCollection new: self entriesCount.
	1 to: self entriesCount do: [:index | tables add: (self pageTableAtIndex: index - 1)].
	^tables
]

{ #category : #private }
PageDirectory >> pageTables: anOrderedCollection [
	(self entries first: anOrderedCollection size) withIndexDo: [:entry : index | entry pageFrame: (anOrderedCollection at: index) externalAddress; setPresentAndWritable]
]

{ #category : #printing }
PageDirectory >> printOn: aStream [
	self entries withIndexDo: [ :entry :index | 
		aStream nextPutAll: 'Table ', index printString, ': ', entry printString; cr.
	]
]

{ #category : #services }
PageDirectory >> readOnly [
	self pageTables do: [:pageTable | pageTable readOnly]
]

{ #category : #services }
PageDirectory >> readOnlyFrom: start to: end [
	| interval |
	interval := start to: end.
	self pageTables select: [:pageTable | interval rangeIncludes: pageTable ] thenDo: [:pageTable | pageTable readOnly]
]
