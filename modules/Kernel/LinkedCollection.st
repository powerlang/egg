"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #LinkedCollection,
	#superclass : #SequenceableCollection,
	#type : #variable,
	#instVars : [
		'next',
		'localSize'
	],
	#category : #Kernel
}

{ #category : #instances }
LinkedCollection class >> new [
	^self new: 50
]

{ #category : #instances }
LinkedCollection class >> new: anInteger [
	| instance |
	instance := super new: anInteger.
	instance initialize.
	^instance
]

{ #category : #accessing }
LinkedCollection >> add: anObject [
	^next == nil
		ifTrue: [
			localSize = self basicSize
				ifTrue: [
					self createNextLink.
					next add: anObject]
				ifFalse: [self basicAdd: anObject]]
		ifFalse: [next add: anObject]
]

{ #category : #accessing }
LinkedCollection >> at: anInteger [
	(0 < anInteger and: [anInteger <= self basicSize])
		ifTrue: [^self basicAt: anInteger].
	next == nil
		ifTrue: [self outOfBoundsIndex: anInteger]
		ifFalse: [^next at: anInteger - localSize]
]

{ #category : #accessing }
LinkedCollection >> at: anInteger put: anObject [
	(0 < anInteger and: [anInteger <= localSize])
		ifTrue: [^self basicAt: anInteger put: anObject].
	next == nil
		ifTrue: [self outOfBoundsIndex: anInteger]
		ifFalse: [^next at: anInteger - localSize put: anObject]
]

{ #category : #private }
LinkedCollection >> basicAdd: anObject [
	localSize := localSize + 1.
	self basicAt: localSize put: anObject
]

{ #category : #accessing }
LinkedCollection >> copyFrom: beginning to: end [
	| total copy |
	total := end - beginning + 1.
	total negative ifTrue: [self outOfBoundsIndex: total].
	copy := self species new: total.
	copy localSize: total.
	^copy replaceFrom: 1 to: total with: self startingAt: beginning
]

{ #category : #accessing }
LinkedCollection >> createNextLink [
	next := self species new: self basicSize * 2
]

{ #category : #accessing }
LinkedCollection >> do: aBlock [
	| index |
	index := 0.
	[
		index := index + 1.
		index <= localSize]
		whileTrue: [aBlock evaluateWith: (self basicAt: index)].
	next == nil ifFalse: [next do: aBlock]
]

{ #category : #accessing }
LinkedCollection >> hasIndexedSlots [
	^true
]

{ #category : #initialization }
LinkedCollection >> initialize [
	localSize := 0
]

{ #category : #accessing }
LinkedCollection >> localSize: anInteger [
	localSize := anInteger
]

{ #category : #accessing }
LinkedCollection >> size [
	| extra |
	extra := next == nil ifTrue: [0] ifFalse: [next size].
	^localSize + extra
]

