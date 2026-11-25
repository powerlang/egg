'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Dictionary category: #Kernel!
HashedCollection subclass: #Dictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Dictionary commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Dictionary methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aCollection
	self == aCollection ifTrue: [^true].
	self class = aCollection class ifFalse: [^false].
	self size = aCollection size ifFalse: [^false].
	self keysAndValuesDo: [:k :v | | w |
		w := aCollection at: k ifAbsent: [^false].
		v = w ifFalse: [^false]].
	^true
! !

!Dictionary methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anAssociation
	^self basicAdd: anAssociation
! !

!Dictionary methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
addAll: aCollection
	aCollection isDictionary
		ifTrue: [aCollection associationsDo: [:assoc | self add: assoc]]
		ifFalse: [aCollection do: [:assoc | self add: assoc]].
	^aCollection
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
anyone
	self associationsDo: [:assoc | ^assoc value].
	^nil
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationAt: key
	^self associationAt: key ifAbsent: [self keyNotFound: key]
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationAt: key ifAbsent: aBlock
	| assoc |
	assoc := table lookupKey: key.
	^assoc isNil ifTrue: [aBlock value] ifFalse: [assoc]
! !

!Dictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationClass
	^Association
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
associations
	^Array
		streamContents: [:strm | self associationsDo: [:a | strm nextPut: a]]
! !

!Dictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationsDo: aBlock
	table elementsDo: aBlock count: self size
! !

!Dictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationsSelect: aBlock
	| selection |
	selection := self species new.
	self
		associationsDo: [:assoc | (aBlock evaluateWith: assoc)
			ifTrue: [selection add: assoc]].
	^selection
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: key
	^table lookupValue: key
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: key ifAbsent: aBlock
	^table lookupValue: key ifAbsent: aBlock
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: key ifAbsent: aBlock ifPresent: pBlock
	^table lookUpValue: key ifAbsent: aBlock ifPresent: pBlock
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: key ifAbsentPut: aBlock
	^self at: key ifAbsent: [self at: key put: aBlock value]
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: key ifPresent: aBlock
	^table lookupValue: key ifPresent: aBlock
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: key put: element
	| assoc |
	assoc := self associationClass key: key value: element.
	self add: assoc.
	^element
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: key put: anObject ifPresent: aBlock
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
! !

!Dictionary methodsFor:  'arithmetic' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: key sum: aNumber
	| prev |
	prev := table atKey: key sum: aNumber.
	^prev isNil
		ifTrue: [
			self incrementTally.
			aNumber]
		ifFalse: [self storesAssociations ifTrue: [prev value] ifFalse: [prev]]
! !

!Dictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAdd: anAssociation
	| assoc |
	assoc := table atKey: anAssociation key put: anAssociation.
	assoc == nil
		ifTrue: [self incrementTally]
		ifFalse: [assoc value: anAssociation value].
	^anAssociation
! !

!Dictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAt: key put: element for: aDictionary
	table basicAtKey: key put: element.
	tally := tally + 1
! !

!Dictionary methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicRemoveKey: key ifAbsent: aBlock
	table removeKey: key ifAbsent: [^aBlock value].
	tally := tally - 1.
	^key
! !

!Dictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
collect: aBlock
	| answer |
	answer := self species new: self size.
	self keysAndValuesDo: [:key :value | 
		answer
			add: (answer associationClass key: key value: (aBlock evaluateWith: value))].
	^answer
! !

!Dictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
collect: collectBlock thenDo: actionBlock
	self associationsDo: [:x | | fx |
		fx := collectBlock evaluateWith: x value.
		actionBlock evaluateWith: fx]
! !

!Dictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
collect: collectBlock thenSelect: selectBlock
	| answer |
	answer := self species new.
	self associationsDo: [:x | | fx |
		fx := collectBlock evaluateWith: x value.
		(selectBlock evaluateWith: fx)
			ifTrue: [answer add: (answer associationClass key: x key value: fx)]].
	^answer
