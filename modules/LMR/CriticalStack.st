"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #CriticalStack,
	#superclass : #SequenceableCollection,
	#instVars : [
		'head',
		'limit',
		'top',
		'buffers',
		'bufferIndex'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
CriticalStack class >> emptyReserving: anInteger [
	| buffers |
	buffers := CriticalArray new growTo: 40.
	^self new buffers: buffers initialSize: anInteger
]

{ #category : #'adding/removing' }
CriticalStack >> addBuffer: size [
	| address |
	address := Kernel os reserveAndCommit: size * WordSize.
	buffers
		push: size;
		push: address // 2
]

{ #category : #actions }
CriticalStack >> at: anInteger [
	^self errorNotIndexable
]

{ #category : #accessing }
CriticalStack >> buffers: aCriticalArray initialSize: anInteger [
	buffers := aCriticalArray.
	self addBuffer: anInteger.
	top := 0.
	bufferIndex := 2.
	head := buffers at: bufferIndex.
	limit := anInteger
]

{ #category : #private }
CriticalStack >> grow [
	bufferIndex = buffers size ifTrue: [self addBuffer: limit * 2].
	bufferIndex := bufferIndex + 2.
	head := buffers at: bufferIndex.
	limit := buffers at: bufferIndex - 1.
	top := 0
]

{ #category : #testing }
CriticalStack >> isEmpty [
	^top = 0 and: [bufferIndex = 2]
]

{ #category : #'adding/removing' }
CriticalStack >> pop [
	| answer |
	top = 0 ifTrue: [self shrink].
	answer := head _asObject _basicAt: top.
	top := top - 1.
	^answer
]

{ #category : #'adding/removing' }
CriticalStack >> push: anObject [
	top = limit ifTrue: [self grow].
	top := top + 1.
	^head _asObject _basicAt: top put: anObject
]

{ #category : #finalization }
CriticalStack >> release [
	2 to: buffers size by: 2 do: [:i | | address |
		address := buffers at: i.
		Kernel os release: address * 2].
	buffers reset
]

{ #category : #actions }
CriticalStack >> reset [
	[buffers size > 2] whileTrue: [| address |
		address := buffers pop.
		buffers pop.
		Kernel os release: address * 2].
	bufferIndex := 2.
	head := buffers at: bufferIndex.
	limit := buffers at: bufferIndex - 1.
	top := 0
]

{ #category : #private }
CriticalStack >> shrink [
	bufferIndex < 2 ifTrue: [self error: 'cannot shrink empty stack'].
	bufferIndex := bufferIndex - 2.
	head := buffers at: bufferIndex.
	limit := top := buffers at: bufferIndex - 1
]

