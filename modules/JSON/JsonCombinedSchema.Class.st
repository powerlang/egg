'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonCombinedSchema category: #JSON!
JsonSchema subclass: #JsonCombinedSchema
	instanceVariableNames: 'schemas'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonCombinedSchema commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonCombinedSchema methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:41'!
asJson
	^JsonObject new at: self typeName put: schemas; yourself
! !

!JsonCombinedSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
schemas
	^schemas
! !

!JsonCombinedSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
schemas: aCollection
	schemas := aCollection.
	aCollection do: [:schema | schema parent: self]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonCombinedSchema class' category: #JSON!
JsonCombinedSchema class
	instanceVariableNames: ''!


