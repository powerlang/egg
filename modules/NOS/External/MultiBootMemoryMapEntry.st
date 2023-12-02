Class {
	#name : #MultiBootMemoryMapEntry,
	#superclass : #ExternalStructure,
	#category : 'SqueakNOS-External-Structures'
}

{ #category : #accessing }
MultiBootMemoryMapEntry class >> fields [
	^#(
		(size 'ulong')
		(baseAddress 'double')
		(length 'double')
		(type 'ulong')
	   )
]

{ #category : #accessing }
MultiBootMemoryMapEntry >> baseAddress [
	"This method was automatically generated"
	^handle doubleAt: 5
]

{ #category : #accessing }
MultiBootMemoryMapEntry >> baseAddress: anObject [
	"This method was automatically generated"
	handle doubleAt: 5 put: anObject
]

{ #category : #accessing }
MultiBootMemoryMapEntry >> length [
	"This method was automatically generated"
	^handle doubleAt: 13
]

{ #category : #accessing }
MultiBootMemoryMapEntry >> length: anObject [
	"This method was automatically generated"
	handle doubleAt: 13 put: anObject
]

{ #category : #accessing }
MultiBootMemoryMapEntry >> size [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #accessing }
MultiBootMemoryMapEntry >> size: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]

{ #category : #accessing }
MultiBootMemoryMapEntry >> type [
	"This method was automatically generated"
	^handle unsignedLongAt: 21
]

{ #category : #accessing }
MultiBootMemoryMapEntry >> type: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 21 put: anObject
]
