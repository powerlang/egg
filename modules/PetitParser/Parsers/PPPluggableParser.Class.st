'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPPluggableParser category: #Parsers!
PPParser subclass: #PPPluggableParser
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPPluggableParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPPluggableParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
block
	"Answer the pluggable block."

	^ block
! !

!PPPluggableParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeOn: aBlock
	block := aBlock
! !

!PPPluggableParser methodsFor:  'parsing' stamp: 'KenD 28/Jun/2026 13:27:39'!
parseOn: aStream
	| position result |
	position := aStream position.
	result := block value: aStream.
	result isPetitFailure
		ifTrue: [ aStream position: position ].
	^ result
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPPluggableParser class' category: #Parsers!
PPPluggableParser class
	instanceVariableNames: ''!

!PPPluggableParser class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aBlock
	^ self new initializeOn: aBlock
! !


