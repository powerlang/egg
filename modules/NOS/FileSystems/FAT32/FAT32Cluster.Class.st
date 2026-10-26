'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #FAT32Cluster category: 'SqueakNOS-Filesystems-FAT32'!
Object subclass: #FAT32Cluster
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Filesystems-FAT32'!
!FAT32Cluster methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
add: aFAT32ClusterRecord at: anIndex
	| start bytes |
	start := self recordSize * (anIndex - 1).
	bytes := aFAT32ClusterRecord contents.
	contents replaceFrom: start to: start + bytes size - 1 with: bytes startingAt: 1
! !

!FAT32Cluster methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
addEndOfDirectoryRecord
	| index record |
	index := self firstFreeRecordIndex.
	record := self recordAt: index.
	record beEndOfDirectory.
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
addFirstClusterToFileNamed: aString cluster: aNumber
	| index record |
	index := self indexOfRecordNamed: aString.
	record := self recordAt: index.
	record firstCluster: aNumber
! !

!FAT32Cluster methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
addRecordNamed: aString firstCluster: aNumber
	| index record addEndOfDirectoryRecord |
	index := self firstFreeRecordIndex.
	addEndOfDirectoryRecord := (index = 1 or: [(self recordAt: index) isEndOfDirectory and: [(index = self lastIndex) not]]).
	record := self recordAt: index.
	record name: aString; firstCluster: aNumber.
	addEndOfDirectoryRecord ifTrue: [self addEndOfDirectoryRecord].
	^record
	
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
allRecords
	^ (1 to: self lastIndex) collect: [ :i | self recordAt: i ]
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: index count: amount
	^ contents segmentFrom: index to: index + amount - 1
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: aNumber
	contents position: 0. 
	^contents next: aNumber
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytes: aNumber startingAt: anotherNumber
	contents position: anotherNumber. 
	^contents next: aNumber
! !

!FAT32Cluster methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents
	^ contents
! !

!FAT32Cluster methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents: bytes
	contents := bytes
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
directoryRecords
	^self records select: [:record | (record isUnused not and: [record isVFat not]) and: [record isDirectory]]
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
fileRecords
	^self records select: [:record | (record isUnused not and: [record isVFat not]) and: [record isFile]]
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
firstFreeRecordIndex
	self allRecords withIndexDo: [:record :index | (record isUnused or: [record isEndOfDirectory]) ifTrue: [^index]].
	self error: 'aaaa'
! !

!FAT32Cluster methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
firstIndex
	^1
! !

!FAT32Cluster methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hasFreeRecords
	| records |
	records := self allRecords.
	^(records anySatisfy: [:record | record isUnused]) or: [records anySatisfy: [:record | record isEndOfDirectory]].
! !

!FAT32Cluster methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hasRecord: id
	^self allRecords anySatisfy: [:record | (record firstCluster = id)].
	
! !

!FAT32Cluster methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hasRecordNamed: aString
	^self allRecords anySatisfy: [:record | (record name asLowercase = aString asLowercase)].
	
! !

!FAT32Cluster methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
identifierOfRecordNamed: aString
	self records withIndexDo: [:record :index | (record name asLowercase = aString asLowercase) ifTrue: [^record firstCluster]].
	self error: 'Not found'
! !

!FAT32Cluster methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
indexOfRecord: id
	self records withIndexDo: [:record :index | (record firstCluster = id) ifTrue: [^index]].
	self error: 'Not found'
! !

!FAT32Cluster methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
indexOfRecordNamed: aString
	self records withIndexDo: [:record :index | (record name asLowercase = aString asLowercase) ifTrue: [^index]].
	self error: 'Not found'
! !

!FAT32Cluster methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:25'!
initializeUnused
	self allRecords do: [:record | record free]
! !

!FAT32Cluster methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
lastIndex
	^self size // self recordSize
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
record: id
	| index |
	index := self indexOfRecord: id.
	^self recordAt: index
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
recordAt: index
	| size start bytes |
	size := self recordSize.
	start := (index - 1) * size.
	bytes := contents segmentFrom: start + 1  size: size.
	^ FAT32ClusterRecord contents: bytes
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
recordNamed: aString
	| index |
	index := self indexOfRecordNamed: aString.
	^self recordAt: index
! !

!FAT32Cluster methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
recordSize
	^32
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
records
	^self allRecords reject: [:record | record isUnused or: [record isEndOfDirectory]]
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
removeRecord: id
	| record |
	record := self record: id.
	record free
	
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
removeRecordNamed: aString
	| record |
	record := self recordNamed: aString.
	record free
	
! !

!FAT32Cluster methodsFor:  'accesing' stamp: 'KenD 28/Jun/2026 13:32:25'!
size
	^contents size
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
updateSizeOfFileNamed: aString with: aNumber
	| index record |
	index := self indexOfRecordNamed: aString.
	record := self recordAt: index.
	record size: aNumber
! !

!FAT32Cluster methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
writeFrom: start with: stringOrByteArray startingAt: otherStart count: count
	contents
		replaceFrom: start to: start + count - 1 with: stringOrByteArray startingAt: otherStart.
	^ count
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FAT32Cluster class' category: 'SqueakNOS-Filesystems-FAT32'!
FAT32Cluster class
	instanceVariableNames: ''!

!FAT32Cluster class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents: aStream
	^self new contents: aStream.
! !


