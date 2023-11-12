Class {
	#name : #FAT32Cluster,
	#superclass : #Object,
	#instVars : [
		'contents'
	],
	#category : #'SqueakNOS-Filesystems-FAT32'
}

{ #category : #'instance creation' }
FAT32Cluster class >> contents: aStream [
	^self new contents: aStream.
]

{ #category : #private }
FAT32Cluster >> add: aFAT32ClusterRecord at: anIndex [
	| start bytes |
	start := self recordSize * (anIndex - 1).
	bytes := aFAT32ClusterRecord contents.
	contents replaceFrom: start to: start + bytes size - 1 with: bytes startingAt: 1
]

{ #category : #private }
FAT32Cluster >> addEndOfDirectoryRecord [
	| index record |
	index := self firstFreeRecordIndex.
	record := self recordAt: index.
	record beEndOfDirectory.
]

{ #category : #services }
FAT32Cluster >> addFirstClusterToFileNamed: aString cluster: aNumber [
	| index record |
	index := self indexOfRecordNamed: aString.
	record := self recordAt: index.
	record firstCluster: aNumber
]

{ #category : #private }
FAT32Cluster >> addRecordNamed: aString firstCluster: aNumber [
	| index record addEndOfDirectoryRecord |
	index := self firstFreeRecordIndex.
	addEndOfDirectoryRecord := (index = 1 or: [(self recordAt: index) isEndOfDirectory and: [(index = self lastIndex) not]]).
	record := self recordAt: index.
	record name: aString; firstCluster: aNumber.
	addEndOfDirectoryRecord ifTrue: [self addEndOfDirectoryRecord].
	^record
	
]

{ #category : #services }
FAT32Cluster >> allRecords [
	^ (1 to: self lastIndex) collect: [ :i | self recordAt: i ]
]

{ #category : #services }
FAT32Cluster >> at: index count: amount [
	^ contents segmentFrom: index to: index + amount - 1
]

{ #category : #services }
FAT32Cluster >> bytes: aNumber [
	contents position: 0. 
	^contents next: aNumber
]

{ #category : #services }
FAT32Cluster >> bytes: aNumber startingAt: anotherNumber [
	contents position: anotherNumber. 
	^contents next: aNumber
]

{ #category : #accesing }
FAT32Cluster >> contents [
	^ contents
]

{ #category : #accesing }
FAT32Cluster >> contents: bytes [
	contents := bytes
]

{ #category : #services }
FAT32Cluster >> directoryRecords [
	^self records select: [:record | (record isUnused not and: [record isVFat not]) and: [record isDirectory]]
]

{ #category : #services }
FAT32Cluster >> fileRecords [
	^self records select: [:record | (record isUnused not and: [record isVFat not]) and: [record isFile]]
]

{ #category : #services }
FAT32Cluster >> firstFreeRecordIndex [
	self allRecords withIndexDo: [:record :index | (record isUnused or: [record isEndOfDirectory]) ifTrue: [^index]].
	self error: 'aaaa'
]

{ #category : #private }
FAT32Cluster >> firstIndex [
	^1
]

{ #category : #testing }
FAT32Cluster >> hasFreeRecords [
	| records |
	records := self allRecords.
	^(records anySatisfy: [:record | record isUnused]) or: [records anySatisfy: [:record | record isEndOfDirectory]].
]

{ #category : #testing }
FAT32Cluster >> hasRecord: id [
	^self allRecords anySatisfy: [:record | (record firstCluster = id)].
	
]

{ #category : #testing }
FAT32Cluster >> hasRecordNamed: aString [
	^self allRecords anySatisfy: [:record | (record name asLowercase = aString asLowercase)].
	
]

{ #category : #private }
FAT32Cluster >> identifierOfRecordNamed: aString [
	self records withIndexDo: [:record :index | (record name asLowercase = aString asLowercase) ifTrue: [^record firstCluster]].
	self error: 'Not found'
]

{ #category : #private }
FAT32Cluster >> indexOfRecord: id [
	self records withIndexDo: [:record :index | (record firstCluster = id) ifTrue: [^index]].
	self error: 'Not found'
]

{ #category : #private }
FAT32Cluster >> indexOfRecordNamed: aString [
	self records withIndexDo: [:record :index | (record name asLowercase = aString asLowercase) ifTrue: [^index]].
	self error: 'Not found'
]

{ #category : #'initialize-release' }
FAT32Cluster >> initializeUnused [
	self allRecords do: [:record | record free]
]

{ #category : #private }
FAT32Cluster >> lastIndex [
	^self size // self recordSize
]

{ #category : #services }
FAT32Cluster >> record: id [
	| index |
	index := self indexOfRecord: id.
	^self recordAt: index
]

{ #category : #services }
FAT32Cluster >> recordAt: index [
	| size start bytes |
	size := self recordSize.
	start := (index - 1) * size.
	bytes := contents segmentFrom: start + 1  size: size.
	^ FAT32ClusterRecord contents: bytes
]

{ #category : #services }
FAT32Cluster >> recordNamed: aString [
	| index |
	index := self indexOfRecordNamed: aString.
	^self recordAt: index
]

{ #category : #private }
FAT32Cluster >> recordSize [
	^32
]

{ #category : #services }
FAT32Cluster >> records [
	^self allRecords reject: [:record | record isUnused or: [record isEndOfDirectory]]
]

{ #category : #services }
FAT32Cluster >> removeRecord: id [
	| record |
	record := self record: id.
	record free
	
]

{ #category : #services }
FAT32Cluster >> removeRecordNamed: aString [
	| record |
	record := self recordNamed: aString.
	record free
	
]

{ #category : #accesing }
FAT32Cluster >> size [
	^contents size
]

{ #category : #services }
FAT32Cluster >> updateSizeOfFileNamed: aString with: aNumber [
	| index record |
	index := self indexOfRecordNamed: aString.
	record := self recordAt: index.
	record size: aNumber
]

{ #category : #services }
FAT32Cluster >> writeFrom: start with: stringOrByteArray startingAt: otherStart count: count [
	contents
		replaceFrom: start to: start + count - 1 with: stringOrByteArray startingAt: otherStart.
	^ count
]
