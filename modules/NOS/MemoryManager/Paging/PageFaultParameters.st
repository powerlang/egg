Class {
	#name : #PageFaultParameters,
	#superclass : #Alien,
	#type : #bytes,
	#category : #'SqueakNOS-MemoryManager-Paging'
}

{ #category : #'methodsFor:' }
PageFaultParameters >> dataSize [ 
	^4
]

{ #category : #accessing }
PageFaultParameters >> virtualFaultAddress [
	^self unsignedLongAt: 1
]
