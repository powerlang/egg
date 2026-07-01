'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPMappedParser category: #Parsers!
PPListParser subclass: #PPMappedParser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPMappedParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPMappedParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
at: key put: aPPParser
	parsers at: key put: aPPParser
! !

!PPMappedParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	parsers := Dictionary new
! !

!PPMappedParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| key parser |
	key := aStream peek.
	key isNil
		ifTrue: [^PPFailure
			message: 'no parser for key ' , key printString
			from: aStream].
	parser := parsers
		at: key
		ifAbsent: [^PPFailure
			message: 'no parser for key ' , key printString
			from: aStream].
	^parser parseOn: aStream
! !

!PPMappedParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
setParsers: aDictionary
	parsers := aDictionary
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPMappedParser class' category: #Parsers!
PPMappedParser class
	instanceVariableNames: ''!


PPMappedParser initialize!

