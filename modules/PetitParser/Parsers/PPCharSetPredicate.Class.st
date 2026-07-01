'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPCharSetPredicate category: #Parsers!
Object subclass: #PPCharSetPredicate
	instanceVariableNames: 'block classification'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPCharSetPredicate commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPCharSetPredicate methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initializeOn: aBlock
	block := aBlock.
	classification := Array new: 255.
	1 to: classification size do: [ :index |
		classification at: index put: (block
			value: (Character value: index)) ]
! !

!PPCharSetPredicate methodsFor:  'evaluating' stamp: 'KenD 28/Jun/2026 13:27:39'!
value: aCharacter
	| index |
	index := aCharacter asInteger.
	index == 0
		ifTrue: [ ^ block value: aCharacter ].
	index > 255
		ifTrue: [ ^ block value: aCharacter ].
	^ classification at: index
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPCharSetPredicate class' category: #Parsers!
PPCharSetPredicate class
	instanceVariableNames: ''!

!PPCharSetPredicate class methodsFor:  'instance creation' stamp: 'KenD 28/Jun/2026 13:27:39'!
on: aBlock
	^ self basicNew initializeOn: aBlock
! !


