'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPLiteralParser category: #Parsers!
PPParser subclass: #PPLiteralParser
	instanceVariableNames: 'literal message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPLiteralParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPLiteralParser methodsFor:  'operators' stamp: 'KenD 28/Jun/2026 13:27:39'!
caseInsensitive
	"Answer a parser that can parse the receiver case-insensitive."

	self subclassResponsibility
! !

!PPLiteralParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeOn: anObject message: aString
	literal := anObject.
	message := aString
! !

!PPLiteralParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
literal
	"Answer the parsed literal."

	^ literal
! !

!PPLiteralParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
message
	"Answer the failure message."

	^ message
! !

!PPLiteralParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printNameOn: aStream
	super printNameOn: aStream.
	aStream nextPutAll: ', '.
	literal storeOn: aStream
! !

!PPLiteralParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printOn: aStream
	literal literalString printOn: aStream.
	aStream nextPutAll: ' asParser'
! !

!PPLiteralParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	literal literalString printTextOn: rtf.
	rtf nextPutAll: ' asParser'
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPLiteralParser class' category: #Parsers!
PPLiteralParser class
	instanceVariableNames: ''!

!PPLiteralParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: anObject
	^ self on: anObject message: anObject printString , ' expected'
! !

!PPLiteralParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: anObject message: aString
	^ self new initializeOn: anObject message: aString
! !


