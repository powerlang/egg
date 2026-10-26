'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPLiteralObjectParser category: #Parsers!
PPLiteralParser subclass: #PPLiteralObjectParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPLiteralObjectParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPLiteralObjectParser methodsFor:  'operators' stamp: 'KenD 28/Jun/2026 13:27:39'!
caseInsensitive
	"Answer a parser that can parse the receiver case-insensitive."

	literal asUppercase = literal asLowercase ifTrue: [ ^ self ].
	^ PPPredicateObjectParser on: [ :value | literal sameAs: value ] message: message
! !

!PPLiteralObjectParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	^(aStream atEnd not and: [aStream uncheckedPeek = literal])
		ifFalse: [PPFailure message: message from: aStream]
		ifTrue: [aStream next]
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPLiteralObjectParser class' category: #Parsers!
PPLiteralObjectParser class
	instanceVariableNames: ''!


