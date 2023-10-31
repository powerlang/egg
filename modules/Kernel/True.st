"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #True,
	#superclass : #Boolean,
	#category : #Kernel
}

{ #category : #instances }
True class >> allInstances [
	^{true}
]

{ #category : #testing }
True class >> canBeDeleted [
	^false
]

{ #category : #operations }
True >> & aBoolean [
	^aBoolean
]

{ #category : #operations }
True >> | aBoolean [
	^self
]

{ #category : #operations }
True >> and: aBlock [
	^aBlock value
]

{ #category : #operations }
True >> and: block1 and: block2 [
	^block1 value and: [block2 value]
]

{ #category : #operations }
True >> and: block1 and: block2 and: block3 [
	^block1 value and: [block2 value] and: [block3 value]
]

{ #category : #operations }
True >> and: block1 andNot: block2 [
	^block1 value andNot: [block2 value]
]

{ #category : #operations }
True >> andNot: aBlock [
	^aBlock value not
]

{ #category : #converting }
True >> asParameter [
	^1
]

{ #category : #'flow control' }
True >> ifFalse: aBlock [
	^nil
]

{ #category : #'flow control' }
True >> ifFalse: aBlock ifTrue: anotherBlock [
	^anotherBlock value
]

{ #category : #'flow control' }
True >> ifTrue: aBlock [
	^aBlock value
]

{ #category : #'flow control' }
True >> ifTrue: aBlock ifFalse: anotherBlock [
	^aBlock value
]

{ #category : #operations }
True >> not [
	^false
]

{ #category : #operations }
True >> or: aBlock [
	^self
]

{ #category : #operations }
True >> or: aBlock or: aBlock2 [
	^self
]

{ #category : #operations }
True >> orNot: aBlock [
	^self
]

{ #category : #printing }
True >> printOn: aStream [
	aStream nextPutAll: 'true'
]

{ #category : #operations }
True >> xor: aBlock [
	^aBlock value not
]

