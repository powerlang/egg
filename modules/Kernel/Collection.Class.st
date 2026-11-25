'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Collection category: #Kernel!
Object subclass: #Collection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Collection commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Collection methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
& collection
	^CompositeCollection with: self with: collection
! !

!Collection methodsFor:  'operations' stamp: 'KenD 28/Jun/2026 13:27:38'!
&& anObject
	^CompositeCollection with: self with: {anObject}
! !

!Collection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anObject
	self subclassResponsibility
! !

!Collection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
addAll: aCollection
	aCollection do: [:element | self add: element].
	^aCollection
! !

!Collection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
anyone
	^self detect: [:one | true] ifNone: nil
! !

!Collection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
anySatisfy: aBlock
	self detect: aBlock ifNone: [^false].
	^true
! !

!Collection methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asArray
	^Array withAll: self
! !

!Collection methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asBag
	^Bag withAll: self
! !

!Collection methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asIdentitySet
	^IdentitySet withAll: self
! !

!Collection methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asOrderedCollection
	^OrderedCollection withAll: self
! !

!Collection methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asSet
	^Set withAll: self
! !

!Collection methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asSortedCollection
	^SortedCollection withAll: self
! !

!Collection methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asSortedCollection: aBlock
	^SortedCollection withAll: self sortingBy: aBlock
! !

!Collection methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicPrintOn: aStream
	self disableCode: [Recursion
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
			^self]].
	self class printOn: aStream.
	aStream nextPut: $(.
	self
		do: [:element | element printOn: aStream]
		separatedBy: [aStream space].
	aStream nextPut: $)
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
collect: evaluable
	| collector |
	collector := self species new: self size.
	^self collect: evaluable in: collector
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
collect: evaluable in: aCollection
	self do: [:x | | fx |
		fx := evaluable evaluateWith: x.
		aCollection add: fx].
	^aCollection
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
collect: aBlock thenDetect: anotherBlock
	self do: [:x | | fx |
		fx := aBlock evaluateWith: x.
		(anotherBlock evaluateWith: fx) ifTrue: [^fx]].
	^nil
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
collect: aBlock thenDo: anotherBlock
	self do: [:x | | fx |
		fx := aBlock evaluateWith: x.
		anotherBlock evaluateWith: fx]
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
collect: aBlock thenSelect: anotherBlock
	| collector |
	collector := self species new: self size.
	^self collect: aBlock thenSelect: anotherBlock in: collector
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
collect: aBlock thenSelect: anotherBlock in: aCollection
	self do: [:x | | fx |
		fx := aBlock evaluateWith: x.
		(anotherBlock evaluateWith: fx) ifTrue: [aCollection add: fx]].
	^aCollection
! !

!Collection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
conform: evaluable
	self
		detect: [:x | | fx |
			fx := evaluable evaluateWith: x.
			fx not]
		ifNone: [^true].
	^false
! !

!Collection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyWith: anObject
	^self copy add: anObject; yourself
! !

!Collection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyWithout: anObject
	^self reject: [:element | element = anObject]
! !

!Collection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
count: evaluable
	| count |
	count := 0.
	self select: evaluable thenDo: [:x | count := count + 1].
	^count
! !

!Collection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
deepCopy
	^self collect: [:element | element copy] in: self species new
! !

!Collection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
detect: evaluable
	^self detect: evaluable ifNone: [self errorNotFound]
! !

!Collection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
detect: evaluable ifFound: aBlock
	self detect: evaluable ifFound: aBlock ifNone: nil
! !

!Collection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
detect: aBlock ifFound: foundBlock ifNone: exceptionBlock
	self do: [:element | | found |
		found := aBlock evaluateWith: element.
		found ifTrue: [^foundBlock evaluateWith: element]].
	^exceptionBlock value
! !

!Collection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
detect: aBlock ifNone: anotherBlock
	^self detect: aBlock ifFound: [:element | element] ifNone: anotherBlock
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock
	self subclassResponsibility
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock separatedBy: separatorBlock
	| separate |
	separate := false.
	self do: [:element | 
		separate ifTrue: [separatorBlock value] ifFalse: [separate := true].
		aBlock evaluateWith: element]
! !

!Collection methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
equalsTo: aCollection
	self size = aCollection size ifFalse: [^false].
	aCollection do: [:element | (self includes: element) ifFalse: [^false]].
	self do: [:element | (aCollection includes: element) ifFalse: [^false]].
	^true
! !

!Collection methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
errorNotFound
	^self error: 'object not found in the collection'
! !

!Collection methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
errorNotIndexable
	^self error: 'instances of ' , self class name , ' are not indexable'
! !

