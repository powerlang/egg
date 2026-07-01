'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #DataAdaptor category: #JSON!
Object subclass: #DataAdaptor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!DataAdaptor commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!DataAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
dataFrom: anObject
	^anObject asString
! !

!DataAdaptor methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isEntityAdaptor
	^false
! !

!DataAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
objectFrom: aString
	^(aString conform: [:ch | ch isDigit or: [#($+ $- $.) includes: ch]])
		ifTrue: [aString asNumber]
		ifFalse: [aString]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataAdaptor class' category: #JSON!
DataAdaptor class
	instanceVariableNames: ''!


