'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:32:25 pm'!
!classDefinition: #SnapshotInfo category: 'SqueakNOS-External-Structures'!
ExternalStructure subclass: #SnapshotInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SqueakNOS-External-Structures'!
!SnapshotInfo methodsFor:  'methodsFor:' stamp: 'KenD 28/Jun/2026 13:32:25'!
fields
	"self defineFields"
	^#(
		(saved 'ulong')
		(toSave 'ulong')
		(pages 'ReadonlyPage*')
	   )
! !

!SnapshotInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
pageFor: anAddress
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
! !

!SnapshotInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
pages
	"This method was automatically generated"
	| pages start |
	pages := OrderedCollection new: self toSave.
	start :=  handle pointerAt: 9.
	0 to: self toSave - 1 do: [:index | pages add: (ReadonlyPage fromHandle: start + (index * ReadonlyPage byteSize))].
	^pages
! !

!SnapshotInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
pages: anObject
	"This method was automatically generated (and then modified by hand)"
	handle pointerAt: 9 put: anObject.
! !

!SnapshotInfo methodsFor:  'initialize-release' stamp: 'KenD 28/Jun/2026 13:32:25'!
resetPages
	| address |
	address := ExternalAddress allocate: self toSave * ReadonlyPage byteSize.
	self pages: address 
! !

!SnapshotInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
saved
	"This method was automatically generated"
	^handle unsignedLongAt: 1
! !

!SnapshotInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
saved: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
! !

!SnapshotInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
toSave
	"This method was automatically generated"
	^handle unsignedLongAt: 5
! !

!SnapshotInfo methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:32:25'!
toSave: anObject
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SnapshotInfo class' category: 'SqueakNOS-External-Structures'!
SnapshotInfo class
	instanceVariableNames: ''!


