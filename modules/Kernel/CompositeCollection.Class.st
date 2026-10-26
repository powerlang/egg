'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #CompositeCollection category: #Kernel!
Collection subclass: #CompositeCollection
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!CompositeCollection commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!CompositeCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
& collection
	collection class == self class
		ifTrue: [collection addTo: self]
		ifFalse: [self add: collection]
! !

!CompositeCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
&& anObject
	contents add: {anObject}
! !

!CompositeCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anObject
	anObject isEmpty ifFalse: [contents add: anObject]
! !

!CompositeCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
addAll: aCollection
	self & aCollection
! !

!CompositeCollection methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
addTo: aCompositeCollection
	contents do: [:c | aCompositeCollection add: c]
! !

!CompositeCollection methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asOrderedCollection
	| collection |
	collection := OrderedCollection new: self size.
	contents do: [:c | collection addAll: c].
	^collection
! !

!CompositeCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index
	^self at: index ifAbsent: [self error: 'Invalid index']
! !

!CompositeCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: index ifAbsent: aBlock
	| s end |
	s := 0.
	contents do: [:collection | 
		end := s + collection size.
		index <= end ifTrue: [^collection at: index - s].
		s := end].
	^aBlock value
! !

!CompositeCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
contents
	^contents
! !

!CompositeCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyFrom: start to: stop
	| size copy |
	size := stop - start + 1 max: 0.
	copy := self species new: size.
	self withIndexDo: [:e :i | 
		i >= start ifTrue: [copy add: e].
		i = stop ifTrue: [^copy]].
	^copy
! !

!CompositeCollection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
copyWithout: anObject
	| copy |
	copy := contents collect: [:c | c copyWithout: anObject].
	^self class withAll: copy
! !

!CompositeCollection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock
	contents do: [:each | each do: aBlock]
! !

!CompositeCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
findFirst: aBlock ifAbsent: errorBlock
	self withIndexDo: [:ai :i | (aBlock evaluateWith: ai) ifTrue: [^i]].
	^errorBlock value
! !

!CompositeCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
first
	^self at: 1
! !

!CompositeCollection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOf: anObject
	^self indexOf: anObject ifAbsent: 0
! !

!CompositeCollection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOf: anObject ifAbsent: aBlock
	self withIndexDo: [:o :i | o = anObject ifTrue: [^i]].
	^aBlock value
! !

!CompositeCollection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOfIdentical: anObject
	^self indexOfIdentical: anObject ifAbsent: 0
! !

!CompositeCollection methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOfIdentical: anObject ifAbsent: aBlock
	self withIndexDo: [:o :i | o = anObject ifTrue: [^i]].
	^aBlock value
! !

!CompositeCollection methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	contents := OrderedCollection new
! !

!CompositeCollection methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isEmpty
	contents isEmpty ifTrue: [^true].
	contents do: [:c | c isEmpty ifFalse: [^false]].
	^true
! !

!CompositeCollection methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isSequenceableCollection
	^contents conform: [:collection | collection isSequenceableCollection]
! !

!CompositeCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
last
	^(contents notEmpty and: [contents last notEmpty])
		ifTrue: [contents last last]
		ifFalse: [self at: self size]
! !

!CompositeCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
owningResource
	^nil
! !

!CompositeCollection methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
postCopy
	super postCopy.
	contents := contents copy
! !

!CompositeCollection methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
readStream
	^InternalReadStream on: self
! !

!CompositeCollection methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
remove: anObject
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
! !

!CompositeCollection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
reverseDo: aBlock
	contents reverseDo: [:each | each reverseDo: aBlock]
! !

!CompositeCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
second
	^self at: 2
! !

!CompositeCollection methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	^contents sum: [:c | c size] ifNone: [0]
! !

!CompositeCollection methodsFor:  'organizing' stamp: 'KenD 28/Jun/2026 13:27:38'!
sortBy: aBlock
	^self asOrderedCollection sortBy: aBlock
! !

!CompositeCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
species
	^OrderedCollection
! !

!CompositeCollection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: aCollection do: aBlock
	self
		with: aCollection
		withIndexDo: [:e1 :e2 :i | aBlock value: e1 value: e2]
! !

!CompositeCollection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
with: aCollection withIndexDo: aBlock
	self ASSERT: self isSequenceableCollection.
	aCollection size = self size
		ifFalse: [self error: 'both collections must have the same size'].
	self
		withIndexDo: [:each :index | aBlock
			value: each
			value: (aCollection at: index)
			value: index]
! !

!CompositeCollection methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAll: collection
	contents := collection
! !

!CompositeCollection methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
withIndexDo: aBlock
	| i |
	self ASSERT: self isSequenceableCollection.
	i := 1.
	self do: [:each | 
		aBlock value: each value: i.
		i := i + 1]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CompositeCollection class' category: #Kernel!
CompositeCollection class
	instanceVariableNames: ''!

!CompositeCollection class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAll: collection
	^self new withAll: collection
! !


CompositeCollection initialize!

