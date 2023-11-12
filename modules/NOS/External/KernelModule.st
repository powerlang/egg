Class {
	#name : #KernelModule,
	#superclass : #ExternalStructure,
	#category : #'SqueakNOS-External-Structures'
}

{ #category : #accessing }
KernelModule class >> fields [
	^#(
		(start 'ulong')
		(end 'ulong')
		(string 'ulong')
		(reserved 'ulong')
	   )
]

{ #category : #accessing }
KernelModule >> end [
	"This method was automatically generated"
	^handle unsignedLongAt: 5
]

{ #category : #accessing }
KernelModule >> end: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
]

{ #category : #accessing }
KernelModule >> reserved [
	"This method was automatically generated"
	^handle unsignedLongAt: 13
]

{ #category : #accessing }
KernelModule >> reserved: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 13 put: anObject
]

{ #category : #accessing }
KernelModule >> start [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #accessing }
KernelModule >> start: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]

{ #category : #accessing }
KernelModule >> string [
	"This method was automatically generated"
	^handle unsignedLongAt: 9
]

{ #category : #accessing }
KernelModule >> string: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 9 put: anObject
]
