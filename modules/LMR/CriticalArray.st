"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #CriticalArray,
	#superclass : #SequenceableCollection,
	#instVars : [
		'size',
		'contents',
		'allocator',
		'writeBarrier'
	],
	#category : #Kernel
}

{ #category : #actions }
CriticalArray >> add: object [
	size = contents _size ifTrue: [self grow].
	size := size + 1.
	self at: size put: object
]

{ #category : #accessing }
CriticalArray >> allocator [
	^allocator
]

{ #category : #accessing }
CriticalArray >> allocator: anAllocator [
	allocator := anAllocator
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
	self growTo: contents _size * 2
]

{ #category : #private }
CriticalArray >> growTo: n [
	| expanded |
	contents _size >= n ifTrue: [^self].
	expanded := allocator shallowCopy: contents growingTo: n.
	expanded ifNil: [self _error: 'Could not copy critical array contents'].
	contents := expanded
]

{ #category : #actions }
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

{ #category : #initialization }
CriticalArray >> initialize [
	super initialize.
	size := 0.
	writeBarrier := true.
	contents := #().
	allocator := Allocator new memory: Memory current
]

{ #category : #testing }
CriticalArray >> isEmpty [
	^size = 0
]

{ #category : #actions }
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

{ #category : #removing }
CriticalArray >> remove: anObject ifAbsent: aBlock [
	1 to: size do: [:i | 
		anObject == (contents at: i) ifTrue: [
			self removeIndex: i.
			^anObject]].
	^aBlock value
]

{ #category : #removing }
CriticalArray >> removeIndex: anInteger [
	contents
		replaceFrom: anInteger
		to: size - 1
		with: contents
		startingAt: anInteger + 1;
		at: size put: nil.
	size := size - 1
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

{ #category : #adding }
CriticalArray >> unsafeAdd: anObject [
	size = contents _size ifTrue: [self grow].
	size := size + 1.
	self unsafeAt: size put: anObject
]

{ #category : #accessing }
CriticalArray >> unsafeAt: index put: anObject [
	^contents _basicAt: index put: anObject
]

{ #category : #actions }
CriticalArray >> usePinnedAllocation [
	allocator := PinnedAllocator new
]

