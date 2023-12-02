Class {
	#name : #ReadonlyPage,
	#superclass : #ExternalStructure,
	#category : 'SqueakNOS-External-Structures'
}

{ #category : #accessing }
ReadonlyPage >> contents [
	"This method was automatically generated"
	^(Buffer at: self address + 8 size: 4096) contents
	
]

{ #category : #'methodsFor:' }
ReadonlyPage >> fields [
	"self defineFields"
	^#(
		(virtual 'ulong')
		(physical 'ulong')
		(contents 'string' 4096)
	   )
]

{ #category : #accessing }
ReadonlyPage >> physical [
	"This method was automatically generated"
	^handle unsignedLongAt: 5
]

{ #category : #accessing }
ReadonlyPage >> physical: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 5 put: anObject
]

{ #category : #accessing }
ReadonlyPage >> virtual [
	"This method was automatically generated"
	^handle unsignedLongAt: 1
]

{ #category : #accessing }
ReadonlyPage >> virtual: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: 1 put: anObject
]
