"
    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
"

Class {
	#name : #Dictionary,
	#superclass : #HashedCollection,
	#category : #Kernel
}

{ #category : #comparing }
Dictionary >> = aCollection [
	self == aCollection ifTrue: [^true].
	self class = aCollection class ifFalse: [^false].
	self size = aCollection size ifFalse: [^false].
	self keysAndValuesDo: [:k :v | | w |
		w := aCollection at: k ifAbsent: [^false].
		v = w ifFalse: [^false]].
	^true
]

{ #category : #adding }
Dictionary >> add: anAssociation [
	^self basicAdd: anAssociation
]

{ #category : #adding }
Dictionary >> addAll: aCollection [
	aCollection isDictionary
		ifTrue: [aCollection associationsDo: [:assoc | self add: assoc]]
		ifFalse: [aCollection do: [:assoc | self add: assoc]].
	^aCollection
]

{ #category : #accessing }
Dictionary >> anyone [
	self associationsDo: [:assoc | ^assoc value].
	^nil
]

{ #category : #accessing }
Dictionary >> associationAt: key [
	^self associationAt: key ifAbsent: [self keyNotFound: key]
]

{ #category : #accessing }
Dictionary >> associationAt: key ifAbsent: aBlock [
	| assoc |
	assoc := table lookupKey: key.
	^assoc isNil ifTrue: [aBlock value] ifFalse: [assoc]
]

{ #category : #private }
Dictionary >> associationClass [
	^Association
]

{ #category : #accessing }
Dictionary >> associations [
	^Array
		streamContents: [:strm | self associationsDo: [:a | strm nextPut: a]]
]

{ #category : #enumerating }
Dictionary >> associationsDo: aBlock [
	table elementsDo: aBlock count: self size
]

{ #category : #enumerating }
Dictionary >> associationsSelect: aBlock [
	| selection |
	selection := self species new.
	self
		associationsDo: [:assoc | (aBlock evaluateWith: assoc)
			ifTrue: [selection add: assoc]].
	^selection
]

{ #category : #accessing }
Dictionary >> at: key [
	^table lookupValue: key
]

{ #category : #accessing }
Dictionary >> at: key ifAbsent: aBlock [
	^table lookupValue: key ifAbsent: aBlock
]

{ #category : #accessing }
Dictionary >> at: key ifAbsent: aBlock ifPresent: pBlock [
	^table lookUpValue: key ifAbsent: aBlock ifPresent: pBlock
]

{ #category : #accessing }
Dictionary >> at: key ifAbsentPut: aBlock [
	^self at: key ifAbsent: [self at: key put: aBlock value]
]

{ #category : #accessing }
Dictionary >> at: key ifPresent: aBlock [
	^table lookupValue: key ifPresent: aBlock
]

{ #category : #accessing }
Dictionary >> at: key put: element [
	| assoc |
	assoc := self associationClass key: key value: element.
	self add: assoc.
	^element
]

{ #category : #accessing }
Dictionary >> at: key put: anObject ifPresent: aBlock [
	| assoc existing answer |
	assoc := self associationClass key: key value: anObject.
	existing := table atKey: key put: assoc.
	existing isNil
		ifTrue: [
			self incrementTally.
			answer := anObject]
		ifFalse: [
			answer := aBlock value: existing value.
			existing value: answer].
	^answer
]

{ #category : #arithmetic }
Dictionary >> at: key sum: aNumber [
	| prev |
	prev := table atKey: key sum: aNumber.
	^prev isNil
		ifTrue: [
			self incrementTally.
			aNumber]
		ifFalse: [self storesAssociations ifTrue: [prev value] ifFalse: [prev]]
]

{ #category : #private }
Dictionary >> basicAdd: anAssociation [
	| assoc |
	assoc := table atKey: anAssociation key put: anAssociation.
	assoc == nil
		ifTrue: [self incrementTally]
		ifFalse: [assoc value: anAssociation value].
	^anAssociation
]

{ #category : #private }
Dictionary >> basicAt: key put: element for: aDictionary [
	table basicAtKey: key put: element.
	tally := tally + 1
]

{ #category : #removing }
Dictionary >> basicRemoveKey: key ifAbsent: aBlock [
	table removeKey: key ifAbsent: [^aBlock value].
	tally := tally - 1.
	^key
]

{ #category : #enumerating }
Dictionary >> collect: aBlock [
	| answer |
	answer := self species new: self size.
	self keysAndValuesDo: [:key :value | 
		answer
			add: (answer associationClass key: key value: (aBlock evaluateWith: value))].
	^answer
]

{ #category : #enumerating }
Dictionary >> collect: collectBlock thenDo: actionBlock [
	self associationsDo: [:x | | fx |
		fx := collectBlock evaluateWith: x value.
		actionBlock evaluateWith: fx]
]

{ #category : #enumerating }
Dictionary >> collect: collectBlock thenSelect: selectBlock [
	| answer |
	answer := self species new.
	self associationsDo: [:x | | fx |
		fx := collectBlock evaluateWith: x value.
		(selectBlock evaluateWith: fx)
			ifTrue: [answer add: (answer associationClass key: x key value: fx)]].
	^answer
]

{ #category : #copying }
Dictionary >> deepCopy [
	| copy |
	copy := self species new: tally.
	table policy == self ifFalse: [copy usePolicy: table policy copy].
	self associationsDo: [:element | copy add: element copy].
	^copy
]

{ #category : #private }
Dictionary >> defaultPolicy [
	^super defaultPolicy associationClass: self associationClass
]

{ #category : #enumerating }
Dictionary >> do: aBlock [
	super do: [:assoc | aBlock evaluateWith: assoc value]
]

{ #category : #system }
Dictionary >> doesNotUnderstand: aMessage [
	^self
		at: aMessage selector asString asLowercase
		ifAbsent: [super doesNotUnderstand: aMessage]
]

{ #category : #private }
Dictionary >> equates: key with: association [
	^key = association key
]

{ #category : #inquiries }
Dictionary >> includesKey: key [
	^(table lookupKey: key) !== nil
]

{ #category : #testing }
Dictionary >> isDictionary [
	^true
]

{ #category : #testing }
Dictionary >> isOrderedDictionary [
	^false
]

{ #category : #inquiries }
Dictionary >> keyAtValue: anObject [
	^self keyAtValue: anObject ifAbsent: nil
]

{ #category : #inquiries }
Dictionary >> keyAtValue: anObject ifAbsent: aBlock [
	self associationsDo: [:assoc | assoc value = anObject ifTrue: [^assoc key]].
	^aBlock value
]

{ #category : #private }
Dictionary >> keyCollector [
	^Set new: self size
]

{ #category : #private }
Dictionary >> keyFor: anObject [
	^anObject key
]

{ #category : #errors }
Dictionary >> keyNotFound: anObject [
	KeyNotFound signalFor: anObject
]

{ #category : #accessing }
Dictionary >> keys [
	| keys |
	keys := self keyCollector.
	self keysDo: [:k | keys add: k].
	^keys
]

{ #category : #enumerating }
Dictionary >> keysAndElementsDo: aBlock [
	self associationsDo: [:assoc | aBlock evaluateWith: assoc key with: assoc]
]

{ #category : #enumerating }
Dictionary >> keysAndValuesDo: aBlock [
	self associationsDo: [:assoc | aBlock value: assoc key value: assoc value]
]

{ #category : #enumerating }
Dictionary >> keysDo: aBlock [
	self associationsDo: [:assoc | aBlock evaluateWith: assoc key]
]

{ #category : #inquiries }
Dictionary >> occurrencesOf: anObject [
	| count |
	count := 0.
	self do: [:value | value = anObject ifTrue: [count := count + 1]].
	^count
]

{ #category : #copying }
Dictionary >> postCopy [
	super postCopy.
	self storesAssociations ifTrue: [table copyAssociations]
]

{ #category : #private }
Dictionary >> rebuildOn: aDictionary [
	self
		keysAndElementsDo: [:key :assoc | aDictionary
			basicAt: key
			put: assoc
			for: aDictionary].
	table := aDictionary table
]

{ #category : #removing }
Dictionary >> remove: anObject ifAbsent: aBlock [
	^self shouldNotImplement
]

{ #category : #removing }
Dictionary >> removeAssociation: anAssociation [
	self removeKey: anAssociation key
]

{ #category : #removing }
Dictionary >> removeKey: key [
	self removeKey: key ifAbsent: [self keyNotFound: key]
]

{ #category : #removing }
Dictionary >> removeKey: key ifAbsent: aBlock [
	^self basicRemoveKey: key ifAbsent: aBlock
]

{ #category : #enumerating }
Dictionary >> select: aBlock [
	| selection |
	selection := self species new.
	self
		associationsDo: [:assoc | (aBlock evaluateWith: assoc value)
			ifTrue: [selection add: assoc]].
	^selection
]

{ #category : #enumerating }
Dictionary >> select: selectBlock thenCollect: collectBlock [
	| answer |
	answer := self species new.
	self keysAndValuesDo: [:key :value | | assoc |
		(selectBlock evaluateWith: value) ifTrue: [
			assoc := answer associationClass
				key: key
				value: (collectBlock evaluateWith: value).
			answer add: assoc]].
	^answer
]

{ #category : #printing }
Dictionary >> storeOn: aStream [
	| first |
	self isEmpty
		ifTrue: [^aStream nextPutAll: self class name; nextPutAll: ' new'].
	first := true.
	aStream
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' new'.
	self associationsDo: [:assoc | 
		first ifFalse: [aStream nextPut: $;].
		aStream crtab; nextPutAll: 'add: '.
		assoc storeOn: aStream.
		first := false].
	aStream
		nextPut: $;;
		crtab;
		nextPutAll: 'yourself';
		nextPut: $)
]

{ #category : #testing }
Dictionary >> storesAssociations [
	^true
]

{ #category : #accessing }
Dictionary >> values [
	| values |
	values := Bag new.
	self do: [:each | values add: each].
	^values
]

