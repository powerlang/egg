Class {
	#name : #SnapshotInfo,
	#superclass : #ExternalStructure,
	#category : 'SqueakNOS-External-Structures'
}

{ #category : #'methodsFor:' }
SnapshotInfo >> fields [
	"self defineFields"
	^#(
		(saved 'ulong')
		(toSave 'ulong')
		(pages 'ReadonlyPage*')
	   )
]

{ #category : #accessing }
SnapshotInfo >> pageFor: anAddress [
	"This method was automatically generated"
	| pages start pageDescriptorAddress virtualAddress |
	pages := OrderedCollection new: self toSave.
	start :=  handle pointerAt: 9.
	0 to: self saved - 1 do: [:index | 
		pageDescriptorAddress := start + (index * ReadonlyPage byteSize).
		virtualAddress := pageDescriptorAddress unsignedLongAt: 1.
		(anAddress between: virtualAddress and: virtualAddress + 4095) ifTrue: 
			[^ReadonlyPage fromHandle: pageDescriptorAddress]
	].
	^nil
]

{ #category : #accessing }
SnapshotInfo >> pages [
	"This method was automatically generated"
	| pages start |
	pages := OrderedCollection new: self toSave.
	start :=  handle pointerAt: 9.
	0 to: self toSave - 1 do: [:index | pages add: (ReadonlyPage fromHandle: start + (index * ReadonlyPage byteSize))].
	^pages
]

{ #category : #accessing }
SnapshotInfo >> pages: anObject [
	"This method was automatically generated (and then modified by hand)"
	handle pointerAt: 9 put: anObject.
]

{ #category : #'initialize-release' }
SnapshotInfo >> resetPages [
	| address |
	address := ExternalAddress allocate: self toSave * ReadonlyPage byteSize.
	self pages: address 
]

{ #category : #accessing }
SnapshotInfo >> saved [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #accessing }
SnapshotInfo >> saved: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]

{ #category : #accessing }
SnapshotInfo >> toSave [
	"This method was automatically generated"
	^handle unsignedLongAt: 5
]

{ #category : #accessing }
SnapshotInfo >> toSave: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
]
