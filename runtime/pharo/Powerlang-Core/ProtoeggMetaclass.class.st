Class {
	#name : #ProtoeggMetaclass,
	#superclass : #ProtoeggSpecies,
	#category : #'Powerlang-Core-Execution-Ring'
}

{ #category : #'accessing - parallel hierarchy' }
ProtoeggMetaclass >> allInstVarNames [
	^ (spec environment at: #Metaclass) allInstVarNames
		, spec allInstVarNames
]

{ #category : #'accessing - parallel hierarchy' }
ProtoeggMetaclass >> class: aClassMap [
	self slotNamed: #class put: aClassMap
]

{ #category : #'accessing - parallel hierarchy' }
ProtoeggMetaclass >> computeAllSlotNames [
	| c |
	c := spec environment at: #Metaclass.
	^slotNames := c allInstVarNames
]

{ #category : #'accessing - parallel hierarchy' }
ProtoeggMetaclass >> createClassAssociationsWith: aVirtualImage [
	
]

{ #category : #'accessing - parallel hierarchy' }
ProtoeggMetaclass >> instanceSide [
	^ self slotNamed: #class
]

{ #category : #'accessing - parallel hierarchy' }
ProtoeggMetaclass >> module [
	^ self instanceSide module
]

{ #category : #'accessing - parallel hierarchy' }
ProtoeggMetaclass >> namespaces [
	^ self instanceSide namespaces
]

{ #category : #'accessing - parallel hierarchy' }
ProtoeggMetaclass >> printOn: aStream [
	aStream
		nextPutAll: '<<';
		nextPutAll: self instanceSide name asString;
		nextPutAll: ' class>>'
]
