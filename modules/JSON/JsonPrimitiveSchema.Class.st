'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonPrimitiveSchema category: #JSON!
JsonSchema subclass: #JsonPrimitiveSchema
	instanceVariableNames: 'format'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonPrimitiveSchema commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonPrimitiveSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
defaultFormat
	^self subclassResponsibility
! !

!JsonPrimitiveSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
format
	^format ifNil: [self defaultFormat]
! !

!JsonPrimitiveSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
format: anObject
	format := anObject
! !

!JsonPrimitiveSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isPrimitiveSchema
	^true
! !

!JsonPrimitiveSchema methodsFor:  'validation' stamp: 'KenD 28/Jun/2026 13:27:41'!
targetClass
	^Smalltalk at: self typeName asProperNoun asSymbol
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonPrimitiveSchema class' category: #JSON!
JsonPrimitiveSchema class
	instanceVariableNames: ''!


