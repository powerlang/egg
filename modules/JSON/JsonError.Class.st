'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:41 pm'!
!classDefinition: #JsonError category: #JSON!
Error subclass: #JsonError
	instanceVariableNames: 'position context'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'JSON'!
!JsonError commentStamp: '<historical>' prior: 0!

	Copyright (c) 2020 Aucerna.
	See (MIT) license in root directory.
!

!JsonError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
context: aString
	context := aString
! !

!JsonError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
description
	^'Cannot parse the JSON stream around ' , context storeString , ' because '
		, super description
! !

!JsonError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
position
	^position
! !

!JsonError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:41'!
position: anInteger
	position := anInteger
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'JsonError class' category: #JSON!
JsonError class
	instanceVariableNames: ''!

!JsonError class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
signal: aString at: anInteger
	^self new position: anInteger; description: aString; signal
! !

!JsonError class methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:41'!
signal: aString at: anInteger context: context
	^self new
		position: anInteger;
		description: aString;
		context: context;
		signal
! !


