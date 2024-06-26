"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #Allocator,
	#superclass : #Object,
	#instVars : [
		'memory'
	],
	#category : #Kernel
}

{ #category : #copying }
Allocator >> allocate: anInteger [
	^memory allocate: anInteger
]

{ #category : #accessing }
Allocator >> initialize [
	memory := Memory current
]

{ #category : #accessing }
Allocator >> memory: aMemory [
	memory := aMemory
]

{ #category : #copying }
Allocator >> shallowCopy: array growingTo: newSize [
	| headerSize total buffer copy |
	headerSize := 16.
	total := headerSize + (newSize * WordSize).
	buffer := self allocate: total.
	copy := (buffer + headerSize _asPointer) _asObject.
	copy _copyBasicHeaderFrom: array; _makeExtendedSize: newSize; _beUnseen.
	1 to: array _size do: [:index | | original |
		original := array _basicAt: index.
		copy _basicAt: index put: original].
	array _size + 1 to: newSize do: [:i | copy _basicAt: i put: nil].
	(array _isRemembered
		or: [(memory isYoung: copy) not and: [memory pointsToYoungObjects: array]])
		ifTrue: [memory remember: copy]
		ifFalse: [copy _beNotRemembered].
	^copy
]

