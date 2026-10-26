'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #FAT32FileSystem category: 'SqueakNOS-Filesystems-FAT32'!
Object subclass: #FAT32FileSystem
	instanceVariableNames: 'contents bootRecordCache fat clusterContents stream offsetToPartition flushProcess'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Filesystems-FAT32'!
!FAT32FileSystem commentStamp: '<historical>' prior: 0!

A FAT32FileSystem is the one who interacts with a FAT32 partition. It has a stream pointing to a disk
and the offset to the start point of one of its' partitions.

Instance Variables
	offsetToPartition: offset to partition
	stream:		a stream pointing to a disk.

!

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
addClusterTo: aFilesystemContent
	| index id |
	id := aFilesystemContent identifier.
	index := fat addClusterTo: id.
	aFilesystemContent isDirectory ifTrue: [(self clusterAt: index) initializeUnused].	
	^index
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
addClustersTo: aFilesystemContent count: aNumber
	| clusters |
	Transcript show: 'adding ', aNumber printString, ' clusters to file.', Character cr asString.
	clusters := OrderedCollection new.
	aNumber timesRepeat: [clusters add: (self addClusterTo: aFilesystemContent)].
	^clusters
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
addFirstClusterTo: aFilesystemContent
	| index cluster |
	index := self addClusterTo: aFilesystemContent.
	aFilesystemContent identifier: index.
	cluster := self clusterForFileNamed: aFilesystemContent name onDirectory: aFilesystemContent directory.
	cluster addFirstClusterToFileNamed: aFilesystemContent name cluster: index
	
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
adjacentClustersListFrom: clusters do: aBlock
	| clusterStartNumber numberOfClusters |
	clusters size = 0 ifTrue: [^self].
	clusterStartNumber := clusters first.
	numberOfClusters := 1.
	2 to: clusters size do: [ :i | | cluster |
		cluster := clusters at: i.	
		(clusterStartNumber + numberOfClusters = cluster) 
			ifTrue: [ numberOfClusters := numberOfClusters + 1]
			ifFalse: [ aBlock value: clusterStartNumber value: numberOfClusters. 
					numberOfClusters := 1. 
					clusterStartNumber := cluster]
	].
	aBlock value: clusterStartNumber value: numberOfClusters.
	
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
as83Format: aString
	| index name extension |
	index := aString findFirst: [:char | char = $.].
	name := index > 7 ifTrue: [aString first: 8] ifFalse: [(aString first: index - 1) , ((String new: 8 - index + 1) atAllPut: $ ) ].
	extension := aString size - index > 3 ifTrue: [aString copyFrom: index + 1 to: index + 3] ifFalse: [(aString copyFrom: index + 1 to: aString size) , ((String new: 3 - (aString size - index)) atAllPut: $ ) ].
	^name , extension. 
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bootRecord
	^ bootRecordCache ifNil: [ bootRecordCache := FAT32BootRecord bytes: (contents copyFrom: 1 to: 512) ]
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytesPerCluster
	^self sectorsPerCluster * self bytesPerSector
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytesPerFAT
	^self sectorsPerFAT * self bytesPerSector
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
bytesPerSector
	^self bootRecord bytesPerSector
! !

!FAT32FileSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
cleanExtraSpace: id
	| clusters |
	clusters := self clustersNeededFor: id size.
	fat shrinkClusterChainOf: id identifier to: clusters
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
clusterAt: index
	| start bytes |
	start := self positionOfCluster: index.

	bytes := clusterContents segmentFrom: start size: self bytesPerCluster.
	^ FAT32Cluster contents: bytes
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
clusterForFile: aFile onDirectory: aDirectory
	| chain |
	chain := self clustersChainFor: aDirectory.
	chain do: [:number | | cluster | 
		cluster := self clusterAt: number.
		(cluster hasRecord: aFile identifier) ifTrue: [^cluster]].
	self error:'cluster not found!!'
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
clusterForFileNamed: aString onDirectory: aDirectory
	| chain |
	chain := self clustersChainFor: aDirectory.
	chain do: [:number | | cluster | 
		cluster := self clusterAt: number.
		(cluster hasRecordNamed: aString) ifTrue: [^cluster]].
	self error:'cluster not found!!'
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
clusterNumberWithFreeRecordsFor: aDirectory
	| chain |
	chain := self clustersChainFor: aDirectory.
	^chain 
		detect: [:number | (self clusterAt: number) hasFreeRecords]
	 	ifNone: [self addClusterTo: aDirectory]
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
clusterWithFileNamed: aString for: aDirectory
	| chain |
	chain := self clustersChainFor: aDirectory.
	^chain detect: [:number | (self clusterAt: number) hasRecordNamed: aString]
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
clustersBeginOffset
	^self fatBeginOffset + (self numberOfCopiesOfFAT * self bytesPerFAT)
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
clustersChainFor: aFileSystemContent
	| clusters count |
	count := aFileSystemContent isFile ifTrue: [
		(aFileSystemContent size / self bytesPerCluster) ceiling.
	] ifFalse: [0].
	^fat clustersChainFor: aFileSystemContent identifier preferredSize: count.

! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
clustersChainNoCopyFor: aFileSystemContent
	| count |
	count := aFileSystemContent isFile
		ifTrue: [ (aFileSystemContent size / self bytesPerCluster) ceiling ]
		ifFalse: [ 0 ].
	^ fat clustersChainNoCopyFor: aFileSystemContent identifier preferredSize: count
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
clustersCount
	^(bootRecordCache numberOfSectorsInPartition - (self numberOfCopiesOfFAT * self bytesPerFAT / self bytesPerSector + self reservedSectors)) / self sectorsPerCluster.
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
clustersNeededFor: aNumber
	^(aNumber / self bytesPerCluster) ceiling
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents: bytes
	contents:= bytes
! !

!FAT32FileSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
contentsFor: aFile startingAt: position count: count
	| bytesPerCluster size clusterOffset needed clusters |
	
	bytesPerCluster := self bytesPerCluster.
	aFile identifier > 0 ifFalse: [^ByteArray new].
	size := count min: aFile size.
	clusterOffset := position \\ bytesPerCluster.
	needed := (size + clusterOffset / bytesPerCluster) ceiling.
	clusters := self clustersChainFor: aFile.
	clusters removeFirst: position // bytesPerCluster.
	clusters size >= needed ifTrue: [clusters removeLast: clusters size - needed].
	^self readFromClusters: clusters startingAt: clusterOffset count: size.

! !

!FAT32FileSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
createFileNamed: aString on: aDirectory
	| cluster record number name |
	name := aString size > 11 ifTrue: [self pureFAT32FilenameFor: aString] 
							     ifFalse: [aString].
	number := self clusterNumberWithFreeRecordsFor: aDirectory.
	cluster := self clusterAt: number.
	contents := 	fat firstFreeClusterSince: 2.
	fat addCluster: contents to: 0.
	record := cluster addRecordNamed: (self as83Format: name) firstCluster: contents.
	^NOSFile named: record name identifier: record firstCluster filesystem: self directory: aDirectory size: record size
! !

!FAT32FileSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
directoriesFor: aDirectory
	| cluster directories clusters subdirs|
	directories := OrderedCollection new.
	clusters := self clustersChainFor: aDirectory.
	clusters do: [ :aNumber |
		cluster := self clusterAt: aNumber.
		subdirs := (cluster directoryRecords 
			select: [:record | record isInternal not]
			thenCollect: [:record | NOSDirectory 
												named: record name
												identifier: record firstCluster
												filesystem: self
												directory: aDirectory]).
		directories addAll: subdirs
	].
	^directories
! !

!FAT32FileSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
directoryNamed: aString
	| components current |
	components := aString findTokens: $/.
	components isEmpty ifTrue: [^nil].
	current := self root.
	components do: [ :name |
		current := current directories detect: [:directory | directory name asLowercase = name] ifNone: [^nil].
	].
	^current
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
fatBeginOffset
	^self reservedSectors * self bytesPerSector
	

! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
fatFinishClustersChainValue
	^fat finishClustersChainValue
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
fatOffset
	^self reservedSectors * self bytesPerSector
	

! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
fatRecordSize
	^fat recordSize
! !

!FAT32FileSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
filesFor: aDirectory
	| cluster files clusters subfiles |
	files := OrderedCollection new.
	clusters := self clustersChainFor: aDirectory.
	clusters
		do: [ :aNumber | 
			cluster := self clusterAt: aNumber.
			subfiles := cluster fileRecords
				collect: [ :record | 
					NOSFile
						named: record name
						identifier: record firstCluster
						filesystem: self
						directory: aDirectory
						size: record size ].
			files addAll: subfiles ].
	^ files
