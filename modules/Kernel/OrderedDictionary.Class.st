'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #OrderedDictionary category: #Kernel!
Dictionary subclass: #OrderedDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!OrderedDictionary commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!OrderedDictionary methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= aCollection
	super = aCollection ifFalse: [^false].
	^self keys = aCollection keys
! !

!OrderedDictionary methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anAssociation at: anInteger
	^self at: anAssociation key index: anInteger put: anAssociation value
! !

!OrderedDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: key index: anInteger put: anObject
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
! !

!OrderedDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
bucketClass
	^OrderedHashTable
! !

!OrderedDictionary methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
compress
	table compressTo: tally
! !

!OrderedDictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock
	(tally > 10 and: [1.5 * tally < table totalSize]) ifTrue: [self compress].
	super do: [:assoc | aBlock evaluateWith: assoc]
! !

!OrderedDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
first
	^table first value
! !

!OrderedDictionary methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexAtKey: key
	^table indexAtKey: key
! !

!OrderedDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOf: anObject
	^table indexOfElement: anObject
! !

!OrderedDictionary methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
isOrderedDictionary
	^true
! !

!OrderedDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyCollector
	^OrderedCollection new: self size
! !

!OrderedDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
last
	^table last value
! !

!OrderedDictionary methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
remove: anObject ifAbsent: aBlock
	table removeObject: anObject ifAbsent: aBlock.
	tally := tally - 1.
	^anObject
! !

!OrderedDictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
reverseDo: aBlock
	table valuesReverseDo: aBlock
! !

!OrderedDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
values
	| values |
	values := Array new: tally.
	self withIndexDo: [:each :i | values at: i put: each].
	^values
! !

!OrderedDictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
withIndexDo: aBlock
	| i |
	i := 1.
	self do: [:each | 
		aBlock value: each value: i.
		i := i + 1]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OrderedDictionary class' category: #Kernel!
OrderedDictionary class
	instanceVariableNames: ''!


