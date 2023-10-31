"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #False,
	#superclass : #Boolean,
	#category : #Kernel
}

{ #category : #instances }
False class >> allInstances [
	^{false}
]

{ #category : #testing }
False class >> canBeDeleted [
	^false
]

{ #category : #operations }
False >> & aBoolean [
	^self
]

{ #category : #operations }
False >> | aBoolean [
	^aBoolean
]

{ #category : #operations }
False >> and: aBlock [
	^false
]

{ #category : #operations }
False >> and: block1 and: block2 [
	^self
]

{ #category : #operations }
False >> and: block1 and: block2 and: block3 [
	^self
]

{ #category : #operations }
False >> and: block1 andNot: block2 [
	^self
]

{ #category : #operations }
False >> andNot: aBlock [
	^self
]

{ #category : #converting }
False >> asParameter [
	^0
]

{ #category : #comparing }
False >> basicHash [
	^0
]

{ #category : #comparing }
False >> hash [
	^0
]

{ #category : #'flow control' }
False >> ifFalse: aBlock [
	^aBlock value
]

{ #category : #'flow control' }
False >> ifFalse: aBlock ifTrue: anotherBlock [
	^aBlock value
]

{ #category : #'flow control' }
False >> ifTrue: aBlock [
	^nil
]

{ #category : #'flow control' }
False >> ifTrue: aBlock ifFalse: anotherBlock [
	^anotherBlock value
]

{ #category : #operations }
False >> not [
	^true
]

{ #category : #operations }
False >> or: aBlock [
	^aBlock value
]

{ #category : #operations }
False >> or: aBlock or: anotherBlock [
	^aBlock value or: [anotherBlock value]
]

{ #category : #operations }
False >> orNot: aBlock [
	^aBlock value not
]

{ #category : #converting }
False >> printOn: aStream [
	aStream nextPutAll: 'false'
]

{ #category : #operations }
False >> xor: aBlock [
	^aBlock value
]

