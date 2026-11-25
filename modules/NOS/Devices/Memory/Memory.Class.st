'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:24 pm'!
!classDefinition: #Memory category: 'SqueakNOS-Devices-Memory'!
HardwareDevice subclass: #Memory
	instanceVariableNames: 'size blocks'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-Devices-Memory'!
!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
alreadyReserved: anInterval for: aString
	blocks add: (MemoryBlock from: anInterval first to: anInterval last description: aString)
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
biggestEmptyBlock
	"Answers the biggest free block of memory"
	^self emptyBlocks detectMax: [ :block | block interval last - block interval first ].
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
emptyBlocks
	"Calculate all the free memory blocks. The algorithm assumes that used blocks are ordered and not overlapping."
	| emptyBlocks nextBlockStart |
	emptyBlocks := OrderedCollection new.
	nextBlockStart := 0.
	blocks do: [:block |
		block start > nextBlockStart 
			ifTrue: [
				emptyBlocks add: (MemoryBlock from: nextBlockStart to: block start - 1 description: 'Empty')
			].
		nextBlockStart := block end + 1.
	].
	nextBlockStart < size ifTrue: [emptyBlocks add: (MemoryBlock from: nextBlockStart to: size - 1 description: 'Empty') ].
	 ^emptyBlocks.
	
! !

!Memory methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:32:24'!
initialize
	super initialize.
	blocks := OrderedCollection new.
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
size
	 ^size
! !

!Memory methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:24'!
size: anInteger
	"memory size in bytes"
	 size := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Memory class' category: 'SqueakNOS-Devices-Memory'!
Memory class
	instanceVariableNames: ''!

!Memory class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:32:24'!
installOn: aComputer
	| memory |
	memory := aComputer memory: (self atMemoryAddress: 0).
	aComputer setInitialMemoryState.
	^memory
! !


Memory initialize!

