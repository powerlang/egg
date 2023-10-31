"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #UndefinedObject,
	#superclass : #Object,
	#category : #Kernel
}

{ #category : #instances }
UndefinedObject class >> allInstances [
	^Array new: 1
]

{ #category : #testing }
UndefinedObject class >> canBeDeleted [
	^false
]

{ #category : #'instance creation' }
UndefinedObject class >> new [
	^self shouldNotImplement
]

{ #category : #'instance creation' }
UndefinedObject class >> new: anInteger [
	^self shouldNotImplement
]

{ #category : #converting }
UndefinedObject >> asParameter [
	^0
]

{ #category : #converting }
UndefinedObject >> asUnicode [
	
]

{ #category : #printing }
UndefinedObject >> canBePrintedAsLiteral [
	^true
]

{ #category : #copying }
UndefinedObject >> deepCopy [
	^self
]

{ #category : #'ffi support' }
UndefinedObject >> externalCopy [
	^nil
]

{ #category : #'ffi support' }
UndefinedObject >> free [
	"
	do nothing
	"
	
]

{ #category : #services }
UndefinedObject >> ifNil: aBlock [
	^aBlock value
]

{ #category : #testing }
UndefinedObject >> ifNil: aBlock ifNotNil: anotherBlock [
	^aBlock value
]

{ #category : #services }
UndefinedObject >> ifNotNil: aBlock [
	^self
]

{ #category : #testing }
UndefinedObject >> ifNotNil: aBlock ifNil: nilBlock [
	^nilBlock argumentCount = 1
		ifTrue: [nilBlock value: self]
		ifFalse: [nilBlock value]
]

{ #category : #testing }
UndefinedObject >> isEmptyOrNil [
	^true
]

{ #category : #testing }
UndefinedObject >> isFixedObject [
	^true
]

{ #category : #testing }
UndefinedObject >> isNil [
	^true
]

{ #category : #testing }
UndefinedObject >> notNil [
	^false
]

{ #category : #printing }
UndefinedObject >> printOn: aStream [
	aStream nextPutAll: 'nil'
]

{ #category : #copying }
UndefinedObject >> shallowCopy [
	^self
]

{ #category : #accessing }
UndefinedObject >> sizeInBytes [
	^0
]

{ #category : #printing }
UndefinedObject >> storeOn: aStream [
	self printOn: aStream
]

