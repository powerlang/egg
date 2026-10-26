'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonNotSchema category: #JSON!
JsonSchema subclass: #JsonNotSchema
	instanceVariableNames: 'schema'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonNotSchema commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonNotSchema methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:41'!
asJson
	^JsonObject new at: self typeName put: schema; yourself
! !

!JsonNotSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isNotSchema
	^true
! !

!JsonNotSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
schema
	^schema
! !

!JsonNotSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
schema: aJsonSchema
	schema := aJsonSchema.
	aJsonSchema parent: self
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonNotSchema class' category: #JSON!
JsonNotSchema class
	instanceVariableNames: ''!


