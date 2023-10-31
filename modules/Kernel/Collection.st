"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Collection,
	#superclass : #Object,
	#category : #Kernel
}

{ #category : #'instance creation' }
Collection class >> with: anObject [
	^self new add: anObject; yourself
]

{ #category : #'instance creation' }
Collection class >> with: object1 with: object2 [
	^self new add: object1; add: object2; yourself
]

{ #category : #'instance creation' }
Collection class >> with: object1 with: object2 with: object3 [
	^self new
		add: object1;
		add: object2;
		add: object3;
		yourself
]

{ #category : #'instance creation' }
Collection class >> with: object1
with: object2
with: object3
with: object4 [
	^self new
		add: object1;
		add: object2;
		add: object3;
		add: object4;
		yourself
]

{ #category : #'instance creation' }
Collection class >> with: anObject withAll: aCollection [
	^self new add: anObject; addAll: aCollection; yourself
]

{ #category : #operations }
Collection >> & collection [
	^CompositeCollection with: self with: collection
]

{ #category : #operations }
Collection >> && anObject [
	^CompositeCollection with: self with: {anObject}
]

{ #category : #adding }
Collection >> add: anObject [
	self subclassResponsibility
]

{ #category : #adding }
Collection >> addAll: aCollection [
	aCollection do: [:element | self add: element].
	^aCollection
]

{ #category : #accessing }
Collection >> anyone [
	^self detect: [:one | true] ifNone: nil
]

{ #category : #inquiries }
Collection >> anySatisfy: aBlock [
	self detect: aBlock ifNone: [^false].
	^true
]

{ #category : #converting }
Collection >> asArray [
	^Array withAll: self
]

{ #category : #converting }
Collection >> asBag [
	^Bag withAll: self
]

{ #category : #converting }
Collection >> asIdentitySet [
	^IdentitySet withAll: self
]

{ #category : #converting }
Collection >> asOrderedCollection [
	^OrderedCollection withAll: self
]

{ #category : #converting }
Collection >> asSet [
	^Set withAll: self
]

{ #category : #converting }
Collection >> asSortedCollection [
	^SortedCollection withAll: self
]

{ #category : #converting }
Collection >> asSortedCollection: aBlock [
	^SortedCollection withAll: self sortingBy: aBlock
]

{ #category : #printing }
Collection >> basicPrintOn: aStream [
	Recursion
		checkOn: self
		while: [
			self class printOn: aStream.
			aStream nextPut: $(.
			self
				do: [:element | element printOn: aStream]
				separatedBy: [aStream space].
			aStream nextPut: $)]
		onSignal: [:e | 
			aStream nextPutAll: e description.
			^self]
]

{ #category : #enumerating }
Collection >> collect: evaluable [
	| collector |
	collector := self species new: self size.
	^self collect: evaluable in: collector
]

{ #category : #enumerating }
Collection >> collect: evaluable in: aCollection [
	self do: [:x | | fx |
		fx := evaluable evaluateWith: x.
		aCollection add: fx].
	^aCollection
]

{ #category : #enumerating }
Collection >> collect: aBlock thenDetect: anotherBlock [
	self do: [:x | | fx |
		fx := aBlock evaluateWith: x.
		(anotherBlock evaluateWith: fx) ifTrue: [^fx]].
	^nil
]

{ #category : #enumerating }
Collection >> collect: aBlock thenDo: anotherBlock [
	self do: [:x | | fx |
		fx := aBlock evaluateWith: x.
		anotherBlock evaluateWith: fx]
]

{ #category : #enumerating }
Collection >> collect: aBlock thenSelect: anotherBlock [
	| collector |
	collector := self species new: self size.
	^self collect: aBlock thenSelect: anotherBlock in: collector
]

{ #category : #enumerating }
Collection >> collect: aBlock thenSelect: anotherBlock in: aCollection [
	self do: [:x | | fx |
		fx := aBlock evaluateWith: x.
		(anotherBlock evaluateWith: fx) ifTrue: [aCollection add: fx]].
	^aCollection
]

{ #category : #inquiries }
Collection >> conform: evaluable [
	self
		detect: [:x | | fx |
			fx := evaluable evaluateWith: x.
			fx not]
		ifNone: [^true].
	^false
]

{ #category : #copying }
Collection >> copyWith: anObject [
	^self copy add: anObject; yourself
]

{ #category : #copying }
Collection >> copyWithout: anObject [
	^self reject: [:element | element = anObject]
]

{ #category : #inquiries }
Collection >> count: evaluable [
	| count |
	count := 0.
	self select: evaluable thenDo: [:x | count := count + 1].
	^count
]

{ #category : #copying }
Collection >> deepCopy [
	^self collect: [:element | element copy] in: self species new
]

{ #category : #inquiries }
Collection >> detect: evaluable [
	^self detect: evaluable ifNone: [self errorNotFound]
]

{ #category : #inquiries }
Collection >> detect: evaluable ifFound: aBlock [
	self detect: evaluable ifFound: aBlock ifNone: nil
]

{ #category : #inquiries }
Collection >> detect: aBlock ifFound: foundBlock ifNone: exceptionBlock [
	self do: [:element | | found |
		found := aBlock evaluateWith: element.
		found ifTrue: [^foundBlock evaluateWith: element]].
	^exceptionBlock value
]

{ #category : #inquiries }
Collection >> detect: aBlock ifNone: anotherBlock [
	^self detect: aBlock ifFound: [:element | element] ifNone: anotherBlock
]

{ #category : #enumerating }
Collection >> do: aBlock [
	self subclassResponsibility
]

{ #category : #enumerating }
Collection >> do: aBlock separatedBy: separatorBlock [
	| separate |
	separate := false.
	self do: [:element | 
		separate ifTrue: [separatorBlock value] ifFalse: [separate := true].
		aBlock evaluateWith: element]
]

{ #category : #comparing }
Collection >> equalsTo: aCollection [
	self size = aCollection size ifFalse: [^false].
	aCollection do: [:element | (self includes: element) ifFalse: [^false]].
	self do: [:element | (aCollection includes: element) ifFalse: [^false]].
	^true
]

{ #category : #errors }
Collection >> errorNotFound [
	^self error: 'object not found in the collection'
]

{ #category : #errors }
Collection >> errorNotIndexable [
	^self error: 'instances of ' , self class name , ' are not indexable'
]

{ #category : #errors }
Collection >> errorNotKeyed [
	self
		error: 'instances of ' , self class name
			, ' do not respond to keyed accessing messages'
]

{ #category : #enumerating }
Collection >> gather: aBlock [
	^self gather: aBlock in: (OrderedCollection new: self size)
]

{ #category : #enumerating }
Collection >> gather: aBlock in: collection [
	self do: [:each | | things |
		things := aBlock evaluateWith: each.
		collection addAll: things].
	^collection
]

{ #category : #enumerating }
Collection >> gather: aBlock thenSelect: anotherBlock in: aCollection [
	self do: [:each | | things |
		things := aBlock evaluateWith: each.
		things
			do: [:element | (anotherBlock evaluateWith: element)
				ifTrue: [aCollection add: element]]].
	^aCollection
]

{ #category : #inquiries }
Collection >> includes: anObject [
	^self anySatisfy: [:element | anObject = element]
]

{ #category : #inquiries }
Collection >> includesIdentical: anObject [
	self do: [:each | each == anObject ifTrue: [^true]].
	^false
]

{ #category : #enumerating }
Collection >> inject: anObject into: aBlock [
	| result |
	result := anObject.
	self do: [:element | result := aBlock value: result value: element].
	^result
]

{ #category : #testing }
Collection >> isCollection [
	^true
]

{ #category : #testing }
Collection >> isEmpty [
	^self size = 0
]

{ #category : #testing }
Collection >> isEmptyOrNil [
	^self isEmpty
]

{ #category : #enumerating }
Collection >> noneSatisfy: evaluable [
	self do: [:item | (evaluable evaluateWith: item) ifTrue: [^false]].
	^true
]

{ #category : #testing }
Collection >> notEmpty [
	^self isEmpty not
]

{ #category : #inquiries }
Collection >> occurrencesOf: anObject [
	| count |
	count := 0.
	self do: [:element | element = anObject ifTrue: [count := count + 1]].
	^count
]

{ #category : #printing }
Collection >> printElementText: element on: rtf position: i [
	element printOn: rtf
]

{ #category : #printing }
Collection >> printLimit [
	^4000
]

{ #category : #printing }
Collection >> printOn: aStream [
	self basicPrintOn: aStream
]

{ #category : #printing }
Collection >> printOn: aStream limit: aNumber [
	| limit |
	Recursion
		checkOn: self
		while: [
			limit := aStream position + (aNumber ifNil: [Number infinity]).
			self class printOn: aStream.
			aStream nextPut: $(.
			self
				do: [:element | 
					aStream position > limit ifTrue: [
						'…etc…)' printOn: aStream.
						^self].
					element printOn: aStream]
				separatedBy: [aStream space].
			aStream nextPut: $)]
		onSignal: [:e | 
			aStream nextPutAll: e description.
			^self]
]

{ #category : #enumerating }
Collection >> reject: aBlock [
	^self select: [:x | (aBlock evaluateWith: x) not]
]

{ #category : #enumerating }
Collection >> reject: aBlock thenDo: anotherBlock [
	self
		do: [:each | (aBlock evaluateWith: each)
			ifFalse: [anotherBlock evaluateWith: each]]
]

{ #category : #removing }
Collection >> remove: anObject [
	^self remove: anObject ifAbsent: [self errorNotFound]
]

{ #category : #removing }
Collection >> remove: anObject ifAbsent: aBlock [
	self subclassResponsibility
]

{ #category : #removing }
Collection >> removeAll [
	self isEmpty ifTrue: [^self].
	self copy do: [:x | self remove: x]
]

{ #category : #removing }
Collection >> removeAll: aCollection [
	aCollection do: [:x | self remove: x].
	^aCollection
]

{ #category : #removing }
Collection >> removeAllSuchThat: aBlock [
	self copy do: [:each | (aBlock value: each) ifTrue: [self remove: each]]
]

{ #category : #enumerating }
Collection >> select: aBlock [
	^self select: aBlock in: self species new
]

{ #category : #enumerating }
Collection >> select: evaluable in: aCollection [
	self select: evaluable thenDo: [:x | aCollection add: x].
	^aCollection
]

{ #category : #enumerating }
Collection >> select: aBlock thenCollect: anotherBlock [
	| collection |
	collection := self species new.
	self select: aBlock thenCollect: anotherBlock in: collection.
	^collection
]

{ #category : #errors }
Collection >> select: aBlock thenCollect: anotherBlock in: aCollection [
	self select: aBlock thenDo: [:x | | fx |
		fx := anotherBlock evaluateWith: x.
		aCollection add: fx].
	^aCollection
]

{ #category : #enumerating }
Collection >> select: aBlock thenDo: anotherBlock [
	self
		do: [:element | (aBlock evaluateWith: element)
			ifTrue: [anotherBlock evaluateWith: element]]
]

{ #category : #printing }
Collection >> storeOn: aStream [
	Recursion checkOn: self while: [
		aStream
			nextPut: $(;
			nextPutAll: self class name;
			nextPutAll: ' new'.
		self do: [:x | 
			aStream nextPutAll: ' add: ('.
			x storeOn: aStream.
			aStream nextPutAll: ');'].
		aStream nextPutAll: ' yourself'; nextPut: $)]
]

{ #category : #arithmetic }
Collection >> sum [
	^self sum: [:x | x] ifNone: 0
]

{ #category : #functions }
Collection >> sum: aBlock [
	^self sum: aBlock ifNone: 0
]

{ #category : #functions }
Collection >> sum: aBlock ifNone: exceptionBlock [
	| sum |
	self do: [:each | | value |
		value := aBlock evaluateWith: each.
		value isUndefinedValue
			ifFalse: [sum := sum == nil ifTrue: [value] ifFalse: [sum + value]]].
	^sum isUndefinedValue ifTrue: [exceptionBlock value] ifFalse: [sum]
]

{ #category : #enumerating }
Collection >> withoutDuplicates [	
	| visited |
	visited := Set new.
	^self select: [:element | | found |
		found := visited includes: element.
		found ifFalse: [visited add: element].
		found not]
]
