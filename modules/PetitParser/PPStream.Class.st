'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPStream category: #PetitParser!
InternalReadStream subclass: #PPStream
	instanceVariableNames: 'failure'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'PetitParser'!
!PPStream commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPStream methodsFor:  'converting' stamp: 'KenD 28/Jun/2026 13:27:39'!
asPetitStream
	^ self
! !

!PPStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
failure
	^failure
! !

!PPStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
failure: aPPFailure
	(failure isNil or: [failure position < aPPFailure position])
		ifTrue: [failure := aPPFailure]
! !

!PPStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
next: anInteger
	| answer endPosition |
	endPosition := position + anInteger min: limit.
	answer := contents copyFrom: position + 1 to: endPosition.
	position := endPosition.
	^answer
! !

!PPStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
peek
	"
	An improved version of peek, that is slightly faster than the built in version.
	"
	^self atEnd ifFalse: [contents at: position + 1]
! !

!PPStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
position: anInteger
	"The receiver does not check for invalid arguments passed to this method, as it is solely used with valid indexes for backtracking."

	position := anInteger
! !

!PPStream methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	aStream
		nextPutAll: (contents copyFrom: 1 to: position);
		nextPutAll: 'ꞈ';
		nextPutAll: (contents copyFrom: position + 1 to: limit)
! !

!PPStream methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
uncheckedPeek
	"
	An unchecked version of peek that throws an error if we try to peek over the end of the stream, even faster than #peek.
	"
	^contents at: position + 1
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPStream class' category: #PetitParser!
PPStream class
	instanceVariableNames: ''!


