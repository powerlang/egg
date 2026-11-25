'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:37 pm'!
!classDefinition: #Option category: #ArgParser!
Object subclass: #Option
	instanceVariableNames: 'short long description required hasValue defaultValue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ArgParser'!
!Option commentStamp: '<historical>' prior: 0!

    Copyright (c) 2026, Javier Pimás.
    See (MIT) license in root directory.
!

!Option methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:27:37'!
beFlag
	hasValue := false.
	defaultValue := false
! !

!Option methodsFor:  'configuration' stamp: 'KenD 28/Jun/2026 13:27:37'!
beRequired
	required := true
! !

!Option methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
defaultValue
	^defaultValue
! !

!Option methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
defaultValue: anObject
	defaultValue := anObject
! !

!Option methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
description
	^description
! !

!Option methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
description: aString
	description := aString
! !

!Option methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
hasValue
	^hasValue
! !

!Option methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:37'!
initialize
	required := false.
	hasValue := true.
	defaultValue := nil
! !

!Option methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
long
	^long
! !

!Option methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
long: aString
	long := aString
! !

!Option methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
matches: aString
	^aString = short or: [aString = long]
! !

!Option methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
name
	long ifNotNil: [^long copyFrom: 3].
	^short copyFrom: 2
! !

!Option methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:37'!
required
	^required
! !

!Option methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
short
	^short
! !

!Option methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:37'!
short: aString
	short := aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Option class' category: #ArgParser!
Option class
	instanceVariableNames: ''!


Option initialize!

