'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPListParser category: #Parsers!
PPParser subclass: #PPListParser
	instanceVariableNames: 'parsers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPListParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPListParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
children
	^ parsers
! !

!PPListParser methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:39'!
copyWith: aParser
	^ self species withAll: (parsers copyWith: aParser)
! !

!PPListParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	super initialize.
	self setParsers: #()
! !

!PPListParser methodsFor:  'copying' stamp: 'KenD 28/Jun/2026 13:27:39'!
postCopy
	super postCopy.
	parsers := parsers copy
! !

!PPListParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
setParsers: aCollection
	parsers := aCollection asArray
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPListParser class' category: #Parsers!
PPListParser class
	instanceVariableNames: ''!

!PPListParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
with: aParser
	^self withAll: {aParser}
! !

!PPListParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
with: aFirstParser with: aSecondParser
	^self withAll: {aFirstParser. aSecondParser}
! !

!PPListParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
withAll: aCollection
	^ self basicNew setParsers: aCollection
! !


PPListParser initialize!

