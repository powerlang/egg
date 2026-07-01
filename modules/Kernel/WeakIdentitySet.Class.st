'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #WeakIdentitySet category: #Kernel!
IdentitySet subclass: #WeakIdentitySet
	instanceVariableNames: 'finalizer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!WeakIdentitySet commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!WeakIdentitySet methodsFor:  'adding' stamp: 'KenD 28/Jun/2026 13:27:38'!
add: element
	| ephemeron |
	element == nil ifTrue: [^element].
	[
		ephemeron := Ephemeron new registry: self.
		ephemeron key: element value: nil.
		(table atKey: element put: ephemeron) == nil ifTrue: [self incrementTally]] evaluateAtomically.
	^element
! !

!WeakIdentitySet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
basicAdd: element
	element isNil ifTrue: [^self].
	tally := tally + 1.
	self ASSERT: element class == Ephemeron.
	table basicAtKey: element key put: element.
	^element
! !

!WeakIdentitySet methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
do: aBlock
	[super do: [:e | aBlock value: e key]] evaluateAtomically
! !

!WeakIdentitySet methodsFor:  'enumerating' stamp: 'KenD 28/Jun/2026 13:27:38'!
ephemeronsDo: aBlock
	super do: [:e | aBlock value: e]
! !

!WeakIdentitySet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
equates: key with: element
	^key == element key
! !

!WeakIdentitySet methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
finalizer: evaluableAction
	finalizer := evaluableAction
! !

!WeakIdentitySet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
hashFor: object
	^object basicHash
! !

!WeakIdentitySet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
keyFor: anObject
	^anObject key
! !

!WeakIdentitySet methodsFor:  'removing' stamp: 'KenD 28/Jun/2026 13:27:38'!
remove: anObject ifAbsent: aBlock
	^[super remove: anObject ifAbsent: aBlock] evaluateAtomically
! !

!WeakIdentitySet methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
rescue: anEphemeron
	self remove: anEphemeron key ifAbsent: nil.
	finalizer isNil ifTrue: [^self].
	finalizer evaluateWith: anEphemeron key
! !

!WeakIdentitySet methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:38'!
storesAssociations
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WeakIdentitySet class' category: #Kernel!
WeakIdentitySet class
	instanceVariableNames: ''!


