"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #InlinedDictionary,
	#superclass : #Dictionary,
	#category : #Kernel
}

{ #category : #accessing }
InlinedDictionary >> associationAt: key ifAbsent: exceptionBlock [
	| value |
	value := table lookupValue: key ifAbsent: [^exceptionBlock value].
	^self associationClass key: key value: value
]

{ #category : #enumerating }
InlinedDictionary >> associationsDo: aBlock [
	table keysAndValuesDo: [:key :value | | assoc |
		assoc := Association key: key value: value.
		aBlock evaluateWith: assoc]
]

{ #category : #accessing }
InlinedDictionary >> at: key put: element [
	(table atKey: key put: element) == nil ifTrue: [self incrementTally].
	^element
]

{ #category : #adding }
InlinedDictionary >> basicAdd: anAssociation [
	self at: anAssociation key put: anAssociation value.
	^anAssociation
]

{ #category : #private }
InlinedDictionary >> bucketClass [
	^InlinedHashTable
]

{ #category : #enumerating }
InlinedDictionary >> do: aBlock [
	table keysAndValuesDo: [:key :value | aBlock evaluateWith: value]
]

{ #category : #private }
InlinedDictionary >> equates: key with: element [
	^key = element
]

{ #category : #accessing }
InlinedDictionary >> indexOf: element ifAbsent: aBlock [
	self keysAndValuesDo: [:key :value | value = element ifTrue: [^key]].
	^aBlock value
]

{ #category : #inquiries }
InlinedDictionary >> keyAtValue: anObject ifAbsent: aBlock [
	1 to: table size by: 2 do: [:index | 
		(table at: index + 1) = anObject
			ifTrue: [(table at: index) ifNotNil: [:k | ^k]]].
	^aBlock value
]

{ #category : #private }
InlinedDictionary >> keyFor: anObject [
	^anObject
]

{ #category : #enumerating }
InlinedDictionary >> keysAndElementsDo: aBlock [
	self keysAndValuesDo: aBlock
]

{ #category : #enumerating }
InlinedDictionary >> keysAndValuesDo: aBlock [
	table keysAndValuesDo: aBlock
]

{ #category : #enumerating }
InlinedDictionary >> keysDo: aBlock [
	table keysAndValuesDo: [:key :value | aBlock evaluateWith: key]
]

{ #category : #private }
InlinedDictionary >> storesAssociations [
	^false
]

{ #category : #accessing }
InlinedDictionary >> values [
	| values |
	values := Bag new.
	self do: [:element | values add: element].
	^values
]

