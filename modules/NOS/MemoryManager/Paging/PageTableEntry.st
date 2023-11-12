Class {
	#name : #PageTableEntry,
	#superclass : #Object,
	#instVars : [
		'handle'
	],
	#category : #'SqueakNOS-MemoryManager-Paging'
}

{ #category : #accessing }
PageTableEntry >> clean [ 
	handle unsignedLongAt: 1 put: 0
]

{ #category : #private }
PageTableEntry >> handle: anExternalHandler [
	handle := anExternalHandler
]

{ #category : #'methodsFor:' }
PageTableEntry >> handledBy: externalHandle [
	^self new handle: externalHandle
]

{ #category : #testing }
PageTableEntry >> isPresent [
	| value |
	value := handle unsignedLongAt: 1.
	value := value bitAnd: 16r00000001.
	^value = 16r1 
]

{ #category : #testing }
PageTableEntry >> isPresentAndAllowed [ 
	| value |
	value := handle unsignedLongAt: 1.
	value := value bitAnd: 16r00000003.
	^value = 16r3 
]

{ #category : #testing }
PageTableEntry >> isPresentAndForbidden [ 
	| value |
	value := handle unsignedLongAt: 1.
	value := value bitAnd: 16r00000003.
	^value = 16r1 
]

{ #category : #testing }
PageTableEntry >> isReadOnly [ 
	| value |
	value := handle unsignedLongAt: 1.
	value := value bitAnd: 16r00000010.
	^value = 16r2 
]

{ #category : #accessing }
PageTableEntry >> notPresent [
	| value |
	value := handle unsignedLongAt: 1.
	value := value bitAt: 1 put: 0.
	handle unsignedLongAt: 1 put: value 
]

{ #category : #accessing }
PageTableEntry >> pageFrame: aNumber [
	| value frame |
	"aNumber must be page aligned"
	value := handle unsignedLongAt: 1.
	value := value bitAnd: 16r00000FFF.
	value := value bitOr: aNumber.
	handle unsignedLongAt: 1 put: value
]

{ #category : #accessing }
PageTableEntry >> pageTable [
	| address |
	address := self pointedAddress.
	^PageTable forPointer: address
]

{ #category : #private }
PageTableEntry >> pointedAddress [
	| address |
	address := handle unsignedLongAt: 1.
	^address bitAnd: 16rFFFFF000
]

{ #category : #private }
PageTableEntry >> presentAndWritableWord [
	^16r00000003
	
]

{ #category : #printing }
PageTableEntry >> printOn: aStream [
	aStream nextPutAll: 'Translates to: ', self pointedAddress printString, ', Status bits: ', self status printString.
]

{ #category : #accessing }
PageTableEntry >> readOnly [ 
	| value |
	"User mode needs to be set"
	value := handle unsignedLongAt: 1.
	value := value bitAt: 2 put: 0.
	handle unsignedLongAt: 1 put: value	
	



]

{ #category : #accessing }
PageTableEntry >> readWrite [
	| value |
	"User mode needs to be set"
	value := handle unsignedLongAt: 1.
	value := value bitAt: 2 put: 1.
	handle unsignedLongAt: 1 put: value	
	



]

{ #category : #accessing }
PageTableEntry >> setPresentAndWritable [ 
	| value |
	value := handle unsignedLongAt: 1.
	value := value bitOr: self presentAndWritableWord.
	handle unsignedLongAt: 1 put: value 	
]

{ #category : #private }
PageTableEntry >> status [
	| value |
	value := handle unsignedLongAt: 1.
	^value := value bitAnd: 16r00000FFF
]
