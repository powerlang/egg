Class {
	#name : #ImageSnapshotter,
	#superclass : #Object,
	#instVars : [
		'computer',
		'savedPages'
	],
	#category : 'SqueakNOS-Kernel'
}

{ #category : #accessing }
ImageSnapshotter >> computer: aComputer [
	computer := aComputer
]

{ #category : #'handling strategies' }
ImageSnapshotter >> copyOnWriteHandlingBlock [
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
	
]

{ #category : #internal }
ImageSnapshotter >> imageFileStreamForWrite [
	| filesystem image contents directory name bytearray |
	filesystem := computer primaryFilesystem.
	directory := filesystem root.
	name := Smalltalk imageName.
	image := (directory fileExists: name) ifTrue: [directory fileNamed: name] ifFalse: [directory newFileNamed: name]. 
	^image writeStream
]

{ #category : #'as yet unclassified' }
ImageSnapshotter >> imageMemoryReadOnlyPageContents: aNumber [	
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
]

{ #category : #internal }
ImageSnapshotter >> imagePagesCount [
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
]

{ #category : #'as yet unclassified' }
ImageSnapshotter >> initialize [
	savedPages := Dictionary new.
]

{ #category : #internal }
ImageSnapshotter >> objectMemoryStartAddress [
	^self startAddress + Smalltalk headerSize
]

{ #category : #'methodsFor:' }
ImageSnapshotter >> on: aComputer [
	^self new computer: aComputer
]

{ #category : #services }
ImageSnapshotter >> pageContentsOf: anAddress [
	| start |
	start := computer memoryManager pageStartAddressOf: anAddress.
	^(Buffer at: start size: computer memoryManager pageSize) contents
]

{ #category : #internal }
ImageSnapshotter >> postPagedSnapshot [

]

{ #category : #internal }
ImageSnapshotter >> postSnapshot [
	"self postClonedSnapshot"
	self postPagedSnapshot
	
]

{ #category : #internal }
ImageSnapshotter >> preSnapshot [
	"self prepareForClonedSnapshot"
	
]

{ #category : #services }
ImageSnapshotter >> prepareToWriteSnapshot [ 
	| pageFaultHandler start | 
	computer setSnapshotEndAddress.
	computer memoryManager ifNotNil: [ :manager | 
		pageFaultHandler := PageFaultHandler manager: manager.
		pageFaultHandler handlingBlock: self copyOnWriteHandlingBlock.
		start := computer imageStartAddress.
		manager from: start to: start + 100000000 useHandler: pageFaultHandler.
		computer resetSnapshotInfo
	]
]

{ #category : #internal }
ImageSnapshotter >> size [
	^computer snapshotEndAddress 
]

{ #category : #services }
ImageSnapshotter >> snapshot [
	| imageCopy memory aStream |
	self preSnapshot.
	aStream := self imageFileStreamForWrite. 
	aStream binary.
	self writeHeaderOn: aStream fromMemory: computer snapshotStartAddress.
	self writeObjectMemory: aStream.
	aStream truncate: computer snapshotEndAddress + Smalltalk headerSize; close.
	self postSnapshot
]

{ #category : #internal }
ImageSnapshotter >> startAddress [
	^computer imageStartAddress
]

{ #category : #internal }
ImageSnapshotter >> writeHeaderOn: aStream fromMemory: anAddress [
	| contents |
	contents := Buffer at: anAddress size: Smalltalk headerSize.
	aStream nextPutAll: contents contents
]

{ #category : #'as yet unclassified' }
ImageSnapshotter >> writeObjectMemory: aStream [
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
]

{ #category : #internal }
ImageSnapshotter >> writeObjectMemory: aStream fromClonedSnapshotOn: anAddress [
	| contents |
	contents := Buffer at: computer snapshotStartAddress size: computer snapshotEndAddress. 
	aStream nextPutAll: contents contents
]
