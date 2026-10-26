'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPFailure category: #PetitParser!
Object subclass: #PPFailure
	instanceVariableNames: 'message position'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PetitParser'!
!PPFailure commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPFailure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
description
	^message
! !

!PPFailure methodsFor:  'testing' stamp: 'KenD 28/Jun/2026 13:27:39'!
isPetitFailure
	"I am the only class that should implement this method to return true."

	^ true
! !

!PPFailure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
message
	"Answer a human readable error message of this parse failure."
	
	^ message
! !

!PPFailure methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
message: aString from: aStream
	message := aString.
	position := aStream position.
	aStream failure: self
! !

!PPFailure methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
position
	"Answer the position in the source string that caused this parse failure."

	^ position
! !

!PPFailure methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream nextPutAll: self message; nextPutAll: ' at '; print: position
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPFailure class' category: #PetitParser!
PPFailure class
	instanceVariableNames: ''!

!PPFailure class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
message: aString from: aStream
	^self basicNew message: aString from: aStream
! !


