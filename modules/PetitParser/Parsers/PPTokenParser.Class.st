'From Cuis7.9 [latest update: #7998] on 28 June 2026 at 1:27:39 pm'!
!classDefinition: #PPTokenParser category: #Parsers!
PPFlattenParser subclass: #PPTokenParser
	instanceVariableNames: 'tokenClass'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Parsers'!
!PPTokenParser commentStamp: '<historical>' prior: 0!

    Copyright (c) 2020 Aucerna. 
    Copyright (c) 2008-2019 The Pharo Project, and Contributors.
    See (MIT) license in root directory.
!

!PPTokenParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
create: aCollection start: aStartInteger stop: aStopInteger
	^ self tokenClass on: aCollection start: aStartInteger stop: aStopInteger
! !

!PPTokenParser methodsFor:  'private' stamp: 'KenD 28/Jun/2026 13:27:39'!
defaultTokenClass
	^ PPToken
! !

!PPTokenParser methodsFor:  'initialization' stamp: 'KenD 28/Jun/2026 13:27:39'!
initialize
	tokenClass := self defaultTokenClass
	
! !

!PPTokenParser methodsFor:  'printing' stamp: 'KenD 28/Jun/2026 13:27:39'!
printTextOn: rtf
	parser printSmalltalkReceiverOn: rtf.
	rtf nextPutAll: ' token'
! !

!PPTokenParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
tokenClass
	^ tokenClass
! !

!PPTokenParser methodsFor:  'accessing' stamp: 'KenD 28/Jun/2026 13:27:39'!
tokenClass: aTokenClass
	tokenClass := aTokenClass
! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PPTokenParser class' category: #Parsers!
PPTokenParser class
	instanceVariableNames: ''!


PPTokenParser initialize!

