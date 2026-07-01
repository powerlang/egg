'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #FAT32FileAllocationTable category: 'SqueakNOS-Filesystems-FAT32'!
Object subclass: #FAT32FileAllocationTable
	instanceVariableNames: 'chains contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Filesystems-FAT32'!
!FAT32FileAllocationTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
addCluster: aNumber to: chainId
	| chain last |
	chainId > 0 ifTrue: [
		chain := self chainFor: chainId.
		last := chain last.
		chain add: aNumber.
		self at: last put: aNumber].
	self at: aNumber put: self clusterChainEndValue
	
! !

!FAT32FileAllocationTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
addClusterTo: chainStart
	| last index chain |
	last := chainStart > 0 ifTrue: 
		[(self clustersChainFor: chainStart) last]
	 ifFalse:
		 [0].
	index := self firstFreeClusterSince: last.
	"Transcript show: 'Adding cluster: ', index printString, 'to: ', chainStart printString, Character cr."
	self addCluster: index to: chainStart.
	^index
! !

!FAT32FileAllocationTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: index
	"fat indexes are 0-based"
	^ contents unsignedLongAt: index * 4 + 1
! !

!FAT32FileAllocationTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
at: index put: value
	"fat indexes are 0-based"

	contents unsignedLongAt: index * 4 + 1 put: value
! !

!FAT32FileAllocationTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
cache: aNumber with: anOrderedCollection
	chains at: aNumber put: anOrderedCollection
! !

!FAT32FileAllocationTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
cachedChain: aNumber preferredSize: aPreferredSize
	^(self hasCached: aNumber)
		ifTrue:  [ ^self chainFor: aNumber ]
		ifFalse: [ | chain | 
				 chain := self internalClusterChainFor: aNumber preferredSize: aPreferredSize.
				 self cache: aNumber with: chain.
				 ^chain ]

! !

!FAT32FileAllocationTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
chainFor: aNumber
	^chains at: aNumber
! !

!FAT32FileAllocationTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
clusterChainEndValue
	^16r0FFFFFF8.

! !

!FAT32FileAllocationTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
clustersChainFor: aNumber
	^self clustersChainFor: aNumber preferredSize: 0
! !

!FAT32FileAllocationTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
clustersChainFor: aNumber preferredSize: aPreferredSize
	^(self cachedChain: aNumber preferredSize: aPreferredSize) copy.

! !

!FAT32FileAllocationTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
clustersChainNoCopyFor: aClusterNumber preferredSize: aSize
	^(self cachedChain: aClusterNumber preferredSize: aSize).	

! !

!FAT32FileAllocationTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents: bytes
	contents := bytes
! !

!FAT32FileAllocationTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
countOfClusters
	^contents size // self recordSize
! !

!FAT32FileAllocationTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
finishClustersChainValue
	| bytes |
	bytes := (ByteArray new: 4).
	bytes unsignedLongAt: 1 put: 16r0FFFFFFF.	
	^bytes
! !

!FAT32FileAllocationTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
firstFreeClusterSince: aNumber
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
! !

!FAT32FileAllocationTable methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:32:25'!
hasCached: aNumber
	^chains includesKey: aNumber
! !

!FAT32FileAllocationTable methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:25'!
initialize
	chains := Dictionary new.
! !

!FAT32FileAllocationTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
internalClusterChainFor: chainId preferredSize: aPreferredSize
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
! !

!FAT32FileAllocationTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextClusterFor: index
	self setPositionTo: index.
	^self nextRecord unsignedLongAt: 1.
! !

!FAT32FileAllocationTable methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:32:25'!
nextRecord
	^contents next: self recordSize
! !

!FAT32FileAllocationTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
point: aFatClusterNumber to: anotherFatClusterNumber
	"Alter the FAT so that it's cluster number aFatClusterNumber points to anotherFatClusterNumber"
	| bytes |
	self setPositionTo: aFatClusterNumber.
	bytes := (ByteArray new: 4).
	bytes unsignedLongAt: 1 put: anotherFatClusterNumber.
	contents nextPutAll: bytes.
! !

!FAT32FileAllocationTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
recordSize
	^4
! !

!FAT32FileAllocationTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
removeChainOf: id
	| chain |
	chain := self clustersChainFor: id.
	chain do: [:index | self at: index put: 0]
! !

!FAT32FileAllocationTable methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
resetAllEntries
	| size |
	size := self recordSize.
	self
		at: 1 put: 16r0FFFFFF8;
		at: 2 put: 16r0FFFFFFF
! !

!FAT32FileAllocationTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
setPositionTo: aNumber
	contents position: aNumber * self recordSize. 
	
! !

!FAT32FileAllocationTable methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:32:25'!
shrinkClusterChainOf: aNumber to: length
	| chain size toRemove last |
	chain := self clustersChainFor: aNumber.
	size := chain size.
	size > length ifFalse: [^self].
	toRemove := length - size.
	last := chain at: length.
	self at: last put: self clusterChainEndValue. 
	chain := chain last: toRemove.
	chain do: [:index | self at: index put: 0].
	

! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FAT32FileAllocationTable class' category: 'SqueakNOS-Filesystems-FAT32'!
FAT32FileAllocationTable class
	instanceVariableNames: ''!

!FAT32FileAllocationTable class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:25'!
contents: aStream
	^self new contents: aStream.
! !


FAT32FileAllocationTable initialize!

