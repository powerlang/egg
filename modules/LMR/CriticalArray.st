"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #CriticalArray,
	#superclass : #SequenceableCollection,
	#instVars : [
		'size',
		'contents',
		'space',
		'writeBarrier'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
CriticalArray class >> emptyReserving: anInteger [
	^self on: Memory current reserving: anInteger
]

{ #category : #'instance creation' }
CriticalArray class >> on: anArray [
	^self new contents: anArray; yourself
]

{ #category : #'instance creation' }
CriticalArray class >> on: space reserving: anInteger [
	| array |
	array := space shallowCopy: #() growingTo: anInteger.
	^self new space: space; contents: array; yourself
]

{ #category : #actions }
CriticalArray >> add: object [
	size = contents _size ifTrue: [self grow].
	size := size + 1.
	self at: size put: object
]

{ #category : #accessing }
CriticalArray >> at: index [
	^contents _basicAt: index
]

{ #category : #accessing }
CriticalArray >> at: index put: anObject [
	^writeBarrier
		ifTrue: [contents objectAtValid: index put: anObject]
		ifFalse: [contents _basicAt: index put: anObject]
]

{ #category : #accessing }
CriticalArray >> contents [
	^contents
]

{ #category : #accessing }
CriticalArray >> contents: collection [
	contents := collection
]

{ #category : #enumerating }
CriticalArray >> do: aBlock [
	1 to: self size do: [:index | | element |
		element := self at: index.
		aBlock value: element]
]

{ #category : #enumerating }
CriticalArray >> grow [
	self growToHold: contents _size * 2
]

{ #category : #private }
CriticalArray >> growToHold: n [
	"
	Change the contents to the expanded version 
	before remembering, as remembering may trigger
	an insertion in this very same array.
	"
	| expanded original |
	contents _size < n ifTrue: [
		expanded := space shallowCopy: contents growingTo: n.
		original := contents.
		contents := expanded.
		original _isRemembered ifTrue: [Memory current remember: expanded]]
]

{ #category : #accessing }
CriticalArray >> ignoreWriteBarrier [
	writeBarrier := false
]

{ #category : #testing }
CriticalArray >> includes: anObject [
	1 to: size do: [:i | anObject = (contents at: i) ifTrue: [^true]].
	^false
]

{ #category : #testing }
CriticalArray >> includesIdentical: anObject [
	1 to: size do: [:i | anObject == (contents at: i) ifTrue: [^true]].
	^false
]

{ #category : #testing }
CriticalArray >> initialize [
	super initialize.
	size := 0.
	writeBarrier := true.
	space := Memory current
]

{ #category : #testing }
CriticalArray >> isEmpty [
	^size = 0
]

{ #category : #accessing }
CriticalArray >> pop [
	| answer |
	answer := self at: size.
	contents _basicAt: size put: nil.
	size := size - 1.
	^answer
]

{ #category : #copying }
CriticalArray >> postCopy [
	super postCopy.
	contents := contents copy
]

{ #category : #actions }
CriticalArray >> push: object [
	^self add: object
]

{ #category : #actions }
CriticalArray >> reset [
	1 to: self size do: [:i | contents _basicAt: i put: nil].
	size := 0
]

{ #category : #accessing }
CriticalArray >> size [
	^size
]

{ #category : #accessing }
CriticalArray >> size: anInteger [
	size := anInteger
]

{ #category : #accessing }
CriticalArray >> space: aSpace [
	space := aSpace
]

{ #category : #'adding / removing' }
CriticalArray >> unsafeAdd: anObject [
	size = contents _size ifTrue: [self grow].
	size := size + 1.
	self unsafeAt: size put: anObject
]

{ #category : #accessing }
CriticalArray >> unsafeAt: index put: anObject [
	^contents _basicAt: index put: anObject
]

