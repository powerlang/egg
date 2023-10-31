"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Bag,
	#superclass : #Collection,
	#instVars : [
		'contents'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
Bag class >> new: anInteger [
	^self basicNew initialize: anInteger
]

{ #category : #'instance creation' }
Bag class >> withAll: aCollection [
	| bag |
	bag := self new: aCollection size.
	bag addAll: aCollection.
	^bag
]

{ #category : #comparing }
Bag >> = aBag [
	(aBag isKindOf: Bag) ifFalse: [^false].
	self size = aBag size ifFalse: [^false].
	contents associationsDo: [:assoc | | count |
		count := aBag occurrencesOf: assoc key.
		assoc value = count ifFalse: [^false]].
	^true
]

{ #category : #adding }
Bag >> add: anObject [
	contents at: anObject sum: 1.
	^anObject
]

{ #category : #adding }
Bag >> add: anObject withOccurrences: anInteger [
	contents at: anObject sum: anInteger.
	^anObject
]

{ #category : #accessing }
Bag >> anyone [
	contents keysDo: [:k | ^k].
	^nil
]

{ #category : #converting }
Bag >> asBag [
	^self
]

{ #category : #converting }
Bag >> asIdentitySet [
	^contents keys asIdentitySet
]

{ #category : #converting }
Bag >> asSet [
	^contents keys
]

{ #category : #accessing }
Bag >> at: anObject [
	^self errorNotKeyed
]

{ #category : #accessing }
Bag >> at: anInteger put: anObject [
	self errorNotKeyed
]

{ #category : #initialization }
Bag >> contentsClass [
	^Dictionary
]

{ #category : #accessing }
Bag >> defaultPolicy [
	^contents defaultPolicy
]

{ #category : #enumerating }
Bag >> do: aBlock [
	contents
		keysAndValuesDo: [:key :value | value timesRepeat: [aBlock value: key]]
]

{ #category : #enumerating }
Bag >> doWithOccurrences: aBlock [
	contents keysAndValuesDo: [:k :v | aBlock value: k value: v]
]

{ #category : #accessing }
Bag >> elements [
	^contents
]

{ #category : #inquiries }
Bag >> frequencies [
	^contents
]

{ #category : #inquiries }
Bag >> includes: anObject [
	^contents includesKey: anObject
]

{ #category : #initialization }
Bag >> initialize [
	super initialize.
	contents := self contentsClass new
]

{ #category : #initialization }
Bag >> initialize: anInteger [
	contents := self contentsClass new: anInteger
]

{ #category : #testing }
Bag >> isEmpty [
	^contents isEmpty
]

{ #category : #enumerating }
Bag >> keysAndValuesDo: aBlock [
	contents keysAndValuesDo: [:k :v | aBlock value: k value: v]
]

{ #category : #inquiries }
Bag >> occurrencesOf: anObject [
	^contents at: anObject ifAbsent: 0
]

{ #category : #copying }
Bag >> postCopy [
	super postCopy.
	contents := contents copy
]

{ #category : #removing }
Bag >> remove: anObject ifAbsent: aBlock [
	| count |
	count := contents at: anObject sum: -1.
	count > 0 ifTrue: [^anObject].
	contents removeKey: anObject.
	count = -1 ifTrue: [^aBlock value].
	^anObject
]

{ #category : #removing }
Bag >> removeAll [
	contents removeAll
]

{ #category : #accessing }
Bag >> size [
	| tally |
	tally := 0.
	contents do: [:count | tally := tally + count].
	^tally
]

{ #category : #private }
Bag >> sortedCounts [
	| counts |
	counts := Array
		streamContents: [:strm | contents
			keysAndValuesDo: [:k :v | strm nextPut: v -> k]].
	^counts sortBy: [:x :y | x key >= y key]
]

{ #category : #accessing }
Bag >> usePolicy: aHashTablePolicy [
	^contents usePolicy: aHashTablePolicy
]

