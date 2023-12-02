Class {
	#name : #DisplayInformation,
	#superclass : #ExternalStructure,
	#category : 'SqueakNOS-External-Structures'
}

{ #category : #accessing }
DisplayInformation class >> fields [
	^#(
		(width 'ulong')
		(height 'ulong')
		(depth 'ulong')
		(address 'ulong')
		(bytesPerScanLine 'ulong')
	    )
]

{ #category : #accessing }
DisplayInformation >> address [
	"This method was automatically generated"
	^handle unsignedLongAt: 13
]

{ #category : #accessing }
DisplayInformation >> address: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
]

{ #category : #accessing }
DisplayInformation >> bytesPerScanLine [
	"This method was automatically generated"
	^handle unsignedLongAt: 17
]

{ #category : #accessing }
DisplayInformation >> bytesPerScanLine: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 17 put: anObject
]

{ #category : #accessing }
DisplayInformation >> depth [
	"This method was automatically generated"
	^handle unsignedLongAt: 9
]

{ #category : #accessing }
DisplayInformation >> depth: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
]

{ #category : #accessing }
DisplayInformation >> height [
	"This method was automatically generated"
	^handle unsignedLongAt: 5
]

{ #category : #accessing }
DisplayInformation >> height: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
]

{ #category : #accessing }
DisplayInformation >> width [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #accessing }
DisplayInformation >> width: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]
