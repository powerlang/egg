'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #WeakIdentityDictionary category: #Kernel!
Dictionary subclass: #WeakIdentityDictionary
	instanceVariableNames: 'critical'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!WeakIdentityDictionary commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!WeakIdentityDictionary methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: anAssociation
	self ASSERT: anAssociation class == Ephemeron.
	^self critical: [super add: anAssociation]
! !

!WeakIdentityDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationClass
	^Ephemeron new registry: self
! !

!WeakIdentityDictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
associationsDo: aBlock
	self critical: [
		super associationsDo: [:ephemeron | | hold |
			hold := ephemeron key.
			hold notNil ifTrue: [aBlock value: ephemeron]]]
! !

!WeakIdentityDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
critical: aBlock
	| save |
	save := critical.
	critical := true.
	^[aBlock value] ensure: [critical := save]
! !

!WeakIdentityDictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock
	self associationsDo: [:assoc | aBlock evaluateWith: assoc value]
! !

!WeakIdentityDictionary methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
ephemeronsDo: aBlock
	self associationsDo: aBlock
! !

!WeakIdentityDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
equates: element with: ephemeron
	^element == ephemeron key
! !

!WeakIdentityDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashFor: element
	^element basicHash
! !

!WeakIdentityDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyCollector
	^IdentitySet new: self size
! !

!WeakIdentityDictionary methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
onTable: aHashTable
	critical := false.
	super onTable: aHashTable
! !

!WeakIdentityDictionary methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
rescue: anEphemeron
	critical
		ifTrue: [anEphemeron activate]
		ifFalse: [self removeKey: anEphemeron key ifAbsent: nil]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WeakIdentityDictionary class' category: #Kernel!
WeakIdentityDictionary class
	instanceVariableNames: ''!


