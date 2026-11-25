'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #BooleanAdaptor category: #JSON!
DataAdaptor subclass: #BooleanAdaptor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!BooleanAdaptor commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!BooleanAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
dataFrom: aBoolean
	^aBoolean ifTrue: [1] ifFalse: [0]
! !

!BooleanAdaptor methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
objectFrom: anInteger
	^anInteger asBoolean
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BooleanAdaptor class' category: #JSON!
BooleanAdaptor class
	instanceVariableNames: ''!


