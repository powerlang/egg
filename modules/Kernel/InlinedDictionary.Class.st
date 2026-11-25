'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #InlinedDictionary category: #Kernel!
Dictionary subclass: #InlinedDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!InlinedDictionary commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!InlinedDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationAt: key ifAbsent: exceptionBlock
	| value |
	value := table lookupValue: key ifAbsent: [^exceptionBlock value].
	^self associationClass key: key value: value
! !

!InlinedDictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationsDo: aBlock
	table keysAndValuesDo: [:key :value | | assoc |
		assoc := Association key: key value: value.
		aBlock evaluateWith: assoc]
! !

!InlinedDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
at: key put: element
	(table atKey: key put: element) == nil ifTrue: [self incrementTally].
	^element
! !

!InlinedDictionary methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAdd: anAssociation
	self at: anAssociation key put: anAssociation value.
	^anAssociation
! !

!InlinedDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
bucketClass
	^InlinedHashTable
! !

!InlinedDictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock
	table keysAndValuesDo: [:key :value | aBlock evaluateWith: value]
! !

!InlinedDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
equates: key with: element
	^key = element
! !

!InlinedDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
indexOf: element ifAbsent: aBlock
	self keysAndValuesDo: [:key :value | value = element ifTrue: [^key]].
	^aBlock value
! !

!InlinedDictionary methodsFor:  'inquiries' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyAtValue: anObject ifAbsent: aBlock
	1 to: table size by: 2 do: [:index | 
		(table at: index + 1) = anObject
			ifTrue: [(table at: index) ifNotNil: [:k | ^k]]].
	^aBlock value
! !

!InlinedDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyFor: anObject
	^anObject
! !

!InlinedDictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
keysAndElementsDo: aBlock
	self keysAndValuesDo: aBlock
! !

!InlinedDictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
keysAndValuesDo: aBlock
	table keysAndValuesDo: aBlock
! !

!InlinedDictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
keysDo: aBlock
	table keysAndValuesDo: [:key :value | aBlock evaluateWith: key]
! !

!InlinedDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
storesAssociations
	^false
! !

!InlinedDictionary methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
values
	| values |
	values := Bag new.
	self do: [:element | values add: element].
	^values
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InlinedDictionary class' category: #Kernel!
InlinedDictionary class
	instanceVariableNames: ''!


