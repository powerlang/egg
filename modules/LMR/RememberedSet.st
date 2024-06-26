"
	Copyright (c) 2020-2022 Quorum Software.
	See (MIT) license in root directory.
"

Class {
	#name : #RememberedSet,
	#superclass : #Object,
	#instVars : [
		'base',
		'tally',
		'maxSize'
	],
	#category : #Kernel
}

{ #category : #private }
RememberedSet >> add: anObject [
	"
	We first check if grow is needed, then increment the tally and 
	finally grow. If not done this way, if growing adds something to
	the remembered set it could cause an infinite recursion
	"
	| grow |
	grow := tally + 10 = maxSize.
	tally := tally + 1.
	base _asObject _basicAt: tally put: anObject.
	grow ifTrue: [self grow: maxSize * 2]
]

{ #category : #private }
RememberedSet >> at: anInteger [
	^base _asObject _basicAt: anInteger
]

{ #category : #private }
RememberedSet >> at: anInteger put: anObject [
	^base _asObject _basicAt: anInteger put: anObject
]

{ #category : #private }
RememberedSet >> base [
	^base
]

{ #category : #private }
RememberedSet >> base: anInteger [
	base := anInteger
]

{ #category : #private }
RememberedSet >> grow: anInteger [
	| new old |
	new := (Kernel os reserveAndCommit: anInteger * WordSize) // 2.
	1
		to: tally
		do: [:i | new _asObject _basicAt: i put: (base _asObject _basicAt: i)].
	old := base.
	base := new.
	maxSize := anInteger.
	Kernel os release: old * 2
]

{ #category : #private }
RememberedSet >> includesIdentical: anObject [
	1 to: maxSize do: [:i | anObject == (self at: i) ifTrue: [^true]].
	^false
]

{ #category : #private }
RememberedSet >> initialize: anInteger [
	tally := 0.
	base := (Kernel os reserveAndCommit: anInteger * WordSize) // 2.
	maxSize := anInteger
]

{ #category : #private }
RememberedSet >> maxSize [
	^maxSize
]

{ #category : #private }
RememberedSet >> release [
	Kernel os release: base * 2.
	base := nil.
	tally := maxSize := 0
]

{ #category : #private }
RememberedSet >> size [
	^tally
]

{ #category : #private }
RememberedSet >> size: anInteger [
	tally := anInteger
]

