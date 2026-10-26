'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPLiteralSequenceParser category: #Parsers!
PPLiteralParser subclass: #PPLiteralSequenceParser
	instanceVariableNames: 'size'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPLiteralSequenceParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPLiteralSequenceParser methodsFor:  'operators' stamp: 'KenD 28/Jun/2026 13:27:39'!
caseInsensitive
	"Answer a parser that can parse the receiver case-insensitive."

	literal asUppercase = literal asLowercase ifTrue: [ ^ self ].
	^ PPPredicateSequenceParser on: [ :value | literal sameAs: value ] message: message size: size
! !

!PPLiteralSequenceParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeOn: anObject message: aString
	super initializeOn: anObject message: aString.
	size := literal size
! !

!PPLiteralSequenceParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| position result |
	position := aStream position.
	result := aStream next: size.
	result = literal ifTrue: [^result].
	aStream position: position.
	^PPFailure message: message from: aStream
! !

!PPLiteralSequenceParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
size
	"Answer the sequence size of the receiver."

	^ size
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPLiteralSequenceParser class' category: #Parsers!
PPLiteralSequenceParser class
	instanceVariableNames: ''!


