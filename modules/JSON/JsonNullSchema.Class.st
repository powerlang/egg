'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonNullSchema category: #JSON!
JsonPrimitiveSchema subclass: #JsonNullSchema
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonNullSchema commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonNullSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isNullSchema
	^true
! !

!JsonNullSchema methodsFor:  'validation' stamp: 'KenD 28/Jun/2026 13:27:41'!
targetClass
	^UndefinedObject
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonNullSchema class' category: #JSON!
JsonNullSchema class
	instanceVariableNames: ''!


