'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPFailingParser category: #Parsers!
PPParser subclass: #PPFailingParser
	instanceVariableNames: 'message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPFailingParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPFailingParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
message
	"Answer the error message of the receiving parser."

	^ message
! !

!PPFailingParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	^PPFailure message: message from: aStream
! !

!PPFailingParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printNameOn: aStream
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: message
! !

!PPFailingParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
setMessage: aString
	message := aString
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPFailingParser class' category: #Parsers!
PPFailingParser class
	instanceVariableNames: ''!

!PPFailingParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
message: aString
	^ self new setMessage: aString
! !