!Collection methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
errorNotKeyed
	self
		error: 'instances of ' , self class name
			, ' do not respond to keyed accessing messages'
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
gather: aBlock
	^self gather: aBlock in: (OrderedCollection new: self size)
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
gather: aBlock in: collection
	self do: [:each | | things |
		things := aBlock evaluateWith: each.
		collection addAll: things].
	^collection
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
gather: aBlock thenSelect: anotherBlock in: aCollection
	self do: [:each | | things |
		things := aBlock evaluateWith: each.
		things
			do: [:element | (anotherBlock evaluateWith: element)
				ifTrue: [aCollection add: element]]].
	^aCollection
! !

!Collection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
includes: anObject
	^self anySatisfy: [:element | anObject = element]
! !

!Collection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
includesIdentical: anObject
	self do: [:each | each == anObject ifTrue: [^true]].
	^false
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
inject: anObject into: aBlock
	| result |
	result := anObject.
	self do: [:element | result := aBlock value: result value: element].
	^result
! !

!Collection methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isCollection
	^true
! !

!Collection methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isEmpty
	^self size = 0
! !

!Collection methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isEmptyOrNil
	^self isEmpty
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
noneSatisfy: evaluable
	self do: [:item | (evaluable evaluateWith: item) ifTrue: [^false]].
	^true
! !

!Collection methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
notEmpty
	^self isEmpty not
! !

!Collection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
occurrencesOf: anObject
	| count |
	count := 0.
	self do: [:element | element = anObject ifTrue: [count := count + 1]].
	^count
! !

!Collection methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printElementText: element on: rtf position: i
	element printOn: rtf
! !

!Collection methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printLimit
	^4000
! !

!Collection methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	self basicPrintOn: aStream
! !

!Collection methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream limit: aNumber
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
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
reject: aBlock
	^self select: [:x | (aBlock evaluateWith: x) not]
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
reject: aBlock thenDo: anotherBlock
	self
		do: [:each | (aBlock evaluateWith: each)
			ifFalse: [anotherBlock evaluateWith: each]]
! !

!Collection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
remove: anObject
	^self remove: anObject ifAbsent: [self errorNotFound]
! !

!Collection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
remove: anObject ifAbsent: aBlock
	self subclassResponsibility
! !

!Collection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAll
	self isEmpty ifTrue: [^self].
	self copy do: [:x | self remove: x]
! !

!Collection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAll: aCollection
	aCollection do: [:x | self remove: x].
	^aCollection
! !

!Collection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAllSuchThat: aBlock
	self copy do: [:each | (aBlock value: each) ifTrue: [self remove: each]]
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
select: aBlock
	^self select: aBlock in: self species new
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
select: evaluable in: aCollection
	self select: evaluable thenDo: [:x | aCollection add: x].
	^aCollection
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
select: aBlock thenCollect: anotherBlock
	| collection |
	collection := self species new.
	self select: aBlock thenCollect: anotherBlock in: collection.
	^collection
! !

!Collection methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
select: aBlock thenCollect: anotherBlock in: aCollection
	self select: aBlock thenDo: [:x | | fx |
		fx := anotherBlock evaluateWith: x.
		aCollection add: fx].
	^aCollection
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
select: aBlock thenDo: anotherBlock
	self
		do: [:element | (aBlock evaluateWith: element)
			ifTrue: [anotherBlock evaluateWith: element]]
! !

!Collection methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storeOn: aStream
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
! !

!Collection methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
sum
	^self sum: [:x | x] ifNone: 0
! !

!Collection methodsFor:  'functions' stamp: 'KenD 28/Jun/2026 13:27:38'!
sum: aBlock
	^self sum: aBlock ifNone: 0
! !

!Collection methodsFor:  'functions' stamp: 'KenD 28/Jun/2026 13:27:38'!
sum: aBlock ifNone: exceptionBlock
	| sum |
	self do: [:each | | value |
		value := aBlock evaluateWith: each.
		value isUndefinedValue
			ifFalse: [sum := sum == nil ifTrue: [value] ifFalse: [sum + value]]].
	^sum isUndefinedValue ifTrue: [exceptionBlock value] ifFalse: [sum]
! !

!Collection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
withoutDuplicates
	| visited |
	visited := Set new.
	^self select: [:element | | found |
		found := visited includes: element.
		found ifFalse: [visited add: element].
		found not]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Collection class' category: #Kernel!
Collection class
	instanceVariableNames: ''!

!Collection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: anObject
	^self new add: anObject; yourself
! !

!Collection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: object1 with: object2
	^self new add: object1; add: object2; yourself
! !

!Collection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: object1 with: object2 with: object3
	^self new
		add: object1;
		add: object2;
		add: object3;
		yourself
! !

!Collection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: object1 with: object2 with: object3 with: object4
	^self new
		add: object1;
		add: object2;
		add: object3;
		add: object4;
		yourself
! !

!Collection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: anObject withAll: aCollection
	^self new add: anObject; addAll: aCollection; yourself
! !


