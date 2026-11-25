'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonNumberSchema category: #JSON!
JsonPrimitiveSchema subclass: #JsonNumberSchema
	instanceVariableNames: 'minimum exclusiveMinimum maximum exclusiveMaximum multipleOf'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonNumberSchema commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonNumberSchema methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:41'!
asJson
	| json |
	json := super asJson.
	minimum notNil ifTrue: [
		json
			at: 'minimum' put: minimum;
			at: 'exclusiveMinimum' put: exclusiveMinimum].
	maximum notNil ifTrue: [
		json
			at: 'maximum' put: maximum;
			at: 'exclusiveMinimum' put: exclusiveMaximum].
	multipleOf notNil ifTrue: [json at: 'multipleOf' put: multipleOf].
	^json
! !

!JsonNumberSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
defaultFormat
	^JsonNumberFormat new
! !

!JsonNumberSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
exclusiveMaximum
	^exclusiveMaximum ifTrue: [maximum]
! !

!JsonNumberSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
exclusiveMaximum: anObject
	anObject isNumber
		ifTrue: [
			maximum := anObject.
			exclusiveMaximum := true]
		ifFalse: [exclusiveMaximum := anObject]
! !

!JsonNumberSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
exclusiveMinimum
	^exclusiveMinimum ifTrue: [minimum]
! !

!JsonNumberSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
exclusiveMinimum: anObject
	anObject isNumber
		ifTrue: [
			minimum := anObject.
			exclusiveMinimum := true]
		ifFalse: [exclusiveMinimum := anObject]
! !

!JsonNumberSchema methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:41'!
initialize
	super initialize.
	exclusiveMinimum := exclusiveMaximum := false
! !

!JsonNumberSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isNumberSchema
	^true
! !

!JsonNumberSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
maximum
	^maximum
! !

!JsonNumberSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
maximum: aNumber
	maximum := aNumber
! !

!JsonNumberSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
minimum
	^minimum
! !

!JsonNumberSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
minimum: aNumber
	minimum := aNumber
! !

!JsonNumberSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
multipleOf
	^multipleOf
! !

!JsonNumberSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
multipleOf: anNumber
	multipleOf := anNumber
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonNumberSchema class' category: #JSON!
JsonNumberSchema class
	instanceVariableNames: ''!


JsonNumberSchema initialize!

