'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:38 pm'!
!classDefinition: #Ephemeron category: #Kernel!
Association subclass: #Ephemeron
	instanceVariableNames: 'key value registry'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Kernel'!
!Ephemeron commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    See (MIT) license in root directory.
!

!Ephemeron methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
= anEphemeron
	^anEphemeron class == self class and: [key = anEphemeron key]
! !

!Ephemeron methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
activate
	self _beSpecial
! !

!Ephemeron methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
deactivate
	self _beNotSpecial
! !

!Ephemeron methodsFor:  'comparing' stamp: 'KenD 28/Jun/2026 13:27:38'!
hash
	^key hash
! !

!Ephemeron methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:38'!
initialize
	super initialize.
	self activate
! !

!Ephemeron methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
key
	^key
! !

!Ephemeron methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
key: anObject
	key := anObject
! !

!Ephemeron methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
key: anObject value: aDictionary
	key := anObject.
	value := aDictionary
! !

!Ephemeron methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:38'!
printOn: aStream
	aStream
		print: key;
		nextPutAll: ' → ';
		print: value
! !

!Ephemeron methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
registry
	^registry
! !

!Ephemeron methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
registry: weakRegistry
	registry := weakRegistry
! !

!Ephemeron methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:38'!
rescue
	registry isNil ifFalse: [registry rescue: self]
! !

!Ephemeron methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
value
	^value
! !

!Ephemeron methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:38'!
value: aDictionary
	value := aDictionary
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ephemeron class' category: #Kernel!
Ephemeron class
	instanceVariableNames: ''!

!Ephemeron class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
key: anObject
	^self new key: anObject
! !

!Ephemeron class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:38'!
key: anObject value: aDictionary
	^self new key: anObject value: aDictionary
! !


Ephemeron initialize!

