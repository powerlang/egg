"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #WeakIdentitySet,
	#superclass : #IdentitySet,
	#instVars : [
		'finalizer'
	],
	#category : #Kernel
}

{ #category : #adding }
WeakIdentitySet >> add: element [
	| ephemeron |
	element == nil ifTrue: [^element].
	[
		ephemeron := Ephemeron new registry: self.
		ephemeron key: element value: nil.
		(table atKey: element put: ephemeron) == nil ifTrue: [self incrementTally]] evaluateAtomically.
	^element
]

{ #category : #private }
WeakIdentitySet >> basicAdd: element [
	element isNil ifTrue: [^self].
	tally := tally + 1.
	self ASSERT: element class == Ephemeron.
	table basicAtKey: element key put: element.
	^element
]

{ #category : #enumerating }
WeakIdentitySet >> do: aBlock [
	[super do: [:e | aBlock value: e key]] evaluateAtomically
]

{ #category : #enumerating }
WeakIdentitySet >> ephemeronsDo: aBlock [
	super do: [:e | aBlock value: e]
]

{ #category : #private }
WeakIdentitySet >> equates: key with: element [
	^key == element key
]

{ #category : #accessing }
WeakIdentitySet >> finalizer: evaluableAction [
	finalizer := evaluableAction
]

{ #category : #private }
WeakIdentitySet >> hashFor: object [
	^object basicHash
]

{ #category : #private }
WeakIdentitySet >> keyFor: anObject [
	^anObject key
]

{ #category : #removing }
WeakIdentitySet >> remove: anObject ifAbsent: aBlock [
	^[super remove: anObject ifAbsent: aBlock] evaluateAtomically
]

{ #category : #private }
WeakIdentitySet >> rescue: anEphemeron [
	self remove: anEphemeron key ifAbsent: nil.
	finalizer isNil ifTrue: [^self].
	finalizer evaluateWith: anEphemeron key
]

{ #category : #testing }
WeakIdentitySet >> storesAssociations [
	^true
]