! !

!Dictionary methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
deepCopy
	| copy |
	copy := self species new: tally.
	table policy == self ifFalse: [copy usePolicy: table policy copy].
	self associationsDo: [:element | copy add: element copy].
	^copy
! !

!Dictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
defaultPolicy
	^super defaultPolicy associationClass: self associationClass
! !

!Dictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock
	super do: [:assoc | aBlock evaluateWith: assoc value]
! !

!Dictionary methodsFor:  'system' stamp: 'KenD 28/Jun/2026 13:27:38'!
doesNotUnderstand: aMessage
	^self
		at: aMessage selector asString asLowercase
		ifAbsent: [super doesNotUnderstand: aMessage]
! !

!Dictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
equates: key with: association
	^key = association key
! !

!Dictionary methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
includesKey: key
	^(table lookupKey: key) !!== nil
! !

!Dictionary methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isDictionary
	^true
! !

!Dictionary methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isOrderedDictionary
	^false
! !

!Dictionary methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyAtValue: anObject
	^self keyAtValue: anObject ifAbsent: nil
! !

!Dictionary methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyAtValue: anObject ifAbsent: aBlock
	self associationsDo: [:assoc | assoc value = anObject ifTrue: [^assoc key]].
	^aBlock value
! !

!Dictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyCollector
	^Set new: self size
! !

!Dictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyFor: anObject
	^anObject key
! !

!Dictionary methodsFor:  'errors' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyNotFound: anObject
	KeyNotFound signalFor: anObject
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
keys
	| keys |
	keys := self keyCollector.
	self keysDo: [:k | keys add: k].
	^keys
! !

!Dictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
keysAndElementsDo: aBlock
	self associationsDo: [:assoc | aBlock evaluateWith: assoc key with: assoc]
! !

!Dictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
keysAndValuesDo: aBlock
	self associationsDo: [:assoc | aBlock value: assoc key value: assoc value]
! !

!Dictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
keysDo: aBlock
	self associationsDo: [:assoc | aBlock evaluateWith: assoc key]
! !

!Dictionary methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
occurrencesOf: anObject
	| count |
	count := 0.
	self do: [:value | value = anObject ifTrue: [count := count + 1]].
	^count
! !

!Dictionary methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
postCopy
	super postCopy.
	self storesAssociations ifTrue: [table copyAssociations]
! !

!Dictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
rebuildOn: aDictionary
	self
		keysAndElementsDo: [:key :assoc | aDictionary
			basicAt: key
			put: assoc
			for: aDictionary].
	table := aDictionary table
! !

!Dictionary methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
remove: anObject ifAbsent: aBlock
	^self shouldNotImplement
! !

!Dictionary methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAssociation: anAssociation
	self removeKey: anAssociation key
! !

!Dictionary methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeKey: key
	self removeKey: key ifAbsent: [self keyNotFound: key]
! !

!Dictionary methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeKey: key ifAbsent: aBlock
	^self basicRemoveKey: key ifAbsent: aBlock
! !

!Dictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
select: aBlock
	| selection |
	selection := self species new.
	self
		associationsDo: [:assoc | (aBlock evaluateWith: assoc value)
			ifTrue: [selection add: assoc]].
	^selection
! !

!Dictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
select: selectBlock thenCollect: collectBlock
	| answer |
	answer := self species new.
	self keysAndValuesDo: [:key :value | | assoc |
		(selectBlock evaluateWith: value) ifTrue: [
			assoc := answer associationClass
				key: key
				value: (collectBlock evaluateWith: value).
			answer add: assoc]].
	^answer
! !

!Dictionary methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storeOn: aStream
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
! !

!Dictionary methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storesAssociations
	^true
! !

!Dictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
values
	| values |
	values := Bag new.
	self do: [:each | values add: each].
	^values
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Dictionary class' category: #Kernel!
Dictionary class
	instanceVariableNames: ''!


