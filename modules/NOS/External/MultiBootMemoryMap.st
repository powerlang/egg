Class {
	#name : #MultiBootMemoryMap,
	#superclass : #ExternalStructure,
	#instVars : [
		'size'
	],
	#category : 'SqueakNOS-External-Structures'
}

{ #category : #'instance creation' }
MultiBootMemoryMap class >> fromHandle: handle size: anInteger [
	^(self fromHandle: handle) size: anInteger
]

{ #category : #collection }
MultiBootMemoryMap >> do: aBlock [
	| memoryAddress entry |
	memoryAddress := self address.
		[memoryAddress - self address > self size] 
	whileFalse:
		[entry := MultiBootMemoryMapEntry fromHandle: (ExternalAddress new fromInteger: memoryAddress).
		aBlock value: entry.
		memoryAddress := memoryAddress + entry size]
]

{ #category : #accessing }
MultiBootMemoryMap >> size [
	^size
]

{ #category : #accessing }
MultiBootMemoryMap >> size: anInteger [
	size := anInteger
]