! !

!FAT32FileSystem methodsFor:  'flushing' stamp: 'KenD 28/Jun/2026 13:32:25'!
flushProcess
	^ [ (Delay forSeconds: 10) wait.
	fat flushChanges.
	self flushClusterChanges ] fork
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
format
	| sectors boot |
	sectors := contents size / 512.
	boot := FAT32BootRecord bytes: (contents segmentFrom: 1 to: 512).
	boot initializeWithDefaultValues; numberOfSectorsInPartition: sectors.
	self open.
	fat resetAllEntries
! !

!FAT32FileSystem methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	super initialize
! !

!FAT32FileSystem methodsFor:  'formatting' stamp: 'KenD 28/Jun/2026 13:32:25'!
nameFormat: aString
	^self pureFAT32FilenameFor: aString
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
numberOfCopiesOfFAT
	^self bootRecord numberOfCopiesOfFAT
! !

!FAT32FileSystem methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
open
	| fatContents fatEnd clusterStart |
	self bootRecord verifySignature.
	fatEnd := self fatOffset + (self clustersCount * 4).
	fatContents := contents segmentFrom: self fatOffset + 1 to: fatEnd - 1.
	fat := FAT32FileAllocationTable contents: fatContents.
	clusterStart := self clustersBeginOffset - (self bytesPerCluster * 2) + 1.
	clusterContents := contents segmentFrom: clusterStart to: contents size - 1
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
positionOfCluster: index
	"cluster numbers are 0-based"
	^index * self bytesPerCluster + 1
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printOn: out
	"Answer the value of stream"

	out nextPutAll: 'FAT32FileSystem'; cr;
		nextPutAll: 'Begin of FAT: ', self fatBeginOffset hex; cr;
		nextPutAll: 'Begin of data clusters: ', self clustersBeginOffset hex; cr; cr;
		nextPutAll: bootRecordCache printString; cr; cr;
		nextPutAll: self root printString.
	 
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
printStringOf: aDirectory
	| cluster clusters out |

	out := ReadWriteStream on: ''.
	clusters := self clustersChainFor: aDirectory.
	clusters do: [ :aNumber |
		cluster := self clusterAt: aNumber.
		cluster fileRecords do: [ :record |
			out nextPutAll: 'File: ', record name;
				nextPutAll: ', first cluster: '; << record firstCluster;
				nextPutAll: ', size: '; << record size; nextPut: Character cr ].
	].
	 
	^out contents.
! !

!FAT32FileSystem methodsFor:  'formatting' stamp: 'KenD 28/Jun/2026 13:32:25'!
pureFAT32FilenameFor: aFileName
	| path basename extension finalName |
	path := aFileName asFileReference path.
	basename := path base. 
	extension := path extension.
	(basename size > self class basenameMaxSize or: [extension size > self class extensionMaxSize]) ifTrue: [
		basename := (basename first: self class basenameTruncationIndex) , '~1'
	].
	extension := extension copyFrom: 1 to: (extension size min: self class extensionMaxSize).
	finalName := (extension size > 0) ifTrue: [ basename , '.' , extension ] ifFalse: [ basename ].
	^ (String streamContents: [:str | (path parent / finalName) asFileReference gtDisplayOn: str]) 
	
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
readFromClusters: clusters startingAt: offset count: count
	| startOffset contentsIndex cluster bytes result qty remaining |
	result := ByteArray new: count.
	startOffset := offset.
	contentsIndex := 1.
	remaining := count.
	clusters do: [ :clusterNumber |
			cluster := self clusterAt: clusterNumber.
			qty := cluster size - startOffset min: remaining. 
			bytes := cluster at: startOffset + 1 count: qty.
			result replaceFrom: contentsIndex to: contentsIndex + qty - 1 with: bytes.
			startOffset := 0.
			remaining := remaining - qty.
			contentsIndex := contentsIndex + qty].
	^result
	
	
! !

