'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #PageManager category: 'SqueakNOS-Memory-Manager'!
MemoryManagerStrategy subclass: #PageManager
	instanceVariableNames: 'directory handlers pageHandled interrupted pageFaultCallback'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Memory-Manager'!
!PageManager methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
defaultPageFaultHandler
	^PageFaultHandler manager: self.
! !

!PageManager methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
directory
	^directory
! !

!PageManager methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
directory: aPageDirectory
	directory := aPageDirectory
! !

!PageManager methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
from: startAddress to: stopAddress useHandler: aPageFaultHandler
	handlers at: (startAddress to: stopAddress) put: aPageFaultHandler
! !

!PageManager methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:24'!
handlerFor: anAddress
	| interval intervals |
	handlers keys isEmpty ifTrue: [^self defaultPageFaultHandler].  
	intervals := handlers keys select: [:int | int includes: anAddress].
	interval := intervals isEmpty 
	ifTrue: [Computer show: 'No handling interval for address ', anAddress printString. Computer show: handlers printString. 0] 
	ifFalse: [intervals min].
	^handlers at: interval
	
	
	

! !

!PageManager methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:24'!
identityMapping
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

! !

!PageManager methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	handlers := Dictionary new.
	pageHandled := Semaphore new.
	interrupted := Semaphore new.
	

	
		
! !

!PageManager methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:24'!
installCallbackOn: aComputer
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
! !

!PageManager methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:24'!
installOn: aComputer
	self installCallbackOn: aComputer.
	processor enablePagingWithDirectory: directory externalAddress

	
		
! !

!PageManager methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:24'!
isPresentAndAllowed: anAddress
	|  table tableIndex |
	table := self pageTableFor: anAddress.
	tableIndex := self pageTableIndexFor: anAddress.
	^table isPresentAndAllowed: tableIndex
! !

!PageManager methodsFor:  'translation-private' stamp: 'KenD 28/Jun/2026 13:32:24'!
offsetFor: anAddress
	^anAddress bitAnd: 16r00000FFF.
	
! !

!PageManager methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageDirectoryEntryFor: anAddress
	| index |
	index := self pageDirectoryIndexFor: anAddress.
	^directory entryFor: index 
! !

!PageManager methodsFor:  'translation-private' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageDirectoryIndexFor: anAddress
	| shifted trunced |
	shifted := anAddress bitShift: -22.
	trunced := shifted bitAnd: 16r000003FF.
	^trunced
! !

!PageManager methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageSize
	^4096
! !

!PageManager methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageStartAddressOf: anAddress.
	^anAddress bitAnd: 16rFFFFF000
! !

!PageManager methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageTableEntriesCount
	^1024
! !

!PageManager methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageTableEntriesFor: anInterval
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
	
	
! !

!PageManager methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageTableEntryFor: anAddress
	| table index |
	table := self pageTableFor: anAddress.
	index := self pageTableIndexFor: anAddress.
	^table entryFor: index 
! !

!PageManager methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageTableEntrySize
	^4
! !

!PageManager methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageTableFor: anAddress
	| directoryIndex tableIndex |
	directoryIndex := self pageDirectoryIndexFor: anAddress.
	^directory pageTableAtIndex: directoryIndex.
	
! !

!PageManager methodsFor:  'translation-private' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageTableIndexFor: anAddress
	| shifted trunced |
	shifted := anAddress bitShift: -12.
	trunced := shifted bitAnd: 16r000003FF.
	^trunced
! !

!PageManager methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageTableMappedSpace
	^self pageSize * self pageTableEntriesCount
! !

!PageManager methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:24'!
pageTablesCount
	| size space |
	"size := self memory size."
	size := 1024 * 1024 * 1024 * 4.
	space := self pageTableMappedSpace.
	^(size / space) ceiling.
	
! !

!PageManager methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
readOnly
	directory readOnly
! !

!PageManager methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
readOnlyFrom: start to: end
	(self pageTableEntriesFor: (start to: end)) do: [:entry | entry readOnly]
! !

!PageManager methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:24'!
readWriteFrom: start to: end
	(self pageTableEntriesFor: (start to: end)) do: [:entry | entry readWrite]
! !

!PageManager methodsFor:  'page faults' stamp: 'KenD 28/Jun/2026 13:32:24'!
resolvePageFaultOn: anAddress
	| handler |
	handler := self handlerFor: anAddress.
	handler resolvePageFaultOn: anAddress
	
! !

!PageManager methodsFor:  'translation' stamp: 'KenD 28/Jun/2026 13:32:24'!
translate: anAddress
	| directoryIndex tableIndex offset table address |
	directoryIndex := self pageDirectoryIndexFor: anAddress.
	tableIndex := self pageTableIndexFor: anAddress.
	offset := self offsetFor: anAddress.
	table := directory pageTableAtIndex: directoryIndex.
	address := table phisicalAddressFor: tableIndex.
	^address + offset
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PageManager class' category: 'SqueakNOS-Memory-Manager'!
PageManager class
	instanceVariableNames: ''!


PageManager initialize!

