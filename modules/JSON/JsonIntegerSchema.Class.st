'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonIntegerSchema category: #JSON!
JsonNumberSchema subclass: #JsonIntegerSchema
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonIntegerSchema commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonIntegerSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
defaultFormat
	^JsonIntegerFormat new
! !

!JsonIntegerSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isIntegerSchema
	^true
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonIntegerSchema class' category: #JSON!
JsonIntegerSchema class
	instanceVariableNames: ''!


