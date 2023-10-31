"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Association,
	#superclass : #Object,
	#instVars : [
		'key',
		'value'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Association class >> key: anObject [
	^self new key: anObject
]

{ #category : #'instance creation' }
Association class >> key: key value: value [
	| assoc |
	assoc := self key: key.
	^assoc value: value
]

{ #category : #comparing }
Association >> = anAssociation [
	^anAssociation isAssociation
		and: [key = anAssociation key]
		and: [value = anAssociation value]
]

{ #category : #accessing }
Association >> canBePrintedAsLiteral [
	^key canBePrintedAsLiteral and: [value canBePrintedAsLiteral]
]

{ #category : #comparing }
Association >> hash [
	^key hash
]

{ #category : #testing }
Association >> isAssociation [
	^true
]

{ #category : #comparing }
Association >> key [
	^key
]

{ #category : #accessing }
Association >> key: anObject [
	key := anObject
]

{ #category : #printing }
Association >> printOn: aStream [
	key printOn: aStream.
	aStream nextPutAll: ' -> '.
	value printOn: aStream
]

{ #category : #printing }
Association >> storeOn: aStream [
	aStream nextPut: $(.
	key storeOn: aStream.
	aStream nextPutAll: ' -> '.
	value storeOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
Association >> value [
	^value
]

{ #category : #accessing }
Association >> value: anObject [
	value := anObject
]

