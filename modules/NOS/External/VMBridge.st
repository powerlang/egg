Class {
	#name : #VMBridge,
	#superclass : #ExternalStructure,
	#category : 'SqueakNOS-External-Structures'
}

{ #category : #accessing }
VMBridge class >> fields [
	^#(
		(video 'DisplayInformation')
		(multiboot 'MultiBootInfo*')
		(image 'void*')
	   	(snapshotStartAddress 'ulong') 
	      (snapshotEndAddress 'ulong')
		(pageFaultHandlerEntry 'void*')
		(snapshotInfo 'SnapshotInfo')    
	)
]

{ #category : #'system startup' }
VMBridge class >> install [
	Computer current ifNotNil: [:computer | computer initializeBridge]
]

{ #category : #accessing }
VMBridge >> image [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: 25) type: ExternalType void asPointerType
]

{ #category : #accessing }
VMBridge >> image: anObject [
	"This method was automatically generated"
	handle pointerAt: 25 put: anObject getHandle.
]

{ #category : #accessing }
VMBridge >> inPageFault [	
	^handle unsignedLongAt: 53
]

{ #category : #accessing }
VMBridge >> inPageFault: anInteger [	
	handle unsignedLongAt: 53 put: anInteger
]

{ #category : #accessing }
VMBridge >> multiboot [
	"This method was automatically generated"
	^MultiBootInfo fromHandle: (handle pointerAt: 21)
]

{ #category : #accessing }
VMBridge >> multiboot: anObject [
	"This method was automatically generated"
	handle pointerAt: 21 put: anObject getHandle.
]

{ #category : #accessing }
VMBridge >> pageFaultAddress [	
	^handle unsignedLongAt: 57
]

{ #category : #accessing }
VMBridge >> pageFaultAddress: anInteger [	
	handle unsignedLongAt: 57 put: anInteger
]

{ #category : #accessing }
VMBridge >> pageFaultHandlerEntry [
	^handle unsignedLongAt: 37
]

{ #category : #accessing }
VMBridge >> pageFaultHandlerEntry: aCallBackAddress [
	"This method was automatically generated"
	handle unsignedLongAt: 37 put: aCallBackAddress
]

{ #category : #accessing }
VMBridge >> snapshotEndAddress [
	"This method was automatically generated"
	^handle unsignedLongAt: 33
]

{ #category : #accessing }
VMBridge >> snapshotEndAddress: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 33 put: anObject
]

{ #category : #accessing }
VMBridge >> snapshotInfo [
	"This method was automatically generated and modified by hand"
	^SnapshotInfo fromHandle: handle + 40
]

{ #category : #accessing }
VMBridge >> snapshotInfo: anObject [
	"This method was automatically generated"
	handle structAt: 41 put: anObject getHandle length: 12.
]

{ #category : #accessing }
VMBridge >> snapshotStartAddress [
	"This method was automatically generated"
	^handle unsignedLongAt: 29
]

{ #category : #accessing }
VMBridge >> snapshotStartAddress: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 29 put: anObject
]

{ #category : #accessing }
VMBridge >> totalPageFaults [	
	^handle unsignedLongAt: 61
]

{ #category : #accessing }
VMBridge >> totalPageFaults: anInteger [	
	handle unsignedLongAt: 61 put: anInteger
]

{ #category : #accessing }
VMBridge >> video [
	"This method was automatically generated"
	^DisplayInformation fromHandle: (handle structAt: 1 length: 20)
]

{ #category : #accessing }
VMBridge >> video: anObject [
	"This method was automatically generated"
	handle structAt: 1 put: anObject getHandle length: 20.
]
