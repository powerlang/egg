"
A FAT32FileSystem is the one who interacts with a FAT32 partition. It has a stream pointing to a disk
and the offset to the start point of one of its' partitions.

Instance Variables
	offsetToPartition: offset to partition
	stream:		a stream pointing to a disk.

"
Class {
	#name : #FAT32FileSystem,
	#superclass : #Object,
	#instVars : [
		'contents',
		'bootRecordCache',
		'fat',
		'clusterContents',
		'stream',
		'offsetToPartition',
		'flushProcess'
	],
	#category : 'SqueakNOS-Filesystems-FAT32'
}

{ #category : #constants }
FAT32FileSystem class >> basenameMaxSize [
	^8
]

{ #category : #constants }
FAT32FileSystem class >> basenameTruncationIndex [
	^self basenameMaxSize - 2
]

{ #category : #constants }
FAT32FileSystem class >> extensionMaxSize [
	^3
]

{ #category : #services }
FAT32FileSystem class >> join: path to: finalName [
	^((path = '') ifFalse: [path, FileDirectory slash] ifTrue: ['']), finalName.
]

{ #category : #'instance creation' }
FAT32FileSystem class >> of: aDiskStream partition: aNumber readOnly: beReadOnly [
	"We asume sector size of 512 to make things easier for now."
	aDiskStream binary. "With this we make #next: return ByteArrays and no ByteStrings"
	
	beReadOnly ifTrue: [aDiskStream readOnly] ifFalse: [aDiskStream readWrite].
	
	^(self new stream: aDiskStream; offsetToPartition: 
		((MasterBootRecord of: aDiskStream) offsetToPartition: 1 sectorSize: 512)) initializeFAT.
]

{ #category : #'instance creation' }
FAT32FileSystem class >> on: bytes [
	^ (self new contents: bytes)
]

{ #category : #private }
FAT32FileSystem >> addClusterTo: aFilesystemContent [
	| index id |
	id := aFilesystemContent identifier.
	index := fat addClusterTo: id.
	aFilesystemContent isDirectory ifTrue: [(self clusterAt: index) initializeUnused].	
	^index
]

{ #category : #private }
FAT32FileSystem >> addClustersTo: aFilesystemContent count: aNumber [
	| clusters |
	Transcript show: 'adding ', aNumber printString, ' clusters to file.', Character cr asString.
	clusters := OrderedCollection new.
	aNumber timesRepeat: [clusters add: (self addClusterTo: aFilesystemContent)].
	^clusters
]

{ #category : #private }
FAT32FileSystem >> addFirstClusterTo: aFilesystemContent [
	| index cluster |
	index := self addClusterTo: aFilesystemContent.
	aFilesystemContent identifier: index.
	cluster := self clusterForFileNamed: aFilesystemContent name onDirectory: aFilesystemContent directory.
	cluster addFirstClusterToFileNamed: aFilesystemContent name cluster: index
	
]

{ #category : #private }
FAT32FileSystem >> adjacentClustersListFrom: clusters do: aBlock [
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
	
]

{ #category : #accessing }
FAT32FileSystem >> as83Format: aString [
	| index name extension |
	index := aString findFirst: [:char | char = $.].
	name := index > 7 ifTrue: [aString first: 8] ifFalse: [(aString first: index - 1) , ((String new: 8 - index + 1) atAllPut: $ ) ].
	extension := aString size - index > 3 ifTrue: [aString copyFrom: index + 1 to: index + 3] ifFalse: [(aString copyFrom: index + 1 to: aString size) , ((String new: 3 - (aString size - index)) atAllPut: $ ) ].
	^name , extension. 
]

{ #category : #accessing }
FAT32FileSystem >> bootRecord [
	^ bootRecordCache ifNil: [ bootRecordCache := FAT32BootRecord bytes: (contents copyFrom: 1 to: 512) ]
]

{ #category : #accessing }
FAT32FileSystem >> bytesPerCluster [
	^self sectorsPerCluster * self bytesPerSector
]

{ #category : #accessing }
FAT32FileSystem >> bytesPerFAT [
	^self sectorsPerFAT * self bytesPerSector
]

{ #category : #accessing }
FAT32FileSystem >> bytesPerSector [
	^self bootRecord bytesPerSector
]

{ #category : #services }
FAT32FileSystem >> cleanExtraSpace: id [
	| clusters |
	clusters := self clustersNeededFor: id size.
	fat shrinkClusterChainOf: id identifier to: clusters
]

{ #category : #private }
FAT32FileSystem >> clusterAt: index [
	| start bytes |
	start := self positionOfCluster: index.

	bytes := clusterContents segmentFrom: start size: self bytesPerCluster.
	^ FAT32Cluster contents: bytes
]

{ #category : #private }
FAT32FileSystem >> clusterForFile: aFile onDirectory: aDirectory [
	| chain |
	chain := self clustersChainFor: aDirectory.
	chain do: [:number | | cluster | 
		cluster := self clusterAt: number.
		(cluster hasRecord: aFile identifier) ifTrue: [^cluster]].
	self error:'cluster not found!'
]

{ #category : #private }
FAT32FileSystem >> clusterForFileNamed: aString onDirectory: aDirectory [
	| chain |
	chain := self clustersChainFor: aDirectory.
	chain do: [:number | | cluster | 
		cluster := self clusterAt: number.
		(cluster hasRecordNamed: aString) ifTrue: [^cluster]].
	self error:'cluster not found!'
]

{ #category : #private }
FAT32FileSystem >> clusterNumberWithFreeRecordsFor: aDirectory [
	| chain |
	chain := self clustersChainFor: aDirectory.
	^chain 
		detect: [:number | (self clusterAt: number) hasFreeRecords]
	 	ifNone: [self addClusterTo: aDirectory]
]

{ #category : #private }
FAT32FileSystem >> clusterWithFileNamed: aString for: aDirectory [
	| chain |
	chain := self clustersChainFor: aDirectory.
	^chain detect: [:number | (self clusterAt: number) hasRecordNamed: aString]
]

{ #category : #private }
FAT32FileSystem >> clustersBeginOffset [
	^self fatBeginOffset + (self numberOfCopiesOfFAT * self bytesPerFAT)
]

{ #category : #private }
FAT32FileSystem >> clustersChainFor: aFileSystemContent [
	| clusters count |
	count := aFileSystemContent isFile ifTrue: [
		(aFileSystemContent size / self bytesPerCluster) ceiling.
	] ifFalse: [0].
	^fat clustersChainFor: aFileSystemContent identifier preferredSize: count.

]

{ #category : #private }
FAT32FileSystem >> clustersChainNoCopyFor: aFileSystemContent [
	| count |
	count := aFileSystemContent isFile
		ifTrue: [ (aFileSystemContent size / self bytesPerCluster) ceiling ]
		ifFalse: [ 0 ].
	^ fat clustersChainNoCopyFor: aFileSystemContent identifier preferredSize: count
]

{ #category : #private }
FAT32FileSystem >> clustersCount [
	^(bootRecordCache numberOfSectorsInPartition - (self numberOfCopiesOfFAT * self bytesPerFAT / self bytesPerSector + self reservedSectors)) / self sectorsPerCluster.
]

{ #category : #private }
FAT32FileSystem >> clustersNeededFor: aNumber [
	^(aNumber / self bytesPerCluster) ceiling
]

{ #category : #private }
FAT32FileSystem >> contents: bytes [
	contents:= bytes
]

{ #category : #services }
FAT32FileSystem >> contentsFor: aFile startingAt: position count: count [
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

]

{ #category : #services }
FAT32FileSystem >> createFileNamed: aString on: aDirectory [
	| cluster record number name |
	name := aString size > 11 ifTrue: [self pureFAT32FilenameFor: aString] 
							     ifFalse: [aString].
	number := self clusterNumberWithFreeRecordsFor: aDirectory.
	cluster := self clusterAt: number.
	contents := 	fat firstFreeClusterSince: 2.
	fat addCluster: contents to: 0.
	record := cluster addRecordNamed: (self as83Format: name) firstCluster: contents.
	^NOSFile named: record name identifier: record firstCluster filesystem: self directory: aDirectory size: record size
]

{ #category : #services }
FAT32FileSystem >> directoriesFor: aDirectory [
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
]

{ #category : #services }
FAT32FileSystem >> directoryNamed: aString [
	| components current |
	components := aString findTokens: $/.
	components isEmpty ifTrue: [^nil].
	current := self root.
	components do: [ :name |
		current := current directories detect: [:directory | directory name asLowercase = name] ifNone: [^nil].
	].
	^current
]

{ #category : #private }
FAT32FileSystem >> fatBeginOffset [
	^self reservedSectors * self bytesPerSector
	

]

{ #category : #private }
FAT32FileSystem >> fatFinishClustersChainValue [
	^fat finishClustersChainValue
]

{ #category : #private }
FAT32FileSystem >> fatOffset [
	^self reservedSectors * self bytesPerSector
	

]

{ #category : #accessing }
FAT32FileSystem >> fatRecordSize [
	^fat recordSize
]

{ #category : #services }
FAT32FileSystem >> filesFor: aDirectory [
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
]

{ #category : #flushing }
FAT32FileSystem >> flushProcess [
	^ [ (Delay forSeconds: 10) wait.
	fat flushChanges.
	self flushClusterChanges ] fork
]

{ #category : #accessing }
FAT32FileSystem >> format [
	| sectors boot |
	sectors := contents size / 512.
	boot := FAT32BootRecord bytes: (contents segmentFrom: 1 to: 512).
	boot initializeWithDefaultValues; numberOfSectorsInPartition: sectors.
	self open.
	fat resetAllEntries
]

{ #category : #'initialize-release' }
FAT32FileSystem >> initialize [
	super initialize
]

{ #category : #formatting }
FAT32FileSystem >> nameFormat: aString [
	^self pureFAT32FilenameFor: aString
]

{ #category : #accessing }
FAT32FileSystem >> numberOfCopiesOfFAT [
	^self bootRecord numberOfCopiesOfFAT
]

{ #category : #'instance creation' }
FAT32FileSystem >> open [
	| fatContents fatEnd clusterStart |
	self bootRecord verifySignature.
	fatEnd := self fatOffset + (self clustersCount * 4).
	fatContents := contents segmentFrom: self fatOffset + 1 to: fatEnd - 1.
	fat := FAT32FileAllocationTable contents: fatContents.
	clusterStart := self clustersBeginOffset - (self bytesPerCluster * 2) + 1.
	clusterContents := contents segmentFrom: clusterStart to: contents size - 1
]

{ #category : #private }
FAT32FileSystem >> positionOfCluster: index [
	"cluster numbers are 0-based"
	^index * self bytesPerCluster + 1
]

{ #category : #accessing }
FAT32FileSystem >> printOn: out [
	"Answer the value of stream"

	out nextPutAll: 'FAT32FileSystem'; cr;
		nextPutAll: 'Begin of FAT: ', self fatBeginOffset hex; cr;
		nextPutAll: 'Begin of data clusters: ', self clustersBeginOffset hex; cr; cr;
		nextPutAll: bootRecordCache printString; cr; cr;
		nextPutAll: self root printString.
	 
]

{ #category : #accessing }
FAT32FileSystem >> printStringOf: aDirectory [
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
]

{ #category : #formatting }
FAT32FileSystem >> pureFAT32FilenameFor: aFileName [
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
	
]

{ #category : #private }
FAT32FileSystem >> readFromClusters: clusters startingAt: offset count: count [
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
	
	
]

{ #category : #services }
FAT32FileSystem >> removeFileNamed: aString on: aDirectory [
	| cluster number id name |
	name := self pureFAT32FilenameFor: aString.
	number := self clusterWithFileNamed: name  for: aDirectory.
	cluster := self clusterAt: number.
	id := cluster identifierOfRecordNamed: name.
	cluster removeRecordNamed: name.
	id > 0 ifTrue: [fat removeChainOf: id]
	
]

{ #category : #accessing }
FAT32FileSystem >> reservedSectors [
	^self bootRecord reservedSectors
]

{ #category : #accessing }
FAT32FileSystem >> root [
	^NOSDirectory identifier: self bootRecord clusterNumberOfStartOfRootDir filesystem: self 
]

{ #category : #accessing }
FAT32FileSystem >> sectorsPerCluster [
	^self bootRecord sectorsPerCluster
]

{ #category : #accessing }
FAT32FileSystem >> sectorsPerFAT [
	^self bootRecord sectorsPerFAT
]

{ #category : #private }
FAT32FileSystem >> startOfClusterSectors [
	^(self numberOfCopiesOfFAT * self bytesPerFAT) / self bytesPerSector + self reservedSectors.
]

{ #category : #services }
FAT32FileSystem >> truncateClusterChainOf: aFile newSize: aNumber [
	| clusterSize  clusters needed |
	clusterSize := self bytesPerCluster.
	clusters := self clustersChainFor: aFile.
	needed := (aNumber / clusterSize) ceiling.
	
	needed <= clusters size ifTrue: [clusters removeLast: clusters size - needed]

]

{ #category : #services }
FAT32FileSystem >> updateSizeOf: aFile with: aNumber [
 	| cluster |
	self truncateClusterChainOf: aFile newSize: aNumber.
	cluster := self clusterForFile: aFile onDirectory: aFile directory.
	cluster updateSizeOfFileNamed: aFile name with: aNumber.
	aFile size: aNumber
]

{ #category : #private }
FAT32FileSystem >> writeClusters: clusters startingAt: start with: bytes startingAt: bytesStart count: count [
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
]

{ #category : #services }
FAT32FileSystem >> writeOn: aFile startingAt: aFileOffset contents: bytes startingAt: bytesStart count: count [
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
]
