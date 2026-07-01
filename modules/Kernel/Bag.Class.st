'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Bag category: #Kernel!
Collection subclass: #Bag
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Bag commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Bag methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aBag
	(aBag isKindOf: Bag) ifFalse: [^false].
	self size = aBag size ifFalse: [^false].
	contents associationsDo: [:assoc | | count |
		count := aBag occurrencesOf: assoc key.
		assoc value = count ifFalse: [^false]].
	^true
! !

!Bag methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anObject
	contents at: anObject sum: 1.
	^anObject
! !

!Bag methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anObject withOccurrences: anInteger
	contents at: anObject sum: anInteger.
	^anObject
! !

!Bag methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
anyone
	contents keysDo: [:k | ^k].
	^nil
! !

!Bag methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asBag
	^self
! !

!Bag methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asIdentitySet
	^contents keys asIdentitySet
! !

!Bag methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:38'!
asSet
	^contents keys
! !

!Bag methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anObject
	^self errorNotKeyed
! !

!Bag methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: anInteger put: anObject
	self errorNotKeyed
! !

!Bag methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
contentsClass
	^Dictionary
! !

!Bag methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
defaultPolicy
	^contents defaultPolicy
! !

!Bag methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock
	contents
		keysAndValuesDo: [:key :value | value timesRepeat: [aBlock value: key]]
! !

!Bag methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
doWithOccurrences: aBlock
	contents keysAndValuesDo: [:k :v | aBlock value: k value: v]
! !

!Bag methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
elements
	^contents
! !

!Bag methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
frequencies
	^contents
! !

!Bag methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
includes: anObject
	^contents includesKey: anObject
! !

!Bag methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	contents := self contentsClass new
! !

!Bag methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize: anInteger
	contents := self contentsClass new: anInteger
! !

!Bag methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isEmpty
	^contents isEmpty
! !

!Bag methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
keysAndValuesDo: aBlock
	contents keysAndValuesDo: [:k :v | aBlock value: k value: v]
! !

!Bag methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
occurrencesOf: anObject
	^contents at: anObject ifAbsent: 0
! !

!Bag methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:38'!
postCopy
	super postCopy.
	contents := contents copy
! !

!Bag methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
remove: anObject ifAbsent: aBlock
	| count |
	count := contents at: anObject sum: -1.
	count > 0 ifTrue: [^anObject].
	contents removeKey: anObject.
	count = -1 ifTrue: [^aBlock value].
	^anObject
! !

!Bag methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
removeAll
	contents removeAll
! !

!Bag methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
size
	| tally |
	tally := 0.
	contents do: [:count | tally := tally + count].
	^tally
! !

!Bag methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
sortedCounts
	| counts |
	counts := Array
		streamContents: [:strm | contents
			keysAndValuesDo: [:k :v | strm nextPut: v -> k]].
	^counts sortBy: [:x :y | x key >= y key]
! !

!Bag methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
usePolicy: aHashTablePolicy
	^contents usePolicy: aHashTablePolicy
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Bag class' category: #Kernel!
Bag class
	instanceVariableNames: ''!

!Bag class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
new: anInteger
	^self basicNew initialize: anInteger
! !

!Bag class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
withAll: aCollection
	| bag |
	bag := self new: aCollection size.
	bag addAll: aCollection.
	^bag
! !


Bag initialize!

