Class {
	#name : #ProtoeggMetaclass,
	#superclass : #ProtoeggSpecies,
	#category : #'Powerlang-Core-Execution-Bootstrap-Ring'
}

{ #category : #'accessing - parallel hierarchy' }
ProtoeggMetaclass >> class: aClassMap [
	self slotNamed: #class put: aClassMap
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
