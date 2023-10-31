"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #WeakIdentityDictionary,
	#superclass : #Dictionary,
	#instVars : [
		'critical'
	],
	#category : #Kernel
}

{ #category : #adding }
WeakIdentityDictionary >> add: anAssociation [
	self ASSERT: anAssociation class == Ephemeron.
	^self critical: [super add: anAssociation]
]

{ #category : #private }
WeakIdentityDictionary >> associationClass [
	^Ephemeron new registry: self
]

{ #category : #enumerating }
WeakIdentityDictionary >> associationsDo: aBlock [
	self critical: [
		super associationsDo: [:ephemeron | | hold |
			hold := ephemeron key.
			hold notNil ifTrue: [aBlock value: ephemeron]]]
]

{ #category : #private }
WeakIdentityDictionary >> critical: aBlock [
	| save |
	save := critical.
	critical := true.
	^[aBlock value] ensure: [critical := save]
]

{ #category : #enumerating }
WeakIdentityDictionary >> do: aBlock [
	self associationsDo: [:assoc | aBlock evaluateWith: assoc value]
]

{ #category : #enumerating }
WeakIdentityDictionary >> ephemeronsDo: aBlock [
	self associationsDo: aBlock
]

{ #category : #private }
WeakIdentityDictionary >> equates: element with: ephemeron [
	^element == ephemeron key
]

{ #category : #private }
WeakIdentityDictionary >> hashFor: element [
	^element basicHash
]

{ #category : #private }
WeakIdentityDictionary >> keyCollector [
	^IdentitySet new: self size
]

{ #category : #initialization }
WeakIdentityDictionary >> onTable: aHashTable [
	critical := false.
	super onTable: aHashTable
]

{ #category : #private }
WeakIdentityDictionary >> rescue: anEphemeron [
	critical
		ifTrue: [anEphemeron activate]
		ifFalse: [self removeKey: anEphemeron key ifAbsent: nil]
]

