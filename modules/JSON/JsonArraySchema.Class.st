'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonArraySchema category: #JSON!
JsonSchema subclass: #JsonArraySchema
	instanceVariableNames: 'items minItems maxItems uniqueItems'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonArraySchema commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonArraySchema methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:41'!
asJson
	| json |
	json := super asJson.
	items notNil ifTrue: [json items: items asJson].
	minItems notNil ifTrue: [json at: 'minItems' put: minItems].
	maxItems notNil ifTrue: [json at: 'maxItems' put: maxItems].
	^json
! !

!JsonArraySchema methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:41'!
initialize
	super initialize.
	uniqueItems := false
! !

!JsonArraySchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isArraySchema
	^true
! !

!JsonArraySchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
items
	^items
! !

!JsonArraySchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
items: aJsonSchema
	items := aJsonSchema.
	aJsonSchema parent: self
! !

!JsonArraySchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
maxItems
	^maxItems
! !

!JsonArraySchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
maxItems: aNumber
	maxItems := aNumber
! !

!JsonArraySchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
minItems
	^minItems
! !

!JsonArraySchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
minItems: aNumber
	minItems := aNumber
! !

!JsonArraySchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
uniqueItems
	^uniqueItems
! !

!JsonArraySchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
uniqueItems: aBoolean
	uniqueItems := aBoolean
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonArraySchema class' category: #JSON!
JsonArraySchema class
	instanceVariableNames: ''!


JsonArraySchema initialize!

