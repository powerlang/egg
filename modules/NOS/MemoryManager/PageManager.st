Class {
	#name : #PageManager,
	#superclass : #MemoryManagerStrategy,
	#instVars : [
		'directory',
		'handlers',
		'pageHandled',
		'interrupted',
		'pageFaultCallback'
	],
	#category : 'SqueakNOS-Memory-Manager'
}

{ #category : #private }
PageManager >> defaultPageFaultHandler [ 
	^PageFaultHandler manager: self.
]

{ #category : #accesing }
PageManager >> directory [
	^directory
]

{ #category : #private }
PageManager >> directory: aPageDirectory [
	directory := aPageDirectory
]

{ #category : #services }
PageManager >> from: startAddress to: stopAddress useHandler: aPageFaultHandler [
	handlers at: (startAddress to: stopAddress) put: aPageFaultHandler
]

{ #category : #private }
PageManager >> handlerFor: anAddress [
	| interval intervals |
	handlers keys isEmpty ifTrue: [^self defaultPageFaultHandler].  
	intervals := handlers keys select: [:int | int includes: anAddress].
	interval := intervals isEmpty 
	ifTrue: [Computer show: 'No handling interval for address ', anAddress printString. Computer show: handlers printString. 0] 
	ifFalse: [intervals min].
	^handlers at: interval
	
	
	

]

{ #category : #'initialize-release' }
PageManager >> identityMapping [ 
	| tables space count |
	space := self pageTableMappedSpace.
	count := self pageTablesCount.
	tables := OrderedCollection new: count.
	1 to: count do: [:i | 
		| table | table := PageTable entriesCount: self pageTableEntriesCount entrySize: self pageTableEntrySize. 
						 table identityMappingStartingAt: (i - 1) * space pageSize: self pageSize.
						 tables add: table.
	].
	directory := PageDirectory entriesCount: count entrySize: 4 pageTables: tables.

]

{ #category : #'initialize-release' }
PageManager >> initialize [ 
	super initialize.
	handlers := Dictionary new.
	pageHandled := Semaphore new.
	interrupted := Semaphore new.
	

	
		
]

{ #category : #'initialize-release' }
PageManager >> installCallbackOn: aComputer [
	| callback |
	pageFaultCallback := Callback block: [:args :result | "Project spawnNewProcessIfThisIsUICallback: Processor activeProcess"
													    pageHandled wait. 
													    result returnInteger: 1]
								    argsClass: PageFaultParameters.
	aComputer info pageFaultHandlerEntry: pageFaultCallback thunk address.
	Computer primRegisterSemaphoreIndex: (Smalltalk registerExternalObject: interrupted) forIRQ: 15. 
	[[true] whileTrue: [
		interrupted wait. "this is activated by C glue code"
		self resolvePageFaultOn: aComputer pageFaultAddress.
		pageHandled signal]
	] forkAt: Processor highIOPriority + 1
]

{ #category : #'initialize-release' }
PageManager >> installOn: aComputer [ 
	self installCallbackOn: aComputer.
	processor enablePagingWithDirectory: directory externalAddress

	
		
]

{ #category : #testing }
PageManager >> isPresentAndAllowed: anAddress [
	|  table tableIndex |
	table := self pageTableFor: anAddress.
	tableIndex := self pageTableIndexFor: anAddress.
	^table isPresentAndAllowed: tableIndex
]

{ #category : #'translation-private' }
PageManager >> offsetFor: anAddress [
	^anAddress bitAnd: 16r00000FFF.
	
]

{ #category : #accesing }
PageManager >> pageDirectoryEntryFor: anAddress [
	| index |
	index := self pageDirectoryIndexFor: anAddress.
	^directory entryFor: index 
]

{ #category : #'translation-private' }
PageManager >> pageDirectoryIndexFor: anAddress [
	| shifted trunced |
	shifted := anAddress bitShift: -22.
	trunced := shifted bitAnd: 16r000003FF.
	^trunced
]

{ #category : #accesing }
PageManager >> pageSize [
	^4096
]

{ #category : #services }
PageManager >> pageStartAddressOf: anAddress. [ 
	^anAddress bitAnd: 16rFFFFF000
]

{ #category : #accesing }
PageManager >> pageTableEntriesCount [
	^1024
]

{ #category : #accesing }
PageManager >> pageTableEntriesFor: anInterval [
	|  startDirectoryIndex stopDirectoryIndex start end firstIndex lastIndex entries |
	start := anInterval first.
	end := anInterval last.
	startDirectoryIndex := self pageDirectoryIndexFor: start.
	stopDirectoryIndex := self pageDirectoryIndexFor: end.
	entries := OrderedCollection new.
	firstIndex := self pageTableIndexFor: start.
	lastIndex := self pageTableIndexFor: end.
	startDirectoryIndex = stopDirectoryIndex ifTrue: [
		entries addAll: ((directory pageTableAtIndex: startDirectoryIndex) entriesFromIndex: firstIndex to: lastIndex).
	] ifFalse: [
		entries addAll: ((directory pageTableAtIndex: startDirectoryIndex) entriesFromIndex: firstIndex);
				addAll: ((directory pageTableAtIndex: stopDirectoryIndex) entriesUptoIndex: lastIndex).		
		startDirectoryIndex + 1 to: stopDirectoryIndex - 1 do: [:index |
			entries addAll: (directory pageTableAtIndex: index) entries
		]
	].
	^entries
	
	
]

{ #category : #accesing }
PageManager >> pageTableEntryFor: anAddress [
	| table index |
	table := self pageTableFor: anAddress.
	index := self pageTableIndexFor: anAddress.
	^table entryFor: index 
]

{ #category : #accesing }
PageManager >> pageTableEntrySize [
	^4
]

{ #category : #accesing }
PageManager >> pageTableFor: anAddress [
	| directoryIndex tableIndex |
	directoryIndex := self pageDirectoryIndexFor: anAddress.
	^directory pageTableAtIndex: directoryIndex.
	
]

{ #category : #'translation-private' }
PageManager >> pageTableIndexFor: anAddress [
	| shifted trunced |
	shifted := anAddress bitShift: -12.
	trunced := shifted bitAnd: 16r000003FF.
	^trunced
]

{ #category : #accesing }
PageManager >> pageTableMappedSpace [ 
	^self pageSize * self pageTableEntriesCount
]

{ #category : #accesing }
PageManager >> pageTablesCount [ 
	| size space |
	"size := self memory size."
	size := 1024 * 1024 * 1024 * 4.
	space := self pageTableMappedSpace.
	^(size / space) ceiling.
	
]

{ #category : #services }
PageManager >> readOnly [
	directory readOnly
]

{ #category : #services }
PageManager >> readOnlyFrom: start to: end [
	(self pageTableEntriesFor: (start to: end)) do: [:entry | entry readOnly]
]

{ #category : #services }
PageManager >> readWriteFrom: start to: end [
	(self pageTableEntriesFor: (start to: end)) do: [:entry | entry readWrite]
]

{ #category : #'page faults' }
PageManager >> resolvePageFaultOn: anAddress [
	| handler |
	handler := self handlerFor: anAddress.
	handler resolvePageFaultOn: anAddress
	
]

{ #category : #translation }
PageManager >> translate: anAddress [
	| directoryIndex tableIndex offset table address |
	directoryIndex := self pageDirectoryIndexFor: anAddress.
	tableIndex := self pageTableIndexFor: anAddress.
	offset := self offsetFor: anAddress.
	table := directory pageTableAtIndex: directoryIndex.
	address := table phisicalAddressFor: tableIndex.
	^address + offset
]