!FAT32FileSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
removeFileNamed: aString on: aDirectory
	| cluster number id name |
	name := self pureFAT32FilenameFor: aString.
	number := self clusterWithFileNamed: name  for: aDirectory.
	cluster := self clusterAt: number.
	id := cluster identifierOfRecordNamed: name.
	cluster removeRecordNamed: name.
	id > 0 ifTrue: [fat removeChainOf: id]
	
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
reservedSectors
	^self bootRecord reservedSectors
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
root
	^NOSDirectory identifier: self bootRecord clusterNumberOfStartOfRootDir filesystem: self 
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
sectorsPerCluster
	^self bootRecord sectorsPerCluster
! !

!FAT32FileSystem methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
sectorsPerFAT
	^self bootRecord sectorsPerFAT
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
startOfClusterSectors
	^(self numberOfCopiesOfFAT * self bytesPerFAT) / self bytesPerSector + self reservedSectors.
! !

!FAT32FileSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
truncateClusterChainOf: aFile newSize: aNumber
	| clusterSize  clusters needed |
	clusterSize := self bytesPerCluster.
	clusters := self clustersChainFor: aFile.
	needed := (aNumber / clusterSize) ceiling.
	
	needed <= clusters size ifTrue: [clusters removeLast: clusters size - needed]

! !

!FAT32FileSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
updateSizeOf: aFile with: aNumber
 	| cluster |
	self truncateClusterChainOf: aFile newSize: aNumber.
	cluster := self clusterForFile: aFile onDirectory: aFile directory.
	cluster updateSizeOfFileNamed: aFile name with: aNumber.
	aFile size: aNumber
! !

!FAT32FileSystem methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
writeClusters: clusters startingAt: start with: bytes startingAt: bytesStart count: count
	| written offset toWrite |
	written := 0.
	offset := start - 1.
	self
		adjacentClustersListFrom: clusters
		do: [ :clusterStartNumber :numberOfClusters | 
			| cluster index |
			toWrite := numberOfClusters * self bytesPerCluster - offset min: count - written.
			index := self positionOfCluster: clusterStartNumber.
			clusterContents
				replaceFrom: index + offset
				to: index + offset + toWrite - 1
				with: bytes
				startingAt: bytesStart + written.
			offset := 0.
			written := written + toWrite ].
	^ written
! !

!FAT32FileSystem methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
writeOn: aFile startingAt: aFileOffset contents: bytes startingAt: bytesStart count: count
	"notice: aFileOffset  is zero indexed, anotherNumber is not"
	| helper firstIndex lastIndex clusters |

	helper := BlockArithmetic new size: self bytesPerCluster.
	firstIndex := helper blockNumberOf: aFileOffset + 1.
	lastIndex := helper blockNumberOf: aFileOffset + count.
	
	aFile identifier = 0 ifTrue: [self addFirstClusterTo: aFile].
	
	clusters := self clustersChainNoCopyFor: aFile.
	lastIndex > clusters size ifTrue: [ self addClustersTo: aFile count: lastIndex - clusters size].
	
	^self writeClusters: (clusters copyFrom: firstIndex to: lastIndex)
		   startingAt: (helper positionInBlockOf: aFileOffset + 1)
	  	   with: bytes asByteArray startingAt: bytesStart count: count.	
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FAT32FileSystem class' category: 'SqueakNOS-Filesystems-FAT32'!
FAT32FileSystem class
	instanceVariableNames: ''!

!FAT32FileSystem class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:32:25'!
basenameMaxSize
	^8
! !

!FAT32FileSystem class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:32:25'!
basenameTruncationIndex
	^self basenameMaxSize - 2
! !

!FAT32FileSystem class methodsFor:  'constants' stamp: 'KenD 28/Jun/2026 13:32:25'!
extensionMaxSize
	^3
! !

!FAT32FileSystem class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
join: path to: finalName
	^((path = '') ifFalse: [path, FileDirectory slash] ifTrue: ['']), finalName.
! !

!FAT32FileSystem class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
of: aDiskStream partition: aNumber readOnly: beReadOnly
	"We asume sector size of 512 to make things easier for now."
	aDiskStream binary. "With this we make #next: return ByteArrays and no ByteStrings"
	
	beReadOnly ifTrue: [aDiskStream readOnly] ifFalse: [aDiskStream readWrite].
	
	^(self new stream: aDiskStream; offsetToPartition: 
		((MasterBootRecord of: aDiskStream) offsetToPartition: 1 sectorSize: 512)) initializeFAT.
! !

!FAT32FileSystem class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
on: bytes
	^ (self new contents: bytes)
! !


FAT32FileSystem initialize!

