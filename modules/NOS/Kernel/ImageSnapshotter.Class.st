'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #ImageSnapshotter category: 'SqueakNOS-Kernel'!
Object subclass: #ImageSnapshotter
	instanceVariableNames: 'computer savedPages'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Kernel'!
!ImageSnapshotter methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
computer: aComputer
	computer := aComputer
! !

!ImageSnapshotter methodsFor:  'handling strategies' stamp: 'KenD 28/Jun/2026 13:32:25'!
copyOnWriteHandlingBlock
	^[ :anAddress :handler |	| directoryEntry pageEntry table newTable contents start manager |
		manager := computer memoryManager.
		directoryEntry := manager pageDirectoryEntryFor: anAddress.
		directoryEntry isPresentAndAllowed ifFalse: [self error: 'Que fachemo si viene el fault en el directory?'].
		pageEntry := manager pageTableEntryFor: anAddress.
		pageEntry isPresentAndForbidden ifFalse: [pageEntry isPresent ifTrue: [self] ifFalse: [ handler doDefaultHandlingFor: anAddress ]]
			ifTrue:[
				contents := self pageContentsOf: anAddress.
				start := manager pageStartAddressOf: anAddress.
				savedPages at: start put: contents. 
				pageEntry setPresentAndWritable
		]
	]
	
! !

!ImageSnapshotter methodsFor:  'internal' stamp: 'KenD 28/Jun/2026 13:32:25'!
imageFileStreamForWrite
	| filesystem image contents directory name bytearray |
	filesystem := computer primaryFilesystem.
	directory := filesystem root.
	name := Smalltalk imageName.
	image := (directory fileExists: name) ifTrue: [directory fileNamed: name] ifFalse: [directory newFileNamed: name]. 
	^image writeStream
! !

!ImageSnapshotter methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
imageMemoryReadOnlyPageContents: aNumber
	| size address contents manager |
	manager := computer memoryManager.
	size := manager pageSize.	
	address := self objectMemoryStartAddress + (aNumber - 1 * size) bitAnd: 16rFFFFF000.	
	^savedPages at: address ifAbsent: [
		(computer kernelPageAt: address) ifNotNilDo: [:page | page contents] ifNil: [
			contents := (Buffer at: address size: 4096) contents. 			
			(manager pageTableEntryFor: address) readWrite.
			contents := (computer kernelPageAt: address) ifNil: [contents].
			contents		
		]
	]
! !

!ImageSnapshotter methodsFor:  'internal' stamp: 'KenD 28/Jun/2026 13:32:25'!
imagePagesCount
	| image pageSize startAddress rest firstSpace addendum |
	image := self size.
	pageSize := computer memoryManager pageSize. 
	startAddress := self objectMemoryStartAddress.
	addendum := 0.
	startAddress isPageAligned ifFalse: [
		rest := (image \\ pageSize).
		firstSpace := (startAddress bitOr: 16r00000FFF) - startAddress.
		(firstSpace > rest) ifFalse: [addendum := 1].
	].
	^(image / pageSize) ceiling + addendum
! !

!ImageSnapshotter methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	savedPages := Dictionary new.
! !

!ImageSnapshotter methodsFor:  'internal' stamp: 'KenD 28/Jun/2026 13:32:25'!
objectMemoryStartAddress
	^self startAddress + Smalltalk headerSize
! !

!ImageSnapshotter methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: aComputer
	^self new computer: aComputer
! !

!ImageSnapshotter methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
pageContentsOf: anAddress
	| start |
	start := computer memoryManager pageStartAddressOf: anAddress.
	^(Buffer at: start size: computer memoryManager pageSize) contents
! !

!ImageSnapshotter methodsFor:  'internal' stamp: 'KenD 28/Jun/2026 13:32:25'!
postPagedSnapshot

! !

!ImageSnapshotter methodsFor:  'internal' stamp: 'KenD 28/Jun/2026 13:32:25'!
postSnapshot
	"self postClonedSnapshot"
	self postPagedSnapshot
	
! !

!ImageSnapshotter methodsFor:  'internal' stamp: 'KenD 28/Jun/2026 13:32:25'!
preSnapshot
	"self prepareForClonedSnapshot"
	
! !

!ImageSnapshotter methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
prepareToWriteSnapshot
	| pageFaultHandler start | 
	computer setSnapshotEndAddress.
	computer memoryManager ifNotNil: [ :manager | 
		pageFaultHandler := PageFaultHandler manager: manager.
		pageFaultHandler handlingBlock: self copyOnWriteHandlingBlock.
		start := computer imageStartAddress.
		manager from: start to: start + 100000000 useHandler: pageFaultHandler.
		computer resetSnapshotInfo
	]
! !

!ImageSnapshotter methodsFor:  'internal' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^computer snapshotEndAddress 
! !

!ImageSnapshotter methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
snapshot
	| imageCopy memory aStream |
	self preSnapshot.
	aStream := self imageFileStreamForWrite. 
	aStream binary.
	self writeHeaderOn: aStream fromMemory: computer snapshotStartAddress.
	self writeObjectMemory: aStream.
	aStream truncate: computer snapshotEndAddress + Smalltalk headerSize; close.
	self postSnapshot
! !

!ImageSnapshotter methodsFor:  'internal' stamp: 'KenD 28/Jun/2026 13:32:25'!
startAddress
	^computer imageStartAddress
! !

!ImageSnapshotter methodsFor:  'internal' stamp: 'KenD 28/Jun/2026 13:32:25'!
writeHeaderOn: aStream fromMemory: anAddress
	| contents |
	contents := Buffer at: anAddress size: Smalltalk headerSize.
	aStream nextPutAll: contents contents
! !

!ImageSnapshotter methodsFor:  'as yet unclassified' stamp: 'KenD 28/Jun/2026 13:32:25'!
writeObjectMemory: aStream
	| startAddress firstPageOffset pages lastAddress lastPageLimit |
	pages := self imagePagesCount.
	startAddress := self objectMemoryStartAddress.
	firstPageOffset := startAddress - (startAddress bitAnd: 16rFFFFF000).
	aStream nextPutAll: ((self imageMemoryReadOnlyPageContents: 1) allButFirst: firstPageOffset).
	2 to: pages - 1 do: [:index | | memory |
		index \\ 1000 = 0  ifTrue: [Computer show: 'Writing page number ', index asString].
		aStream nextPutAll: (self imageMemoryReadOnlyPageContents: index)
	].
	lastAddress := startAddress + self size.
	lastPageLimit := lastAddress - (lastAddress bitAnd: 16rFFFFF000).
	aStream nextPutAll: ((self imageMemoryReadOnlyPageContents: pages) first: lastPageLimit)
! !

!ImageSnapshotter methodsFor:  'internal' stamp: 'KenD 28/Jun/2026 13:32:25'!
writeObjectMemory: aStream fromClonedSnapshotOn: anAddress
	| contents |
	contents := Buffer at: computer snapshotStartAddress size: computer snapshotEndAddress. 
	aStream nextPutAll: contents contents
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ImageSnapshotter class' category: 'SqueakNOS-Kernel'!
ImageSnapshotter class
	instanceVariableNames: ''!


ImageSnapshotter initialize!

