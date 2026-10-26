'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #StringAdaptor category: #JSON!
DataAdaptor subclass: #StringAdaptor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!StringAdaptor commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!StringAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
objectFrom: anObject
	| s |
	anObject isString ifFalse: [^anObject].
	s := anObject trimBlanks.
	^s isEmpty ifFalse: [s]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StringAdaptor class' category: #JSON!
StringAdaptor class
	instanceVariableNames: ''!


