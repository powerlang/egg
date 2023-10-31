"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #OrderedDictionary,
	#superclass : #Dictionary,
	#category : #Kernel
}

{ #category : #comparing }
OrderedDictionary >> = aCollection [
	super = aCollection ifFalse: [^false].
	^self keys = aCollection keys
]

{ #category : #'adding / removing' }
OrderedDictionary >> add: anAssociation at: anInteger [
	^self at: anAssociation key index: anInteger put: anAssociation value
]

{ #category : #accessing }
OrderedDictionary >> at: key index: anInteger put: anObject [
	| assoc |
	assoc := self associationClass key: key value: anObject.
	assoc := table atKey: key put: assoc.
	assoc == nil
		ifTrue: [
			self incrementTally.
			table moveLastTo: anInteger]
		ifFalse: [
			assoc value: anObject.
			table move: assoc to: anInteger].
	^anObject
]

{ #category : #accessing }
OrderedDictionary >> bucketClass [
	^OrderedHashTable
]

{ #category : #services }
OrderedDictionary >> compress [
	table compressTo: tally
]

{ #category : #enumerating }
OrderedDictionary >> do: aBlock [
	(tally > 10 and: [1.5 * tally < table totalSize]) ifTrue: [self compress].
	super do: [:assoc | aBlock evaluateWith: assoc]
]

{ #category : #accessing }
OrderedDictionary >> first [
	^table first value
]

{ #category : #services }
OrderedDictionary >> indexAtKey: key [
	^table indexAtKey: key
]

{ #category : #accessing }
OrderedDictionary >> indexOf: anObject [
	^table indexOfElement: anObject
]

{ #category : #testing }
OrderedDictionary >> isOrderedDictionary [
	^true
]

{ #category : #accessing }
OrderedDictionary >> keyCollector [
	^OrderedCollection new: self size
]

{ #category : #accessing }
OrderedDictionary >> last [
	^table last value
]

{ #category : #removing }
OrderedDictionary >> remove: anObject ifAbsent: aBlock [
	table removeObject: anObject ifAbsent: aBlock.
	tally := tally - 1.
	^anObject
]

{ #category : #enumerating }
OrderedDictionary >> reverseDo: aBlock [
	table valuesReverseDo: aBlock
]

{ #category : #accessing }
OrderedDictionary >> values [
	| values |
	values := Array new: tally.
	self withIndexDo: [:each :i | values at: i put: each].
	^values
]

{ #category : #enumerating }
OrderedDictionary >> withIndexDo: aBlock [
	| i |
	i := 1.
	self do: [:each | 
		aBlock value: each value: i.
		i := i + 1]
]

