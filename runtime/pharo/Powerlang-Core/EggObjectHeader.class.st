Class {
	#name : #EggObjectHeader,
	#superclass : #Object,
	#instVars : [
		'behavior',
		'flags',
		'size',
		'hash'
	],
	#category : #'Powerlang-Core-Execution-Metacircular'
}

{ #category : #accessing }
EggObjectHeader >> behavior [
	^behavior
]

{ #category : #accessing }
EggObjectHeader >> behavior: anLMRHeapObject [
	behavior := anLMRHeapObject
]

{ #category : #accessing }
EggObjectHeader >> bytes: bytes arrayed: arrayed named: named [
	| b a n |
	b := bytes
		ifTrue: [ 1 ]
		ifFalse: [ 0 ].
	a := arrayed
		ifTrue: [ 2 ]
		ifFalse: [ 0 ].
	n := named	ifTrue: [ 4 ]
		ifFalse: [ 0 ].
	flags := b | a | n 
]

{ #category : #accessing }
EggObjectHeader >> flags [
	^flags
]

{ #category : #accessing }
EggObjectHeader >> hash [
	^hash
]

{ #category : #accessing }
EggObjectHeader >> hash: anInteger [
	hash := anInteger
]

{ #category : #accessing }
EggObjectHeader >> isSmall [
	^ self size < 256
]

{ #category : #accessing }
EggObjectHeader >> printOn: aStream [

	aStream
		nextPutAll: '[ hash: ';
		print: hash;
		nextPutAll: ' | size: ';
		print: size;
		nextPutAll: ' | flags: ';
		nextPutAll: flags hex;
		nextPutAll: ' | ';
		print: behavior;
		nextPut: $]
]

{ #category : #accessing }
EggObjectHeader >> size [
	^size 
]

{ #category : #accessing }
EggObjectHeader >> size: anInteger [
	size := anInteger.
	self isSmall ifTrue: [ flags := flags | 16r80]
]
