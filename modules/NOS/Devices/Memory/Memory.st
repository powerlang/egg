Class {
	#name : #Memory,
	#superclass : #HardwareDevice,
	#instVars : [
		'size',
		'blocks'
	],
	#category : #'SqueakNOS-Devices-Memory'
}

{ #category : #'instance creation' }
Memory class >> installOn: aComputer [
	| memory |
	memory := aComputer memory: (self atMemoryAddress: 0).
	aComputer setInitialMemoryState.
	^memory
]

{ #category : #accessing }
Memory >> alreadyReserved: anInterval for: aString [
	blocks add: (MemoryBlock from: anInterval first to: anInterval last description: aString)
]

{ #category : #accessing }
Memory >> biggestEmptyBlock [
	"Answers the biggest free block of memory"
	^self emptyBlocks detectMax: [ :block | block interval last - block interval first ].
]

{ #category : #accessing }
Memory >> emptyBlocks [
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
	
]

{ #category : #initialization }
Memory >> initialize [
	super initialize.
	blocks := OrderedCollection new.
]

{ #category : #accessing }
Memory >> size [
	 ^size
]

{ #category : #accessing }
Memory >> size: anInteger [
	"memory size in bytes"
	 size := anInteger
]
