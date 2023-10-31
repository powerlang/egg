"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #CompositeCollection,
	#superclass : #Collection,
	#instVars : [
		'contents'
	],
	#category : #Kernel
}

{ #category : #'instance creation' }
CompositeCollection class >> withAll: collection [
	^self new withAll: collection
]

{ #category : #adding }
CompositeCollection >> & collection [
	collection class == self class
		ifTrue: [collection addTo: self]
		ifFalse: [self add: collection]
]

{ #category : #adding }
CompositeCollection >> && anObject [
	contents add: {anObject}
]

{ #category : #adding }
CompositeCollection >> add: anObject [
	anObject isEmpty ifFalse: [contents add: anObject]
]

{ #category : #adding }
CompositeCollection >> addAll: aCollection [
	self & aCollection
]

{ #category : #adding }
CompositeCollection >> addTo: aCompositeCollection [
	contents do: [:c | aCompositeCollection add: c]
]

{ #category : #converting }
CompositeCollection >> asOrderedCollection [
	| collection |
	collection := OrderedCollection new: self size.
	contents do: [:c | collection addAll: c].
	^collection
]

{ #category : #accessing }
CompositeCollection >> at: index [
	^self at: index ifAbsent: [self error: 'Invalid index']
]

{ #category : #accessing }
CompositeCollection >> at: index ifAbsent: aBlock [
	| s end |
	s := 0.
	contents do: [:collection | 
		end := s + collection size.
		index <= end ifTrue: [^collection at: index - s].
		s := end].
	^aBlock value
]

{ #category : #accessing }
CompositeCollection >> contents [
	^contents
]

{ #category : #accessing }
CompositeCollection >> copyFrom: start to: stop [
	| size copy |
	size := stop - start + 1 max: 0.
	copy := self species new: size.
	self withIndexDo: [:e :i | 
		i >= start ifTrue: [copy add: e].
		i = stop ifTrue: [^copy]].
	^copy
]

{ #category : #copying }
CompositeCollection >> copyWithout: anObject [
	| copy |
	copy := contents collect: [:c | c copyWithout: anObject].
	^self class withAll: copy
]

{ #category : #enumerating }
CompositeCollection >> do: aBlock [
	contents do: [:each | each do: aBlock]
]

{ #category : #accessing }
CompositeCollection >> findFirst: aBlock ifAbsent: errorBlock [
	self withIndexDo: [:ai :i | (aBlock evaluateWith: ai) ifTrue: [^i]].
	^errorBlock value
]

{ #category : #accessing }
CompositeCollection >> first [
	^self at: 1
]

{ #category : #inquiries }
CompositeCollection >> indexOf: anObject [
	^self indexOf: anObject ifAbsent: 0
]

{ #category : #inquiries }
CompositeCollection >> indexOf: anObject ifAbsent: aBlock [
	self withIndexDo: [:o :i | o = anObject ifTrue: [^i]].
	^aBlock value
]

{ #category : #inquiries }
CompositeCollection >> indexOfIdentical: anObject [
	^self indexOfIdentical: anObject ifAbsent: 0
]

{ #category : #inquiries }
CompositeCollection >> indexOfIdentical: anObject ifAbsent: aBlock [
	self withIndexDo: [:o :i | o = anObject ifTrue: [^i]].
	^aBlock value
]

{ #category : #initialization }
CompositeCollection >> initialize [
	super initialize.
	contents := OrderedCollection new
]

{ #category : #testing }
CompositeCollection >> isEmpty [
	contents isEmpty ifTrue: [^true].
	contents do: [:c | c isEmpty ifFalse: [^false]].
	^true
]

{ #category : #testing }
CompositeCollection >> isSequenceableCollection [
	^contents conform: [:collection | collection isSequenceableCollection]
]

{ #category : #accessing }
CompositeCollection >> last [
	^(contents notEmpty and: [contents last notEmpty])
		ifTrue: [contents last last]
		ifFalse: [self at: self size]
]

{ #category : #accessing }
CompositeCollection >> owningResource [
	^nil
]

{ #category : #copying }
CompositeCollection >> postCopy [
	super postCopy.
	contents := contents copy
]

{ #category : #converting }
CompositeCollection >> readStream [
	^InternalReadStream on: self
]

{ #category : #removing }
CompositeCollection >> remove: anObject [
	| index |
	index := contents findFirst: [:c | c == anObject] ifAbsent: [| continue |
		continue := Object new.
		contents withIndexDo: [:c :i | | answer |
			answer := c remove: anObject ifAbsent: continue.
			answer == continue ifFalse: [
				c isEmpty ifTrue: [contents removeIndex: i].
				^answer]].
		self errorNotFound].
	contents removeIndex: index.
	^anObject
]

{ #category : #enumerating }
CompositeCollection >> reverseDo: aBlock [
	contents reverseDo: [:each | each reverseDo: aBlock]
]

{ #category : #accessing }
CompositeCollection >> second [
	^self at: 2
]

{ #category : #accessing }
CompositeCollection >> size [
	^contents sum: [:c | c size] ifNone: [0]
]

{ #category : #organizing }
CompositeCollection >> sortBy: aBlock [
	^self asOrderedCollection sortBy: aBlock
]

{ #category : #private }
CompositeCollection >> species [
	^OrderedCollection
]

{ #category : #enumerating }
CompositeCollection >> with: aCollection do: aBlock [
	self
		with: aCollection
		withIndexDo: [:e1 :e2 :i | aBlock value: e1 value: e2]
]

{ #category : #enumerating }
CompositeCollection >> with: aCollection withIndexDo: aBlock [
	self ASSERT: self isSequenceableCollection.
	aCollection size = self size
		ifFalse: [self error: 'both collections must have the same size'].
	self
		withIndexDo: [:each :index | aBlock
			value: each
			value: (aCollection at: index)
			value: index]
]

{ #category : #private }
CompositeCollection >> withAll: collection [
	contents := collection
]

{ #category : #enumerating }
CompositeCollection >> withIndexDo: aBlock [
	| i |
	self ASSERT: self isSequenceableCollection.
	i := 1.
	self do: [:each | 
		aBlock value: each value: i.
		i := i + 1]
]

