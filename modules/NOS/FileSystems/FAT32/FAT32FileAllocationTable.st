Class {
	#name : #FAT32FileAllocationTable,
	#superclass : #Object,
	#instVars : [
		'chains',
		'contents'
	],
	#category : 'SqueakNOS-Filesystems-FAT32'
}

{ #category : #'instance creation' }
FAT32FileAllocationTable class >> contents: aStream [
	^self new contents: aStream.
]

{ #category : #services }
FAT32FileAllocationTable >> addCluster: aNumber to: chainId [
	| chain last |
	chainId > 0 ifTrue: [
		chain := self chainFor: chainId.
		last := chain last.
		chain add: aNumber.
		self at: last put: aNumber].
	self at: aNumber put: self clusterChainEndValue
	
]

{ #category : #services }
FAT32FileAllocationTable >> addClusterTo: chainStart [
	| last index chain |
	last := chainStart > 0 ifTrue: 
		[(self clustersChainFor: chainStart) last]
	 ifFalse:
		 [0].
	index := self firstFreeClusterSince: last.
	"Transcript show: 'Adding cluster: ', index printString, 'to: ', chainStart printString, Character cr."
	self addCluster: index to: chainStart.
	^index
]

{ #category : #accessing }
FAT32FileAllocationTable >> at: index [
	"fat indexes are 0-based"
	^ contents unsignedLongAt: index * 4 + 1
]

{ #category : #accessing }
FAT32FileAllocationTable >> at: index put: value [
	"fat indexes are 0-based"

	contents unsignedLongAt: index * 4 + 1 put: value
]

{ #category : #accessing }
FAT32FileAllocationTable >> cache: aNumber with: anOrderedCollection [
	chains at: aNumber put: anOrderedCollection
]

{ #category : #services }
FAT32FileAllocationTable >> cachedChain: aNumber preferredSize: aPreferredSize [
	^(self hasCached: aNumber)
		ifTrue:  [ ^self chainFor: aNumber ]
		ifFalse: [ | chain | 
				 chain := self internalClusterChainFor: aNumber preferredSize: aPreferredSize.
				 self cache: aNumber with: chain.
				 ^chain ]

]

{ #category : #private }
FAT32FileAllocationTable >> chainFor: aNumber [
	^chains at: aNumber
]

{ #category : #accessing }
FAT32FileAllocationTable >> clusterChainEndValue [
	^16r0FFFFFF8.

]

{ #category : #services }
FAT32FileAllocationTable >> clustersChainFor: aNumber [
	^self clustersChainFor: aNumber preferredSize: 0
]

{ #category : #services }
FAT32FileAllocationTable >> clustersChainFor: aNumber preferredSize: aPreferredSize [
	^(self cachedChain: aNumber preferredSize: aPreferredSize) copy.

]

{ #category : #services }
FAT32FileAllocationTable >> clustersChainNoCopyFor: aClusterNumber preferredSize: aSize [
	^(self cachedChain: aClusterNumber preferredSize: aSize).	

]

{ #category : #accessing }
FAT32FileAllocationTable >> contents: bytes [
	contents := bytes
]

{ #category : #accessing }
FAT32FileAllocationTable >> countOfClusters [
	^contents size // self recordSize
]

{ #category : #accessing }
FAT32FileAllocationTable >> finishClustersChainValue [
	| bytes |
	bytes := (ByteArray new: 4).
	bytes unsignedLongAt: 1 put: 16r0FFFFFFF.	
	^bytes
]

{ #category : #services }
FAT32FileAllocationTable >> firstFreeClusterSince: aNumber [
	| current limit entry |
	current := aNumber max: 2.
	limit := aNumber - 1.
	[
	entry := self at: current.
	entry isZero ] whileFalse: [
		current = limit ifTrue: [ self error: 'No more free space on filesystem' ].
		current := current + 1.
		current = self countOfClusters ifTrue: [ current := 2 ].
	].
	^current
]

{ #category : #testing }
FAT32FileAllocationTable >> hasCached: aNumber [
	^chains includesKey: aNumber
]

{ #category : #'initialize-release' }
FAT32FileAllocationTable >> initialize [
	chains := Dictionary new.
]

{ #category : #services }
FAT32FileAllocationTable >> internalClusterChainFor: chainId preferredSize: aPreferredSize [
	| chain next end  |
	next := chainId.
	chain := OrderedCollection new: aPreferredSize.
	end := self clusterChainEndValue.
	[ next := next bitAnd: 16r0FFFFFFF.
	next < end ]
		whileTrue: [ next = 0
				ifTrue: [ self error: 'broken FAT: found empty cluster while following cluster chain' ].
			chain add: next.
			next := self at: next ].
	^ chain
]

{ #category : #accessing }
FAT32FileAllocationTable >> nextClusterFor: index [
	self setPositionTo: index.
	^self nextRecord unsignedLongAt: 1.
]

{ #category : #private }
FAT32FileAllocationTable >> nextRecord [
	^contents next: self recordSize
]

{ #category : #services }
FAT32FileAllocationTable >> point: aFatClusterNumber to: anotherFatClusterNumber [
	"Alter the FAT so that it's cluster number aFatClusterNumber points to anotherFatClusterNumber"
	| bytes |
	self setPositionTo: aFatClusterNumber.
	bytes := (ByteArray new: 4).
	bytes unsignedLongAt: 1 put: anotherFatClusterNumber.
	contents nextPutAll: bytes.
]

{ #category : #accessing }
FAT32FileAllocationTable >> recordSize [
	^4
]

{ #category : #accessing }
FAT32FileAllocationTable >> removeChainOf: id [
	| chain |
	chain := self clustersChainFor: id.
	chain do: [:index | self at: index put: 0]
]

{ #category : #accessing }
FAT32FileAllocationTable >> resetAllEntries [
	| size |
	size := self recordSize.
	self
		at: 1 put: 16r0FFFFFF8;
		at: 2 put: 16r0FFFFFFF
]

{ #category : #services }
FAT32FileAllocationTable >> setPositionTo: aNumber [
	contents position: aNumber * self recordSize. 
	
]

{ #category : #services }
FAT32FileAllocationTable >> shrinkClusterChainOf: aNumber to: length [
	| chain size toRemove last |
	chain := self clustersChainFor: aNumber.
	size := chain size.
	size > length ifFalse: [^self].
	toRemove := length - size.
	last := chain at: length.
	self at: last put: self clusterChainEndValue. 
	chain := chain last: toRemove.
	chain do: [:index | self at: index put: 0].
	

]
