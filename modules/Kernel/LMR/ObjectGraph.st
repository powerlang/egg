"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #ObjectGraph,
	#superclass : #Object,
	#instVars : [
		'stack'
	],
	#category : #Kernel
}

{ #category : #accessing }
ObjectGraph >> follow: root [
	| index scanned limit |
	self queue: root.
	[stack isEmpty] whileFalse: [
		limit := stack pop.
		index := stack pop.
		scanned := stack pop.
		[index <= limit] whileTrue: [| object class |
			object := index = 0
				ifTrue: [scanned behavior]
				ifFalse: [scanned _basicAt: index].
			index := index + 1.
			(self haveToFollow: object) ifTrue: [
				object _beSeen.
				class := object class.
				class == StackWrapper ifTrue: [self queue: object allObjects].
				class == NativeCode ifTrue: [self scanNativeCode: object].
				index < limit ifTrue: [self queue: scanned from: index to: limit].
				index := 0.
				limit := object _pointersSize.
				scanned := object]]]
]

{ #category : #accessing }
ObjectGraph >> haveToFollow: object [
	^object _isSmallInteger not and: [object _hasBeenSeen not]
]

{ #category : #initialization }
ObjectGraph >> initialize [
	stack := CriticalArray emptyReserving: 1000.
	stack ignoreWriteBarrier
]

{ #category : #accessing }
ObjectGraph >> queue: anObject [
	(self haveToFollow: anObject) ifFalse: [^self].
	self queue: anObject _beSeen from: 0 to: anObject _pointersSize
]

{ #category : #accessing }
ObjectGraph >> queue: anObject from: index to: limit [
	stack
		push: anObject;
		push: index;
		push: limit
]

{ #category : #accessing }
ObjectGraph >> scanNativeCode: aNativeCode [
	| bytes |
	aNativeCode isFresh ifFalse: [^self].
	bytes := aNativeCode code.
	aNativeCode references do: [:encoded | | object |
		(aNativeCode isObjectReference: encoded) ifTrue: [
			object := bytes _objectAtOffset: encoded.
			self queue: object]]
]

{ #category : #accessing }
ObjectGraph >> updateAndFollow: root [
	ActiveProcess stack update.
	self follow: root
]

