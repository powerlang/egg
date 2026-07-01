'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonStringSchema category: #JSON!
JsonPrimitiveSchema subclass: #JsonStringSchema
	instanceVariableNames: 'minLength maxLength'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonStringSchema commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonStringSchema methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:41'!
asJson
	| json |
	json := super asJson.
	minLength notNil ifTrue: [json at: 'minLength' put: minLength].
	maxLength notNil ifTrue: [json at: 'maxLength' put: maxLength].
	^json
! !

!JsonStringSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
defaultFormat
	^JsonStringFormat new
! !

!JsonStringSchema methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:41'!
isStringSchema
	^true
! !

!JsonStringSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
maxLength
	^maxLength
! !

!JsonStringSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
maxLength: anInteger
	maxLength := anInteger
! !

!JsonStringSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
minLength
	^minLength
! !

!JsonStringSchema methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
minLength: anInteger
	minLength := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonStringSchema class' category: #JSON!
JsonStringSchema class
	instanceVariableNames: ''!


