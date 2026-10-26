'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonObjectSchema category: #JSON!
JsonSchema subclass: #JsonObjectSchema
	instanceVariableNames: 'properties required additionalProperties'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonObjectSchema commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonObjectSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
additionalProperties
	^additionalProperties
! !

!JsonObjectSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
additionalProperties: anObject
	additionalProperties := anObject
! !

!JsonObjectSchema methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:41'!
addProperty: aString schema: aJsonSchema
	properties at: aString put: aJsonSchema.
	aJsonSchema parent: self
! !

!JsonObjectSchema methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:41'!
asJson
	| json |
	json := super asJson.
	json at: 'properties' put: properties.
	required notEmpty ifTrue: [json at: 'required' put: required].
	additionalProperties notEmpty
		ifTrue: [json at: 'additionalProperties' put: additionalProperties].
	^json
! !

!JsonObjectSchema methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:41'!
initialize
	super initialize.
	properties := Dictionary new.
	required := OrderedCollection new.
	additionalProperties := OrderedCollection new
! !

!JsonObjectSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isObjectSchema
	^true
! !

!JsonObjectSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
properties
	^properties
! !

!JsonObjectSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
propertyAt: aString
	^properties at: aString ifAbsent: nil
! !

!JsonObjectSchema methodsFor:  'adding / removing' stamp: 'KenD 28/Jun/2026 13:27:41'!
removeProperty: aString
	properties remove: aString ifAbsent: nil
! !

!JsonObjectSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
required
	^required
! !

!JsonObjectSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
required: aCollection
	required := aCollection
! !

!JsonObjectSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
requires: aString
	^required includes: aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonObjectSchema class' category: #JSON!
JsonObjectSchema class
	instanceVariableNames: ''!


JsonObjectSchema initialize!

