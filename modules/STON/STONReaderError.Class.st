'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #STONReaderError category: #STON!
Error subclass: #STONReaderError
	instanceVariableNames: 'position'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'STON'!
!STONReaderError commentStamp: '<historical>' prior: 0!

	Copyright (c) 2024 Quorum Software.
	See (MIT) license in root directory.
!

!STONReaderError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
description
	position ifNil: [^super description].
	^String streamContents: [:strm | 
		strm
			nextPutAll: 'At character ';
			nextPutAll: position asString;
			space;
			nextPutAll: super description]
! !

!STONReaderError methodsFor:  'services' stamp: 'KenD 28/Jun/2026 13:27:39'!
signal: aString
	self description: aString; signal
! !

!STONReaderError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
streamPosition
	^ position
! !

!STONReaderError methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
streamPosition: aNumber
	position := aNumber
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'STONReaderError class' category: #STON!
STONReaderError class
	instanceVariableNames: ''!

!STONReaderError class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
signal: aString streamPosition: streamPosition
	^ self new
		streamPosition: streamPosition;
		signal: aString;
		yourself
! !


